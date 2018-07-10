@isTest (seeAllData=true) private class MclDuplicationControllerTest {

  @isTest static void test1() {
    System.debug('test1() start');

    List <sObject> data = MclDuplicationController.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List <sObject> data = MclDuplicationController.getMclData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test2() end');
  }

  @isTest static void test3() {
      System.debug('test3() start');
        List<MCL_Report__c> mclIds = [SELECT Id FROM MCL_Report__c ORDER BY LastModifiedDate DESC LIMIT 1];
        String mclId = mclIds[0].Id;

      String base  = 'Test Coverage Mcl';

      List<Account> accIds = [Select Id From Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' And Constituency__c != null Order By LastModifiedDate DESC LIMIT 2];
      String accountIds = accIds[0].Id + ',' + accIds[1].Id;

      List <String> errors = MclDuplicationController.createDuplicates(mclId,base,accountIds, true, false, true);
      integer l = errors.size();
      System.assertEquals(l,0);      System.debug('test3() end');
  }

}