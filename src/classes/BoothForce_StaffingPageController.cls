global with sharing class BoothForce_StaffingPageController {

   
   public List  <AreaWithZones> areaWithZonesList    {get; private set;}
   public boolean isAManager      {get; private set;}
   public Staffing_Assignment__c blankStaffingAssignment  {get; set;}
   private map<String, String> areaMap;
   private String userStaffingRole;
   private String userId;
   private list <Booth__c> booths;
   private List <String> areasList;
   public String reportId {get; private set;}
  /************************************/
  public BoothForce_StaffingPageController(){
  	setupUserInfo();
  	setupBoothsList();
  	setupAreasList();
  	setupAreaWithZonesList();
  	setupIsAManager();
  	getDummyStaffingAssignment();
  	//blankStaffingAssignment = new Staffing_Assignment__c();
  }
  
  /*--test--*/
  private static testmethod void controllerTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    
    User u = [select id, Booth_Staffing_Role__c from User where id = :Userinfo.getUserId()];
    u.Booth_Staffing_Role__c = 'test';
    update u;
    
    BoothForce_StaffingPageController bspc = new BoothForce_StaffingPageController();
    bspc.ONLYCALLFORTESTING();
    bspc.setupBoothsList();
    bspc.setupAreasList();
    bspc.setupAreaWithZonesList();
    System.assert(bspc.booths.size() >= 1);
  }
  /*--End Test--*/
  /************************************/
   private void getDummyStaffingAssignment(){
    list<Staffing_Assignment__c> saList = [select id, Assigned__c from Staffing_Assignment__c limit 1];
    blankStaffingAssignment = saList[0];
    blankStaffingAssignment.Assigned__c = null;
   }
  /************************************/
  private void setupBoothsList(){
  	if (userStaffingRole == null || userStaffingRole ==''){
  	 booths = new list<Booth__c>();
  	 return;
  	}
    
    String role = userStaffingRole;	
  	booths =                 [Select b.Name, b.Id, b.Booth_Type__c, b.Zone__c,
  	                          b.Area_Zone__r.Location__c, b.Area_Zone__r.Id, b.Area_Zone__r.Name, 
  	                          b.Booth_Description__c, b.User_Booth_Staff__c,
								  	         (Select Id, IsDeleted,
								              Assigned__c, Is_Staffed__c 
								              From Staffing_Assignments__r 
								              where IsDeleted = false)
								              From Booth__c b 
                              where  b.User_Booth_Staff__c includes (:role)
                              Order By b.Area_Zone__r.Name, Name];
  }
 /************************************/
  private void setupUserInfo(){
  	userID = Userinfo.getUserId();
  	User userStuff = [select id, Name, Booth_Staffing_Role__c 
  	                  from User 
  	                  where id = :userId];
  	userStaffingRole = userStuff.Booth_Staffing_Role__c;
  }  
  /************************************/
  private void setupIsAManager(){
  	List<User> underlings = [Select ManagerId 
  	                         From User 
  	                         where managerId = :userId];
    if(underlings!=null && underlings.size()>0)
      isAManager = true;
    else
      isAManager = false;  	                         
  }
  /************************************/
  private void setupAreasList(){
  	areasList = new list<String>();
  	areaMap = new map <String, String>();
  	for(Booth__c b : booths){
  		areaMap.put(b.Area_Zone__r.Name, b.Area_Zone__r.Id);
  	}
  	for(String a: areaMap.keySet()){
  		areasList.add(a);
  	}
  	areasList.sort();
  }
  /************************************
  private void setupReportId(String reportName){
  	ReportFinderUtil rfu = new ReportFinderUtil();
    reportId = rfu.findReportId(reportName);
  }  
  /************************************/
  private void setupAreaWithZonesList(){
  	areaWithZonesList = new list<AreaWithZones>();
  	for(String a:areasList){
  		areaWithZonesList.add(new AreaWithZones(areaMap.get(a), a, booths));
  	}
  }
  /************************************/
  private void ONLYCALLFORTESTING(){
  	userStaffingRole = 'test';
  }
  /************************************/
}