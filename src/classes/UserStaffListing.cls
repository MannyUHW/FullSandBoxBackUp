public with sharing class UserStaffListing {

   public String shiftTime    {get; set;}
   public String boothName    {get; set;}
   public String boothId      {get; set;}
   public String boothDesc    {get; private set;}
   public String staffingId   {get; set;}
   public String userId       {get; set;}
   public String userName     {get; set;}
   public String shiftDay     {get; set;}
  /**********************************/
  public UserStaffListing(Staffing_Assignment__c sta){
  	shiftTime = makeShiftTime(sta.Shift_Time__r.Shift_Start_Time__c, sta.Shift_Time__r.Shift_End_Time__c);
    shiftDay =  makeShiftDay(sta.Shift_Time__r.Shift_Start_Time__c);
    boothName = sta.Booth__r.Name;
    boothId = sta.Booth__r.Id;
    boothDesc = sta.Booth__r.Booth_Description__c;
    staffingId = sta.id;
    userName = sta.Assigned__r.Name;
    userId = sta.Assigned__r.Id;
  }
  /**********************************/
  private String makeShiftTime(Datetime startT, Datetime endT){
  	return  startT.format('h:mm a')+' - '+endT.format('h:mm a');
  }
  /**********************************/
  private String makeShiftDay(Datetime startT){
    return  startT.format('yyyy-dd-MM');
  }
  /**********************************/
}