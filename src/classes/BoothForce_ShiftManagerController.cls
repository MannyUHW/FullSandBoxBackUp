public with sharing class BoothForce_ShiftManagerController {
  
  public list<Selectoption> areas      {get; set;}
  public list<Selectoption> zones      {get; set;}
  public list<Selectoption> shiftTimes {get; set;}
  public String area                   {get; set;}
  public String zone                   {get; set;}
  public String shiftTime              {get; set;}
  public boolean  showZones            {get; set;}
  public boolean  showShiftTimes       {get; set;}
  public list <Staffing_Assignment__c> staffingList {get; set;}
  public String niceDate               {get; private set;}
  public String areaName               {get; private set;}
  public boolean  showTable            {get; private set;}
  /****************************************/
  public BoothForce_ShiftManagerController(){
   setupAreas();	
   setupZones();
   setupShiftTimes();
  }
  /*--Test--*/
  private static testmethod void testController(){
  	BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
  	BoothForce_ShiftManagerController smc = new BoothForce_ShiftManagerController();
    smc.area = btu.zoneId;
    smc.areaSelected();
    System.assert(smc.areas.size()>0);
  } 
  /*--End Test--*/
  /****************************************/
  public void areaSelected(){
  	setupZones();
    setupShiftTimes();
    shiftTimeSelected();
  }
  /*--Test--*/
  private static testmethod void testAreaSelected(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_ShiftManagerController smc = new BoothForce_ShiftManagerController();
    smc.area = btu.zoneId;
    smc.areaSelected();
    System.assert(smc.zones.size()>0);
  }
  /*--End Test--*/
  /****************************************/
  public void zoneSelected(){
  	setupShiftTimes();
  	shiftTimeSelected();
  }
  /*--Test--*/
  private static testmethod void testZoneSelected(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_ShiftManagerController smc = new BoothForce_ShiftManagerController();
    smc.area = btu.zoneId;
    smc.zone = 'test';
    smc.zoneSelected();
    System.assert(smc.shiftTimes.size()>0);
  }
  /*--End Test--*/
  /****************************************/
  public void shiftTimeSelected(){
  	if(showShiftTimes && shiftTime != null && shiftTime != 'SELECT'){
  	   staffingList = [Select s.Id, s.Shift_Time__r.Shift_End_Time__c,
                       s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__c, 
                       s.Booth__r.Zone__c, s.Booth__r.Area_Zone__c, s.Is_Staffed__c,
  	                   s.Booth__r.Name, s.Booth__c, s.Assigned__r.Manager.Name, 
                       s.Assigned__r.MobilePhone, s.Assigned__r.Phone, 
                       s.Assigned__r.Email, s.Assigned__r.Name, s.Assigned__c,
                       s.Booth__r.Area_Zone__r.Name 
                       From Staffing_Assignment__c s
                       where s.Booth__r.Area_Zone__c = :area
                       and s.Booth__r.Zone__c = :zone
                       and s.Shift_Time__c = :shiftTime
                       and s.Is_Staffed__c > 0
                       order by Booth__r.Name, Assigned__r.Name];
  	}
    if(staffingList!=null && staffingList.size()>0){
  	  showTable = true;
  	  niceDate = staffingList[0].Shift_Time__r.Shift_Start_Time__c.format('MM/dd hh:mm')+'-'+staffingList[0].Shift_Time__r.Shift_End_Time__c.format('hh:mm a');
      areaName = staffingList[0].Booth__r.Area_Zone__r.Name;
    }
    else{
    	showTable = false;
    	niceDate = '';
    	areaName = '';
    }
  }
  /*--Test--*/
  private static testmethod void testshiftTimeSelected(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    BoothForce_ShiftManagerController smc = new BoothForce_ShiftManagerController();
    btu.addStaffingAssignment();
    smc.area = btu.zoneId;
    smc.zone = 'test';
    smc.shiftTime = btu.shiftTimeOneId;
    smc.setupAreas();
    smc.setupZones();
    smc.setupShiftTimes();
    smc.shiftTimeSelected();
    System.assert(smc.staffingList.size()>0);
  }
  /*--End Test--*/
  /****************************************/
  public void setupAreas(){
  	list <Area_Zone__c> areaList = [select id, Name from Area_Zone__c Order by Name limit 249];
    areas = new list <Selectoption>();
    areas.add(new Selectoption('SELECT','SELECT'));
    for(Area_Zone__c az : areaList){
    	areas.add(new Selectoption(az.Id, az.Name));
    }
  }
  /****************************************/
  public void setupZones(){
  	if(area == null || area == 'SELECT')
  	 showZones = false;
  	else
  	 showZones = true;
  	 
  	zones = new list<Selectoption>();
  	zones.add(new Selectoption('SELECT', 'SELECT'));
    if(showZones)
      addZonesList(); 	
  }
  /****************************************/
  private void addZonesList(){
    List <Booth__c>  boothList = [select id, zone__c, Area_Zone__c from Booth__c where Area_Zone__c = :area];
    Map <String, Integer> zoneMap = new Map <String, Integer>();
    for(Booth__c b : boothList){
    	zoneMap.put(b.zone__c, 1);
    }
    
    list<String> zoneList = new List<String>();
    for(String z : zoneMap.keySet()){
      zoneList.add(z);
    }
    
    zoneList.sort();
    
    for(String zl: zoneList){
    	zones.add(new Selectoption(zl,zl));
    }
  }
  /****************************************/
  public void setupShiftTimes(){
  	if(!showZones || zone == null || zone == 'SELECT')
  	 showShiftTimes = false;
  	else 
  	 showShiftTimes = true;
  	
  	shiftTimes = new List<Selectoption>();
  	shiftTimes.add(new Selectoption('SELECT','SELECT'));
  	
  	if(showShiftTimes){
  		addShiftTimesList();
  	}
  }
  /****************************************/
  public void addShiftTimesList(){
  	list <Shift_Time__c> stList = [Select s.Shift_Start_Time__c, s.Shift_End_Time__c, 
  	                               s.Id, s.Area_Zone__c, (Select Booth__r.zone__c From Staffing_Assignments__r
  	                               where Booth__r.zone__c = :zone)
  	                               From Shift_Time__c s
  	                               Where s.Area_Zone__c = :area 
  	                               order by s.Shift_Start_Time__c];
  	String soString;
  	for(Shift_Time__c st: stList){
      soString = st.Shift_Start_Time__c.format('MM/dd hh:mm')+'-'+st.Shift_End_Time__c.format('hh:mm a');  	
  		shiftTimes.add(new Selectoption(st.Id, soString));
  	}
  }
  /****************************************/
}