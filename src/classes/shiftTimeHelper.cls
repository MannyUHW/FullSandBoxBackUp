public with sharing class shiftTimeHelper {

  public String niceDate    {get; set;}
  public String classDate   {get; set;}
  
  public shiftTimeHelper(String nDay, String nClassDate){
  	niceDate = nDay;
  	classDate= nClassDate;
  }

}