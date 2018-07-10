public with sharing class AreaWithZones {

  private list<String> zonesList;
  private list <Booth__c> booths;
  public  String areaName {get; private set;}
  public  String areaId   {get; private set;}
  public  list<ZoneAndBoothInfoList> zonesAndBoothList  {get; private set;}

  /************************************/
  public AreaWithZones(String areaIdIn, String areaNameIn, list<Booth__c> boothsIn){
  	booths = boothsIn;
  	areaName = areaNameIn;
  	areaId   =areaIdIn;
    setupZonesList();
    setupZonesAndBoothList();
  }
  /************************************/
  private void setupZonesList(){
    zonesList = new list<String>();
    map <String, Integer> zoneMap = new map <String, Integer>();
    for(Booth__c b: booths){
    	if(b.Area_Zone__r.Id == areaId){
    		zoneMap.put(b.zone__c, 1);
    	}
    }
    for(String s: zoneMap.keySet()){
      zonesList.add(s);	
    }
    zonesList.sort();
  }
  /************************************/
  private void setupZonesAndBoothList(){
  	zonesAndBoothList = new list<ZoneAndBoothInfoList>();
  	for(String z: zonesList){
  		zonesAndBoothList.add(new ZoneAndBoothInfoList(z, areaId, booths));
  	}
  }
  /************************************/
  
}