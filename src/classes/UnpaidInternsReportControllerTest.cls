@isTest (seeAllData=true) private class UnpaidInternsReportControllerTest  {

  @isTest static void test1() {
    System.debug('test1() start');
    List <sObject> data = UnpaidInternsReportController.getEmpData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');
    List <sObject> data = UnpaidInternsReportController.getRespData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    System.debug('test2() end');
  }

}