trigger SOS_SetRecordType on Contact (before insert, before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        ContactTriggerHelper.beforUpdate_SOS_SetRecordType(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        ContactTriggerHelper.beforInsert_SOS_SetRecordType(Trigger.new, Trigger.oldMap);
    }
}