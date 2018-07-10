@isTest
private class SOS_ApprovalPendingNotificationTest {
    static testMethod void TestApprovalPendingNotification() {
        
        Test.startTest();
       
        EstimatedBalanceDate__c setting = new EstimatedBalanceDate__c();
        setting.Name = 'SOS Time Off Balance Date Update';
        setting.Data_Load_Date__c = system.today()-20;
        insert setting;
        
        
        Profile pfl = [select id from profile where name='Standard User'];

        User testUser = new User(alias = 'u1234', email='u1234@testorg.com', Manager_Email__c = 'u1234@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1',
            timezonesidkey='America/Los_Angeles', username='u1234@testorg.com', Vacation__c=40,Sick__c=50);
        
        insert testUser ; 
        
        /*
        SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c();
        
        
           tob.Bereavement_Time_Rem__c=0;
           tob.Bereavement_Time_Pending__c =0;
           tob.Bereavement_Time_Approved__c =0;
           tob.Birthday_Time_Rem__c =0;
           tob.Birthday_Time_Pending__c  =0;
           tob.Birthday_Time_Approved__c =0;
           tob.Float_Time_Rem__c =0;
           tob.Float_Time_Pending__c  =0;
           tob.Float_Time_Approved__c =0;
           tob.Holiday_work_days_Time_Rem__c =0;
           tob.Holiday_work_days_Time_Pending__c  =0;
           tob.Holiday_work_days_Time_Approved__c =0;
           tob.Jury_Duty_Time_Rem__c=0;
           tob.Jury_Duty_Time_Pending__c  =0;
           tob.Jury_Duty_Time_Approved__c =0;
           tob.Relieve_Time_Rem__c =0;
           tob.Relieve_Time_Pending__c  =0;
           tob.Relieve_Time_Approved__c =0;
           tob.Religious_OPEIU_Only_Time_Rem__c =0;
           tob.Religious_OPEIU_Only_Time_Pending__c  =0;
           tob.Religious_OPEIU_Only_Time_Approved__c =0;
           tob.Sick_Time_Rem__c=0;
           tob.Sick_Time_Pending__c  =0;
           tob.Sick_Time_Approved__c =0;
           tob.Unpaid_Time_Rem__c =0;
           tob.Unpaid_Time_Pending__c  =0;
           tob.Unpaid_Time_Approved__c =0;
           tob.Vacation_Time_Rem__c =0;
           tob.Vacation_Time_Pending__c  =0;
           tob.Vacation_Time_Approved__c =0;
        
        try{
        
        insert tob;

        
        SOS_Time_Off_Request__c newtimeOffRequest = new SOS_Time_Off_Request__c();         
        newtimeOffRequest.Time_Off_Balance__c = tob.Id;      
        newtimeOffRequest.Full_Day__c = True;
        newtimeOffRequest.Type__c ='Sick';
        newtimeOffRequest.Start_Date__c = system.today();
        newtimeOffRequest.End_Date__c = system.today()+1;
        newtimeOffRequest.OwnerId = testUser.Id;
        newtimeOffRequest.Status__c = 'Manager Pending';
        newtimeOffRequest.Manager_Pending_Date__c = system.today()-8;
        newtimeOffRequest.Total_Hours_Requested__c = 1;
        
        insert newtimeOffRequest;
        newtimeOffRequest.Status__c = 'Manager Pending';
        newtimeOffRequest.Manager_Pending_Date__c = system.today()-8;

        update newtimeOffRequest;
        }
        catch(Exception ex)
        {
        
        }
   
       */
        new SOS_ApprovalPendingNotification().execute(null);
        
         Test.stopTest();
    }
   
}