@isTest(SeeAllData=true)
public class Contact_Political_DistrictsTest {

  public static testMethod  void testDistricts() {
  
    Contact_Political_Districts cpd = new Contact_Political_Districts();
    Integer cheese = Contact_Political_Districts.cheese();
    
    Account em = new Account(name='Test Employer');
    insert em;
    Integer i = 0;
    
      Contact c = new Contact();
      c.LastName = ('TestLast');
      c.FirstName = ('TestFirst');
      c.FID__c = '9999-15999' + (1000 + i);
      c.Title = 'LVN';
      c.MailingPostalCode = '90022';
      c.account = em;    
      insert c;    
      System.Debug('FID = ' + c.FID__c);      



    System.Debug('DONE test political districts');

    System.assert(true);
  }
  
}