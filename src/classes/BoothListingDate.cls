public with sharing class BoothListingDate {

public String formattedDate{get; set;}
public String idDate  {get; set;}

  public BoothListingDate(Date dateIn){
  	formattedDate = dateIn.format();
  	idDate = String.valueOf(dateIn.month())+String.valueOf(dateIn.day())+String.valueOf(dateIn.year());
  	
  }
}