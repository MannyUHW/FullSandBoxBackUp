@isTest (seeAllData=true) private class GotvMobileControllerTest {

  @isTest static void test1() {
    System.debug('test1() start');

    List <Gotv_Universe__c> data = GotvMobileController.getUniverseData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List<Gotv_Universe__c> getOneList = [SELECT Id FROM Gotv_Universe__c LIMIT 1];

    Gotv_Universe__c getOne = getOneList[0];
    System.debug(getOne.Id);
    List <Contact> data = GotvMobileController.getContactData(getOne.Id);
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test2() end');
  }

  @isTest static void test3() {
    System.debug('test3() start');

    List<Contact> getOneList = [SELECT Id,Three_Touch_ST__c,Three_Touch_VC__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status;
    Boolean touchST,touchVC,touchOB;

    touchST = !getOne.Three_Touch_ST__c;
    touchVC = !getOne.Three_Touch_VC__c;
    status = GotvMobileController.updateContact(getOne.Id, touchST,touchVC);
    system.assertEquals(status,'OK');

    touchST = !touchST;
    touchVC = !touchVC;
    status = GotvMobileController.updateContact(getOne.Id, touchST,touchVC);
    system.assertEquals(status,'OK');

    System.debug('test3() end');         
  }

}