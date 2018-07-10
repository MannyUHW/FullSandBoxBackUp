@isTest (seeAllData=true) private class LeaderOutreachReportControllerTest {

  @isTest static void test1() {
    System.debug('test1() start');

    List <String> emptyList = new List <String>();
    List <sObject> data = LeaderOutreachReportController.getData('J01',emptyList );
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List <sObject> data = LeaderOutreachReportController.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

    @isTest static void test3() {
    System.debug('test3() start');
    
    String data = LeaderOutreachReportController.getCountData('J01');
    integer l = data.length();
    system.assertNotEquals(l,0);
    
    System.debug('test3() end');
  }

  
}