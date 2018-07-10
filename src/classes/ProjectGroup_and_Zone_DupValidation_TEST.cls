@isTest(SeeAllData = True)

public class ProjectGroup_and_Zone_DupValidation_TEST
{
    public static testMethod void test1()
    {   
        Project_SOSP__c p = new Project_SOSP__c(name = 'project1');
        insert p;
        
        Zone_Group_SOSP__c zg = new Zone_Group_SOSP__c(name = 'zonegroup1');
        insert zg;
        
        Project_Zone_Group_SOSP__c pzg = new Project_Zone_Group_SOSP__c(Project__c = p.id, Zone_Group__c = zg.id);
        insert pzg;
        
        Zone_SOSP__c z = new Zone_SOSP__c(Zone_Group__c = zg.id);
        insert z;
        
        Project_Zone_SOSP__c pz = new Project_Zone_SOSP__c(Project__c = p.id, Project_Zone_Group__c = pzg.id, Zone_p__c=z.id);
        insert pz;
    }
}