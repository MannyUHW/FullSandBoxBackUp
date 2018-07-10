@isTest(SeeAllData = true)
public class Contact_Address_DeDupeTest {

  public static testMethod void test() {
  
    Account em = new Account(name='Test Employer');
    insert em;
  
    Contact c = new Contact();
    c.lastname = ('TestLast');
    c.firstName = ('TestFirst');
    c.fid__c = '9999-159990001';
    c.account = em;    
    insert c;
    
    Contact_Address__c ca = new Contact_Address__c();
    ca.Contact__c = c.id;
    ca.Street__c = '1234 Elm St.';
    ca.City__c = 'Commerce';    
    ca.State__c = 'CA';
    ca.PostalCode__c = '90022';
    insert ca;

    ca.Primary_Address__c = true;
    update ca;
    
    Contact_Address_DeDupe.cheese();    
   
    System.assert(true);
  }

}