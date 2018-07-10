trigger SOSTimeOffBalanceTrigger on SOS_Time_Off_Balance__c (before insert, before update) {
    If(Trigger.isBefore && Trigger.isInsert)
    {
        SOSTimeOffBalanceTriggerHandler.onBeforeInsert(Trigger.new);
    }
        
    If(Trigger.isBefore && Trigger.isUpdate)
    {
        SOSTimeOffBalanceTriggerHandler.onBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
 
             
}