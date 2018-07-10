public class BHAT_RollupSummaryOnWEEKLY{
    public List<BHAT_Activity_Daily__c> dailyList {get;set;}
    public List<BHAT_Activity_Weekly__c> WeekList {get;set;}
    public AggregateResult[] ChildDailyList{get;set;}
     
    public BHAT_RollupSummaryOnWEEKLY()
    {
       dailyList = [SELECT id,Name,Status__c,Activity_Date__c,BHAT_Activity_Weekly__c,
                    Daily_Hours_Spent__c, Time_Off_Total__c, EndDateMonth__c,OwnerId, 
                    Paid_Break_Total__c, Unpaid_Lunch_Total__c,EndDateWeek__c,ReturnedDate__c,
                    StartDateMonth__c from BHAT_Activity_Daily__c where OwnerID =:userInfo.getUserID() ];
                                            
      WeekList = [Select id, WeekStartDate__c,Status__c, WeekEndDate__c,ownerId,
                  WeeklyTotalHours__c,Total_Time_Off_Hours__c, WeeklyPaidBreakHours__c,
                  WeeklyUnpaidLunchHours__c from BHAT_Activity_Weekly__c where OwnerID =:userInfo.getUserID()];
                  
      ChildDailyList =  [SELECT BHAT_Activity_Weekly__c wk, sum(Daily_Hours_Spent__c)dailyhours ,
                         sum(Time_Off_Total__c)TimeOff ,sum(Paid_Break_Total__c)Paidbreak ,
                         sum(Unpaid_Lunch_Total__c)Unpaid FROM BHAT_Activity_Daily__c 
                         where ownerId =: userInfo.getUserID() group by BHAT_Activity_Weekly__c limit 1000];
    }    
    
    public void DoInsert(Set<ID> dailySET)
    { 
        
        Decimal DailyHours = 0.0, timeOff = 0.0, paidbreak = 0.0, unpaidlunch = 0.0;      
        Set<ID> ParentWeekSET = new Set<ID>();
        Set<ID> ParentWeekSET1 = new Set<ID>();
        list<Bhat_Activity_Daily__c> dailylist1=new list<Bhat_Activity_Daily__c>();
        List<BHAT_Activity_Weekly__c> weeklylist1 = new List<BHAT_Activity_Weekly__c>();
        
      for(Bhat_Activity_Daily__c daily : dailyList)
      {      
                             
      if(dailySET.contains(daily.id))
      {   
      
        if(daily.BHAT_Activity_Weekly__c != null)
        {   
        system.debug('nnnnnnnnnnnn'+daily.BHAT_Activity_Weekly__c);                                         
            for(BHAT_Activity_Weekly__c week : WeekList)
            {
                if(week.id == daily.BHAT_Activity_Weekly__c)
                { 
                    
                    weeklylist1.add(week);     
                    //CommonRollupSummary(week);
                }
            }
        } 
        else{     
         system.debug('Else loop entry');   
             List<BHAT_Activity_Weekly__c> ExistingWeekList = [Select id, Status__c,WeekStartDate__c, WeekEndDate__c,ownerId
                                                       from BHAT_Activity_Weekly__c where WeekStartDate__c =: daily.ReturnedDate__c and
                                                       WeekEndDate__c =: daily.EndDateWeek__c  and ownerId =: daily.ownerId limit 1];
             system.debug('size of ExistingWeekList '+ExistingWeekList );
             if( ExistingWeekList.size() > 0){
                daily.BHAT_Activity_Weekly__c = ExistingWeekList[0].id; 
                system.debug('if week id does not exist'+daily.BHAT_Activity_Weekly__c);     
                update daily;
             }
             else{
                  dailylist1.add(daily);
             } 
        }
      }
      }
      
      if(weeklylist1.size() > 0){
         CommonRollupSummary(weeklylist1);
      }
      if(dailylist1.size()>0){
      
         InsertNewWeekly(dailylist1);
         }
    }
    
    //Common Weekly Insert Function
    public void InsertNewWeekly(list<BHAT_Activity_Daily__c> daily)
    {
      
      list<BHAT_Activity_Weekly__c> newWeeklist=new List<BHAT_Activity_Weekly__c>();   
      for(BHAT_Activity_Daily__c daily1:daily)
       {
       BHAT_Activity_Weekly__c newWeek =  new BHAT_Activity_Weekly__c (Name = daily1.StartDateMonth__c + '-' +  daily1.EndDateMonth__c, ownerId = daily1.ownerId,
                                                                       WeekStartDate__c = daily1.ReturnedDate__c,
                                                                       WeekEndDate__c = daily1.EndDateWeek__c,
                                                                       WeeklyTotalHours__c = daily1.Daily_Hours_Spent__c,
                                                                       WeeklyPaidBreakHours__c = daily1.Paid_Break_Total__c,
                                                                       WeeklyUnpaidLunchHours__c  =  daily1.Unpaid_Lunch_Total__c,
                                                                       Total_Time_Off_Hours__c = daily1.Time_Off_Total__c);
         newWeeklist.add(newWeek);                                                              
       }
       if(newWeeklist.size()>0)
       insert newWeeklist;
       
       List<BHAT_Activity_Daily__c> update_DailyList = new List<BHAT_Activity_Daily__c>();
       for(BHAT_Activity_Daily__c daily2:daily)
       {
           for(BHAT_Activity_weekly__c week : newweeklist){       
               daily2.BHAT_Activity_Weekly__c = week.id;
               update_DailyList.add(daily2);
           }       
       }
      if( update_DailyList.size() > 0){
       update daily;
      }       
    }
    
    //Common function for RollupSummary Calculation
    public void CommonRollupSummary(List<BHAT_Activity_Weekly__c> weeklist)
    {
     Decimal DailyHours = 0.0, timeOff = 0.0, paidbreak = 0.0, unpaidlunch = 0.0;
     List<BHAT_Activity_Weekly__c> weekupdate_list = new List<BHAT_Activity_Weekly__c>();
         for(BHAT_Activity_Weekly__c week : weeklist)
         {
               for(AggregateResult agr : ChildDailyList)
               {  
                  if(agr.get('wk') == week.id)
                  {
                     DailyHours = DailyHours + (Decimal)agr.get('dailyhours');
                     paidbreak = paidbreak + (Decimal)agr.get('Paidbreak');
                     timeOff = timeOff + (Decimal)agr.get('TimeOff');
                     unpaidlunch = unpaidlunch + (Decimal)agr.get('Unpaid');
                  }
               }
               week.WeeklyTotalHours__c = DailyHours;  
               week.WeeklyPaidBreakHours__c = paidbreak;
               week.Total_Time_Off_Hours__c = timeOff;
               week.WeeklyUnpaidLunchHours__c = unpaidlunch; 
               
               weekupdate_list.add(week);
         }  
         
         if(weekupdate_list.size() > 0)
         {       
               update weekupdate_list;
         }   
    }
    
  
    public void DoUpdate(Set<ID> dailySET)
    {
         Decimal sum1 = 0, timeOff1 = 0, paidbreak = 0, unpaidlunch = 0;
         List<Bhat_Activity_Daily__c> dailyList1 = new  List<Bhat_Activity_Daily__c>();
         List<Bhat_Activity_Weekly__c> WeeklyList1 = new  List<Bhat_Activity_Weekly__c>();
      
      for(Bhat_Activity_Daily__c daily : dailyList)
      {     
      if(dailySET.contains(daily.id))
      { 
        if(daily.BHAT_Activity_Weekly__c != null)
        {                                            
            for(BHAT_Activity_Weekly__c week : WeekList)
            {
                if(week.id == daily.BHAT_Activity_Weekly__c)
                {  
                    WeeklyList1.add(week); 
                    //CommonRollupSummary(week);                     
                }
            }
        }
         else{
             List<BHAT_Activity_Weekly__c> ExistingWeekList = [Select id, Status__c,WeekStartDate__c, WeekEndDate__c,
                                                               ownerId from BHAT_Activity_Weekly__c where 
                                                               WeekStartDate__c =: daily.ReturnedDate__c and
                                                               WeekEndDate__c =: daily.EndDateWeek__c  and
                                                               ownerId =: daily.ownerId  limit 1];
             
             if( ExistingWeekList.size() > 0){
                 daily.BHAT_Activity_Weekly__c = ExistingWeekList[0].id;      
                 update daily;
             }
             else{
                 dailyList1.add(daily);
                 //InsertNewWeekly(daily);
             }
         } 
       }        
      } 
      
       if(WeeklyList1.size() > 0)
       {
           CommonRollupSummary(WeeklyList1);  
       }
       if(dailyList1.size() > 0){
          InsertNewWeekly(dailyList1); 
       }   
    }
    
    public void DoDelete(Set<ID> dailySET)
    {
         List<BHAT_Activity_Daily__c> daily = [select id,Name,Activity_Date__c,BHAT_Activity_Weekly__c,
                                         OwnerId,Daily_Hours_Spent__c,Time_Off_Total__c, 
                                         Paid_Break_Total__c, Unpaid_Lunch_Total__c
                                         from BHAT_Activity_Daily__c where id IN : dailySET  limit 1];
                                         
         List<BHAT_Activity_Weekly__c> WeekList = [Select id, WeekStartDate__c,Status__c, WeekEndDate__c,ownerId,
                                                   WeeklyTotalHours__c,Total_Time_Off_Hours__c, WeeklyPaidBreakHours__c,
                                                   WeeklyUnpaidLunchHours__c from BHAT_Activity_Weekly__c 
                                                   where id =: daily[0].BHAT_Activity_Weekly__c  limit 1];
         if(WeekList.size() > 0){
               WeekList[0].WeeklyTotalHours__c  =  WeekList[0].WeeklyTotalHours__c  - daily[0].Daily_Hours_Spent__c ;
               WeekList[0].Total_Time_Off_Hours__c =  WeekList[0].Total_Time_Off_Hours__c - daily[0].Time_Off_Total__c ;
               WeekList[0].WeeklyPaidBreakHours__c = WeekList[0].WeeklyPaidBreakHours__c - daily[0].Paid_Break_Total__c ;
               WeekList[0].WeeklyUnpaidLunchHours__c  = WeekList[0].WeeklyUnpaidLunchHours__c - daily[0].Unpaid_Lunch_Total__c; 
               
               update WeekList[0];
         }
    }


}