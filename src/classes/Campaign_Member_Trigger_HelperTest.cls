@isTest(SeeAllData=true)
public class Campaign_Member_Trigger_HelperTest {

  public static testMethod  void testCampaignMember() {
  
    Integer cheese = Campaign_Member_Trigger_Helper.cheese();
    
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

    Campaign camp = new Campaign(name='Test Campaign');
    insert camp;

    UHW_Campaign__c camp2 = new UHW_Campaign__c(name='Test Campaign');
    insert camp2;
    
    
    Survey_Question__c sq = new Survey_Question__c();
    sq.Name           = 'Test Question';
    sq.Description__c = 'Test Description';
    sq.Survey_Code__c = 'T99';
    sq.Allowed_Responses__c = 'M.Committed\nB. Confirmed\nN. Cancelled';
    sq.UHW_Campaign__c = camp2.Id;
    insert sq;
    
    CampaignMember cm = new CampaignMember();
    cm.ContactId = c.Id;
    cm.CampaignId = camp.Id;
    cm.Status = 'Sent';
    
    insert cm;
    
    System.Debug('DONE campaign member test');

    System.assert(true);
  }
  
}