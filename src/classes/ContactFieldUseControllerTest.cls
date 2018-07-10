@isTest (seeAllData=true) private class ContactFieldUseControllerTest {

  @isTest static void test1() {
    System.debug('test1 - ContactFieldUseController.getCounts() start');

    ContactDescObj__c[] data = ContactFieldUseController.getCounts();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1 - ContactFieldUseController.getCounts() end');
  }

  @isTest static void test2() {
    System.debug('test2 - ContactFieldUseController.getFieldData(false) start');

    ContactDescObj__c[] data = ContactFieldUseController.getFieldData(false);
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1 - ContactFieldUseController.getFieldData() end');
  }

  @isTest static void test3() {
    System.debug('test3 - ContactFieldUseController.startRefresh() start');
    Test.StartTest();
    String data = ContactFieldUseController.startRefresh();
    Test.StopTest();
    system.assertNotEquals(data,null);
    
    System.debug('test3 - ContactFieldUseController.startRefresh() end');
  }

  @isTest static void test4() {
    System.debug('test4 - ContactFieldUseController.fudgeTest() start');

    String data = ContactFieldUseController.fudgeTest();
    system.assertNotEquals(data,null);
    
    System.debug('test4 - ContactFieldUseController.fudgeTest() end');
  }

}