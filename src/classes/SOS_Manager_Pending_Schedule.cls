global class SOS_Manager_Pending_Schedule implements Schedulable {
	global void execute(SchedulableContext SC) {
    	SOS_Manager_Pending_Notification sosnotify = new SOS_Manager_Pending_Notification();
		Database.executeBatch(sosnotify);
	}
}