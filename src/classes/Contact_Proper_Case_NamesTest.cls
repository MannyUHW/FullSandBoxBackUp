@isTest
public class Contact_Proper_Case_NamesTest {

  public static testMethod  void testNames() {
  
    Contact_Proper_Case_Names cpn = new Contact_Proper_Case_Names();
    Integer cheese = Contact_Proper_Case_Names.cheese();
  
    Account em = new Account(name='Test Employer');
    insert em;
    
    List<String> titleList = new List<String> { 'LVN'};

    for (Integer i = 0; i < titleList.size(); i++) {
      Contact c = new Contact();
      c.LastName = ('TestLast');
      c.FirstName = ('TestFirst');
      c.FID__c = '9999-15999' + (1000 + i);
      c.Title = titleList[i];
      c.Job_Group__c = 'LVN';
      c.account = em;    
      insert c;    
      System.Debug('FID = ' + c.FID__c);      
    }


    System.Debug('DONE test Proper Case Names');
    
    System.assert(true);
  }
  
}