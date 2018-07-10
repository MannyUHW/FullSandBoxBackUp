trigger UserTrigger on User (before update, before insert, after update, after insert ) {

    if(Trigger.isBefore && Trigger.isUpdate)
      UserTriggerHandler.onBeforeUpdate(Trigger.Old,Trigger.new);

    if(Trigger.isBefore && Trigger.isInsert)
        UserTriggerHandler.onBeforeInsert(Trigger.new);

    if(Trigger.isAfter && Trigger.isInsert)
        UserTriggerHandler.onAfterInsert(Trigger.new);

    if(Trigger.isAfter && Trigger.isUpdate)
        UserTriggerHandler.onAfterUpdate(Trigger.new);
}