trigger BHAT_RollupOnWeekly on BHAT_Activity_Daily__c (after insert, after update, before delete) 
{  
   Set<ID> DailyID_insert = new Set<ID>();
   Set<ID> DailyID_update = new Set<ID>();
   Set<ID> DailyID_delete = new Set<ID>();
   
   Set<String> weeknames_insert = new set<String>();
   Set<String> weeknames_update = new set<String>();
   
   BHAT_RollupSummaryOnWEEKLY Bhat_Util = new BHAT_RollupSummaryOnWEEKLY();
   
   System.debug('Trigger.New...........'+Trigger.New);
   
   if(Trigger.IsInsert){
        for(BHAT_Activity_Daily__c dac : Trigger.New)
        {
              // String WeekName = dac.StartDateMonth__c + '-' +  dac.EndDateMonth__c;  
               DailyID_insert.add(dac.id);
              // weeknames_insert.add(WeekName);   
        }
   } 
   
   if(DailyID_insert.size() > 0)
   {
        Bhat_Util.DOinsert(DailyID_insert);
   }
   
   System.debug('Trigger.old...........'+Trigger.old);
   if(Trigger.IsUpdate){ 
       for(BHAT_Activity_Daily__c dac : Trigger.old)
       {
          //  String WeekName = dac.StartDateMonth__c + '-' +  dac.EndDateMonth__c;  
            DailyID_update.add(dac.id);
            //weeknames_update.add(WeekName);
       } 
   }
   
   if(DailyID_update.size() > 0)
   {
        Bhat_Util.DOinsert(DailyID_update);
   }
   
  
   if(Trigger.IsDelete){ 
       for(BHAT_Activity_Daily__c dac : Trigger.old){
            DailyID_delete.add(dac.id); 
       } 
   }
   
   if(DailyID_delete.size() > 0 )
   {
       Bhat_Util.DOdelete(DailyID_delete);
   }
   
   
   
}