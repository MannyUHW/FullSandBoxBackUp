global class BhatActivityReminderEmailSchedule implements Schedulable {

    global void execute(SchedulableContext ctx) {
            
       BhatActivityReminderEmail BhatActivityReminderEmail = new BhatActivityReminderEmail();
       List<ReminderEmailReport> ReminderEmailReportList = BhatActivityReminderEmail.GetBhatActivityPendingList(new list<id>(), new list<Integer>());
       
       /*
       for(ReminderEmailReport rpt: ReminderEmailReportList)
       {
            rpt.UserEmailId  ='Sun@strategicorganizingsystems.com';
       }       
       */
       
       BhatActivityReminderEmail.SendEmailReminder(ReminderEmailReportList );
       BhatActivityReminderEmail.UpdateReminderLog(ReminderEmailReportList );
    }
   
}