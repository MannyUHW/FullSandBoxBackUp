@isTest
private class ContactTriggerTest {
    static testMethod void TestCreateCompetedTaskTrigger() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = true;
        contact.FID__c = '3312-23212525';
        insert contact;   
        System.assertEquals('Test',contact.FirstName);
        
       
    }


}