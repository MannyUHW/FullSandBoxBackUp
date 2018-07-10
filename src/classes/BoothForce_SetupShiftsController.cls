global with sharing class BoothForce_SetupShiftsController {
  
  public boolean zoneExist                        {get; private set;}
  public List <Area_Zone__c>      zones           {get; set;}
  public Area_Zone__c newAreaZone                 {get; set;}
  public Booth__c     newBooth                    {get; set;}
  public Shift_Time__c newShiftTime               {get; set;}
  
  /************************************/
  public BoothForce_SetupShiftsController(){
  	doQueries();
  	setupNewObjects();
  }
  
  /*--test--*/
  private static testmethod void controllerTest(){
  	BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
  	BoothForce_SetupShiftsController bfss = new BoothForce_SetupShiftsController();
  	System.assert(bfss.zones.size()>=1);
  }
  /*--end test--*/
  /************************************/
  private void doQueries(){
    zones = [Select Name, Id, Prevent_Assignment_Removal__c 
             From Area_Zone__c
             Order By Name limit 250];
    
    if(zones == null || zones.size()==0)
      zoneExist = false;
    else
      zoneExist = true;
  }
  /************************************/
  public Pagereference refresh(){
    doQueries();
    newAreaZone = new Area_Zone__c();
  	return null;
  }
   /*--test--*/
  private static testmethod void refreshTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_SetupShiftsController bfss = new BoothForce_SetupShiftsController();
    bfss.refresh();
    System.assert(bfss.zones.size()>0);
  }
  /*--end test--*/
  /************************************/
  public void createZone(){
    newAreaZone.Prevent_Assignment_Removal__c = false;
    try{
    	insert newAreaZone;
    }catch(Exception e){}
    refresh();
  }
  /*--test--*/
  private static testmethod void createZoneTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_SetupShiftsController bfss = new BoothForce_SetupShiftsController();
    Integer oldVal = bfss.zones.size();
    bfss.newAreaZone.Name = 'A NEW ZONE';
    bfss.newAreaZone.Location__c= 'A New Location';
    bfss.createZone();
    System.assert(bfss.zones.size() > oldVal);
  }
  /*--end test--*/
  /************************************/
  private void setupNewObjects(){
  	newAreaZone = new Area_Zone__c();
  	newBooth = new Booth__c();
  	newShiftTime = new Shift_Time__c();
  }
  /************************************/
  /********************************Static Methods*****************************************************************************/
  /************************************/
  public static Webservice void addBooth(list <String> boothInfo){
    Booth__c newBooth = new Booth__c();
    newBooth.Name = boothInfo[0];
    newBooth.Booth_Type__c =  boothInfo[1];
    newBooth.Booth_Description__c = boothInfo[2];
    newBooth.User_Booth_Staff__c = boothInfo[3];
    newBooth.Area_Zone__c = boothInfo[4];
    newBooth.Zone__c = boothInfo[5];
    try{
    	insert newBooth;
    }catch (Exception e){System.debug('%%%%%%%%'+e);}
  }
  /*--Test--*/
  private static testmethod void addBoothTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    List <String> boothList = new list <String>();
    boothList.add('NEW BOOTH');
    boothList.add('TEST');
    boothList.add('DESCRIPTION');
    boothList.add('ALL');
    boothList.add(btu.zoneId);
    boothList.add('ZONE');
    
    
    Apexpages.currentPage().getParameters().put('id', btu.zoneId);
    BoothForce_StaffingList sl = new BoothForce_StaffingList();
    Integer oldVal = sl.getBoothsSize();
    BoothForce_SetupShiftsController.addBooth(boothList);
    sl = new BoothForce_StaffingList();
    System.debug('!!!!!!!!!!!!!!!!!!!!!!'+oldVal +' '+sl.getBoothsSize());
    System.assert(sl.getBoothsSize()>oldVal);
  }
  /*--end test--*/
  /************************************/
  public static Webservice String addShift(list <String> shiftInfo){
    Shift_Time__c newShiftTime = new Shift_Time__c();
    newShiftTime.Name = shiftInfo[0];
    newShiftTime.Shift_Start_Time__c = DateTime.parse(shiftInfo[1]);
    newShiftTime.Shift_End_Time__c = DateTime.parse(shiftInfo[2]); 
    newShiftTime.Area_Zone__c = shiftInfo[3];
    
    try{
    	insert newShiftTime;
    	return 'ok';
    }catch(Exception e){
      return 'error';
    }
  }
   /*--Test--*/
  private static testmethod void addShiftTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    List <String> newShift = new List<String>();
    newShift.add('NEW SHIFT');
    newShift.add(Datetime.now().format());
    newShift.add(Datetime.now().addHours(1).format());
    newShift.add(btu.zoneId);
    
    String val = BoothForce_SetupShiftsController.addShift(newShift);
    System.assert(val == 'ok');
  }
  /*--end test--*/
  /************************************/
  public static Webservice void makeAllDropable(){
  	List <Area_Zone__c > zones = [Select Name, Id, Prevent_Assignment_Removal__c 
                                  From Area_Zone__c
                                  limit 250];
    for(Area_Zone__c az: zones){
    	az.Prevent_Assignment_Removal__c = false;
    }                                  
    
    if(zones.size()>0)
      update zones;
  }
  /*--test--*/
  private static testmethod void makeAllDropableTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_SetupShiftsController.makeAllDropable();
    Area_Zone__c z= [select id, Prevent_Assignment_Removal__c from Area_Zone__c where id = :btu.zoneId];
    system.assert(z.Prevent_Assignment_Removal__c == false);
    BoothForce_SetupShiftsController.makeAllNonDropable();
    z= [select id, Prevent_Assignment_Removal__c from Area_Zone__c where id = :btu.zoneId];
    system.assert(z.Prevent_Assignment_Removal__c == true);
  }
  /*--end test--*/
  /************************************/
  public static Webservice void makeAllNonDropable(){
    List <Area_Zone__c > zones = [Select Name, Id, Prevent_Assignment_Removal__c 
                                  From Area_Zone__c
                                  limit 250];
    for(Area_Zone__c az: zones){
      az.Prevent_Assignment_Removal__c = true;
    }                                  
    
    if(zones.size()>0)
      update zones;
  }
  
  /************************************/
  public static Webservice void toggleDrop(String zoneId){
    List <Area_Zone__c> azList = [select id, Prevent_Assignment_Removal__c
                                  from Area_Zone__c
                                  where id = :zoneId];  	
    if(azList == null || azList.size() == 0){
      return;
    }
    
    Area_Zone__c az = azList[0];
    
    if(az.Prevent_Assignment_Removal__c == true)
      az.Prevent_Assignment_Removal__c = false;
    else
      az.Prevent_Assignment_Removal__c = true;
    
     try{
     	update az;
     }catch(Exception e){
     	System.debug('TOGGLE DROP UPDATE ERROR');
     }
  }
  /*--test--*/
  private static testmethod void toggleDropTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    Area_Zone__c az;
    az = [select id, Prevent_Assignment_Removal__c
          from Area_Zone__c
          where id = :btu.zoneId];
    
    boolean oldVal = az.Prevent_Assignment_Removal__c;                       
    BoothForce_SetupShiftsController.toggleDrop(btu.zoneId);
    az = [select id, Prevent_Assignment_Removal__c
          from Area_Zone__c
          where id = :btu.zoneId];
    System.assert(oldVal != az.Prevent_Assignment_Removal__c);
     
    oldVal=az.Prevent_Assignment_Removal__c; 
    BoothForce_SetupShiftsController.toggleDrop(btu.zoneId);
    az = [select id, Prevent_Assignment_Removal__c
          from Area_Zone__c
          where id = :btu.zoneId];
    System.assert(oldVal != az.Prevent_Assignment_Removal__c);
  }
  /*--end test--*/
  /************************************/
  public static Webservice String updateZone(list<String> updateVals){
  	if(updateVals==null || updateVals.size() != 3)
  	 return 'LIST ERROR';
  	String zoneId = updateVals[2];
  	String zoneName = updateVals[1];
  	String preventDrop = updateVals[0];
  	
  	try{
  	 Area_Zone__c az = [select name, Id, Prevent_Assignment_Removal__c from Area_Zone__c where id = :zoneId];
  	 az.Name = zoneName;
  	 az.Prevent_Assignment_Removal__c = Boolean.valueOf(preventDrop);
  	 update az;
  	}catch(exception e){
  		return 'FETCH OR UPDATE ERROR';
  	}
  	return 'ok'; 
  }
  /*--test--*/
  private static testmethod void updateZoneTest(){
  	BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
  	list <String> updateVals = new List <String>();
  	updateVals.add('true');
  	updateVals.add('NEW NAME');
  	updateVals.add(btu.zoneId);
  	BoothForce_SetupShiftsController.updateZone(updateVals);
  	Area_Zone__c az = [select name, Id, Prevent_Assignment_Removal__c from Area_Zone__c where id = :btu.zoneId];
  	System.assert(az.Name == 'NEW NAME');
  }
  /*--end test--*/ 
  /************************************/
  public static Webservice List<String> addAndDeleteStaffingAssignments(List <String> shiftCounts){
    String zoneId = shiftCounts[shiftcounts.size()-1];
    if(zoneId.length()<=10){
    	List <String> errorList =  new list <String>();
    	errorList.add('Zone ID ERROR');
    	return errorList;
    }
    shiftCounts.remove(shiftcounts.size()-1);
    List <Integer> shiftCountsInts = stringsToInts(shiftCounts);
    BoothForce_StaffingList slController = new BoothForce_StaffingList(zoneId);
    List <String> returnVals = compareShiftCountsAndExecute(slController, shiftCountsInts);    
    return returnVals;
  }
       /*--test--*/
  private static testmethod void addAndDeleteStaffingAssignmentsTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    List <String> counts = testingFunction('2');
    List <String> returnValues;
    counts.add(btu.zoneId);
    returnValues = BoothForce_SetupShiftsController.addAndDeleteStaffingAssignments(counts);
    System.assert(returnValues[0]=='ok');
    
    counts.clear();
    counts = testingFunction('1');
    counts.add(btu.zoneId);
    returnValues = BoothForce_SetupShiftsController.addAndDeleteStaffingAssignments(counts);
    System.assert(returnValues[0]=='ok');
    
    btu.addStaffingAssignment();
    counts.clear();
    counts = testingFunction('0');
    counts.add(btu.zoneId);
    returnValues = BoothForce_SetupShiftsController.addAndDeleteStaffingAssignments(counts);
    System.assert(returnValues[0]!='ok');
   }
   
   private static testmethod void addAndDeleteStaffingAssignmentsTestPartTwo(){
    
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    
    List <String> counts = testingFunction('2');
    counts.add('abc');
    List <String> returnValues = BoothForce_SetupShiftsController.addAndDeleteStaffingAssignments(counts);
    System.assert(returnValues[0]!='ok');
    
    counts.clear();
    counts = testingFunction('2');
    counts.add('2');
    counts.add(btu.zoneId);
    returnValues = BoothForce_SetupShiftsController.addAndDeleteStaffingAssignments(counts);
    System.assert(returnValues[0]!='ok');
   }
  
  private static List<String> testingFunction(String val){
  	list<String> returnVal = new list<String>();
    for(integer i=0; i<4; i++){
      returnVal.add(val);
    }
  	return returnVal;
  }
  /*--end test--*/
  /************************************/
  private static List<String> compareShiftCountsAndExecute(BoothForce_StaffingList slController, List <Integer> shiftCountsInts){
    List<String> returnVals = new List <String>();
    Integer place = 0;
    ZoneAndShifts zas= slController.zoneShifts;
    
    if(zas == null){
      returnVals.add('Invalid Zone');
      return returnVals;
    }
    
    Integer moveAmount = zas.shiftTimeStrings.size();
    List <Integer> compareArray;   
    List <String> subReturnVals;
        
    String check = checkSizes(shiftCountsInts.size(), moveAmount, zas.boothsAndShifts.size());
    if(check != 'ok'){
      returnVals.add(check);
      return  returnVals;
    }
    
    for(BoothAndShifts bAndS: zas.boothsAndShifts){
    	compareArray = getCompareArray(place, moveAmount, shiftCountsInts);
    	place = place+moveAmount;
    	subReturnVals=addAndDeleteBoothShifts(compareArray, bAndS, zas);
    	if(subReturnVals[0]!='ok'){
    		returnVals.addAll(subReturnVals);
    	}
    } 
    if (returnVals.size()==0)
      returnVals.add('ok'); 	
    return returnVals;
  }
  /************************************/
  private static List<String> addAndDeleteBoothShifts(List<Integer> compareArray, BoothAndShifts bs, ZoneAndShifts zas){
  	List <String> returnVals = new List<String>();
  	List <Staffing_Assignment__c> insertList = new List <Staffing_Assignment__c>();
  	List <Staffing_Assignment__c> deleteList = new List <Staffing_Assignment__c>();
  	Integer difference;
  	List <Staffing_Assignment__c> subDeleteList;
  	
  	for(Integer i=0; i<compareArray.size(); i++){
  		difference= compareArray[i]-bs.shiftInfo[i].total;
  		if(difference > 0){
  		  insertList.addAll(addStaffing(difference, bs, zas.LocalShiftTimes[i]));
  		}
  		else if(difference < 0){
  			subDeleteList = deleteStaffing(difference*-1, bs, zas.LocalShiftTimes[i]);
  		  if(subDeleteList == null)
  		    returnVals.addAll(setupErrorArray(bs, zas.LocalShiftTimes[i]));
  		  else
  		    deleteList.addAll(subDeleteList);
  		}
  	}
  	
  	String updatesOk = handleUpdates(deleteList, insertList);
  	
  	if(updatesOk != 'ok')
  	 returnVals.add(updatesOk);
  	
  	if(returnVals.size()==0)
  	 returnVals.add('ok');
  	 
  	return returnVals;
  }
  /************************************/
  private static List<String> setupErrorArray(BoothAndShifts bs, Shift_Time__c st){
  	List <String> returnVals = new List<String>();
  	String shiftTime = st.Shift_Start_Time__c.format('hh:mm')+'-'+st.Shift_End_Time__c.format('hh:mm a');
  	String shiftDate = st.Shift_Start_Time__c.format('MM/dd');
  	String errorLine = 'Delete Error--Booth:'+bs.boothName+' Shift Time:'+shiftDate+' '+shiftTime+' is fully staffed. Only unstaffed Staffing_Assignments can be deleted';
  	returnVals.add(errorLine);
  	return returnVals;
  }
  /************************************/
  private static String handleUpdates(List <Staffing_Assignment__c> deleteList, List <Staffing_Assignment__c> insertList){
  	String returnVal = '';
  	
  	if(insertList.size()>0){
  		try{
  			insert insertList;
  		}catch(Exception e){
  			 returnVal +='insertError';
  		}
  	}
  	
  	if(deleteList.size()>0){
      try{
        delete deleteList;
      }catch(Exception e){
        returnVal+= 'deleteError';
      }
    }
    
    if (returnVal.length() > 3)
      return returnVal;
    else
      return 'ok';
  }
  /************************************/
  private static list<Staffing_Assignment__c> addStaffing(Integer numToAdd, BoothAndShifts bs, Shift_Time__c st ){
  	List <Staffing_Assignment__c> returnVals = new List <Staffing_Assignment__c>();
  	Staffing_Assignment__c sa;

  	for(Integer i = 0; i<numToAdd; i++){
  		sa = new Staffing_Assignment__c();
  		sa.Shift_Time__c = st.Id;
  		sa.Booth__c = bs.boothId;
  		returnVals.add(sa);
  	}

  	return returnVals;
  }
  /************************************/
  private static list<Staffing_Assignment__c> deleteStaffing(Integer numToAdd, BoothAndShifts bs, Shift_Time__c st ){
    List <Staffing_Assignment__c> returnVals = new List <Staffing_Assignment__c>();
    Staffing_Assignment__c sa;
    Map <String, String> deleteIds = new Map<String, String>();

    for(Integer i = 0; i<numToAdd; i++){
      sa = getStaffingAssignmentToDelete(bs.boothId, st.Id, deleteIds);
      if(sa == null)
        return null;
      else{
        deleteIds.put(sa.Id, sa.Id);
        returnVals.add(sa);
      }
    }

    return returnVals;
  }
  /************************************/
  private static Staffing_Assignment__c getStaffingAssignmentToDelete(String boothId, String shiftId, Map<String, String> deleteIds){
  	String boothIdIn = boothId;
  	String shiftIdIn = shiftId;
  	List <Staffing_Assignment__c> returnVals = [select Id from Staffing_Assignment__c 
  	                                           where Shift_Time__c =:shiftIdIn and Booth__c =:boothIdIn
  	                                           and Is_Staffed__c = 0.0];
    if(returnVals == null || returnVals.size()==0)
    	return null;
    else
      return getDeleteVal(returnVals, deleteIds);  	                                           
  }
  /************************************/
  Private static Staffing_Assignment__c getDeleteVal(List <Staffing_Assignment__c> returnVals, Map<String, String> deleteIds){
    for(Staffing_Assignment__c sa: returnVals){
    	if(deleteIds.get(sa.Id)==null)
    	 return sa;
    }
    return null;    
  }
  /************************************/   
  private static List<Integer> getCompareArray(Integer place, Integer moveAmount, List <Integer> shiftCountsInts){
  	List<Integer> returnVals = new List <Integer>();
  	Integer endLocation = place + moveAmount;
  	for(Integer i = place; i<endLocation; i++){
  		returnVals.add(shiftCountsInts[i]);
  	}
  	return returnVals;
  }
  /************************************/
  private static String checkSizes(Integer incomingShiftCount, Integer numShiftTimes, Integer numBooths){
  	Integer totalLocalCount = numShiftTimes * numBooths;
  	if(totalLocalCount != incomingShiftCount)
  	 return 'CountError';
  	else
  	 return 'ok';
  }
  /************************************/
  private static List <Integer> stringsToInts(List <String> stringList){
    List <Integer> returnVals = new List <Integer>();
    for (String val : stringList){
      returnVals.add(Integer.valueOf(val));
    }
    return returnVals;
  }
  /************************************/
}