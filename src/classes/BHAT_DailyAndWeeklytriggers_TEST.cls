@isTest(SeeAllData = true)

public class BHAT_DailyAndWeeklytriggers_TEST{
    public static testMethod void test1(){
      
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = '1');
        insert bcode;
        System.assertEquals(bcode.name, '1');
        
        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = Date.Today(),
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = null,
                                                   Hours_Spent__c = 5, ownerId = u.id);
        insert ac;
        
        System.assertEquals(ac.Activity_Date__c,Date.Today());
        
        BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = date.today()+1,
                                                                ownerId = ac.OwnerId,
                                                                Time_Off_Total__c = 3, 
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                BHAT_Activity_Weekly__c = null,                                                              
                                                                Daily_Hours_Spent__c = ac.Hours_Spent__c,
                                                                Paid_Break_Total__c = ac.Hours_Spent__c,
                                                                Unpaid_Lunch_Total__c  = ac.Hours_Spent__c,
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;
        
        System.assertEquals(dac.Activity_Date__c,Date.Today()+1);
      
         BHAT_Activity_Weekly__c bweeks =  new BHAT_Activity_Weekly__c(Name = dac.StartDateMonth__c +'-'+dac.EndDateMonth__c ,
                                                                       ownerId = dac.ownerId,
                                                                       Status__c = 'Complete',
                                                                       WeekStartDate__c = dac.ReturnedDate__c,
                                                                       WeekEndDate__c = dac.EndDateWeek__c,
                                                                       WeeklyTotalHours__c = dac.Daily_Hours_Spent__c,
                                                                       WeeklyPaidBreakHours__c = dac.Paid_Break_Total__c,
                                                                       WeeklyUnpaidLunchHours__c = dac.Unpaid_Lunch_Total__c );
         insert bweeks;  
         
          System.assertEquals(bweeks.ownerId,dac.ownerId);
          
         ac.BHAT_Activity_Daily__c = dac.id;
         update ac;
         
         System.assertEquals(ac.BHAT_Activity_Daily__c,dac.id);
        
         dac.BHAT_Activity_Weekly__c = bweeks.id;
         update dac;
                 
        System.assertEquals(dac.BHAT_Activity_Weekly__c,bweeks.id);
        
         delete ac;
          delete dac;
         
    }
    
    public static testMethod void test2(){
      
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = '1');
        insert bcode;
        
        System.assertEquals(bcode.name, '1');
        
        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = Date.Today()+20,
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   Hours_Spent__c = 5, ownerId = u.id);
        insert ac;
        
        System.assertEquals(ac.Activity_Date__c,Date.Today()+20);
        
        BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = date.today()+1,
                                                                ownerId = u.id,
                                                                Time_Off_Total__c = 3, 
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                BHAT_Activity_Weekly__c = null,                                                              
                                                                Daily_Hours_Spent__c =4,
                                                                Paid_Break_Total__c = 2,
                                                                Unpaid_Lunch_Total__c  = .50,
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;
        
        BHAT_Activity_Weekly__c bweeks =  new BHAT_Activity_Weekly__c(Name = 'testweek',ownerId = u.id);
        insert bweeks ;
        dac.BHAT_Activity_Weekly__c=bweeks.id;
        update dac;
        
        }
    
  
    
     public static testMethod void test3(){
      
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = '1');
        insert bcode;
        
        System.assertEquals(bcode.name, '1');
        
        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = Date.Today(),
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = null,
                                                   Hours_Spent__c = 5, ownerId = u.id);
        insert ac;
        
        System.assertEquals(ac.Activity_Date__c,Date.Today());
        
        BHAT_Activity_Weekly__c bhatWeek = new BHAT_Activity_Weekly__c(name ='test',WeeklyPaidBreakHours__c = 3,
                                                                       WeeklyUnpaidLunchHours__c = 4);
        insert bhatweek;
        
        System.assertEquals(bhatweek.name,'test');
        
         BHAT_Activity_Daily__c dac1 = new BHAT_Activity_Daily__c(Activity_Date__c = date.today()-1,
                                                                BHAT_Activity_Weekly__c = bhatweek.id,                                                              
                                                                Daily_Hours_Spent__c = 5,
                                                                Paid_Break_Total__c = 1,
                                                                Unpaid_Lunch_Total__c  = 0,
                                                                Time_Off_Total__c = 3, 
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac1;
        
        System.assertEquals(dac1.BHAT_Activity_Weekly__c,bhatweek.id);
        
         ac.BHAT_Activity_Daily__c = dac1.id;
        update ac;
        
        dac1.Activity_Date__c = ac.Activity_Date__c ;
         dac1.BHAT_Activity_Weekly__c  = null;
         update dac1;
        
        ac.BHAT_Activity_Daily__c = dac1.id;
        update ac;
        
       
    }
    
    public static testMethod void test4(){
          User u = [select id,name from user where id=: userInfo.getUserID() limit 1];
  
      BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = date.today(),
                                                                ownerId = u.id, 
                                                                BHAT_Activity_Weekly__c = null,                                                              
                                                                Daily_Hours_Spent__c = 5,
                                                                EndDateMonth__c = 'test', 
                                                                Paid_Break_Total__c = 1,
                                                                Unpaid_Lunch_Total__c  = 1,
                                                                Time_Off_Total__c = 3, 
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;
        
        System.assertEquals(dac.ownerId,u.id);
        
       BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = 'u');
        insert bcode;
        
        System.assertEquals(bcode.name,'u');
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = dac.activity_date__c,
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = dac.id,
                                                   Hours_Spent__c = 3, ownerId = dac.ownerId);
        insert ac;
      
       System.assertEquals(ac.BHAT_Activity_Code__c,bcode.id);
      
         dac.Daily_Hours_Spent__c = dac.Daily_Hours_Spent__c + ac.Hours_Spent__c;
         update dac;
       
    }
    

    
    
    
    public static testMethod void test5(){
            User u = [select id,name from user where id=: userInfo.getUserID() limit 1];

       BHAT_Activity_Weekly__c bweeks =  new BHAT_Activity_Weekly__c(Name = 'Test',
                                                                      ownerid =u.id,                                                                     
                                                                       WeekStartDate__c = Date.today(),
                                                                       WeekEndDate__c = Date.today()+2,
                                                                       WeeklyTotalHours__c = 2,
                                                                       WeeklyPaidBreakHours__c = 3,
                                                                       WeeklyUnpaidLunchHours__c = 4 );
       insert bweeks;
       
       System.assertEquals(bweeks.name,'Test');
       
       BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = Date.Today(),
                                                                ownerId = u.id, 
                                                                BHAT_Activity_Weekly__c = bweeks.id,                                                              
                                                                Daily_Hours_Spent__c = 5,
                                                                Paid_Break_Total__c = 3,
                                                                Unpaid_Lunch_Total__c  = 2,
                                                                Time_Off_Total__c = 3, 
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;   
        
        System.assertEquals(dac.Activity_Date__c,Date.Today());
         
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = '1');
        insert bcode;
        
        System.assertEquals(bcode.name,'1');
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = Date.Today(),
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = dac.id,
                                                   Hours_Spent__c = 5, ownerId = u.id);
        insert ac;
        
        System.assertEquals(ac.BHAT_Activity_Code__c,bcode.id);
        
        dac.Activity_Date__c = ac.Activity_Date__c ;
        dac.Daily_Hours_Spent__c = ac.Hours_Spent__c;
        dac.ownerId = ac.ownerid;        
         update dac;
         
         System.assertEquals(dac.Activity_Date__c,ac.Activity_Date__c);
      
         bweeks.WeekEndDate__c = dac.EndDateWeek__c;
         bweeks.WeeklyTotalHours__c = dac.Daily_Hours_Spent__c;
         bweeks.WeekStartDate__c = dac.ReturnedDate__c;
         update bweeks;
         
         Integer sum = 0; 
        
         dac.Activity_Date__c = ac.Activity_Date__c ;
         dac.Daily_Hours_Spent__c = sum  + dac.Daily_Hours_Spent__c;
         update dac;
       
        ac.BHAT_Activity_Daily__c = dac.id;
        update ac;
        
        System.assertEquals(ac.BHAT_Activity_Daily__c,dac.id);
        
        dac.Activity_Date__c = ac.Activity_Date__c ;
         dac.BHAT_Activity_Weekly__c  = null;
         update dac;
        
        ac.BHAT_Activity_Daily__c = dac.id;
        update ac;
       
       System.assertEquals(ac.BHAT_Activity_Daily__c,dac.id);
       
    }
    
    
    public static testMethod void test6(){
      
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = '1');
        insert bcode;
        
        System.assertEquals(bcode.name, '1');
        
        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];
        
        BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = Date.Today(),
                                                                ownerId = u.id, 
                                                                BHAT_Activity_Weekly__c = null,                                                              
                                                                Daily_Hours_Spent__c = 5 ,
                                                                Time_Off_Total__c = 3, 
                                                                Paid_Break_Total__c = 2,
                                                                Unpaid_Lunch_Total__c  = 2,
                                                                Status__c = 'Complete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;
      
        System.assertEquals(dac.ownerId,u.id);
        
        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = Date.Today(),
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = null,
                                                   Hours_Spent__c = 5, ownerId = u.id);
        insert ac;
      
        System.assertEquals(ac.BHAT_Activity_Code__c,bcode.id);
      
    }
    
    
    public static testMethod void test7(){
      
        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = '1');
        insert bcode;
        
        System.assertEquals(bcode.name, '1');
        
        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];
        
         BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = Date.Today(),
                                                                ownerId = u.id, 
                                                                Time_Off_Total__c = 3, 
                                                                Paid_Break_Total__c = 1,
                                                                Unpaid_Lunch_Total__c  = 5,
                                                                Status__c = 'Incomplete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM', 
                                                                BHAT_Activity_Weekly__c = null,                                                              
                                                                Daily_Hours_Spent__c = 5 ,
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac;
      
      System.assertEquals(dac.Activity_Date__c,Date.Today());
      
          BHAT_Activity_Daily__c dac1 = new BHAT_Activity_Daily__c(Activity_Date__c = Date.Today() + 4,
                                                                ownerId = u.id, 
                                                                BHAT_Activity_Weekly__c = null,                                                              
                                                                Daily_Hours_Spent__c = 5 ,
                                                                Paid_Break_Total__c = 2,
                                                                Unpaid_Lunch_Total__c  = 3,
                                                                Time_Off_Total__c = 3, 
                                                                Status__c = 'Incomplete',
                                                                Work_Hour_End_Time__c = '09:00 AM', 
                                                                Work_Hour_Start_Time__c = '05:00 PM',
                                                                EndDateMonth__c = 'test', 
                                                                EndDateWeek__c = Date.Today(),
                                                                ReturnedDate__c = Date.Today(),
                                                                StartDateMonth__c = 'test');
        insert dac1;
        
        System.assertEquals(dac1.Activity_Date__c,Date.Today()+4);
        
         BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = Date.Today() + 4,
                                                   BHAT_Activity_Code__c = bcode.id,
                                                   BHAT_Activity_Daily__c = dac.id,
                                                   Hours_Spent__c = 5, ownerId = u.id);
        insert ac;
      
      System.assertEquals(ac.BHAT_Activity_Code__c,bcode.id);
    }
    
}