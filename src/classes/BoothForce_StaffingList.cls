public with sharing class BoothForce_StaffingList {
  
  public String   boothKey         {get; private set;}
  public String   shiftKey         {get; private set;}
  public Area_Zone__c zone         {get; private set;}
  public ZoneAndShifts zoneShifts  {get; private set;}
  public String zoneId             {get; private set;}
  private list <Booth__c> booths;
  private list <Shift_Time__c> shiftTimes;
  
  /***********************************/
  public BoothForce_StaffingList(){
  	zoneId = Apexpages.currentPage().getParameters().get('id');
  	zoneId = Encodingutil.urlEncode(zoneId, 'UTF-8');
  	doQueries();
    zoneShifts = new ZoneAndShifts(zone, booths, shiftTimes);
    setupKeys();
  }

  public BoothForce_StaffingList(String id){
  	zoneId = id;
    doQueries();
    zoneShifts = new ZoneAndShifts(zone, booths, shiftTimes);
  	setupKeys();
  }
  
  public Integer getBoothsSize(){
  	return booths.size();
  }

/*--test--*/
  private static testmethod void controllerTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    Apexpages.currentPage().getParameters().put('id',btu.zoneId);
    BoothForce_StaffingList sl = new BoothForce_StaffingList();
    sl.getBoothsSize();
    System.assert(sl.booths.size()>0);
    System.assert(sl.shiftTimes.size()>0);
  }
  /*--end test--*/
  /***********************************/
  private void setupKeys(){
  	Schema.DescribeSObjectResult D = Booth__c.sObjectType.getDescribe();
  	boothKey = D.getKeyPrefix();
  	D = Shift_Time__c.sObjectType.getDescribe();
  	shiftKey = D.getKeyPrefix();
  }
  /***********************************/
  private void doQueries(){
  	booths = [Select b.Name, b.Id, b.Area_Zone__c, (Select Id, IsDeleted, 
              Name, Shift_Time__c, Assigned__c, Assigned_to_Users_Manager__c, 
              Is_Staffed__c From Staffing_Assignments__r where IsDeleted = false) 
              From Booth__c b 
              where b.Area_Zone__c =:zoneId
              Order By Name];
                              
    shiftTimes = [Select s.Shift_Start_Time__c, s.Shift_End_Time__c,
                  s.Shift_Date__c, s.Name, s.IsDeleted, s.Id, s.Area_Zone__c 
                  From Shift_Time__c s
                  Where s.IsDeleted = false
                  Order By Shift_Start_Time__c];
                  
    list <Area_Zone__c> zones  = [Select Name, Id, Prevent_Assignment_Removal__c 
                                  From Area_Zone__c
                                  where id = :zoneId];
    if(zones != null && zones.size()>0)
      zone = zones[0];
  }
  /***********************************/

}