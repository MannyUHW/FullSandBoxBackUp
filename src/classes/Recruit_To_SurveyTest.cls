@isTest(SeeAllData = true)
public class Recruit_To_SurveyTest {

  public static testMethod  void testPropagate() {

  
    Account em = new Account(name='Test Employer');
    insert em;
  
    Contact c = new Contact();
    c.lastname = ('TestLast');
    c.firstName = ('TestFirst');
    c.fid__c = '9999-169990001';
    c.account = em;    
    insert c;
    
    Recruit__c r = new Recruit__c();
    
    r.Recruit__c = c.Id;
    r.Volunteer_Date__c = Date.today();
    r.Location__c = 'Oakland Early(2-5)';
    r.Recruited_By__c = c.Id;
    
    insert r;
    
    Recruit_To_Survey.cheese();
  }
  
}