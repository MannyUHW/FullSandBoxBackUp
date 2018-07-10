trigger UpdatePacketContactOnVisit on CVRSOS__Visits__c (before insert) {
    
    UpdatePacketContactOnVisitHandler.beforeInsertTrigger(Trigger.newmap, trigger.new);
    
}