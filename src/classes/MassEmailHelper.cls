public with sharing class MassEmailHelper {
  
  public String bodyText    {get; set;}
  public String subjectText {get; set;}
  public String address      {get; set;}
  public list <Staffing_Assignment__c> staffings  {get; set;}
  /************************************/
  public MassEmailHelper(String adressIn, String subjectIn, String bodyTextIn){
  	address = adressIn;
  	subjectText = subjectIn;
  	bodyText = bodyTextIn;
    staffings = new list <Staffing_Assignment__c>();
  }
  /************************************/
  public void addStaffing(Staffing_Assignment__c sa){
  	staffings.add(sa);
  }
  /************************************/
  public void addBodyText(String addition){
  	bodyText += addition;
  }
  /************************************/
  public void getRidOfNewLines(){
  	bodyText = bodyText.replace('/n', '');
  }
  /************************************/
}