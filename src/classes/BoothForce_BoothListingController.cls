global with sharing class BoothForce_BoothListingController{
  
  public  String boothId                        {get; set;}
  private  String userId;
  private  list <Staffing_Assignment__c> staffingAssignmentList;
  private  list <StartTimeEndTime>  startEndList;
  private  list <Date> dateListDates;
  public   list <BoothListingDate> dateList     {get; set;}  
  public   list <ShiftRowsByDay> shiftRowDays   {get; set;}
  public   String signUpStaffingId              {get; set;}
  public   String boothName                     {get; set;}
  public   String boothDesc                     {get; set;}
  public   String noShiftTimes                  {get; set;}
  public   boolean enableAssign                 {get; set;}
  /******************************/
  public BoothForce_BoothListingController(){
  	boothId = Apexpages.currentPage().getParameters().get('id');
  	userId = Userinfo.getUserId();
  	setupStaffingAssignmentList();
  	setupEnableAssign();
  	if(staffingAssignmentList != null && staffingAssignmentList.size()>0){
	  	noShiftTimes= 'true';
	  	setupBoothInfo();
	  	setupDateList();
	  	setupStartEndList();
	    //setupShiftRows();
      setupShiftRowsByDay();
  	}
  	else{
  		noShiftTimes = 'false';
  	}
  }
  /*--test--*/
  private static testmethod void controllerTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    Apexpages.currentPage().getParameters().put('id', btu.boothOneId);
    BoothForce_BoothListingController blc = new BoothForce_BoothListingController();
    System.assert(blc.dateList != null);
  }
  /*--End Test--*/
  /******************************/
  private void setupStaffingAssignmentList(){
  	String localBoothId;
  	if(boothId == null || boothId.length()<12)
      return;
    
    localBoothId = boothId; 
  	staffingAssignmentList = [Select s.Shift_Time__r.Shift_Date__c, s.Shift_Time__r.Shift_End_Time__c, s.Assigned__r.Id,
  	                          s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__r.Id, s.Shift_Time__c, s.Assigned__r.Name,
  	                          s.Is_Staffed__c, s.IsDeleted, s.Id, s.Booth__r.Id, s.Booth__c, s.Assigned__c,
  	                          s.Booth__r.Name, s.Booth__r.Booth_Description__c
  	                          From Staffing_Assignment__c s
  	                          where s.IsDeleted = false and s.Booth__r.Id = :localBoothId
  	                          order by s.Shift_Time__r.Shift_Start_Time__c];
  	
  }
  /******************************/
  private void setupBoothInfo(){
  	boothName =staffingAssignmentList[0].Booth__r.Name;
  	boothDesc = staffingAssignmentList[0].Booth__r.Booth_Description__c;
  }
  /******************************/
  private void setupEnableAssign(){
    List<User> uList = [Select Id, Boothforce_assign_users_enabled__c 
                             From User 
                             where id = :userId];
    if(uList == null || uList.size() == 0 || uList[0].Boothforce_assign_users_enabled__c == false)
       enableAssign = false;
    else
      enableAssign = true;                                 
  }
  /************************************/
  //makes a list of sorted list of dates
  private void setupDateList(){
  	dateListDates = new List<Date>();
  	dateList = new List <BoothListingDate>();
  	Set<Date> dateSet;
  	Map<Date, Integer> dateMap = new Map <Date, Integer>();
  	for(Staffing_Assignment__c sa: staffingAssignmentList){
  		dateMap.put(sa.Shift_Time__r.Shift_Date__c, 1);
  	}
  	dateSet = dateMap.keySet();
    for(Date d: dateSet){
    	dateListDates.add(d);
    }
    dateListDates.sort();
    for(Date d : dateListDates){
    	dateList.add(new BoothListingDate(d));
    }
  }
  /******************************/
  //sets up a list of all the unique start and end times for all staffing assignments
  private void setupStartEndList(){
    	Map <String, StartTimeEndTime> shiftsMap = new Map <String, StartTimeEndTime>();
    	Set <String> shiftsString;
    	String keyS;
    	startEndList = new List <StartTimeEndTime>();
    	for(Staffing_Assignment__c sta : staffingAssignmentList){
    		keyS = shiftsMapToS(sta);
    		shiftsMap.put(keyS, new StartTimeEndTime(sta.Shift_Time__r.Shift_Start_Time__c, sta.Shift_Time__r.Shift_End_Time__c));
    	}
      shiftsString = shiftsMap.keySet();
      for(String s : shiftsString){
      	startEndList.add(shiftsMap.get(s));
      }
  }
  /******************************/
  private String shiftsMapToS(Staffing_Assignment__c sta){
  	String returnVal = ('**'+String.valueOf(sta.Shift_Time__r.Shift_Start_Time__c)+'$$'+String.valueOf(sta.Shift_Time__r.Shift_End_Time__c)+'**');
  	return returnVal;
  }
  /******************************/
  private void setupShiftRowsByDay(){
    shiftRowDays = new list<ShiftRowsByDay>();
    for (Date d: dateListDates){
	    shiftRowDays.add(new ShiftRowsByDay(startEndList, d, staffingAssignmentList));
    }
  }
  /******************************/
  public pagereference refreshPageContents(){
  	setupStaffingAssignmentList();
    setupDateList();
    setupStartEndList();
    //setupShiftRows();
    setupShiftRowsByDay();
    Pagereference pr = new Pagereference('/apex/BoothForce_StaffingPage?bthid='+boothId);
  	return pr;
  }
  /******************************/
  /********************************Static Methods*****************************************************************************/
  /******************************/
  public static webservice String signUp(String staffingAssignmentId){
  	String userId = Userinfo.getUserId();
  	User userToUpdate = [Select Id, number_of_staffing_assignments__c from User where Id = :userId];
  	Staffing_Assignment__c staffingAssignment = [Select s.Shift_Time__r.Shift_Date__c, s.Shift_Time__r.Shift_End_Time__c, 
                                                 s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__c, s.Id, s.Assigned__c
                                                 From Staffing_Assignment__c s where Id= :staffingAssignmentId];
    //check for overlap
    if(!noOverlapCheck(userToUpdate, staffingAssignment)){
    	return 'overlap';
    }
    
    staffingAssignment.Assigned__c = userId;
  	
  	if(userToUpdate.number_of_staffing_assignments__c == null)
  	 userToUpdate.number_of_staffing_assignments__c =1;
  	else
  	 userToUpdate.number_of_staffing_assignments__c += 1;
  	
  	try{
  		update staffingAssignment;
  		update UserToUpdate;
  		return 'ok';
  	}catch(exception e){
  		System.debug(e);
  		return 'error';
  	}
  }
  
   /*--test--*/
  private static testmethod void signUpTest(){
    User u = [select Id, number_of_staffing_assignments__c from User where id = :Userinfo.getUserId()];
    u.number_of_staffing_assignments__c = 0;
    update u;
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    Apexpages.currentPage().getParameters().put('id', btu.boothOneId);
    BoothForce_BoothListingController blc = new BoothForce_BoothListingController();
    BoothForce_BoothListingController.signUp(btu.staffingOneId);
    blc.refreshPageContents();
    System.assert(blc.boothId == btu.boothOneId); 
  }
  /*--End Test--*/
  /******************************/
  private static boolean noOverlapCheck(User u, Staffing_Assignment__c sa){
  	list <Staffing_Assignment__c> saCheckList= [Select s.Shift_Time__r.Shift_Date__c, s.Shift_Time__r.Shift_End_Time__c, 
  	                                            s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__c, s.Id, s.Assigned__c 
  	                                            From Staffing_Assignment__c s
  	                                            where Assigned__c = :u.Id and Shift_Time__r.Shift_Date__c = :sa.Shift_Time__r.Shift_Date__c];
    for(Staffing_Assignment__c saCheck: saCheckList){
    	if(saCheck.Shift_Time__r.Shift_Start_Time__c <= sa.Shift_Time__r.Shift_Start_Time__c && saCheck.Shift_Time__r.Shift_End_Time__c > sa.Shift_Time__r.Shift_Start_Time__c ){
    		return false;
    	}
      
      if(saCheck.Shift_Time__r.Shift_Start_Time__c >= sa.Shift_Time__r.Shift_Start_Time__c && saCheck.Shift_Time__r.Shift_Start_Time__c < sa.Shift_Time__r.Shift_End_Time__c){
      	return false;
      }   
    }
    return true;
  }
  /******************************/
  
   /********************************Static Methods MORE*****************************************************************************/
  public static webservice String assign(list <string> stringList){//String staffingAssignmentId, String assignId){
    
    if(stringList.size() != 2){
      return 'invalid';
    }
    
    String staffingAssignmentId = stringList[0];
    String userId = stringList[1];//assignId;//Userinfo.getUserId();
    
    User userToUpdate;
    
    list <User> userToUpdateList = [Select Id, number_of_staffing_assignments__c, Booth_Staffing_Role__c, Do_Not_Assign__c from User where Id = :userId];
    Staffing_Assignment__c staffingAssignment = [Select s.Shift_Time__r.Shift_Date__c, s.Shift_Time__r.Shift_End_Time__c, 
                                                 s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__c, s.Id, 
                                                 s.Assigned__c, s.Booth__r.User_Booth_Staff__c
                                                 From Staffing_Assignment__c s where Id= :staffingAssignmentId];
    //check user
    if((userToUpdateList == null || userToUpdateList.size()==0 || userToUpdateList[0].Do_Not_Assign__c))
      return 'invalid';
    else
      userToUpdate = userToUpdateList[0];
        
    //check profile
    if(invalidUserSelected(staffingAssignment, userToUpdate)){
      return 'invalid';
    }
    
    //check for overlap
    if(!noOverlapCheckAssign(userToUpdate, staffingAssignment)){
      return 'overlap';
    }
    
    staffingAssignment.Assigned__c = userId;
    
    if(userToUpdate.number_of_staffing_assignments__c == null)
     userToUpdate.number_of_staffing_assignments__c =1;
    else
     userToUpdate.number_of_staffing_assignments__c += 1;
    
    try{
      update staffingAssignment;
      update UserToUpdate;
      return 'ok';
    }catch(exception e){
      System.debug(e);
      return 'error';
    }
  }
  
   /*--test--*/
  private static testmethod void assignTest(){
    User u = [select Id, number_of_staffing_assignments__c from User where id = :Userinfo.getUserId()];
    u.number_of_staffing_assignments__c = 0;
    u.Booth_Staffing_Role__c = 'test';
    update u;
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    String val = BoothForce_BoothListingController.assign(new String[]{btu.staffingOneId, u.Id});
    System.assert(val !=null); 
  }
  /*--End Test--*/
  /**********************************************/
  private static boolean invalidUserSelected(Staffing_Assignment__c sa, User u){
    String rolesUnsplit = sa.Booth__r.User_Booth_Staff__c;
    if(rolesUnsplit == null || rolesUnsplit.length()<2 || u.Booth_Staffing_Role__c == null)
     return true; 

    if(rolesUnsplit.contains(u.Booth_Staffing_Role__c))
      return false;
      
    return true;
  }
  /******************************/
  private static boolean noOverlapCheckAssign(User u, Staffing_Assignment__c sa){
    list <Staffing_Assignment__c> saCheckList= [Select s.Shift_Time__r.Shift_Date__c, s.Shift_Time__r.Shift_End_Time__c, 
                                                s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__c, s.Id, s.Assigned__c 
                                                From Staffing_Assignment__c s
                                                where Assigned__c = :u.Id and Shift_Time__r.Shift_Date__c = :sa.Shift_Time__r.Shift_Date__c];
    for(Staffing_Assignment__c saCheck: saCheckList){
      if(saCheck.Shift_Time__r.Shift_Start_Time__c <= sa.Shift_Time__r.Shift_Start_Time__c && saCheck.Shift_Time__r.Shift_End_Time__c > sa.Shift_Time__r.Shift_Start_Time__c ){
        return false;
      }
      
      if(saCheck.Shift_Time__r.Shift_Start_Time__c >= sa.Shift_Time__r.Shift_Start_Time__c && saCheck.Shift_Time__r.Shift_Start_Time__c < sa.Shift_Time__r.Shift_End_Time__c){
        return false;
      }   
    }
    return true;
  }
  /******************************/ 
  /**********************************************/
}