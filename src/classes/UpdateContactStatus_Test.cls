@IsTest(seealldata = true)

public class UpdateContactStatus_Test
{
    public static testMethod void test1()
    {
        contact c = new contact(LastName = 'test lastname',
                                Subject__c = 'Bad Address', 
                                Bad_Phone_Numbers__c = '1234',
                                Field_Work_Notes__c = 'test notes',FID__c = '3312-23212477');
        insert c;
        
        Project_SOSP__c p = new Project_SOSP__c(name = 'test project');
        insert p;
        
        Project_Zone_SOSP__c pzone = new Project_Zone_SOSP__c(Project__c = p.id);
        insert pzone;
        
        Project_Zone_Contact_SOSP__c pzc = new Project_Zone_Contact_SOSP__c();
        
        pzc.contact__c = c.id;
        pzc.Project_Zone__c = pzone.id;
        pzc.Bad_Phone_Numbers__c = '123456';
        pzc.Field_Work_Notes__c = 'test notes123';
        pzc.Subject__c = 'Visit - Signed Card';
        
        insert pzc;   
        
        pzc.Bad_Phone_Numbers__c = '1234561';
        
        update pzc;
        pzc.Bad_Phone_Numbers__c = '1234561';
        
        update pzc;
        
             
    }
}