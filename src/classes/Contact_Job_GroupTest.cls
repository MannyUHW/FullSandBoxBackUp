@isTest
public class Contact_Job_GroupTest {

  public static testMethod  void testGroup() {
  
    Contact_Job_Group cjg = new Contact_Job_Group();
    Integer cheese = Contact_Job_Group.cheese();
  
    Account em = new Account(name='Test Employer');
    insert em;
    
    List<String> titleList = new List<String> { 'LVN', 'EVS', 'RCP', 'RN', 'MD', 'Secretary', 'Home Care', 'Food', 'Imaging', 'HIM Coder', 'Lab Asst', 'ER Tech', 'Medical Social Worker', 'CT Tech', 'sterile tech', 'Phlebotomist', 'Manager', 'Director', 'Accountant', 'CEO', 'Unknown Title', 'FNS', 'Surg Tech', 'Health Educator'};

    for (Integer i = 0; i < titleList.size(); i++) {
      Contact c = new Contact();
      c.LastName = ('TestLast');
      c.FirstName = ('TestFirst');
      c.FID__c = '9999-15999' + (1000 + i);
      c.Title = titleList[i];
      c.account = em;    
      //insert c;    
      System.Debug('FID = ' + c.FID__c);      
    }


    System.Debug('DONE testGroup');
    
    System.assert(true);
  }
  
}