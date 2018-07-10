public with sharing class ShiftTableData {

  public String needsAssignment       {get; set;}
  public String slotsLeft             {get; set;}
  public List <String> usersAssigned  {get; set;}
  public String openStaffingId        {get; set;}
  public String stdminStart              {get; set;}
  public String stdhrStart              {get; set;} 
  public String stdminEnd                {get; set;}
  public String stdhrEnd                {get; set;}  
  public String stdStartDate          {get; set;} 
  private boolean userIsStaffing;
  private Integer slotsLeftInt;
  
  /************************************/
  public ShiftTableData(StartTimeEndTime stet, Date dateRef, List <Staffing_Assignment__c> staffingAssignmentList){
  	 setupSTDVars(stet);
  	 userIsStaffing = false;
  	 slotsLeftInt = 0;
  	 usersAssigned = new List <String>();
  	 for(Staffing_Assignment__c sta : staffingAssignmentList){
  	 	if(sta.Shift_Time__r.Shift_Date__c == dateRef && sta.Shift_Time__r.Shift_Start_Time__c.time()== stet.startTime && sta.Shift_Time__r.Shift_End_Time__c.time() ==stet.endTime){
  	 		addData(sta);
  	 	}
  	 }
  	if(slotsLeftInt > 0 && !userIsStaffing)
  		needsAssignment = 'True'; 
  	else
  	 needsAssignment='False';
    slotsLeft = String.valueOf(slotsLeftInt);
  }
  /************************************/
  private void addData(Staffing_Assignment__c sta){
  	String userId = Userinfo.getUserId();
  	if(sta.Is_Staffed__c == 1){
  		if(sta.Assigned__r.Id == userId){
  			userIsStaffing = true;
  		}
  		usersAssigned.add(sta.Assigned__r.Name);
  	}
  	else{
  		slotsLeftInt+=1;
  	  openStaffingId = sta.Id;
  	}
  }
  /************************************/
  private void setupSTDVars(StartTimeEndTime stet){
  	stdminStart = stet.startDT.format('mm');
  	stdhrStart = stet.startDT.format('HH');
    stdminEnd   = stet.endDT.format('mm');
    stdhrEnd   = stet.endDT.format('HH');
    
    stdStartDate = stet.startDT.format('yyyyMMdd');
  }
  /***************Added for so empty data is not added********************/
  public boolean emptyData(){
  	if(usersAssigned.size()==0 && userIsStaffing == false && slotsLeftInt == 0){
  		return true;
  	}
  	else{
  		return false;
  	}
  }
  /************************************/
    
}