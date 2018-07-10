public class BHAT_RollupSummaryOnDAILY{   
 
   public void DOinsert(Set<ID> newActivity)
   {
      Decimal DailyHours = 0.0, timeOff = 0.0, paidbreak = 0.0, unpaidlunch = 0.0;
      Set<ID> ParentDailyBhat = new Set<ID>();
      Set<ID> ParentDailyBhat1 = new Set<ID>();
         
      List<BHAT_Activity__c>  activityBHAT = [select id,ownerID,BHAT_Activity_Daily__c,BHAT_Activity_Code__c,
                                        BHAT_Activity_Code__r.Activity_Code_Category__c,
                                        BHAT_Activity_Code__r.name,Activity_Date__c,Hours_Spent__c
                                        from BHAT_Activity__c where id IN : newActivity];
                                        
      List<BHAT_Activity_Daily__c> DailyBHAT_list = [Select id,Status__c,ownerId, Activity_Date__c, Daily_Hours_Spent__c,
                                                     Time_Off_Total__c,Unpaid_Lunch_Total__c,Paid_Break_Total__c
                                                     from BHAT_Activity_Daily__c                                                      
                                                     where Activity_Date__c =: activityBHAT[0].Activity_Date__c
                                                     and ownerId =: activityBHAT[0].ownerId limit 1]; 
                                                     
       List<Bhat_activity__c> updateList = new List<Bhat_activity__c>();
      
       if( DailyBHAT_list.size() > 0)
       {
           ParentDailyBhat.add(DailyBHAT_list[0].id); 
            //Assigning the Lookup id of the parent that matches with the ActivityDate of the current user                     
           for(Bhat_Activity__c actv : activityBHAT)
           {  
             actv.BHAT_Activity_Daily__c = DailyBHAT_list[0].id;      
             updateList.add(actv);
           }
           
           if(updateList.size() > 0){
               update updateList;
           }
          
           //Getting the list of child that the parent Daily has to do rollup summary      
           List<BHAT_Activity__c> activitiesList = [ Select id,Name,BHAT_Activity_Daily__c,Activity_Date__c,Hours_Spent__c,
                                                    IsTimeOff__c,IsUnpaidLunch__c, OwnerId,IsDailyHours__c, IsPaidBreak__c from 
                                                    BHAT_Activity__c where BHAT_Activity_Daily__c IN : ParentDailyBhat];                                                
           if(activitiesList.size() > 0)
           { 
               ParentDailyBhat1.add(activitiesList[0].BHAT_Activity_Daily__c); 
               RollupSummary(ParentDailyBhat1,activitiesList);
           }    
       }
       else{ 
            // String CodeCategory = activityBHAT[0].BHAT_Activity_Code__r.Activity_Code_Category__c ;
            // String CodeName = activityBHAT[0].BHAT_Activity_Code__r.Name;              
              
             insertDailyRecord(activityBHAT);    
       }
   }   
   
   
   //Common fucntion to insert new bhatActivityDaily and update the lookup of the bhatActivity
   public void insertDailyRecord(List<Bhat_Activity__c> activityBHAT)
   {
        System.debug('activity list'+activityBHAT);
        
        BusinessDay b = new BusinessDay(); 
        BHAT_Activity_Daily__c createBHAT = new BHAT_Activity_Daily__c();
        
        
           createBHAT.Activity_Date__c = activityBHAT[0].Activity_Date__c;
           createBHAT.ownerId = activityBHAT[0].ownerId;
           createBHAT.ReturnedDate__c  = b.getStartWeekData(activityBHAT[0].Activity_Date__c);        
           createBHAT.EndDateWeek__c  = b.getEndWeekData(activityBHAT[0].Activity_Date__c); 
           createBHAT.StartDateMonth__c = b.getMonthStart(createBHAT.ReturnedDate__c);        
           createBHAT.EndDateMonth__c = b.getMonthEnd(createBHAT.EndDateWeek__c);                     
           createBHAT.Daily_Hours_Spent__c=0;
           createBHAT.Time_Off_Total__c=0;
           createBHAT.Unpaid_Lunch_Total__c=0;
           createBHAT.Paid_Break_Total__c=0;
           for(integer i = 0; i< activityBHAT.size(); i++){ 
             String CodeCategory = activityBHAT[i].BHAT_Activity_Code__r.Activity_Code_Category__c ;
             String CodeName = activityBHAT[i].BHAT_Activity_Code__r.Name;        
             if(CodeCategory != 'TimeOff'  && (CodeName).toLowerCase() != 'u' && (CodeName).toLowerCase() != 'k'  )
             {    
                    System.debug('Daily_Hours_Spent__c'+createBHAT.Daily_Hours_Spent__c+'activityBHAT[i].Hours_Spent__c'+activityBHAT[i].Hours_Spent__c);
                   createBHAT.Daily_Hours_Spent__c = createBHAT.Daily_Hours_Spent__c + activityBHAT[i].Hours_Spent__c;                      
             }
             else if(CodeCategory  == 'TimeOff'  && (CodeName).toLowerCase() != 'u' && (CodeName).toLowerCase() != 'k' )
             {
                   createBHAT.Time_Off_Total__c = createBHAT.Time_Off_Total__c+ activityBHAT[i].Hours_Spent__c; 
             }  
             else if((CodeName).toLowerCase() == 'u')
             {
                   createBHAT.Unpaid_Lunch_Total__c =createBHAT.Unpaid_Lunch_Total__c+  activityBHAT[i].Hours_Spent__c; 
             }
             else if( (CodeName).toLowerCase() == 'k')
             {
                   createBHAT.Paid_Break_Total__c =  createBHAT.Paid_Break_Total__c+ activityBHAT[i].Hours_Spent__c;
             } 
           }            
           insert createBHAT;
           
           List<Bhat_Activity__c> bhat_list = new List<Bhat_Activity__c>();
           
           for(integer j = 0; j< activityBHAT.size(); j++)
           {     
               activityBHAT[j].BHAT_Activity_Daily__c = createBHAT.id; 
               bhat_list.add(activityBHAT[j]);                      
           }
           if(bhat_list.size() > 0){
               update bhat_list; 
           }  
   }  
   
    public void DOupdate(Set<ID> newActivity)
    {     
          Set<ID> ParentDailyBhat = new Set<ID>();
          Set<ID> ParentDailyBhat1 = new Set<ID>();
       
          List<BHAT_Activity__c>  activityBHAT = [select id,Name,BHAT_Activity_Daily__c,BHAT_Activity_Code__c,
                                            BHAT_Activity_Code__r.Activity_Code_Category__c,OwnerId, 
                                            BHAT_Activity_Code__r.Name,Activity_Date__c,Hours_Spent__c,
                                            IsTimeOff__c,IsUnpaidLunch__c, IsDailyHours__c, IsPaidBreak__c from 
                                            BHAT_Activity__c where id IN : newActivity]; 
           
         List<BHAT_Activity_Daily__c> DailyBHAT = [Select id,Status__c,ownerId, Activity_Date__c from BHAT_Activity_Daily__c
                                                   where Activity_Date__c =: activityBHAT[0].Activity_Date__c
                                                   and ownerId =: activityBHAT[0].ownerId limit 1];
         if(DailyBHAT.size() > 0)
         {         
             ParentDailyBhat.add(DailyBHAT[0].id);
         
           //Getting the list of child that the parent Daily has to do rollup summary      
             List<BHAT_Activity__c> activitiesList = [ Select id,Name,BHAT_Activity_Daily__c,Activity_Date__c,Hours_Spent__c,
                                                      IsTimeOff__c,IsUnpaidLunch__c, OwnerId,IsDailyHours__c, IsPaidBreak__c from 
                                                      BHAT_Activity__c where BHAT_Activity_Daily__c IN : ParentDailyBhat];                                                                                                    
               if(activitiesList.size() > 0)
               {
                   ParentDailyBhat1.add(activitiesList[0].BHAT_Activity_Daily__c); 
                   RollupSummary(ParentDailyBhat1,activitiesList);
               }  
         }
         else{
            // String CodeCategory = activityBHAT[0].BHAT_Activity_Code__r.Activity_Code_Category__c ;
            // String CodeName = activityBHAT[0].BHAT_Activity_Code__r.Name;              
              
             insertDailyRecord(activityBHAT);    
         }           
   }  
   
   //Calcualation of RollupSummary
   public void RollupSummary(Set<ID> DailyID_SET, List<BHAT_Activity__c> ActivityList)  
   {
        Decimal DailyHours = 0.0, timeOff = 0.0, paidbreak = 0.0, unpaidlunch = 0.0;
        List<BHAT_Activity_Daily__c> dlist = [Select id,Status__c,ownerId, Activity_Date__c, Daily_Hours_Spent__c,
                                              Time_Off_Total__c,Unpaid_Lunch_Total__c,Paid_Break_Total__c from 
                                              BHAT_Activity_Daily__c where id IN : DailyID_SET limit 1];
              for(BHAT_Activity__c bhat : ActivityList){
                    if(bhat.IsDailyHours__c == true){
                            dailyhours = dailyhours + bhat.Hours_Spent__c ;                                                             
                     }
                     if(bhat.IsTimeOff__c == true){
                            timeOff = timeOff + bhat.Hours_Spent__c;
                     }
                     if(bhat.IsUnpaidLunch__c == true){
                            unpaidlunch = unpaidlunch + bhat.Hours_Spent__c;   
                     }
                     if(bhat.IsPaidBreak__c == true){
                            paidbreak  = paidbreak  + bhat.Hours_Spent__c;
                     }
              }              
              if(dlist.size() > 0){
                  dlist[0].Daily_Hours_Spent__c  = dailyhours ;
                  dlist[0].Time_Off_Total__c = timeOff;
                  dlist[0].Unpaid_Lunch_Total__c = unpaidlunch;
                  dlist[0].Paid_Break_Total__c = paidbreak;
               update dlist[0];  
             } 
   }    
   
    public void DOdelete(Set<Id> newActivity){
           Decimal DailyHours = 0.0, timeOff = 0.0, paidbreak = 0.0, unpaidlunch = 0.0;
           
            List<BHAT_Activity__c>  activityBHAT = [select id,Name,BHAT_Activity_Daily__c,BHAT_Activity_Code__c,
                                                Activity_Date__c,Hours_Spent__c,IsTimeOff__c,OwnerId, 
                                                IsUnpaidLunch__c, IsDailyHours__c, IsPaidBreak__c from 
                                                BHAT_Activity__c where id IN: newActivity ];
           
            BHAT_Activity_Daily__c DailyBHAT = new BHAT_Activity_Daily__c();
            DailyBHAT = [Select id,Status__c,ownerId, Activity_Date__c, Daily_Hours_Spent__c,
                         Time_Off_Total__c,Unpaid_Lunch_Total__c,Paid_Break_Total__c
                         from BHAT_Activity_Daily__c where id =: activityBHAT[0].BHAT_Activity_Daily__c limit 1]; 
                       
      if( activityBHAT.size() > 0 )//&& activityBHAT[0].BHAT_Activity_Daily__c != null)
      {                                     
             
              for(integer i = 0; i< activityBHAT.size(); i++)
              { 
              if(activityBHAT[i].BHAT_Activity_Daily__c != null)
              {                                   
             if(activityBHAT[i].IsDailyHours__c == true){
                     DailyBHAT.Daily_Hours_Spent__c = DailyBHAT.Daily_Hours_Spent__c - activityBHAT[i].Hours_Spent__c ;
             }
             else if(activityBHAT[i].IsTimeOff__c == true){
                     DailyBHAT.Time_Off_Total__c = DailyBHAT.Time_Off_Total__c - activityBHAT[i].Hours_Spent__c;
             }
             else if(activityBHAT[i].IsUnpaidLunch__c == true){
                     DailyBHAT.Unpaid_Lunch_Total__c = DailyBHAT.Unpaid_Lunch_Total__c  - activityBHAT[i].Hours_Spent__c;
             }
             else if(activityBHAT[i].IsPaidBreak__c == true){
                     DailyBHAT.Paid_Break_Total__c = DailyBHAT.Paid_Break_Total__c - activityBHAT[i].Hours_Spent__c;
             } 
             }
             }
             System.debug('lllllllll'+DailyBHAT);
           update  DailyBHAT;
       }                     
    }
}