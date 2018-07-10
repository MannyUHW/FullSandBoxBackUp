public with sharing class ZoneAndShifts {

  public List <BoothAndShifts> boothsAndShifts           {get; set;}
  public List <shiftTimeHelper>  shiftTimeStrings        {get; set;}
  public List <ShiftDaysAndDates> daysAndDates           {get; set;}
  public List <Shift_Time__c>     localShiftTimes        {get; set;}
  public String zoneName                                 {get; set;}
  public String preventDropBool                          {get; set;}
  public String zoneId                                   {get; set;}
  
  /********************************/
  public ZoneAndShifts(Area_Zone__c zone, List <Booth__c> booths, List <Shift_Time__c> shiftTimes){
  	zoneName = zone.Name;
  	preventDropBool = String.valueOf(zone.Prevent_Assignment_Removal__c);
  	zoneId   = zone.Id;
  	
  	boothsAndShifts = new list <BoothAndShifts>();
    for(Booth__c booth : booths){
      if(booth.Area_Zone__c == zoneId){
        boothsAndShifts.add(new BoothAndShifts(booth, shiftTimes));
      }
  	}
    
    shiftTimeStrings = makeNiceShiftTimeStringsAndLocalShiftTimes(shiftTimes);
    daysAndDates = makeDaysAndDates(shiftTimes);
    
  }
  /********************************/
  private list<ShiftDaysAndDates> makeDaysAndDates(list<Shift_Time__c> shifts){
    
    Map <String, String> mapVals = new Map <String, String>();
    for (Shift_Time__c st : shifts){
    	if(st.Area_Zone__c==zoneId){
        mapVals.put(st.Shift_Start_Time__c.format('MMdd'), st.Shift_Start_Time__c.Format('EEEEE'));
    	}
    }
    
    Set<String> setkeys = mapVals.keySet();
    List<String> keys = new List<String>();
    for(String setKey : setKeys){
      keys.add(setKey);
    }
    keys.sort();
    
    List <ShiftDaysAndDates> returnVals = new List<ShiftDaysAndDates>();
    String sDay;
    for(String key :keys){
      sDay = mapVals.get(key);
      returnVals.add(new ShiftDaysAndDates(sDay, key));
    }
    return returnVals;
  }
  /************************************/
  private List <shiftTimeHelper> makeNiceShiftTimeStringsAndLocalShiftTimes(List<Shift_Time__c> shiftTimes){
    List <shiftTimeHelper> vals = new List <shiftTimeHelper> ();
    localShiftTimes = new List <Shift_Time__c>();
    Datetime startDate;
    Datetime endDate;
    String niceDay;
    String classDate;
    for(Shift_Time__c st: shiftTimes){
    	if(st.Area_Zone__c == zoneId){
    		localShiftTimes.add(st);
	      startDate = st.Shift_Start_Time__c;
	      endDate = st.Shift_End_Time__c;
	      niceDay = startDate.format('hh:mm')+' ... '+endDate.format('hh:mm a');
	      classDate = startDate.format('MMdd');
	      vals.add(new shiftTimeHelper(niceDay, classDate));
    	}
    }
    return vals;
  }
  /************************************/
}