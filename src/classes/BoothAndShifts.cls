/*
  Notes:
        -this class uses the BoothAndShiftsHelper.cls class
*/
public with sharing class BoothAndShifts {
	public String boothName                        {get; set;}
	public String boothId                          {get; set;}
	public List <BoothAndShiftHelper> shiftInfo    {get; set;}
	private String boothZone;
	
	/************************************/
	public BoothAndShifts(Booth__c booth, List<Shift_Time__c> shiftTimes){
	  boothName= booth.Name;
	  boothId = booth.Id;     
	  boothZone = booth.Area_Zone__c;
	  
	  Map <String, Integer> shiftTimeMap = new  Map <String, Integer>();
	  shiftTimeMap = initializeShiftTimes(shiftTimes);
	  shiftTimeMap = fillShiftNumbers(shiftTimeMap, booth);
	  
	  shiftInfo = makeHelperList(shiftTimeMap, shiftTimes);
	        
	}
	/************************************/
	private List<BoothAndShiftHelper> makeHelperList(Map<String, Integer> stm, List<Shift_Time__c> shiftTimes){
	  List<BoothAndShiftHelper> vals = new List <BoothAndShiftHelper>();
	  String classDate;
	  for(Shift_Time__c st: shiftTimes){
	  	if(st.Area_Zone__c==boothZone){
		    classDate = st.Shift_Start_Time__c.format('MMdd');
		    vals.add(new BoothAndShiftHelper(stm.get(st.Id), classDate, st.Id));
	  	}
	  }
	  return vals;
	}
	/************************************/
	private Map <String, Integer> initializeShiftTimes(List<Shift_Time__c> shiftTimes){
	  Map <String, Integer> returnVal = new Map <String, Integer>();
	  for (Shift_Time__c st : shiftTimes){
	    if(st.Area_Zone__c==boothZone){
	     returnVal.put(st.Id, 0);
	    }
	  }
	  return returnVal;
	}
	/************************************/
	private Map<String, Integer> fillShiftNumbers(Map<String, Integer> stm, Booth__c booth){
	  Map <String, Integer> returnVal = stm.clone();
	  for(Staffing_Assignment__c sa : booth.Staffing_Assignments__r){
	    returnVal.put(sa.Shift_Time__c, returnVal.get(sa.Shift_Time__c)+1);
	  }
	  return returnVal;
	}
	/************************************/    
}