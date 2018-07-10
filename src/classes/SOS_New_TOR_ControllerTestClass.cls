@isTest 
private class SOS_New_TOR_ControllerTestClass {
    
     /*
      public static String generateRandomString(Integer len) 
      {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
           randStr += chars.substring(idx, idx+1);
          }
      return randStr; 
      }
     */
    
     static testMethod void anotherRealTest(){
     PageReference pageRef = Page.SOS_New_TimeOffRequest;
     Test.setCurrentPageReference(pageRef);

        //String fname = 'FnTest';
        //String lname = 'LnTest';
        //String fid = '3312-' + generateRandomString(8);
                
        //create contact
        //Contact cont = new Contact(FirstName=fname,LastName=lname,FID__c=fid, MemberID__c = generateRandomString(6), Division_Type__c ='Home Care');
        //insert cont;
        
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
        //tob.name = 'test';
        tob.Employee_Name__c = UserInfo.getUserId();
        insert tob;
        
        SOS_Time_Off_Request__c tor = new SOS_Time_Off_Request__c();
        
        tor.Time_Off_Balance__c = tob.Id;      
        tor.Full_Day__c = True;
        tor.Type__c ='Sick';
        tor.Start_Date__c = system.today();
        tor.End_Date__c = system.today()+1;
        tor.OwnerId =  UserInfo.getUserId();
        tor.Status__c = 'Manager Pending';
        tor.Manager_Pending_Date__c = system.today()-8;
        tor.Total_Hours_Requested__c = 1;
        
        List<Contact > lstContact  = [select id, name from Contact where LastName = 'LnTest'];
        if (lstContact.size() > 0)
        {
         Contact ct = lstContact.get(0);
        

             //ApexPages.CurrentPage().getparameters().put('id', cont[0].id);
            ApexPages.StandardController sc = new ApexPages.standardController(tor);

             SOS_New_TOR_Controller  sos = new SOS_New_TOR_Controller(sc);
             sos.populateTOR();
             sos.saveAndReturn();
             tor.Type__c = 'Vacation';
            tor.Start_Date__c = Date.today();
            tor.End_Date__c = Date.today().addDays(-1);
             sos.saveAndReturn();
             sos.populateTOR();
            tor.End_Date__c = Date.today().addDays(2);
             sos.populateTOR();
             sos.saveAndReturn();
             tor.Type__c = 'Sick';
             sos.saveAndReturn();
             sos.renderSickLeaveType();
             sos.timeOfEntryHome();
             sos.updateAndReturn();
        }

        SOS_New_TOR_Controller obj = new SOS_New_TOR_Controller();
        obj.cheese();

        //ApexPages.currentPage().getParameters().put(?);
        //System.assertEquals('something here');
    }
}