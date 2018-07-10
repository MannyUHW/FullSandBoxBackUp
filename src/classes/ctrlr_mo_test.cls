@isTest
public class ctrlr_mo_test {
    private static Account getTestDataAcct(){    
        // return test account data
        Account em = new Account(name='Test Employer',Account_Group__c='Hospital');
        return em;        
    }
    private static Contact getTestDataContact(){
        //return test contact data
        return new Contact(firstname='Test',lastname='Contact 1',X80_P7_Active__c = false,FID__c='007' );
    }
    private static void setupTestDataSurveyQuestions(){        
        //setup sq (PR1 code for BatchUpdateP7 test)
        UHW_Campaign__c camp = new UHW_Campaign__c();
        insert camp;
        Survey_Question__c sq = new Survey_Question__c(Survey_Code__c = 'PR1',Description__c='test', UHW_Campaign__c=camp.Id);
        insert sq;
        Contact c = getTestDataContact();
        insert c;
        Survey_Response__c sr = new Survey_Response__c(Survey_Question__c = sq.Id,Contact__c = c.Id);
        insert sr;
    }
    static testMethod void TestMOCtrlr(){
        //include test data        
        insert getTestDataAcct();
        //initialize ctrlr class
        ctrlr_mo mo = new ctrlr_mo();
        //use class method for quick and small queries
        List<Contact> lmttwo_cons = ctrlr_mo.getData('Select Id From Contact Limit 2');
        //use class method for larger queries in progression (javascript remoting batch method)
        string hos_query = 'Select Id From Account Where Account_Group__c = \'Hospital\'';
        List<Account> hosptl_emps = ctrlr_mo.getRecords(null,hos_query);
        List<Account> hosptl_emps_withId = ctrlr_mo.getRecords(hosptl_emps[0].Id,hos_query);
    }
    static testMethod void TestP7BatchUpdate(){
        setupTestDataSurveyQuestions();
        BatchUpdateP7 dailyActive = new BatchUpdateP7();
        BatchUpdateP7.scheduleMe();
    }
}