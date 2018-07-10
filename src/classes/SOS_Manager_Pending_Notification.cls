global class SOS_Manager_Pending_Notification implements Database.Batchable<sObject> , Database.Stateful{
    public Set<Id> tobEmpSet = new Set<Id>();
    @testVisible String query;
    Set<String> toAddressesSet = new Set<String>();
    List<String> toAddresses = new List<String>();
    public Boolean isHRPending = false;
    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
    global Database.QueryLocator start(Database.BatchableContext BC){
    if (!Test.isRunningTest())
        query = 'Select Id, Status__c, Time_Off_Balance__c, Time_Off_Balance__r.Employee_Name__c, Manager_Pending_Date__c, HR_Pending_Date__c  from SOS_Time_Off_Request__c where Status__c = \'Manager Pending\' or Status__c = \'HR Pending\'';        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.Debug('@@@Scope:'+scope);
        If(scope != null) {
            for(sobject s : scope){
                SOS_Time_Off_Request__c tor = (SOS_Time_Off_Request__c) s;
                if(tor.Manager_Pending_Date__c < system.today())
                    tobEmpSet.add(tor.Time_Off_Balance__r.Employee_Name__c);
                if(tor.HR_Pending_Date__c < system.today() && !isHRPending)
                  isHRPending = true;
            }
        }
    }
        
    global void finish(Database.BatchableContext BC){
        if(isHRPending || test.isRunningTest())
      toAddressesSet.addAll(SOS_Utility.getUserEmailIdsFromGroup(system.label.HR_Group_Id));
    for(User usr : [Select Id, ManagerId, Manager.email from user where id in : tobEmpSet]) {
            toAddressesSet.add(usr.Manager.email);
            System.Debug('@@@toAddresses'+toAddressesSet);
        }
        if(toAddressesSet != null && toAddressesSet.size() > 0) {
            toAddresses.addAll(toAddressesSet);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('Time off request approval remainder.');
            String messageBody = '<html>Time off requests are pending for your approval. <br/><br/>Please click on below link and Approve/Reject the pending requests.<br>'+sfdcBaseURL+'/home/home.jsp</html>';
            mail.setHtmlBody(messageBody);        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}