global class SOS_ApprovalPendingNotification implements Schedulable {

    global void execute(SchedulableContext SC) {
        
        //Criterion is  send notification to manager If count of pending approvals > 0 for the manager 
        //and any one of the approvals is waiting for > 3 days for the last 30 days, then send email
        
        Date threeDaysBack = Date.today().addDays(-3);
        Date oneMonthBack =  Date.today().addDays(-30);
        
        List<User> listManagers = [SELECT Manager_Email__c,SOS_Manager_Name__c  FROM User WHERE Id IN 
            (SELECT CreatedById FROM SOS_Time_Off_Request__c WHERE Status__c = 'Manager Pending'
            AND Manager_Pending_Date__c >= :oneMonthBack AND Manager_Pending_Date__c < :threeDaysBack AND CreatedBy.Manager_Email__c != null) ];

            
        Map<String, String> managerEmailNames = new Map<String, String>(); 
        for (User u : listManagers) {
            if (managerEmailNames.get(u.Manager_Email__c) == null) {
                managerEmailNames.put(u.Manager_Email__c, u.SOS_Manager_Name__c);
            }
        }
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        
        
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address LIKE  'noreply@%' limit 1];
         
        string approval_url= System.Label.Salesforce_URL + 'apex/MyApprovals';
        string mailBody ='';
         
        for(String emailId : managerEmailNames.keySet()){ 
            String name = managerEmailNames.get(emailId);
            if (name == null) name  = '';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            
            mailBody = 'Dear ' + name + ',<br /><br />You have pending approval(s) waiting for more than 3 days.<br/><br/> ';
            //mailBody = mailBody+ '<a href="javascript:sforce.one.navigateToURL( \'' + approval_url + '\' );">Salesforce 1 Link</a><br /><br/> ';
            mailBody = mailBody+ 'If you are at your computer and would like to open up your Salesforce dashboard now, <a href="'+ approval_url +'">click this link.</a><br /><br/> ';
            mailBody = mailBody+ 'If you are viewing this from your phone, <a href="com.salesforce.salesforce1://apex/MyApprovals?sfdc.tabName=MyApprovals"> click this link </a>go to your Salesforce1 mobile app and select the “My Approvals” app from the list.  <br /><br/> ';
            
            mailBody = mailBody+ 'Thank You <br /><br/> ';
            mailBody = mailBody+ 'HR Dept<br /><br/> ';
            email.setHtmlBody(mailBody);

            email.setSubject('Pending Approvals');
            //email.setSenderDisplayName('Supervisor');
            //email.setTemplateId(templateId30Days);
            //email.setTargetObjectId(u.Id);
            
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            email.setToAddresses(new String[] {emailId});
            //email.setToAddresses(new String[] {'sun@strategicorganizingsystems.com','shoukatkhan@hotmail.com'});
            //email.setToAddresses(new String[] {'sun@strategicorganizingsystems.com', 'sun.nathan2012@gmail.com'});
            email.setSaveAsActivity(false);
            email.setUseSignature(false);
            messages.add(email);
        }
        if (!Test.isRunningTest()) {
            //Actual Emails are Send by this code
            Messaging.sendEmail(messages);
       }
        
    }
}