trigger PetitionLedger_RecordTrigger on Petition_Ledger__c (before insert, before update, after insert, after update, after delete) {
    if (trigger.isBefore){
        PetitionLedger_Helper.LedgerChangeList_Before(trigger.new);
    }
    if (trigger.IsAfter){
        if(trigger.isDelete){
            PetitionLedger_Helper.LedgerChangeList_After(trigger.old);
        }
        else{
            PetitionLedger_Helper.LedgerChangeList_After(trigger.new);
        }
    }
}