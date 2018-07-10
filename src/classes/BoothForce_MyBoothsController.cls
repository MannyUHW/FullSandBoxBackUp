public with sharing class BoothForce_MyBoothsController {
  
  private list <date> dateList;
  private list <Staffing_Assignment__c> staffingAssignmentList;
  private String userId;
  public list <MyBoothsByDate> boothsByDate {get; private set;}
  public Boolean signedUp                   {get; private set;}
  
  /******************************************/
  public BoothForce_MyBoothsController(){
    userId = Userinfo.getUserId();
    setupStaffingAssignmentList();
    setupSignedUp();
    getStaffingDays();
    setupUserStaffingAssignments();
  }
  /*--test--*/
  private static testmethod void controllerTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    BoothForce_MyBoothsController bmbc = new BoothForce_MyBoothsController();
    System.assert(bmbc.boothsByDate.size()>=1);
  }
  /*--End Test--*/
  /******************************************/
  private void setupStaffingAssignmentList(){ 
    staffingAssignmentList = [Select s.Shift_Time__r.Shift_End_Time__c, s.Shift_Time__r.Shift_Start_Time__c, 
                      s.Shift_Time__c, s.Id, s.Booth__r.Booth_Type__c, s.Booth__r.Name, s.Booth__c, s.Booth__r.Booth_Description__c,
                      s.Booth__r.Id, s.Assigned__c, s.Assigned__r.Name 
                      From Staffing_Assignment__c s
                      where s.Assigned__c =:userId
                      order by s.Shift_Time__r.Shift_Start_Time__c];
  }
  /******************************************/
  private void setupUserStaffingAssignments(){
  	boothsByDate = new List <MyBoothsByDate>();
    for(Date d: dateList){
    	addByDate(new MyBoothsByDate(d, staffingAssignmentList));
    }  	
  }
  /******************************************/
  private void getStaffingDays(){
  	Map <String, Date> sdMap = new Map <String, Date>();
  	for(Staffing_Assignment__c s : staffingAssignmentList){
  		sdMap.put(s.shift_Time__r.Shift_Start_Time__c.Date().format(), s.shift_Time__r.Shift_Start_Time__c.Date());
  	}
    dateList = new list <Date>();
    set <String> sdMapKeys = sdMap.keySet();
    for(String str : sdMapKeys){
    	dateList.add(sdMap.get(str));
    }
  }
  /******************************************/
  private void setupSignedUp(){
  	if(staffingAssignmentList.size()==0)
  	 signedUp = false;
  	else
  	 signedUp = true;
  }
  /******************************************/
  //adds resources in order...
  private void addByDate(MyBoothsByDate mbbd){
    boolean mbbdAdded = false;
    list <MyBoothsByDate> localList = new list <MyBoothsByDate>();
    
    for(MyBoothsByDate mbbdOld: boothsByDate){
    	if(mbbd.occurDate < mbbdOld.occurDate && !mbbdAdded){
    		localList.add(mbbd);
    		localList.add(mbbdOld);
    		mbbdAdded = true;
    	}
      else{
      	localList.add(mbbdOld);
      }
    }
    
    if(!mbbdAdded){
    	localList.add(mbbd);
    }
    
    boothsByDate.clear();
    for(MyBoothsByDate val : localList){
    	boothsByDate.add(val);
    }
  }
  /******************************************/
}