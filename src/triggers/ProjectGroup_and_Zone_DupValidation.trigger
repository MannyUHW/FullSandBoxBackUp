trigger ProjectGroup_and_Zone_DupValidation on Project_Zone_SOSP__c (before insert) 
{
    Set<id> ProjectZoneGroupSet=new Set<id>();
    for (Project_Zone_SOSP__c prjtzone:Trigger.new)
    {
        ProjectZoneGroupSet.add(prjtzone.Project_Zone_Group__c);
    }

    List<Project_Zone_SOSP__c> ProjectZoneSOSPlist=[select id,Project_Zone_Group__c,Zone_p__c from Project_Zone_SOSP__c where Project_Zone_Group__c in:ProjectZoneGroupSet];

    Map <String,Project_Zone_SOSP__c> ProjectZoneSOSPId = new Map<String,Project_Zone_SOSP__c>(); 
    
    for (Project_Zone_SOSP__c  ProjectZone:ProjectZoneSOSPlist)
    {
        ProjectZoneSOSPId.put(ProjectZone.Zone_p__c,ProjectZone);
    }

    for (Project_Zone_SOSP__c prjtzone:Trigger.New)
    {    
        if (ProjectZoneSOSPId.containsKey(prjtzone.Zone_p__c))
        {
             Prjtzone.addError('Record with these Group and Zone combination already Exist'); 
        } 
    }
}