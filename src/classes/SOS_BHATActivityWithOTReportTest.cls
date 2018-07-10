@isTest
public class SOS_BHATActivityWithOTReportTest {
    public static testMethod void testBHATActivityWithOTReportController() {
        BHAT_Activity_Code__c ac = new BHAT_Activity_Code__c();
        ac.Name = 'Test';
        insert ac;
        BHAT_Activity__c ba = new BHAT_Activity__c();
        
        ba.Activity_Date__c = Date.today().addDays(-5);
        ba.BHAT_Activity_Code__c= ac.Id;
        ba.Hours_Spent__c = 3.0;
        insert ba;
        
        ba = new BHAT_Activity__c();
        ba.Activity_Date__c = Date.today().addDays(-6);
        ba.BHAT_Activity_Code__c = ac.Id;
        ba.Hours_Spent__c = 3.0;
        insert ba;
        SOS_BHATActivityWithOTReportController controller = new SOS_BHATActivityWithOTReportController() ;
        controller.search();
        controller.range = '2';
        controller.setDates();
        controller.startDateDummyObj.Activity_Date__c = Date.today().addDays(-1);
        controller.search();
        //controller.endDateDummyObj.ActivityDate = controller.startDateDummyObj.ActivityDate;
        //controller.search();
        //controller.endDateDummyObj.Activity_Date__c = Date.today().addDays(1);
        //controller.search();
        
        controller.getStartDateString();
        controller.getEndDateString();
        controller.getItemsForShowBy();
        controller.getItemsForRange();
        
        
    }
}