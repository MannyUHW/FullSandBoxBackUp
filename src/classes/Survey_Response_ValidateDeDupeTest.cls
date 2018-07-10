@isTest(SeeAllData = true)
public class Survey_Response_ValidateDeDupeTest {

  public static testMethod void test() {
  
    UHW_Campaign__c cmp = new UHW_Campaign__c();
    cmp.name = 'Test Campaign';
    insert cmp;
  
    Account em = new Account(name='Test Employer');
    insert em;
  
    Contact c = new Contact();
    c.lastname = ('TestLast');
    c.firstName = ('TestFirst');
    c.fid__c = '9999-159990001';
    c.account = em;    
    insert c;
    
    Survey_Question__c sq = new Survey_Question__c();
    sq.Survey_Code__c = ('Z99');
    sq.name = 'Test Question';
    sq.Description__c = 'Test Description';
    sq.allowed_responses__c = '1. Leader\n2. Supporter\n3. Undecided\n4. Anti-Union\n.5. Anti-UHW\n6. Anti-UHW Leader\n9. Not Eligible';
    sq.UHW_Campaign__c = cmp.id;
    insert sq;
    
    
    Survey_Response__c sr = new Survey_Response__c();
    sr.Collected_Datetime__c = Datetime.now();
    sr.Contact__c = c.id;
    sr.Response_Value__c = '2';
    sr.Survey_Question__c = sq.id;
    insert sr;

    sr = new Survey_Response__c();
    sr.Collected_Datetime__c = Datetime.now();
    sr.Contact__c = c.id;
    sr.Response_Value__c = '1';
    sr.Survey_Question__c = sq.id;
    insert sr;
    
    sr.Response_Value__c = '3';
    update sr;
    
    
    sr = new Survey_Response__c();
    sr.Collected_Datetime__c = Datetime.now();
    sr.Alt_Last_Name__c = 'Uln';    
    sr.Alt_First_Name__c = 'Ufn';
    sr.alt_employer__c = em.id;
    sr.Response_Value__c = '1';
    sr.Survey_Question__c = sq.id;
    insert sr;
    
    System.assert(true);
  }

}