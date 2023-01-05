trigger WhatsAppTrigger on Whatsapp_Message__c (before insert, before update) {

    Map<String, Whatsapp_Message__c> WhatsAppMap = new Map<String, Whatsapp_Message__c>();
    for (Whatsapp_Message__c con : System.Trigger.new) {        

        if ((con.Message_Id__c != null) && (System.Trigger.isInsert || (con.Message_Id__c !=System.Trigger.oldMap.get(con.Id).Message_Id__c))) {
           // Make sure another new Contact isn't also a duplicate  
            if (WhatsAppMap.containsKey(con.Message_Id__c)) {
                con.Message_Id__c.addError('A WHatsapp message with this ID');
                System.debug('A WHatsapp message with this ID');
            } else {
                WhatsAppMap.put(con.Message_Id__c, con);
            }
        }
    }   
    
    for (Whatsapp_Message__c cont : [SELECT Message_Id__c FROM Whatsapp_Message__c WHERE Message_Id__c IN :WhatsAppMap.KeySet()]) {
         Whatsapp_Message__c newMsg = WhatsAppMap.get(cont.Message_Id__c);
         newMsg.Message_Id__c.addError('A WHatsapp message with this ID');
         System.debug('A WHatsapp message with this ID');
    }
}