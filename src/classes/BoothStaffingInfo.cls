public with sharing class BoothStaffingInfo {
	
  public  String boothName          {get; set;}
  public  String boothType          {get; set;}
  public  Integer remainingSlots    {get; set;}
  public  String description        {get; set;}
  public  String boothId            {get; set;}
  public  String zoneId             {get; set;}
  public  String zoneName           {get; set;}
  public  String subZone            {get; private set;}
  /******************************/
  public BoothStaffingInfo(String boothNameIn, String boothTypeIn, Integer remainingSlotsIn, String descriptionIn, String boothIdIn, String zoneIdIn, String zoneNameIn, String subZoneIn){
    boothName = boothNameIn;
    boothType = boothTypeIn;
    remainingSlots = remainingSlotsIn;
    description = descriptionIn;	
    boothId = boothIdIn;
    zoneId = zoneIdIn;
    zoneName = zoneNameIn;
    subZone = subZoneIn;
  }
  /******************************/
}