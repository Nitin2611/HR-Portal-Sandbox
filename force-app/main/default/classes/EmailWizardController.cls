public class EmailWizardController {
    @AuraEnabled 
        public static List<LeadListWrapper> fetchAccountWrapper(String objname){     
            List<LeadListWrapper> lstLeadListWrapper = new List<LeadListWrapper>();
            String query = 'SELECT Id, Name, Phone, Email FROM ' +objname+ ' ORDER BY CreatedDate Desc';
            
            for (SObject sobj : Database.query(query)) {
                lstLeadListWrapper.add(new LeadListWrapper(false,sobj));
            }

            System.debug('lstLeadListWrapper==>'+lstLeadListWrapper);
            return lstLeadListWrapper; 
        }
        
        /* wrapper class */  
        public class LeadListWrapper {
            @AuraEnabled public boolean isChecked {get;set;}
            @AuraEnabled public SObject objAccount{get;set;}
            public LeadListWrapper(boolean isChecked, SObject objAccount){
                this.isChecked = isChecked;
                this.objAccount = objAccount;
            }
        }

        // get Search Record
        @AuraEnabled
        public static List<LeadListWrapper> getSearchValue(String objname, String searchname){
            List<LeadListWrapper> lstLeadListWrapper = new List<LeadListWrapper>();

            String query = 'SELECT Id, Name, Phone, Email FROM ' +objname+ ' WHERE Name LIKE  \''+ '%'+searchname+'%\' ORDER BY CreatedDate Desc';
            System.debug('query-->'+query);
            
            for (SObject sobj : Database.query(query)) {
                lstLeadListWrapper.add(new LeadListWrapper(false,sobj));
            }

            System.debug('lstLeadListWrapper==>'+lstLeadListWrapper);
            return lstLeadListWrapper; 
        }

        // get All Team Record
        @AuraEnabled
        public static List<Team__c> getTeamList(){
            return [SELECT Id, Name, (SELECT Id, Name, Email FROM Contacts__r) FROM Team__c];
        }

        // get all Object
        @AuraEnabled
        public static List<String> getObjectName(){
            List<String> objects=new List<String>();
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
            for(SObjectType sot:gd){
               objects.add(sot.getDescribe().getName());
               objects.sort();  
            }
            return objects;
        }
    
        @AuraEnabled
        public static List<emailTemplates> getEmailTemaltes(){
            List<emailTemplates> TemplateList = new List<emailTemplates>();
            for(sobject emailtemp : [ SELECT Id, FolderId, HtmlValue, FolderName, isActive, body,Name,subject FROM EmailTemplate where isActive= true]){        
                EmailTemplates template = new EmailTemplates();
                template.emailTemplateId = String.valueOf(emailtemp.get('Id'));
                template.emailTemplatename = String.valueOf(emailtemp.get('Name'));
                template.emailbody = (emailtemp.get('HtmlValue') != null ? String.valueOf(emailtemp.get('HtmlValue')) : '' );
                template.emailSubject = String.valueOf(emailtemp.get('subject'));
                TemplateList.add(template);
            }
            return TemplateList;
        }
    
        public class emailTemplates{
            
            @AuraEnabled 
            public String emailTemplateId{get;set;}
            
            @AuraEnabled 
            public String emailbody{get;set;}
            
            @AuraEnabled
            public String emailSubject {get;set;}
            
            @AuraEnabled 
            public String emailTemplatename{get;set;}
        } 
        @AuraEnabled
        public static List<String> getAllFields(String objname){
            System.debug('objname-->'+objname);
            List<String> fieldList = new List<String>();
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            // Schema.SObjectType sobjType = gd.get('Lead'); 
            Schema.SObjectType sobjType = gd.get(objname); 
            Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
            Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap(); 
            
            for(string str: fieldsMap.keySet()){
                // fieldList.add(fieldsMap.get(str).getDescribe().getLabel());                
                // fieldList.add(fieldsMap.get(str).getDescribe().getName());
                String refVar = fieldsMap.get(str).getDescribe().getLabel() + ':::' + fieldsMap.get(str).getDescribe().getName();
                fieldList.add(refVar);
            }
    
            return fieldList;      
        }
    
        @AuraEnabled
        public static String SendMailsMethod(List<Id> IdList , String Subject, String MailBody,String FileName,String FileType,Blob FileBlob,String objname){
            try {        
                System.debug('FileName-->'+FileName);
                System.debug('FileType--->'+FileType);
                System.debug('FileBlob---->'+FileBlob);    
    
                String FileBlobStr = EncodingUtil.base64Encode(FileBlob);
                System.debug('File String Blob--->'+FileBlobStr);
    
                List<SObject> sobjectlst = Database.query(Util.queryData(objname,'',' WHERE Id =: IdList'));
    
                Map<Id,String> LeadMailMap = new Map<Id,String>();
                LeadMailMap = changeLead(MailBody,IdList,objname);
                for(SObject l: sobjectlst){
                    // String Sendto = l.Email;
                    String Sendto = String.valueOf(l.get('Email'));
                    System.debug('Sendto==>'+Sendto);
                    // GoogleGmailApi.sendGmail(Subject,LeadMailMap.get(l.Id),Sendto);
                    sendGmailWithAttachmentBlob(Subject,LeadMailMap.get(l.Id),Sendto,FileBlob,FileName,FileType);
                    //sendEmail(Subject,LeadMailMap.get(l.Id),Sendto,FileBlobStr,FileName,FileType);
                }
    
                return 'Emails Sent Successfully!!';
    
            } catch (Exception e) {
                // throw new AuraHandledException(e.getMessage());
                return e.getMessage();
            }
        }
    
        @AuraEnabled
        public static string getPreview(Id recordId,String MailBody,String objname){
            try {
                List<sObject> SObjectlist = Database.query(Util.queryData(objname,'',' WHERE Id =: recordId LIMIT 1'));
                System.debug('SObjectlist==>'+SObjectlist);
                List<Id> LeadIdList = new List<Id>();
                // for(Lead c: LeadList){
                //     LeadIdList.add(c.Id);
                // }
                for (SObject sobj : SObjectlist) {
                    LeadIdList.add(sobj.Id);
                }
                System.debug('LeadIdList==>'+LeadIdList);
                Map<Id,String> LeadMailMap  = new Map<Id,String>();
                LeadMailMap = changeLead(MailBody,LeadIdList,objname);
                // String updatedMailBody = changeLead(MailBody,LeadIdList);
                String updatedMailBody = LeadMailMap.get(SObjectlist[0].Id);
                System.debug('updatedMailBody==>'+updatedMailBody);
                return updatedMailBody;
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
    
        public static Map<Id,String> changeLead(String MailBody,List<Id> recordId,String objname){        
            List<sObject> sObjectlst = Database.query(Util.queryData(objname,'',' WHERE Id =: recordId'));
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objname).getDescribe().fields.getMap();
            List<String> ListFields = new List<String>();
            for(Schema.SObjectField sfield : fieldMap.Values()){
                ListFields.add(sfield.getDescribe().getname());
            }
    
            Map<Id,String> LeadMailMap = new Map<Id,String>();
    
            for(sObject c: sObjectlst){
                String refMail = MailBody;
                for(String s: ListFields){                
                    String x = '{!'+objname+'.'+s+'}';
                    if(refMail.contains(x)){
                        String strval = String.valueOf(c.get(s));
                        if(strval != null){
                            refMail = refMail.replace(x,String.valueOf(c.get(s)));
                        }else {
                            refMail = refMail.replace(x, '');
                        }
                    }
                }
                LeadMailMap.put(c.Id,refMail);
            }
    
            return LeadMailMap;
        }

        @future (callout=true)
        public static void sendGmailWithAttachmentBlob(String subjectMail,String bodyGmail,String sendTo, Blob attachment,String attachmentName,String ContentType){
            
            String errorMessage ='';
            
            String TestVar = EncodingUtil.base64Encode(attachment);
    
            String str = attachment.toString();
            // decode 
            Blob decodedBlob = EncodingUtil.base64Decode(str);
            // convert to string
            // String result = decodedBlob.toString();
    
            string before = '';
            string endpoint = '';
            string contentType_1 = '';
            if(!String.isEmpty(attachmentName) && !String.isEmpty(ContentType)){
                contentType_1 = 'message/rfc822';
                endpoint = 'callout:Gmail/upload/gmail/v1/users/me/messages/send?uploadType=multipart';
                before = 'From: MvClouds <info@mvclouds.com>\n'+
                'To: '+sendTo+'\n'+
                'MIME-Version: 1.0\n'+
                'Subject: '+subjectMail+'\n' +
                'Content-Type: multipart/mixed; boundary="foo_bar_baz"\n\n'+
                
                    '--foo_bar_baz\n'+
                    'Content-Type: text/html; charset="UTF-8";\n'+
                    '\n\n'+bodyGmail+'\n\n';
                    System.debug('bodyGmail===>'+bodyGmail);
                    System.debug('before-->'+before);
    
                    if(!String.isEmpty(attachmentName) && !String.isEmpty(ContentType)){
                    System.debug('not null');
                    before += 
                        '--foo_bar_baz\n'+
                        'Content-Type: '+ContentType+'; \n'+
                        'Content-Transfer-Encoding: base64\n'+
                        'Content-Disposition: attachment; filename='+attachmentName+'\n\n'+
                        // EncodingUtil.base64Encode(attachment)+'\n\n--foo_bar_baz--';			
                        EncodingUtil.base64Encode(decodedBlob)+'\n\n--foo_bar_baz--';			
                        // result+'\n\n--foo_bar_baz--';
                    }
            }else{
                contentType_1 = 'application/json';
                endpoint = 'callout:Gmail/gmail/v1/users/me/messages/send';
                 String prebefore = 'From: MvCloud <info@mvclouds.com>\n'+
                        'To: '+sendTo+'\n'+
                        'Subject: '+subjectMail+'\n' +
                        'Content-Type: text/html \n\n'+bodyGmail;
                    System.debug(prebefore);
                    Blob beforeblob = Blob.valueOf(prebefore);
                    before = EncodingUtil.base64Encode(beforeblob);
                    before = before.replace('+', '-');
                    before = before.replace('/', '_');
                    System.debug(before);

            }
    
            Http httpMail = new Http();
            HttpRequest httpReqMail = new HttpRequest();
            HttpResponse httpResMail = new HttpResponse();
            httpReqMail.setEndpoint(endpoint);
            httpReqMail.setMethod('POST');
            httpReqMail.setHeader('Content-Type', contentType_1);
            httpReqMail.setHeader('Content-Length', '-1');
            String refreshToknBody = '{"userId":"me","raw":"'+before+'"}';
            system.debug(refreshToknBody);
            httpReqMail.setBody(refreshToknBody);
        
            try{
                httpResMail = httpMail.send(httpReqMail); 
                if(httpResMail.getStatusCode() == 200){
                    System.debug(httpResMail.getBody()); 
                }else{
                    String errorMessageMail = 'Unexpected Error while communicating with Google Calendar API. '
                        +'Status '+httpResMail.getBody()+' and Status Code '+httpResMail.getStatuscode();
                    System.debug('Error ' + errorMessageMail);
                    System.debug(httpResMail);
                }
            }catch(System.Exception e){
                
                System.debug('#### Exception Executed '+e.getStackTraceString() + ' '+e.getMessage());
            } 
        }
    }