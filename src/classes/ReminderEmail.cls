public class ReminderEmail
    {
        public list<Messaging.SingleEmailMessage> EmailMessageList { get; set; }
        public list<BHAT_Activity_Reminder_Log__c> ReminderLogList { get; set; }
        public list<ReminderEmailReport> ReminderEmailReportList{ get; set; }
        
          
        
        public ReminderEmail()
        {
        
            this.EmailMessageList = new List<Messaging.SingleEmailMessage>();
            this.ReminderLogList = new List<BHAT_Activity_Reminder_Log__c>();
            this.ReminderEmailReportList = new list<ReminderEmailReport>();
        
        }
        
    }