@isTest
public class Test_SOS_Manager_Pending_Notification {
    public static testMethod void testMgrPendingReqs() {
    
        Test.startTest();
    
    
       EstimatedBalanceDate__c setting = new EstimatedBalanceDate__c();
        setting.Name = 'SOS Time Off Balance Date Update';
        setting.Data_Load_Date__c = system.today()-20;
        insert setting;
        
        
    
        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];
        //Create User Records
        User u1 = new User(alias = 'user6341', 
        email='user123@mail1.com',emailencodingkey='UTF-8', lastname='u1',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=Math.random() + '2@test.com',CommunityNickname='usr1');
        insert u1;
        User u2 = new User(alias = 'user8722', 
        email='user123@mail2.com',emailencodingkey='UTF-8', lastname='u2',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=Math.random() + '4@test.com',CommunityNickname='usr2',ManagerId = u1.Id);
        insert u2;
        User u3 = new User(alias = 'user9733', 
        email='user123@mail3.com',emailencodingkey='UTF-8', lastname='u3',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=Math.random() + '6@test.com',CommunityNickname='usr3',ManagerId = u2.Id);
        insert u3;
        
        
        /*
        //Create Time off Balace Records
        SOS_Time_Off_Balance__c tob1 = new SOS_Time_Off_Balance__c(Employee_Name__c=u2.id);
               tob1.Bereavement_Time_Rem__c=0;
           tob1.Bereavement_Time_Pending__c =0;
           tob1.Bereavement_Time_Approved__c =0;
           tob1.Birthday_Time_Rem__c =0;
           tob1.Birthday_Time_Pending__c  =0;
           tob1.Birthday_Time_Approved__c =0;
           tob1.Float_Time_Rem__c =0;
           tob1.Float_Time_Pending__c  =0;
           tob1.Float_Time_Approved__c =0;
           tob1.Holiday_work_days_Time_Rem__c =0;
           tob1.Holiday_work_days_Time_Pending__c  =0;
           tob1.Holiday_work_days_Time_Approved__c =0;
           tob1.Jury_Duty_Time_Rem__c=0;
           tob1.Jury_Duty_Time_Pending__c  =0;
           tob1.Jury_Duty_Time_Approved__c =0;
           tob1.Relieve_Time_Rem__c =0;
           tob1.Relieve_Time_Pending__c  =0;
           tob1.Relieve_Time_Approved__c =0;
           tob1.Religious_OPEIU_Only_Time_Rem__c =0;
           tob1.Religious_OPEIU_Only_Time_Pending__c  =0;
           tob1.Religious_OPEIU_Only_Time_Approved__c =0;
           tob1.Sick_Time_Rem__c=0;
           tob1.Sick_Time_Pending__c  =0;
           tob1.Sick_Time_Approved__c =0;
           tob1.Unpaid_Time_Rem__c =0;
           tob1.Unpaid_Time_Pending__c  =0;
           tob1.Unpaid_Time_Approved__c =0;
           tob1.Vacation_Time_Rem__c =0;
           tob1.Vacation_Time_Pending__c  =0;
           tob1.Vacation_Time_Approved__c =0;
           
        insert tob1;
        */
        
      // SOS_Time_Off_Balance__c  tob1 = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u2.id] ; 
        
        /*
        SOS_Time_Off_Balance__c tob2 = new SOS_Time_Off_Balance__c(Employee_Name__c=u3.id);
               tob2.Bereavement_Time_Rem__c=0;
           tob2.Bereavement_Time_Pending__c =0;
           tob2.Bereavement_Time_Approved__c =0;
           tob2.Birthday_Time_Rem__c =0;
           tob2.Birthday_Time_Pending__c  =0;
           tob2.Birthday_Time_Approved__c =0;
           tob2.Float_Time_Rem__c =0;
           tob2.Float_Time_Pending__c  =0;
           tob2.Float_Time_Approved__c =0;
           tob2.Holiday_work_days_Time_Rem__c =0;
           tob2.Holiday_work_days_Time_Pending__c  =0;
           tob2.Holiday_work_days_Time_Approved__c =0;
           tob2.Jury_Duty_Time_Rem__c=0;
           tob2.Jury_Duty_Time_Pending__c  =0;
           tob2.Jury_Duty_Time_Approved__c =0;
           tob2.Relieve_Time_Rem__c =0;
           tob2.Relieve_Time_Pending__c  =0;
           tob2.Relieve_Time_Approved__c =0;
           tob2.Religious_OPEIU_Only_Time_Rem__c =0;
           tob2.Religious_OPEIU_Only_Time_Pending__c  =0;
           tob2.Religious_OPEIU_Only_Time_Approved__c =0;
           tob2.Sick_Time_Rem__c=0;
           tob2.Sick_Time_Pending__c  =0;
           tob2.Sick_Time_Approved__c =0;
           tob2.Unpaid_Time_Rem__c =0;
           tob2.Unpaid_Time_Pending__c  =0;
           tob2.Unpaid_Time_Approved__c =0;
           tob2.Vacation_Time_Rem__c =0;
           tob2.Vacation_Time_Pending__c  =0;
           tob2.Vacation_Time_Approved__c =0;
           
        insert tob2;
        
        */
       // SOS_Time_Off_Balance__c  tob2 = [ Select Id, Name,Employee_Name__c From  SOS_Time_Off_Balance__c Where Employee_Name__c=:u3.id] ; 
        
        /*
        //Create Time off Request Records
        Set<Id> torSet = new Set<Id>();
        SOS_Time_Off_Request__c tor1 = new SOS_Time_Off_Request__c(Employee_Name__c='Test',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().adddays(5),
                                                                 Manager_Name__c='test',Status__c='Manager Pending', 
                                                                   Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation');
                                                                  //Time_Off_Balance__c=tob1.id,
        insert tor1;
        SOS_Time_Off_Request__c tor2 = new SOS_Time_Off_Request__c(Employee_Name__c='Test',
                                                                 Start_Date__c=System.today(),End_Date__c=System.today().addDays(5),
                                                                 Manager_Name__c='test',Status__c='Manager Pending', 
                                                                 Total_Hours_Requested__c =1,
                                                                  Type__c='Vacation');
                                                                  
                                                                  //,Time_Off_Balance__c=tob2.id
        insert tor2;
        torSet.add(tor1.Id);
        torSet.add(tor2.Id);
        */
        Test.stopTest();
        
        //Test.startTest();
        SOS_Manager_Pending_Notification sosNotify = new SOS_Manager_Pending_Notification();
        sosNotify.query='Select Id, Status__c, Time_Off_Balance__c, Time_Off_Balance__r.Employee_Name__c  from SOS_Time_Off_Request__c where Status__c = \' Manager Pending \'';
        // and id in : torset
        ID batchprocessid = Database.executeBatch(sosNotify);
        // Test.stopTest();
        
        
    }
}