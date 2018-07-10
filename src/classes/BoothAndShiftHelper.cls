public with sharing class BoothAndShiftHelper {

  public Integer total    {get; set;}
  public String  day      {get; set;}
  public String  bsId     {get; set;}
  
  public BoothAndShiftHelper(Integer totalC, String dayC, String shiftTimeId){
  	total = totalC;
  	day = dayC;
  	bsID = shiftTimeId;
  }

}