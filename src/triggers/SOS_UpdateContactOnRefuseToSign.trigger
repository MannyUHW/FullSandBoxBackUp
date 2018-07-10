trigger SOS_UpdateContactOnRefuseToSign on Task (after insert, after update, after delete) { 
    
         
    if(Trigger.isInsert && Trigger.isAfter){
        TaskTriggerHelper.afterInsert_SOS_UpdateContactOnRefuseToSign(trigger.new, trigger.old);
    } 
    
    if(Trigger.isUpdate && Trigger.isAfter){
        TaskTriggerHelper.afterUpdate_SOS_UpdateContactOnRefuseToSign(trigger.new, trigger.old);
    } 
    
    if(Trigger.isDelete && Trigger.isAfter){
        TaskTriggerHelper.afterDelete_SOS_UpdateContactOnRefuseToSign (trigger.old);
    }
}