@IsTest(SeeAllData=true)

public class Bhat_UpdateStatusBHATWeeklyTrigger_TEST{
    public static testMethod void test1(){
        BHAT_Activity_Weekly__c bw = new BHAT_Activity_Weekly__c( Name='week11', 
                                                                  WeekStartDate__c = Date.Today(),
                                                                  WeekEndDate__c = Date.Today()+7,
                                                                  WeeklyPaidBreakHours__c = 2.0,
                                                                  WeeklyUnpaidLunchHours__c = 1.0 ,
                                                                  WeeklyTotalHours__c = 0.0);
        insert bw;
        
        System.assertequals(bw.WeekStartDate__c,Date.Today());
        
        List<BHAT_Activity_Daily__c> bdlist = new  List<BHAT_Activity_Daily__c>();
        List<BHAT_Activity_Daily__c> bdlist1 = new  List<BHAT_Activity_Daily__c>();
        
               
            BHAT_Activity_Daily__c bd1 = new BHAT_Activity_Daily__c( Activity_Date__c = Date.Today(),
                                                                    BHAT_Activity_Weekly__c = bw.id,
                                                                    Daily_Hours_Spent__c = 2, 
                                                                    Time_Off_Total__c = 3.0,
                                                                    Paid_Break_Total__c = 3,
                                                                    Unpaid_Lunch_Total__c  = 2,
                                                                    Status__c = 'Complete',
                                                                    Work_Hour_End_Time__c = '09:00 AM', Work_Hour_Start_Time__c = '05:00 PM');
           
        
        insert bd1;
                
       
                bw.WeeklyTotalHours__c  =  bw.WeeklyTotalHours__c + bd1.Daily_Hours_Spent__c ;
                update bw;
                 
            
        
        
       
        
             
            BHAT_Activity_Daily__c bd2 = new BHAT_Activity_Daily__c( Activity_Date__c = Date.Today(),BHAT_Activity_Weekly__c = bw.id,
                                                                    Daily_Hours_Spent__c = 2, 
                                                                    //Total_Time_Off__c = 3, 
                                                                    Status__c = 'Incomplete',
                                                                    Work_Hour_End_Time__c = '09:00 AM', Work_Hour_Start_Time__c = '05:00 PM');
            insert bd2;
            System.assertequals(bd2.Activity_Date__c,Date.Today());
        
        
        
        
       
               // bw.TotalDailyTimeOffs__c  =  bw.TotalDailyTimeOffs__c + d.Total_Time_Off__c ;
                bw.WeeklyTotalHours__c  =  bw.WeeklyTotalHours__c + bd2.Daily_Hours_Spent__c ;
                update bw;
                
           BHAT_Activity_Daily__c bd3 = new BHAT_Activity_Daily__c( Activity_Date__c = Date.Today(),BHAT_Activity_Weekly__c = bw.id,
                                                                    Daily_Hours_Spent__c = 2, 
                                                                    //Total_Time_Off__c = 3, 
                                                                    Status__c = 'No Entry',
                                                                    Work_Hour_End_Time__c = '09:00 AM', Work_Hour_Start_Time__c = '05:00 PM');
            insert bd3 ;
            System.assertequals(bd3.Activity_Date__c,Date.Today());
        
        
        
        
       
               // bw.TotalDailyTimeOffs__c  =  bw.TotalDailyTimeOffs__c + d.Total_Time_Off__c ;
                bw.WeeklyTotalHours__c  =  bw.WeeklyTotalHours__c + bd3.Daily_Hours_Spent__c ;
                update bw;
                
          BHAT_Activity_Daily__c bd4 = new BHAT_Activity_Daily__c( Activity_Date__c = Date.Today(),BHAT_Activity_Weekly__c = bw.id,
                                                                    Daily_Hours_Spent__c = 2, 
                                                                    //Total_Time_Off__c = 3, 
                                                                    Status__c = 'Overtime',
                                                                    Work_Hour_End_Time__c = '09:00 AM', Work_Hour_Start_Time__c = '05:00 PM');
            insert bd4 ;
            System.assertequals(bd4.Activity_Date__c,Date.Today());
        
        
        
        
       
               // bw.TotalDailyTimeOffs__c  =  bw.TotalDailyTimeOffs__c + d.Total_Time_Off__c ;
                bw.WeeklyTotalHours__c  =  bw.WeeklyTotalHours__c + bd4.Daily_Hours_Spent__c ;
                update bw;
                
                delete bd1;
          
        
                                                                      
    }
    
    
    public static testMethod void test2(){
    
   
     BHAT_Activity_Daily__c bd1 = new BHAT_Activity_Daily__c( Activity_Date__c = Date.Today(),
                                                                    BHAT_Activity_Weekly__c = null,
                                                                    Daily_Hours_Spent__c = 2, 
                                                                    Time_Off_Total__c = 3.0,
                                                                    Paid_Break_Total__c = 3,
                                                                    Unpaid_Lunch_Total__c  = 2,
                                                                    Status__c = 'Complete',
                                                                    Work_Hour_End_Time__c = '09:00 AM', Work_Hour_Start_Time__c = '05:00 PM');
           
        
        insert bd1;
        
        
        
        bd1.Daily_Hours_Spent__c = 3;
        
        update bd1;
    
        
    
    }
}