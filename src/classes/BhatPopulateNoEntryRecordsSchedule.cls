global class BhatPopulateNoEntryRecordsSchedule implements Schedulable {

    global void execute(SchedulableContext ctx) {
            List<String> inactiveUsers =  BhatPopulateNoEntryRecordsLib.Populate(false);
    }
   
}