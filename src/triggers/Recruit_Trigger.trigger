trigger Recruit_Trigger on Recruit__c(after insert, after update, after delete) {

  Set<Id> newIdSet = null;
  if (Trigger.new != null) {
    newIdSet = Trigger.newMap.keySet();
  }
  Set<Id> oldIdSet = null;
  if (Trigger.old != null) {
    oldIdSet = Trigger.oldMap.keySet();
  }  
  Recruit_To_Survey.propagateToSurvey(newIdSet, oldIdSet, Trigger.isInsert, Trigger.isDelete);  
  
}