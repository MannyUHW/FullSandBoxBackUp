trigger StaffingAssignmentDelete on Staffing_Assignment__c (before delete) {
  for(Staffing_Assignment__c sa : Trigger.old){
  	if(sa.Assigned__c != null){
  		User u = [select Id, number_of_staffing_assignments__c from User where id = :sa.Assigned__c];
  		u.number_of_staffing_assignments__c -=1;
  		update u;
  	}
  }
}