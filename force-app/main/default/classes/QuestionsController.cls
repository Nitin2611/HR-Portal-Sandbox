public without sharing class QuestionsController {

    public QuestionsController() {

    }

    @AuraEnabled
    public static string createContact(String firstname,String lastname,String email,String enroll){
        String conId = '';
        try {

            List<Contact> contactList = [SELECT Id,Name,Email,Enrollment_No__c FROM Contact WHERE Email =:email LIMIT 1];

            if(contactList.size() > 0){
                conId = contactList[0].Id;
            }else{
                Contact con = new Contact();
                con.FirstName = firstname;
                con.LastName = lastname;
                con.Email = email;
                con.Apply_through_form__c = true;
                con.Enrollment_No__c = enroll;
                con.Description = 'Silveroak Interview Candidate';
                insert con;
                conId = con.Id;
            }

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return conId;
    }

    @AuraEnabled
    public static string saveAnswers(String answer1,String answer2,String answer3,String answer4,String answer5,String answer6,String ansId){
        try {
            System.debug(answer1);
            System.debug(answer2);
            System.debug(answer3);
            System.debug(answer4);
            System.debug(answer5);
            System.debug(answer6);
            System.debug(ansId);
            List<Answer__c> ans = [SELECT Id,Answer_1__c,Answer_2__c,Answer_3__c,Answer_4__c,Answer_5__c,Answer_6__c,Question_1__r.Question__c,Question_2__r.Question__c,Question_3__r.Question__c,Question_4__r.Question__c,Question_5__r.Question__c,Question_6__r.Question__c,Contact__c FROM Answer__c WHERE Id =: ansId LIMIT 1];
            ans[0].Answer_1__c  = answer1;
            ans[0].Answer_2__c = answer2;
            ans[0].Answer_3__c = answer3;
            ans[0].Answer_4__c = answer4;
            ans[0].Answer_5__c = answer5;
            ans[0].Answer_6__c = answer6;
            update ans;

            String connId = ans[0].Contact__c;
            List<Contact> conId = [SELECT Id,Name,Email FROM Contact WHERE Id=:connId LIMIT 1];

            String subject = 'Thank You!';
            String sendTo = conId[0].Name+'<'+conId[0].Email+'>';
            // String body = '<html xmlns="http://www.w3.org/1999/xhtml"> <head> <meta http-equiv="content-type" content="text/html; charset=utf-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0;"> <meta name="format-detection" content="telephone=no" /> <style> /* Reset styles */ body { margin: 0; padding: 0; min-width: 100%; width: 100% !important; height: 100% !important; } body, table, td, div, p, a { -webkit-font-smoothing: antialiased; text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; line-height: 100%; } table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; border-collapse: collapse !important; border-spacing: 0; } img { border: 0; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; } #outlook a { padding: 0; } .ReadMsgBody { width: 100%; } .ExternalClass { width: 100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } /* Rounded corners for advanced mail clients only */ @media all and (min-width: 560px) { .container { border-radius: 8px; -webkit-border-radius: 8px; -moz-border-radius: 8px; -khtml-border-radius: 8px; } } /* Set color for auto links (addresses, dates, etc.) */ a, a:hover { color: #127DB3; } .footer a, .footer a:hover { color: #999999; } </style> <title>Get this responsive email template</title> </head> <body topmargin="0" rightmargin="0" bottommargin="0" leftmargin="0" marginwidth="0" marginheight="0" width="100%" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; width: 100%; height: 100%; -webkit-font-smoothing: antialiased; text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; line-height: 100%; background-color: #F0F0F0; color: #000000;" bgcolor="#F0F0F0" text="#000000"> <table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; width: 100%;" class="background"> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0;" bgcolor="#F0F0F0"> <table border="0" cellpadding="0" cellspacing="0" align="center" width="560" style="border-collapse: collapse; border-spacing: 0; padding: 0; width: inherit; max-width: 560px;" class="wrapper"> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; padding-top: 20px; padding-bottom: 20px;"> <a target="_blank" style="text-decoration: none;" href="https://www.mvclouds.com"><img border="0" vspace="0" hspace="0" src="https://mvclouds.com/wp-content/uploads/2020/08/mvclouds-logo.png" width="auto" height="30" alt="Logo" title="Logo" style=" color: #000000; font-size: 10px; margin: 0; padding: 0; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; border: none; display: block;" /></a> </td> </tr> </table> <table border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="#FFFFFF" width="560" style="border-collapse: collapse; border-spacing: 0; padding: 0; width: inherit; max-width: 560px;" class="container"> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 20px;" class="hero"><a target="_blank" style="text-decoration: none;" href="#"><img border="0" vspace="0" hspace="0" src="https://t4.ftcdn.net/jpg/02/30/01/91/360_F_230019146_b2lZmLVHpGZc031us7MN8Bn2g5qjnbyF.jpg" title="Hero Image" width="560" style=" width: 100%; max-width: 560px; color: #000000; font-size: 13px; margin: 0; padding: 0; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; border: none; display: block;" /></a> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; padding-top: 25px;" class="line"> <hr color="#E0E0E0" align="center" width="100%" size="1" noshade style="margin: 0; padding: 0;" /> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%;" class="list-item"> <table align="center" border="0" cellspacing="0" cellpadding="0" style="width: inherit; margin: 0; padding: 0; border-collapse: collapse; border-spacing: 0;"> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 1:-</b><br /> '+ans[0].Question_1__r.Question__c+'<br /> <b style="color: #333333;">Answer 1:-</b><br /> '+ans[0].Answer_1__c+'</td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 2:-</b><br />'+ans[0].Question_2__r.Question__c+' <br /> <b style="color: #333333;">Answer 2:-</b><br /> '+ans[0].Answer_2__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 3:-</b><br />'+ans[0].Question_3__r.Question__c+' <br /> <b style="color: #333333;">Answer 3:-</b><br /> '+ans[0].Answer_3__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 4:-</b><br />'+ans[0].Question_4__r.Question__c+' <br /> <b style="color: #333333;">Answer 4:-</b><br /> '+ans[0].Answer_4__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 5:-</b><br />'+ans[0].Question_5__r.Question__c+' <br /> <b style="color: #333333;">Answer 5:-</b><br /> '+ans[0].Answer_5__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 6:-</b><br />'+ans[0].Question_6__r.Question__c+' <br /> <b style="color: #333333;">Answer 6:-</b><br /> '+ans[0].Answer_6__c+' </td> </tr> </table> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; padding-top: 25px;" class="line"> <hr color="#E0E0E0" align="center" width="100%" size="1" noshade style="margin: 0; padding: 0;" /> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; font-size: 17px; font-weight: 400; line-height: 160%; padding-top: 20px; padding-bottom: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> Have a question? <a href="mailto:info@mvclouds.com" target="_blank" style="color: #127DB3; font-family: sans-serif; font-size: 17px; font-weight: 400; line-height: 160%;">info@mvclouds.com</a> </td> </tr> </table> </td> </tr> </table> </body> </html>';
            String body = '<html xmlns="http://www.w3.org/1999/xhtml"> <head> <meta http-equiv="content-type" content="text/html; charset=utf-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0;"> <meta name="format-detection" content="telephone=no" /> <style> /* Reset styles */ body { margin: 0; padding: 0; min-width: 100%; width: 100% !important; height: 100% !important; } body, table, td, div, p, a { -webkit-font-smoothing: antialiased; text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; line-height: 100%; } table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; border-collapse: collapse !important; border-spacing: 0; } img { border: 0; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; } #outlook a { padding: 0; } .ReadMsgBody { width: 100%; } .ExternalClass { width: 100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } /* Rounded corners for advanced mail clients only */ @media all and (min-width: 560px) { .container { border-radius: 8px; -webkit-border-radius: 8px; -moz-border-radius: 8px; -khtml-border-radius: 8px; } } /* Set color for auto links (addresses, dates, etc.) */ a, a:hover { color: #127DB3; } .footer a, .footer a:hover { color: #999999; } </style> <title>Get this responsive email template</title> </head> <body topmargin="0" rightmargin="0" bottommargin="0" leftmargin="0" marginwidth="0" marginheight="0" width="100%" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; width: 100%; height: 100%; -webkit-font-smoothing: antialiased; text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; line-height: 100%; background-color: #F0F0F0; color: #000000;" bgcolor="#F0F0F0" text="#000000"> <table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; width: 100%;" class="background"> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0;" bgcolor="#F0F0F0"> <table border="0" cellpadding="0" cellspacing="0" align="center" width="560" style="border-collapse: collapse; border-spacing: 0; padding: 0; width: inherit; max-width: 560px;" class="wrapper"> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; padding-top: 20px; padding-bottom: 20px;"> <a target="_blank" style="text-decoration: none;" href="https://www.mvclouds.com"><img border="0" vspace="0" hspace="0" src="https://mvclouds.com/wp-content/uploads/2020/08/mvclouds-logo.png" width="auto" height="30" alt="Logo" title="Logo" style=" color: #000000; font-size: 10px; margin: 0; padding: 0; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; border: none; display: block;" /></a> </td> </tr> </table> <table border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="#FFFFFF" width="560" style="border-collapse: collapse; border-spacing: 0; padding: 0; width: inherit; max-width: 560px;" class="container"> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 20px;" class="hero"><a target="_blank" style="text-decoration: none;" href="#"><img border="0" vspace="0" hspace="0" src="https://t4.ftcdn.net/jpg/02/30/01/91/360_F_230019146_b2lZmLVHpGZc031us7MN8Bn2g5qjnbyF.jpg" title="Hero Image" width="560" style=" width: 100%; max-width: 560px; color: #000000; font-size: 13px; margin: 0; padding: 0; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; border: none; display: block;" /></a> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; padding-top: 25px;" class="line"> <hr color="#E0E0E0" align="center" width="100%" size="1" noshade style="margin: 0; padding: 0;" /> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%;" class="list-item"> <table align="center" border="0" cellspacing="0" cellpadding="0" style="width: inherit; margin: 0; padding: 0; border-collapse: collapse; border-spacing: 0;"> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 1:-</b><br /> '+ans[0].Question_1__r.Question__c+'<br /> <b style="color: #333333;">Answer 1:-</b><br /> '+ans[0].Answer_1__c+'</td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 2:-</b><br />'+ans[0].Question_2__r.Question__c+' <br /> <b style="color: #333333;">Answer 2:-</b><br /> '+ans[0].Answer_2__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 3:-</b><br />'+ans[0].Question_3__r.Question__c+' <br /> <b style="color: #333333;">Answer 3:-</b><br /> '+ans[0].Answer_3__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 4:-</b><br />'+ans[0].Question_4__r.Question__c+' <br /> <b style="color: #333333;">Answer 4:-</b><br /> '+ans[0].Answer_4__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 5:-</b><br />'+ans[0].Question_5__r.Question__c+' <br /> <b style="color: #333333;">Answer 5:-</b><br /> '+ans[0].Answer_5__c+' </td> </tr> <tr> <td align="left" valign="top" style="font-size: 17px; font-weight: 400; line-height: 160%; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-top: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> <b style="color: #333333;">Question 6:-</b><br />'+ans[0].Question_6__r.Question__c+' <br /> <b style="color: #333333;">Answer 6:-</b><br /> '+ans[0].Answer_6__c+' </td> </tr> </table> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; padding-top: 25px;" class="line"> <hr color="#E0E0E0" align="center" width="100%" size="1" noshade style="margin: 0; padding: 0;" /> </td> </tr> <tr> <td align="center" valign="top" style="border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; padding-left: 6.25%; padding-right: 6.25%; width: 87.5%; font-size: 17px; font-weight: 400; line-height: 160%; padding-top: 20px; padding-bottom: 25px; color: #000000; font-family: sans-serif;" class="paragraph"> Have a question? <a href="mailto:info@mvclouds.com" target="_blank" style="color: #127DB3; font-family: sans-serif; font-size: 17px; font-weight: 400; line-height: 160%;">info@mvclouds.com</a> </td> </tr> </table> </td> </tr> </table> </body> </html>';

            GoogleGmailApi.sendGmail(subject,body,sendTo);



            return '';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static questionwrapper getQuestions(List<String> langlist,String contactId){
        try {
            questionwrapper qw = new questionwrapper();
            qw.quelist = new List<Question__c>();
            System.debug('langlist-->'+langlist);

            List<Answer__c> ansList = [SELECT Id,Name,Question_1__c,Question_2__c,Question_3__c,Question_4__c,Question_5__c,Question_6__c,Contact__c FROM Answer__c WHERE Contact__c=:contactId LIMIT 1];
            if(ansList.size() > 0){
                Set<Id> queId =  new Set<id>();
                queid.add(ansList[0].Question_1__c);
                queid.add(ansList[0].Question_2__c);
                queid.add(ansList[0].Question_3__c);
                queid.add(ansList[0].Question_4__c);
                queid.add(ansList[0].Question_5__c);
                queid.add(ansList[0].Question_6__c);
                qw.quelist = [SELECT Id,Type__c,Question__c FROM Question__c WHERE Id=:queId];
                qw.ansId = ansList[0].Id;
            }else{
                String value = '(\'' + langlist[0] + '\')';
                List<Question__c> q1 = Database.query('SELECT Id,Type__c,Question__c FROM Question__c WHERE Type__c INCLUDES '+value);

                //qw.quelist.add(q1[Integer.valueof((Math.random() * (q1.size()-1)))]);
                while (qw.quelist.size() < 4 && qw.quelist.size() <= q1.size()){
                    Integer index = (Math.random() * (q1.size() - 1)).intValue();
                    qw.quelist.add(q1.remove(index));
                }

                if(langlist.size() == 2){
                    String value1 = '(\'' + langlist[1] + '\')';
                    List<Question__c> q2 = Database.query('SELECT Id,Type__c,Question__c FROM Question__c WHERE Type__c INCLUDES '+value1);
                    //qw.quelist.add(q2[Integer.valueof((Math.random() * (q2.size()-1)))]);
                    while (qw.quelist.size() < 6 && qw.quelist.size() <= (q2.size()+qw.quelist.size())){
                        Integer index = (Math.random() * (q2.size() - 1)).intValue();
                        qw.quelist.add(q2.remove(index));
                    }
                }
    
                Answer__c ans = new Answer__c();
                ans.Question_1__c = null;
                ans.Question_2__c = null;
                ans.Question_3__c = null;
                ans.Question_4__c = null;
                ans.Question_5__c = null;
                ans.Question_5__c = null;
                ans.Contact__c = contactId;
                for(Question__c c: qw.quelist){
                    if(ans.Question_1__c == null){
                        ans.Question_1__c = c.Id;
                    } else if(ans.Question_2__c == null){
                        ans.Question_2__c = c.Id;
                    } else if(ans.Question_3__c == null){
                        ans.Question_3__c = c.Id;
                    } else if(ans.Question_4__c == null){
                        ans.Question_4__c = c.Id;
                    } else if(ans.Question_5__c == null){
                        ans.Question_5__c = c.Id;
                    } else if(ans.Question_6__c == null){
                        ans.Question_6__c = c.Id;
                    } 
                }
    
                insert ans;
                qw.ansId = ans.id;
            }


            return qw;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class questionwrapper{
        @AuraEnabled
        public List<Question__c> quelist {get;set;}
        @AuraEnabled
        public String ansId {get;set;}

    }
}