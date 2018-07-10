trigger SOSTimeOffRequestTrigger on SOS_Time_Off_Request__c (before insert, after insert, after update, after delete, after undelete) {

    If(Trigger.isBefore && Trigger.isInsert )
       SOSTimeOffRequestTriggerHandler.onBeforeInsert(Trigger.New); 
    If(Trigger.isBefore && Trigger.isUpdate)
        SOSTimeOffRequestTriggerHandler.onBeforeUpdate(Trigger.newMap,Trigger.oldMap);
    If(Trigger.isAfter)
        SOSTimeOffRequestTriggerHandler.onAfterEvents(Trigger.Old,Trigger.New,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete, Trigger.isUnDelete, Trigger.newMap);

}