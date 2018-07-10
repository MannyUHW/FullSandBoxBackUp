global with sharing class BoothForce_TradeWithPersonController {
  
  public String staffingId            {get; set;}
  private boolean testing;
  private String oldAssigned;
  public Staffing_Assignment__c staffingAssignment{get; set;}
  public String boothName            {get; set;}
  public String timeSlot             {get; set;}
  public String allowedRoles         {get; set;}
  public String currentStafferName   {get; set;}
  public String validUser            {get; set;}
  public boolean preventDrop         {get; set;}
  /**********************************************/
  public BoothForce_TradeWithPersonController(){
  	testing = false;
  	staffingId = EncodingUtil.urlEncode(System.currentPageReference().getParameters().get('id'), 'UTF-8');
  	setupStaffingAssignment();
  	setupCurrentStafferName();
    makeShiftTime(staffingAssignment.Shift_Time__r.Shift_Start_Time__c, staffingAssignment.Shift_Time__r.Shift_End_Time__c);
    setupBoothName();
    setupAllowedRoles();
    validUser = 'true';
    preventDrop = staffingAssignment.Booth__r.Area_Zone__r.Prevent_Assignment_Removal__c;
  }
  /*--test--*/
  private static testmethod void controllerTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    System.currentPageReference().getParameters().put('id', btu.staffedId);
    BoothForce_TradeWithPersonController twpc = new BoothForce_TradeWithPersonController();
    System.assert(twpc.staffingAssignment!=null);
  }
  /*--End Test--*/
  /**********************************************/
  private void setupCurrentStafferName(){
  	 currentStafferName = staffingAssignment.Assigned__r.Name;
  }
  /**********************************************/
  private void setupStaffingAssignment(){
    staffingAssignment = [Select Name, Id, Booth__r.Name, Booth__c, Booth__r.id, Booth__r.Area_Zone__r.Prevent_Assignment_Removal__c,
                          Shift_Time__r.Shift_End_Time__c, Shift_Time__r.Shift_Start_Time__c, Shift_Time__c,
                          Assigned_to_Users_Manager__c, Assigned__c, Assigned__r.Name, Booth__r.User_Booth_Staff__c
                          From Staffing_Assignment__c
                          where id =:staffingId];
    oldAssigned = staffingAssignment.Assigned__c;
  }
  /**********************************************/
  private boolean invalidUserSelected(){
  	String rolesUnsplit = staffingAssignment.Booth__r.User_Booth_Staff__c;
    String userId = staffingAssignment.Assigned__c;
    
    if(rolesUnsplit == null || rolesUnsplit.length()<2)
     return true; 
  	
  	List <String> roles = rolesUnsplit.split(';');
  	List<User> userCheck = [select id, Name, Booth_Staffing_Role__c, Do_Not_Assign__c 
                            from User 
                            where Booth_Staffing_Role__c in :roles
                            and id = :userId];

    if((userCheck == null || userCheck.size()==0 || userCheck[0].Do_Not_Assign__c) && !testing)
      return true;
      
    return false;
  }
  /**********************************************/
  public Pagereference swap(){
    Pagereference pr =getPageRef();
    
    if(invalidUserSelected()){
      validUser = 'false';
      return pr;
    }
      
    List<User> users = updateShiftCounts();
    try{
    	update staffingAssignment;
      update users;
    	emailSwappers(oldAssigned, staffingAssignment.Assigned__c);
      validUser='true';
      return pr;  
    }catch(Exception e){
    	validUser = 'false';
    	return pr;
    }
  }
  
  /*--test--*/
  private static testmethod void swapTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    System.currentPageReference().getParameters().put('id', btu.staffedId);
    BoothForce_TradeWithPersonController twpc = new BoothForce_TradeWithPersonController();
    twpc.swap();
    System.assert(twpc.validUser == 'false');
    User u = [select id, number_of_staffing_assignments__c from User where Id = :userinfo.getUserId()];
    u.number_of_staffing_assignments__c = 3;
    update u;
    twpc.ONLYUSEFORTESTING();
    twpc.staffingAssignment.Assigned__c = Userinfo.getUserId();
    system.assert(twpc.swap()!=null);
  }
  /*--End Test--*/
  
  /**********************************************/
  private void emailSwappers(String oldId, String newId){
  	List <User> users = [Select u.Name, u.Manager.Email, u.Manager.Name, 
  	                     u.ManagerId, u.Email
  	                     From User u 
  	                     where id = :oldId 
  	                     or id = :newId];
  	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  	
  	String newName;
  	String oldName;
  	list <String> toAddresses = new list<String>();
  	for(User u : users){
  		if(u.Email != null)
  		  toAddresses.add(u.Email);
  		if(u.Manager.Email != null)
  		  toAddresses.add(u.Manager.Email);
  		
  		if(u.Id == oldId)
  		  oldName = u.Name;
      if(u.Id == newId)
        newName = u.Name;
  	}  		    
  	mail.setToAddresses(toAddresses);
  	mail.setSubject('Notice: Boothshift Swap');	
  	String body = oldName + ' has swapped with '+newName+ ' to staff the '+boothName+' booth during the timeslot '+	timeSlot;
  	mail.setPlainTextBody(body);
  	try{
  		Messaging.sendEmail(new Messaging.Email[] { mail });
  		
  	} catch(Exception e){
  		System.debug('!!!!!'+e);
  	}
  }
  /**********************************************/
  private Pagereference getPageRef(){
  	if(oldAssigned != userInfo.getUserId()){
       return new Pagereference('/apex/BoothForce_StaffingPage?mvgls=hrarf');
    }
    else{
      return new Pagereference('/apex/BoothForce_StaffingPage');
    }
  }
  /**********************************************/
  private list<User> updateShiftCounts(){
  	String userId = oldAssigned;//Userinfo.getUserId();
    String swapId = staffingAssignment.Assigned__c;
    list <User> users = [select Id, number_of_staffing_assignments__c from User where Id =:userId or Id = :swapId];
    for(User u : users){
      if(u.id==userId)
        u.number_of_staffing_assignments__c -=1;  
      else if(u.id==swapId){
        if(u.number_of_staffing_assignments__c == null)
          u.number_of_staffing_assignments__c=1;
        else
          u.number_of_staffing_assignments__c+=1;
      }
    }
    return users;    
  }
  /**********************************************/
  private void setupBoothName(){
    boothName = staffingAssignment.Booth__r.Name;	
  }
  /**********************************************/
  private void makeShiftTime(Datetime startT, Datetime endT){
    timeSlot =  startT.format('MM/dd h:mm a')+'-'+endT.format('h:mm a');
  }
  /**********************************************/
  private void setupAllowedRoles(){
  	String listUnsplit = staffingAssignment.Booth__r.User_Booth_Staff__c;
    if (listUnsplit == null){
    	allowedRoles = 'NONE';
    }
    else{
  	 allowedRoles = listUnsplit.replaceAll(';', ', ');
    }
  }
  /*--test--*/
  private static testmethod void setupAllowedRolesTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    System.currentPageReference().getParameters().put('id', btu.staffedId);
    BoothForce_TradeWithPersonController twpc = new BoothForce_TradeWithPersonController();
    twpc.staffingAssignment.Booth__r.User_Booth_Staff__c = null;
    twpc.setupAllowedRoles();
    System.assert(twpc.allowedRoles == 'NONE');
  }
  /*--End Test--*/
  /**********************************************/
  private void ONLYUSEFORTESTING(){
  	testing = true;
  }
  /**********************************************/
  /********************************Static Methods*****************************************************************************/
  /******************************/
  public static webservice String dropRegistration(String staffId){
  	List <Staffing_Assignment__c> staffingList = [Select Id, Assigned_to_Users_Manager__c, Assigned__c 
  	                                              From Staffing_Assignment__c
  	                                              where id = :staffId];
  	                 
    if(staffingList.size() != 1)
      return 'fetch error';
    
    User u = [select Id, number_of_staffing_assignments__c from User where id =:staffingList[0].Assigned__c];
    u.number_of_staffing_assignments__c -= 1;
    
    staffingList[0].Assigned__c = null;
    try{
      update u;
    	update staffingList[0];
    	return 'ok';
    }catch(Exception e){
    	return 'update error';
    }   
  }
  /*--test--*/
  private static testmethod void dropRegistrationTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    String val = BoothForce_TradeWithPersonController.dropRegistration(btu.staffedId);
    System.debug('!!!!!!!!!!!'+val);
    System.assert(val=='ok');
  }
  /*--End Test--*/
  /******************************/
}