@isTest (seeAllData=true) private class MbrActivityReportControllerTest {

  @isTest static void testAll() {
    System.debug('testAll start');

    Map<Id,MbrActivityReportController.ReportClass> data = MbrActivityReportController.getReportData();
    integer len = data.size();
    system.assertNotEquals(len,0);

    System.debug('testAll end');

  }

}