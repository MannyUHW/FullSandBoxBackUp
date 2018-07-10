@istest(seeAllData=true)
public class SOSTimeOffBalanceTriggerHandlerTest{
    public static testMethod void unitTest() {
    
        Test.startTest();
        
        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];
        User u=new User(alias=generateRandomString(4)+'user', 
        email='user123@mail.com',emailencodingkey='UTF-8', lastname='Rose',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user121sos1@mail.com',CommunityNickname=generateRandomString(4)+'usr');
        insert u; 
        
        Test.stopTest();
        
        system.debug('sun u.id:' + u.id);
        
        //SOS_Time_Off_Balance__c sostob = new SOS_Time_Off_Balance__c();
        //sostob.Employee_Name__c =  u.id;
        //sostob.OwnerId =  u.id;
        //insert sostob;                   
        
        
        SOS_Time_Off_Balance__c tob = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u.id] ; 
         
        //SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c(Employee_Name__c=u.id);
        //insert tob;
        SOS_Time_Off_Request__c tor = new SOS_Time_Off_Request__c(Employee_Name__c='Test121',
                                                                Start_Date__c=System.today(),End_Date__c=System.today().addDays(8),
                                                                Manager_Name__c='test',Status__c='Pending', 
                                                                  Time_Off_Balance__c=tob.id, Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation');
        insert tor;
        SOS_Time_Off_Request__c tor1 = new SOS_Time_Off_Request__c(Employee_Name__c='Test122',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().addDays(8),
                                                                 Manager_Name__c='test',Status__c='Pending', 
                                                                 Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation',Time_Off_Balance__c=tob.id);
        insert tor1;
        PageReference pageRef = Page.SOS_TOR_New_button_override;        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(tor1); 
        SOS_TOR_New_buttonController torext = new SOS_TOR_New_buttonController (sc);
        torext.saveAndReturn();
        torext.updateAndReturn();
        torext.timeOfEntryHome(); 
        torext.populateTOR();
    
    }
    public static testMethod void unitTest1() {
    
        Test.startTest();
        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];
        User u=new User(alias = generateRandomString(4)+'user', 
        email='user122@mail.com',emailencodingkey='UTF-8', lastname='newton',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user775sos1@mail.com',CommunityNickname=generateRandomString(4)+'usr1');
        insert u; 
        
        Test.stopTest();
         
        SOS_Time_Off_Balance__c tob = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u.id] ; 
           
        //SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c(Employee_Name__c=u.id);
        //insert tob;
        SOS_Time_Off_Request__c tor = new SOS_Time_Off_Request__c(Employee_Name__c='Test123',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().addDays(8),
                                                                 Manager_Name__c='test',Status__c='Pending', 
                                                                  Time_Off_Balance__c=tob.id, Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation');
        insert tor;
        PageReference pageRef = Page.SOS_TOR_EDIT_STATUS; 
        pageRef.getParameters().put('id',String.valueOf(tor.id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(tor);
        SOS_TOR_EDIT_Controller torEditExt = new SOS_TOR_EDIT_Controller(sc);
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
        User u=new User(alias = generateRandomString(4)+'user', 
        email='user1277@mail.com',emailencodingkey='UTF-8', lastname='John',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user7532@mail.com',CommunityNickname=generateRandomString(4)+'usr3');
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