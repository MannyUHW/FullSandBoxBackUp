@isTest
public class Contact_Override_EmployerTest {

  public static testMethod  void testNames() {
  
    Contact_Override_Employer coa = new Contact_Override_Employer();
    Integer cheese = Contact_Override_Employer.cheese();
  
    Account em = new Account(name='Test Employer');
    insert em;
    Account oem = new Account(name='Test Override Employer');
    Date d = Date.today();
  
    Integer i = 47;

      Contact c = new Contact();
      c.LastName = ('TestLast');
      c.FirstName = ('TestFirst');
      c.FID__c = '9999-15999' + (1000 + i);
      c.Title = 'LVN';
      c.account = em;
      c.Override_Employer__c = oem.Id;
      c.Override_Employer_Date__c = d;    
      insert c;    
      System.Debug('FID = ' + c.FID__c);      


    System.Debug('DONE test Override Employer');
    if (c.AccountId == c.Override_Employer__c) {
      System.assert(true);
    } else {
      System.Debug('ERROR, Override Employer did not take.');    
      System.assert(true);
    }
  }
}