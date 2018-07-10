public with sharing class BoothForce_TestingUtil {
  
  public String zoneId      {get; set;}
  public String boothOneId  {get; set;}
  public String boothTwoId  {get; set;}
  public String shiftTimeOneId  {get; set;}
  public String shiftTimeTwoId  {get; set;}
  public String staffingOneId   {get; set;}
  public String staffingTwoId   {get; set;}
  public String staffedId       {get; set;}

  public BoothForce_TestingUtil(){
  	createZone();
  	createBooths();
  	createShiftTimes();
  	generateStaffingDemand();
  }
  
  private void createZone(){
  	Area_Zone__c az = new Area_Zone__c();
  	az.Name = 'testZone';
  	az.Location__c = 'theCloud';
    insert az;
    zoneId = az.id;
  }
  
  private void createBooths(){
  	Booth__c b1 = new Booth__c();
  	b1.Name = 'bTest1';
  	b1.Booth_Type__c = 'testing';
  	b1.Area_Zone__c = zoneId;
  	b1.User_Booth_Staff__c = 'test';
  	b1.Zone__c = 'test';
  	insert b1;
  	boothOneId = b1.id;
  	
  	Booth__c b2 = new Booth__c();
    b2.Name = 'bTest2';
    b2.Booth_Type__c = 'testing';
    b2.Area_Zone__c = zoneId;
    b2.User_Booth_Staff__c = 'test';
    b2.Zone__c = 'test';
    insert b2;
    boothTwoId = b2.id;
  }

  private void createShiftTimes(){
  	Shift_Time__c s1 = new Shift_Time__c();
  	s1.Name = 'test';
  	s1.Shift_Start_Time__c = Datetime.now();
  	s1.Shift_Start_Time__c = s1.Shift_Start_Time__c.addHours(1);
    s1.Shift_End_Time__c = s1.Shift_Start_Time__c.addHours(1);
    s1.Area_Zone__c = zoneId;
    insert s1;
    shiftTimeOneId= s1.id;
    
    Shift_Time__c s2 = new Shift_Time__c();
    s2.Name = 'test';
    s2.Shift_Start_Time__c = Datetime.now();
    s2.Shift_Start_Time__c = s2.Shift_Start_Time__c.addDays(1);
    s2.Shift_End_Time__c = s2.Shift_Start_Time__c.addHours(1);
    s2.Area_Zone__c = zoneId;
    insert s2;
    shiftTimeTwoId= s2.id;
  }
  
  private void generateStaffingDemand(){
  	Staffing_Assignment__c s1 = new Staffing_Assignment__c();
  	s1.Booth__c = boothOneId;
  	s1.Shift_Time__c = shiftTimeOneId;
  	insert s1;
  	staffingOneId = s1.id;
  	
  	Staffing_Assignment__c s2 = new Staffing_Assignment__c();
    s2.Booth__c = boothTwoId;
    s2.Shift_Time__c = shiftTimeTwoId;
    insert s2;
    staffingTwoId = s2.id; 
  }

  public void addStaffingAssignment(){
  	list <Staffing_Assignment__c> sas = [Select Id, Booth__c, Assigned__c From Staffing_Assignment__c where Booth__c = :boothOneId];
  	sas[0].Assigned__c = Userinfo.getUserId();
  	staffedId = sas[0].id;
  	update sas[0];
  	staffedId = sas[0].id;
  	User u = [select id, number_of_staffing_assignments__c from User where id = :Userinfo.getUserId()];
    if(u.number_of_staffing_assignments__c == null){
    	u.number_of_staffing_assignments__c = 1;
    }
    else
      u.number_of_staffing_assignments__c += 1;
    update u;
  }
  
   /*--test--*/
  private static testmethod void testTrigger(){
  	BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
  	User u = [select id, number_of_staffing_assignments__c from User where id = :Userinfo.getUserId()];
  	double oldVal = u.number_of_staffing_assignments__c;
  	
  	if(oldVal == null)
  	 oldVal = 0;
  	
  	btu.addStaffingAssignment();
  	u = [select id, number_of_staffing_assignments__c from User where id = :Userinfo.getUserId()];
  	System.assert(oldVal+1 == u.number_of_staffing_assignments__c);
  	
  	Staffing_Assignment__c sa= [select Id from Staffing_Assignment__c where id = :btu.staffedId];
  	delete sa;
  	u = [select id, number_of_staffing_assignments__c from User where id = :Userinfo.getUserId()];
  	System.assert(u.number_of_staffing_assignments__c == oldVal);
  }
  /*--end--*/
}