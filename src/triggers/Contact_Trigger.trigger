trigger Contact_Trigger on Contact(before insert, before update) {

  Contact_Proper_Case_Names.toProperCase(Trigger.new);
  Contact_Split_Employer.processSplits(Trigger.new);
  Contact_Override_Employer.checkOverrides(Trigger.new);
  Contact_Political_Districts.populateDistricts(Trigger.new, Trigger.oldMap, Trigger.isInsert);  
  Contact_Job_Group.populateJobGroup(Trigger.new, Trigger.old, Trigger.isInsert);
  
}