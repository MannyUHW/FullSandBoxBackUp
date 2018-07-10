trigger BHAT_RollupOnDaily on BHAT_Activity__c (after insert, after update, before delete) {

Set<ID> activityID = new Set<ID>();
Set<ID> activityID_update = new Set<ID>();
Set<ID> activityID_delete = new Set<ID>();
BHAT_RollupSummaryOnDAILY BHAT_Util = new BHAT_RollupSummaryOnDAILY();

 
       
            if(Trigger.IsInsert){
            for(BHAT_Activity__c ac : Trigger.New){
                  activityID.add(ac.id); 
            }  
       }
     
   if(activityID.size()>0)
   {
  
    BHAT_Util.DOinsert(activityID);
    }
   
   
       
          if(Trigger.IsUpdate){ 
          for(BHAT_Activity__c ac : Trigger.old){
            activityID_update.add(ac.id);
          } 
       }
   if(activityID_update.size()>0)
   {
   BHAT_Util.DOupdate(activityID_update);
   }
   
   if(Trigger.IsDelete){ 
       for(BHAT_Activity__c ac : Trigger.old){
            activityID_delete.add(ac.id);
            
       } 
   }
  if(activityID_delete.size()>0)
  {
  
   BHAT_Util.DOdelete(activityID_delete);
   } 
}