public class GoogleCalendarActionsController {
    public static String Summary { get; set; }
    Public Static String allCalendars { get; set; }
    public Static Boolean isListCalendars { get; set; }
    public static String AccountName {get;set;}
    
    public static void doListAllCalendar(){
        List<GoogleCalenderInfo__c> googleSettingInfoList = new List<GoogleCalenderInfo__c>();
        googleSettingInfoList = GoogleCalenderInfo__c.getAll().values();
        String accessToken = googleSettingInfoList[0].Access_Token__c;
        String endPoint = 'https://www.googleapis.com/calendar/v3/calendars/info@mvclouds.com/events';
        //String endPoint = 'https://www.googleapis.com/calendar/v3/calendars/kushalbagadia.kpb@gmail.com/events';
        
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse HttpRes = new HttpResponse();
        
		httpReq.setEndpoint(endpoint);
        httpReq.setMethod('GET');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization','Bearer '+accessToken);
        try{
            HttpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 200){
                isListCalendars = true;
                System.debug('#### HtteRes '+HttpRes.getBody());
                allCalendars = HttpRes.getBody();
                ApexPages.addmessage(new ApexPages.message(
                    	ApexPages.severity.CONFIRM,'Calendar List Retrieved Successfully '));
            }else{
                String errorMessage = 'Unexpected Error while communicating with Google Calendar API. '
						+'Status '+HttpRes.getStatus()+' and Status Code '+HttpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString() +'  '+e.getMessage());
        }
    }
    
    public static void doCreateNewCalendar(){
        List<GoogleCalenderInfo__c> googleSettingInfoList = new List<GoogleCalenderInfo__c>();
        googleSettingInfoList = GoogleCalenderInfo__c.getAll().values();
        String accessToken = googleSettingInfoList[0].Access_Token__c;
        if(Summary == null || Summary == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Calendar Title!'));
            return ;
        }
        String requestBody = '{"end": {"date": "2020-04-05"},"start": {"date": "2020-04-05"},"kind": "calendar#event","summary": "Hello World"}';
        
        
        
        System.debug('#### requestBody '+requestBody);
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse HttpRes = new HttpResponse();
        
		httpReq.setEndpoint('https://www.googleapis.com/calendar/v3/calendars/info@mvclouds.com/events'); 
        httpReq.setMethod('POST');
        httpReq.setBody(requestBody);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization','Bearer '+accessToken);
        try{
            HttpRes = http.send(httpReq);
            if(HttpRes.getStatusCode() == 200){
                isListCalendars = false;
                allCalendars = '';
                ApexPages.addmessage(new ApexPages.message(
                    	  ApexPages.severity.CONFIRM,'Calendar Created Successfully  '+'\n'+' '+
                			HttpRes.getBody()));
            }else{
                String errorMessage = 'Unexpected Error while communicating with Google Calendar API. '
						+'Status '+HttpRes.getStatus()+' and Status Code '+HttpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
        }catch(System.Exception e){
            System.debug('#### Exception Executed : '+e.getMessage() + '  '+e.getStackTraceString() + ' '+e.getLineNumber());
        }
    }
}