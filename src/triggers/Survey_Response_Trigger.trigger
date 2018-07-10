trigger Survey_Response_Trigger on Survey_Response__c (before insert, before update) {

  Survey_Response_ValidateDeDupe.validateDeDupe(Trigger.new, Trigger.old, Trigger.isInsert);

  
}