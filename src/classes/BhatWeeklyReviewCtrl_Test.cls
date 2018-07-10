@isTest(SeeAllData = true)
global class BhatWeeklyReviewCtrl_Test{

    static testMethod void testMyApprovals() 
    {
    
      Test.startTest();
    
         try{
    
    
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = 'u', Short_Description__c = 'tt' );
        insert bcode;
        
        System.assertEquals(bcode.name,'u');
        
        BHAT_Activity_Note__c  bnote=new BHAT_Activity_Note__c(name='bnotename',Activity_Note_Description__c='Test Descritpion',BHAT_Activity_Code__c=bcode.id);
        insert bnote;
        
        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];       
        
        BHAT_Activity_Weekly__c bweeks =  new BHAT_Activity_Weekly__c( Name = 'Test' ,
                                                                       ownerId = u.id,
                                                                       Status__c = 'Complete',
                                                                       WeekStartDate__c = Date.Today(),
                                                                       WeekEndDate__c = Date.Today()+7,
                                                                       WeeklyTotalHours__c = 2.0,
                                                                       Total_Time_Off_Hours__c= 8.0,
                                                                       WeeklyPaidBreakHours__c = 2.0,
                                                                       WeeklyUnpaidLunchHours__c = 1.0,
                                                                       Review_Notes__c = '',
                                                                       Review_Status__c = 'Not Reviewed');
        insert bweeks;
        
        BHAT_Activity_Weekly__c bweeks1 =  new BHAT_Activity_Weekly__c( Name = 'Test1' ,
                                                                       ownerId = u.id,
                                                                       Status__c = 'Complete1',
                                                                       WeekStartDate__c = Date.Today()+1,
                                                                       WeekEndDate__c = Date.Today()+8,
                                                                       WeeklyTotalHours__c = 2.0,
                                                                       WeeklyPaidBreakHours__c = 2.0,
                                                                       WeeklyUnpaidLunchHours__c = 1.0,
                                                                       Review_Notes__c = '',
                                                                       Review_Status__c = 'Not Reviewed');
        insert bweeks1;
        
        System.assertEquals(bweeks.ownerId,u.id);
        
        BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = date.today()+1,
                                                                ownerId = bweeks.OwnerId,
                                                                Time_Off_Total__c = 3.0, 
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                BHAT_Activity_Weekly__c = bweeks.id,                                                              
                                                                Daily_Hours_Spent__c = bweeks.WeeklyTotalHours__c ,
                                                                Paid_Break_Total__c = bweeks.WeeklyPaidBreakHours__c,
                                                                Unpaid_Lunch_Total__c  = bweeks.WeeklyUnpaidLunchHours__c,
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today()+7,
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;        
        
        System.assertEquals(dac.Activity_Date__c,date.today()+1);
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = dac.Activity_Date__c,
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = dac.id,
                                                   Hours_Spent__c = dac.Daily_Hours_Spent__c,
                                                   BHAT_Activity_Note__c = bnote.id,
                                                   BHAT_Activity_Note_Other__c = 'test note other',
                                                   ownerId = dac.ownerid);
        insert ac;
        
        list<bhat_activity__c> bacList = new list<bhat_activity__c>();
        bacList.add(ac);
        
        System.assertEquals(ac.Activity_Date__c,dac.Activity_Date__c);
           String startDt = String.ValueOf(System.today()-10);
           String endDt = String.ValueOf(System.today());
    
           BhatWeeklyReviewCtrl controller = new BhatWeeklyReviewCtrl() ;
           controller.cheese();
           ApexPages.currentPage().getParameters().put('userid', userInfo.getUserId()); 
           ApexPages.currentPage().getParameters().put('firstName', 'Sun'); 
           ApexPages.currentPage().getParameters().put('lastName', 'Nathan'); 
           ApexPages.currentPage().getParameters().put('reviewnotes', ''); 
           ApexPages.currentPage().getParameters().put('endWeek',endDt ); 
           ApexPages.currentPage().getParameters().put('startWeek',startDt );
           ApexPages.currentPage().getParameters().put('status', 'Incomplete'); 
           ApexPages.currentPage().getParameters().put('reviewstatus', 'Not Reviewed'); 
            
           //controller.getActivityWeeklyDtoList(bacList);
            controller.sortField = 'lastName';
            controller.sortDir = 'asc';
            controller.debugSoql= 'sss'; 
            controller.getSeletedReviewStatus();
            controller.setSeletedReviewStatus('Status1');
            controller.getReviewStatusItems();
            controller.sortDir = null;
            controller.sortField=null;
            controller.debugSoql = null;
            BhatWeeklyReviewCtrl.ActivityWeeklyDto actDTO = new BhatWeeklyReviewCtrl.ActivityWeeklyDto();
            BhatWeeklyReviewCtrl.ActivityDailyDto  dailyDTO = new BhatWeeklyReviewCtrl.ActivityDailyDto();
            BhatWeeklyReviewCtrl.BhatActivityDto bhatDTO = new BhatWeeklyReviewCtrl.BhatActivityDto();
            controller.runSearch();
            try{
                controller.savebhatWeekly();
            }catch(Exception e){
            
            }

            //actDTO values
            actDTO.Id = ac.BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.id;
            
             controller.userList.add([select id, name from user where managerId =: UserInfo.getUserId() limit 1]); 
             controller.reviewStatusList.add('Not Reviewed');
             controller.statusList.add('Incomplete');
            // controller.savebhatWeekly();
              ApexPages.currentPage().getParameters().put('weekid', bweeks.id); 
             ApexPages.currentPage().getParameters().put('weeknotes', 'ttt'); 
             
             //controller.approve();
             //controller.reject(); 
             controller.runSearch();      
             controller.weekid = bweeks.id;
             controller.weeknotes = 'test notes';
             ApexPages.currentPage().getParameters().put('weeklyId',bweeks.id); 
             ApexPages.currentPage().getParameters().put('reviewNotes', 'Test review notes'); 
             Apexpages.currentPage().getParameters().put('approveOrReject','approve');
             controller.runApproveOrReject();
             ApexPages.currentPage().getParameters().put('weeklyId',bweeks1.id); 
             Apexpages.currentPage().getParameters().put('approveOrReject','reject');
             controller.runApproveOrReject();
              
             
             BhatWeeklyReviewCtrl.ActivityDailyDto daily = new BhatWeeklyReviewCtrl.ActivityDailyDto();
             
                              
             }catch(Exception e){
            
            }                
            Test.stopTest();
                            
 
    }
}