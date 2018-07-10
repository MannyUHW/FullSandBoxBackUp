public with sharing class ZoneAndBoothInfoList {
  
  public list  <BoothStaffingInfo> boothInfoList    {get; private set;}
  public String zone  {get; private set;}
  private String areaId;
  private List <Booth__c> booths;
 
  /************************************/
  public ZoneAndBoothInfoList(String zoneIn, String areaIdIn, list<Booth__c> boothsIn){
    booths = boothsIn;
    areaId = areaIdIn;
    zone = zoneIn;
    setupBoothInfoList();  	
  }
  /************************************/
  public void setupBoothInfoList(){
  	boothInfoList = new list<BoothStaffingInfo>();
  	Integer slotsRemaining;
    for(Booth__c booth:booths){
      if(booth.Area_Zone__r.Id == areaId && booth.Zone__c == zone){
		      slotsRemaining  = getSlotsRemaining(booth);
		      boothInfoList.add(new BoothStaffingInfo(booth.Name, booth.Booth_Type__c, slotsRemaining, booth.Booth_Description__c, booth.Id, booth.Area_Zone__r.Id, booth.Area_Zone__r.Name, booth.Zone__c)); 
      }
    }
  }
  /************************************/
  private Integer getSlotsRemaining(Booth__c booth){
    Integer returnVal = 0;
    for(Staffing_Assignment__c staffingA: booth.Staffing_Assignments__r){
      if(staffingA.Is_Staffed__c != 1)
        returnVal++;
    }  
    return returnVal;
  }
  
  /************************************/
}