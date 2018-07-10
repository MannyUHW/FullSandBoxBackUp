public with sharing class MyBoothsByDate {
  public Datetime occurDate                                 {get; private set;}
  public list <UserStaffListing> userStaffingAssignments    {get; private set;}
  
  /******************************************/
  public MyBoothsByDate(Date d, list <Staffing_Assignment__c> staffingAssignmentList){
  	occurDate = Datetime.newInstance(d.year(), d.month(), d.day());
  	userStaffingAssignments = new list<UserStaffListing>();
    for(Staffing_Assignment__c sta : staffingAssignmentList){
      if(sta.shift_Time__r.Shift_Start_Time__c.Date() == d){
        userStaffingAssignments.add(new UserStaffListing(sta));
      }
    }
  }
  /******************************************/
}