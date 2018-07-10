@isTest (seeAllData=true) private class ContactFieldUseControllerTest2 {

  @isTest static void test1() {
    System.debug('test1 - ContactFieldUseController2.getCounts() start');

    ContactDescObj__c[] data = ContactFieldUseController2.getCounts('All');
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1 - ContactFieldUseController2.getCounts() end');
  }

  @isTest static void test2() {
    System.debug('test2 - ContactFieldUseController2.getFieldData(false) start');

    ContactDescObj__c[] data = ContactFieldUseController2.getFieldData(false, 'All');
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1 - ContactFieldUseController2.getFieldData() end');
  }

  @isTest static void test3() {
    System.debug('test3 -   .startRefresh() start');
    Test.StartTest();
    String data = ContactFieldUseController2.startRefresh('All');
    Test.StopTest();
    system.assertNotEquals(data,null);
    
    System.debug('test3 - ContactFieldUseController2.startRefresh() end');
  }

  @isTest static void test4() {
    System.debug('test4 - ContactFieldUseController2.fudgeTest() start');

    String data = ContactFieldUseController2.fudgeTest();
    system.assertNotEquals(data,null);
    
    System.debug('test4 - ContactFieldUseController2.fudgeTest() end');
  }

}