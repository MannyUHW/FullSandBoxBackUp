public with sharing class ShiftRow {
  
  public String shiftTime                     {get; set;}
  public List <ShiftTableData> datesData      {get; set;}
  public Datetime              startDTime     {get; set;}
  public String                dateMapper     {get; set;}
  /**************************/
  /*public ShiftRow(StartTimeEndTime stet, List<Date> dateListDates, List <Staffing_Assignment__c> staffingAssignmentList){
  	setupShiftTimeString(stet);
    setupDatesData(stet, dateListDates, staffingAssignmentList);
  }*/
  /**************************/
  public ShiftRow(StartTimeEndTime stet, Date d, List <Staffing_Assignment__c> staffingAssignmentList){
    startDTime = stet.startDT;
    dateMapper = startDTime.format('yyyyMMdd');
    setupShiftTimeString(stet);
    setupDatesDataByDate(stet, d, staffingAssignmentList);
    
  }
  /**************************/
  private void setupShiftTimeString(StartTimeEndTime stet){
  	shiftTime = stet.startDT.format('h:mm a')+' - '+stet.endDT.format('h:mm a');
    
  }
  /**************************/
  /*private void setupDatesData(StartTimeEndTime stet, List<Date> dateListDates, List <Staffing_Assignment__c> staffingAssignmentList){
  	datesData = new List <ShiftTableData>();
  	ShiftTableData std;
  	for(Date d : dateListDates){
  		std=new ShiftTableData(stet, d, staffingAssignmentList);
  		if(std.emptyData()==false){
  		  datesData.add(std);
  		}
  	}
  }*/
  /**************************/
   private void setupDatesDataByDate(StartTimeEndTime stet, Date d, List <Staffing_Assignment__c> staffingAssignmentList){
    datesData = new List <ShiftTableData>();
	  ShiftTableData std=new ShiftTableData(stet, d, staffingAssignmentList);
	  if(std.emptyData()==false){
	    datesData.add(std);
	  }
  } 
  /**************************/
}