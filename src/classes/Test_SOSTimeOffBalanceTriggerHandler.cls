@istest(seeAllData=true)
public class Test_SOSTimeOffBalanceTriggerHandler {
    public static testMethod void unitTest() {
    
        Test.startTest();
        
        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];
        RecordType recType = [Select id,name from RecordType where name = 'Time Off Request' limit 1];
        User u=new User(alias = 'user121', 
        email='user123@mail.com',emailencodingkey='UTF-8', lastname='u',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user@mail.com',CommunityNickname='usr');
        insert u;   
        
        Test.stopTest();
        
        SOS_Time_Off_Balance__c tob = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u.id] ;  
        //SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c(Employee_Name__c=u.id);
        //insert tob;
        SOS_Time_Off_Request__c tor = new SOS_Time_Off_Request__c(Employee_Name__c='Test',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().addDays(8),
                                                                 Manager_Name__c='test',Status__c='Pending', 
                                                                  Time_Off_Balance__c=tob.id, Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation',RecordTypeId=recType.id);
        insert tor;
        tor.status__c = 'Manager Pending';
        update tor;
        SOS_Time_Off_Request__c tor1 = new SOS_Time_Off_Request__c(Employee_Name__c='Test',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().addDays(8),
                                                                 Manager_Name__c='test',Status__c='Pending', 
                                                                 Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation',Time_Off_Balance__c=tob.id);
        insert tor1;
        PageReference pageRef = Page.SOS_New_TimeOffRequest;        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(tor1); 
        SOS_New_TOR_Controller torext = new SOS_New_TOR_Controller(sc);
        torext.saveAndReturn();
        torext.updateAndReturn();
        torext.renderSickLeaveType();
        torext.timeOfEntryHome(); 
        torext.populateTOR();
    
    }
    public static testMethod void unitTest1() {
    
        Test.startTest();
    
        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];
        User u=new User(alias = 'user122', 
        email='user122@mail.com',emailencodingkey='UTF-8', lastname='u',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user@mail.com',CommunityNickname='usr');
        insert u; 
        
        Test.stopTest();
        
        
        SOS_Time_Off_Balance__c tob = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u.id] ;   
        //SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c(Employee_Name__c=u.id);
        //insert tob;
        SOS_Time_Off_Request__c tor = new SOS_Time_Off_Request__c(Employee_Name__c='Test',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().addDays(8),
                                                                 Manager_Name__c='test',Status__c='Pending', 
                                                                  Time_Off_Balance__c=tob.id, Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation');
        insert tor;
        PageReference pageRef = Page.SOS_EDIT_TimeOffRequest; 
        pageRef.getParameters().put('id',String.valueOf(tor.id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(tor);
        SOS_EDIT_TOR_Controller torEditExt = new SOS_EDIT_TOR_Controller(sc);
        //torEditExt.updateAndReturn();
        torEditExt.hrApproved();
        torEditExt.hrRejected();
        torEditExt.hrCancel();
        torEditExt.updateAndReturn();
        SOS_TOR_Display_Hr_Pending torHRPending = new SOS_TOR_Display_Hr_Pending (sc);
        torHRPending.navRecord();
    }
    public static testMethod void unitTest2() {
    
        Test.startTest();
    
        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];
        User u=new User(alias = generateRandomString(3)+'user3', 
        email=generateRandomString(4)+'user@mail.com',emailencodingkey='UTF-8', lastname='u',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user@mail.com',CommunityNickname='usr');
        insert u;   
        
        Test.stopTest();
        
        SOS_Time_Off_Balance__c tob = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u.id] ; 
        //SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c(Employee_Name__c=u.id);
        //insert tob;
        PageReference pageRef = Page.SOS_TOB_TOR_Redirect; 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(tob);
        SOS_TOB_Controller tobext = new SOS_TOB_Controller(sc);
        tobext.sosTorRedirect();
        tobext.getHolidays();
        tobext.Beginning();
        tobext.Previous();
        tobext.Next();
        tobext.End();
        tobext.getDisablePrevious();
        tobext.getDisableNext();
        tobext.getTotal_size();
        tobext.getPageNumber();
        tobext.getTotalPages();        
    }
    
        public static String generateRandomString(Integer len) {
		    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		    String randStr = '';
		    while (randStr.length() < len) {
		       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
		       randStr += chars.substring(idx, idx+1);
		    	}
    	return randStr; 
	}
	
}