@isTest
private class SOS_ContactTriggerTest {
    static testMethod void TestCreateCompetedTaskTrigger() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = true;
        insert contact;   
        System.assertEquals('Test',contact.FirstName);
        
       
    }


}