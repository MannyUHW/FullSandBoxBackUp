public with sharing class BoothForce_ManagerViewController {
	
	private list <date> dateList;
	private list <Staffing_Assignment__c> staffingAssignmentList;
	public  list <UserStaffListing> staffingAssignments    {get; set;}
	public list <MyBoothsByDate> boothsByDate {get; private set;}
	
	/********************************************/
  public BoothForce_ManagerViewController(){
  	createStaffingAssignmentList();
  	setupStaffingAssignments();
  	getStaffingDays();
    setupUserStaffingAssignments();
  }
  /*--test--*/
  private static testmethod void controllerTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_ManagerViewController bmvc = new BoothForce_ManagerViewController();
    System.assert(bmvc.StaffingAssignments != null);
  }
  /*--End Test--*/
  /********************************************/
  private void createStaffingAssignmentList(){
  	String userId = Userinfo.getUserId();
  	if(userId.length()>15)
  	 userId = userId.substring(0, 15);
    staffingAssignmentList = [Select s.Shift_Time__r.Shift_End_Time__c, s.Shift_Time__r.Shift_Start_Time__c, 
                              s.Shift_Time__c, s.Id, s.Booth__r.Booth_Type__c, s.Booth__r.Name, s.Booth__c, 
                              s.Booth__r.Id, s.Assigned__c,  s.Assigned_to_Users_Manager__c, s.Manager_Id__c , 
                              s.Assigned__r.LastName, s.Assigned__r.Name, Assigned__r.FirstName, s.Booth__r.Booth_Description__c
                              From Staffing_Assignment__c s
                              where  s.Manager_Id__c =:userId
                              order by s.Shift_Time__r.Shift_Start_Time__c, s.Assigned__r.FirstName];
  }
  /********************************************/
  private void setupStaffingAssignments(){
    StaffingAssignments = new list<UserStaffListing>();
    for(Staffing_Assignment__c sta : staffingAssignmentList){
      StaffingAssignments.add(new UserStaffListing(sta));
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
    private void setupUserStaffingAssignments(){
    boothsByDate = new List <MyBoothsByDate>();
    for(Date d: dateList){
      addByDate(new MyBoothsByDate(d, staffingAssignmentList));
    }   
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