trigger Contact_Address_Trigger on Contact_Address__c (before insert, before update) {

Contact_Address_DeDupe.deDupe(Trigger.new, Trigger.old, Trigger.isInsert);

}