public class SOS_BhatActivityReminderReportController{
    
    public Task startDateObj{get; set;}
    public Task endDateObj{get; set;}
    public List<BHAT_Activity_Reminder_Log__c> reminderLog{get; set;}
    
    public SOS_BhatActivityReminderReportController() {  
        
        startDateObj = new Task();
        endDateObj = new Task();        
    }
    
    public PageReference search() {
        if (startDateObj.ActivityDate == null) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Start Date is required');
            ApexPages.addMessage(message);
            return null;
        }
        if (endDateObj.ActivityDate == null) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'End Date is required');
            ApexPages.addMessage(message);
            return null;
        }
        if (startDateObj.ActivityDate >= endDateObj.ActivityDate) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Start Date should be less than End Date');
            ApexPages.addMessage(message);
            return null;
        }
        
        reminderLog = [SELECT User__r.Name, User__r.Email, Email_For_30_Day_Sent_On__c, 
            Email_For_60_Day_Sent_On__c, Email_For_90_Day_Sent_On__c FROM BHAT_Activity_Reminder_Log__c
            WHERE 
            (Email_For_30_Day_Sent_On__c != null AND Email_For_30_Day_Sent_On__c >= :startDateObj.ActivityDate AND Email_For_30_Day_Sent_On__c <= :endDateObj.ActivityDate) OR
            (Email_For_60_Day_Sent_On__c!= null AND Email_For_60_Day_Sent_On__c >= :startDateObj.ActivityDate AND Email_For_60_Day_Sent_On__c<= :endDateObj.ActivityDate) OR
            (Email_For_90_Day_Sent_On__c != null AND Email_For_90_Day_Sent_On__c >= :startDateObj.ActivityDate AND Email_For_90_Day_Sent_On__c <= :endDateObj.ActivityDate)
            ORDER BY Email_For_90_Day_Sent_On__c DESC,  Email_For_60_Day_Sent_On__c DESC, Email_For_30_Day_Sent_On__c DESC
        ];
        
        return null;
    }
    
    
}