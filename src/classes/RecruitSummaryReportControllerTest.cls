@isTest (seeAllData=true) private class RecruitSummaryReportControllerTest {

  @isTest static void testAll() {
    System.debug('testAll start');

    Map<String,RecruitSummaryReportController.ReportClass> data = RecruitSummaryReportController.getReportData();
    integer len = data.size();
    system.assertNotEquals(len,0);

    System.debug('testAll end');

  }

}