@isTest
private class SOS_ContactGeoCodeTest {
    static testMethod void TestContactGeoCode() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.MailingStreet = '123 St';
        contact.MailingCity = 'San Francisco';
        contact.FID__c = '3312-23212325';
        insert contact;  
        
        contact.MailingCity = 'San Jose';
        update contact;       
    }
   
}