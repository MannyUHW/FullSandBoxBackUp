public with sharing class BoothForce_TradeShowSetupController {

  private list <Staffing_Assignment__c> staffingAssignments;
  private map <String, MassEmailHelper> emailMap;
  public  String emailsSent   {get;set;}
  /******************************************/
  public BoothForce_TradeShowSetupController(){
    emailsSent='NONE';
  }
  /******************************************/
  public Pagereference massEmailShifts(){
  	getAllStaffingAssignments();
  	setupEmailMap();
  	addBoothShiftsToEmail();
  	list <Messaging.SingleEmailMessage> listOfEmails = makeListOfEmails();
  	sendEmails(listOfEmails);
  	return null;
  }
  
  /*--test--*/
  private static testmethod void massEmailShiftsTest(){
    BoothForce_TestingUtil btu = new BoothForce_TestingUtil();
    btu.addStaffingAssignment();
    BoothForce_TradeShowSetupController tsc = new BoothForce_TradeShowSetupController();
    tsc.massEmailShifts();
    System.assert(tsc.emailsSent != null);
  }
  /*--End Test--*/
  
  /******************************************/
  private void getAllStaffingAssignments(){
  	staffingAssignments = [Select s.Shift_Time__r.Shift_Date__c, s.Shift_Time__r.Shift_End_Time__c, s.Booth__r.Area_Zone__r.Location__c,
  	                       s.Shift_Time__r.Shift_Start_Time__c, s.Shift_Time__c, s.IsDeleted, s.Is_Staffed__c,
  	                       s.Booth__r.Name, s.Booth__c, s.Assigned__r.number_of_staffing_assignments__c, 
  	                       s.Assigned__r.Email, s.Assigned__r.Name, s.Assigned__r.Id, s.Assigned__c 
  	                       From Staffing_Assignment__c s
  	                       Where s.IsDeleted = false and s.Is_Staffed__c > 0.0
  	                       order by s.Shift_Time__r.Shift_Start_Time__c];
  }
  /******************************************/
  private void setupEmailMap(){
  	emailMap = new Map<String, MassEmailHelper>();
    MassEmailHelper meh;
    for(Staffing_Assignment__c sa : staffingAssignments){
      meh = emailMap.get(sa.Assigned__c);
      if(meh==null && sa.Assigned__r.Email != null)
        emailMap.put(sa.Assigned__c, new MassEmailHelper(sa.Assigned__r.Email, emailSubject(), bodyText(sa.Assigned__r.Name)));
    }
  }
  /******************************************
  PROBABLY CAN BE DELETED
  private list<String> getUsers(){
  	map <String, String> userMap = new map<String, String>();
  	for(Staffing_Assignment__c sa : staffingAssignments){
  		userMap.put(sa.Assigned__c, sa.Assigned__c);
  	}
    return userMap.values();  	
  }
  ******************************************/
  private String emailSubject(){
  	return 'Your upcoming booth shifts';
  }
 /******************************************/
 private String bodyText(String name){
  return '<h4>Hello '+name+', you are signed up for the following booth shifts:</h4>';
 }
 /******************************************/
 private void addBoothShiftsToEmail(){
  MassEmailHelper meh;
  for(Staffing_Assignment__c sa : staffingAssignments){
  	meh = emailMap.get(sa.Assigned__c);
  	meh.addBodyText(shiftInfoString(sa));
  	meh.addStaffing(sa);
  }
 }
 /******************************************/ 
  private String shiftInfoString(Staffing_Assignment__c sa){
  	String returnVal =         '<p>';   
  	returnVal +=               '<b>' + sa.Booth__r.Name + '</b>';
  	returnVal +=               ': '  + sa.Shift_Time__r.Shift_Start_Time__c.format('MM/dd hh:mm');
  	returnVal +=               '-'   + sa.Shift_Time__r.Shift_End_Time__c.format('hh:mm');
    returnVal +=               '</p>';
  	return returnVal;
  }
 /******************************************/
 private list <Messaging.SingleEmailMessage>  makeListOfEmails(){
  list <Messaging.SingleEmailMessage> listOfEmails = new list <Messaging.SingleEmailMessage>();
  list <MassEmailHelper> mehList = emailMap.values();
  Messaging.SingleEmailMessage mail;
  List <String> toAddresses;

  for(MassEmailHelper meh : mehList){
  	meh.getRidOfNewLines();
  	mail = new Messaging.Singleemailmessage();
  	toAddresses = new List <String>();
  	toAddresses.add(meh.address);
  	mail.setToAddresses(toAddresses);
  	mail.setSubject(meh.subjectText);
  	mail.setHtmlBody(meh.bodyText);
  	mail.setFileAttachments(makeAttachments(meh));
  	listOfEmails.add(mail);
  }	
  return listOfEmails;
 }
 /******************************************/
 private void sendEmails(list <Messaging.SingleEmailMessage> listOfEmails){
 	Messaging.SingleEmailMessage[] sendArray = new Messaging.SingleEmailMessage[]{};
 	for(Messaging.SingleEmailMessage mes:listOfEmails){
 		sendArray.add(mes);
 	}
 	 Messaging.sendEmail(sendArray);
 }
 /******************************************/
 private Messaging.EmailFileattachment[] makeAttachments(MassEmailHelper meh){
 	Messaging.EmailFileattachment[] attachments =new Messaging.EmailFileattachment[]{};
 	Messaging.EmailFileattachment attach;
 	Integer i = 1;
 	for(Staffing_Assignment__c sa : meh.staffings){
 		attach = new Messaging.EmailFileattachment();
 		generateIcalendarAttachment body = new generateIcalendarAttachment(sa.Shift_Time__r.Shift_Start_Time__c, sa.Shift_Time__r.Shift_End_Time__c, sa.Id, sa.Booth__r.Area_Zone__r.Location__c, sa.Booth__r.Name);
 		attach.setBody(blob.valueOf(body.attachmentString));
 		attach.setContentType('text/calendar');
 		attach.setInline(true);
 		attach.setFileName('BoothShift'+String.valueOf(i)+'.ics');
 		i++;
 		attachments.add(attach);
 	}
 	  return attachments;
 }
 /******************************************/
}