@isTest (seeAllData=true) private class SOFA_Controller_Test  {

    @isTest static void test1() {
        System.debug('test1() start');
        String res1;
        res1 = SOFA_Controller.verifySoql('Account', 'Account_Group__c = \'Kaiser\' ');
        System.AssertEquals(res1,'SOQL OK');        
        System.debug('test1() end');
    }


    @isTest static void test2() {
        System.debug('test2() start');

        SOFA_Controller.ResultsRecord res1;
        List<String> fieldList = new List<String>();
        String objectName = 'Common_Settings__c';
        fieldList.add('HospitalCode__c');
        fieldList.add('Name');
        res1 = SOFA_Controller.createJob(objectName,fieldList);
        System.debug(res1);

        System.debug('test2() end');
    }

    @isTest static void test3() {
        System.debug('test3() start');
        Map<String, SOFA_Job__c>     res1;
        Map<String, SOFA_JobItem__c> res2;

        res1 = SOFA_Controller.getJobData();
        System.AssertNotEquals(res1.size(),0);      

        res2 = SOFA_Controller.getJobItemData();
        System.AssertNotEquals(res2.size(),0);      

        System.debug('test3() end');
    }

    @isTest static void test4() {
        System.debug('test4() start');

        List<SOFA_Controller.GlobalObjectRecord> res1;
        res1 = SOFA_Controller.getObjects();
        System.AssertNotEquals(res1.size(),0);

        System.debug('test4() end');
    }

}