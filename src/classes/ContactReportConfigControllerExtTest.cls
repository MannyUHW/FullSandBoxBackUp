@isTest
private class ContactReportConfigControllerExtTest {
	
	private static MCL_Report__c report;
	private static Survey_Question__c surveyQuestion;

	private static List<Account> createTestContacts() {
		List<Account> testAccounts = new List<Account>();
		Account a = new Account(Name = 'Test Account 1');
		insert a;
		testAccounts.add(a);
		Contact c = new Contact(FirstName = 'Test', LastName = 'User', BU__c = 'Test1', Department = 'Test1', Title = 'Test1', AccountId = a.Id);
		insert c;
		a = new Account(Name = 'Test Account 2');
		insert a;
		testAccounts.add(a);
		c = new Contact(FirstName = 'Test2', LastName = 'User2', BU__c = 'Test2', Department = 'Test2', Title = 'Test2', AccountId = a.Id);
		insert c;
		return testAccounts;
	}

	private static void createTestReport() {
		Account a = new Account(Name = 'Test Account 1');
		insert a;
		UHW_Campaign__c campaign = new UHW_Campaign__c(name='Test Campaign');
		insert campaign;
		surveyQuestion = new Survey_Question__c(Name='test question', Description__c='Is this a test?', 
			UHW_Campaign__c=campaign.Id,Allowed_Responses__c='Yes\nNo', Survey_Code__c='000');
		insert surveyQuestion;
		report = new MCL_Report__c(name = 'Test Report', UHW_Campaign__c = campaign.Id,Columns__c=2, Employer__c=a.Id, Rows__c=8);
		insert report;
	}

	private static List<String> getAccountIds(List<Account> accounts) {
		List<String> ids = new List<String>();
		for (Account a : accounts) {
			ids.add(a.Id);
			System.debug('account ID: ' + a.Id);
		}
		return ids;
	}

	private static boolean confirmExpectedValues(List<String> actual) {
		Integer found = 0;
		System.debug('actual.size = ' + actual.size());
		for (String s : actual) {
			if (s.equals('Test1') || s.equals('Test2')) {
				found++;
			}
		}
		System.debug('found = ' + found);
		return found == 2 && actual.size() == 2;
	}
/*
	@isTest 
	static void testGetDepartmentsForEmployers() {
		List<Account> testAccts = createTestContacts();
		List<String> acctIds = getAccountIds(testAccts);
		List<String> depts = ContactReportConfigControllerExt.getDepartmentsForEmployers(acctIds);
		System.assert(confirmExpectedValues(depts));
	}
	
	@isTest 
	static void testGetJobClassesForEmployers() {
		List<String> acctIds = getAccountIds(createTestContacts());
		List<String> depts = ContactReportConfigControllerExt.getBargainingUnitsForEmployers(acctIds);
		System.assert(confirmExpectedValues(depts));		
	}

	@isTest 
	static void testGetBargainingUnitsForEmployers() {
		List<String> acctIds = getAccountIds(createTestContacts());
		List<String> depts = ContactReportConfigControllerExt.getJobClassesForEmployers(acctIds);
		System.assert(confirmExpectedValues(depts));
	}
*/
	@isTest
	static void testGetRelatedSurveyQuestions() {
		createTestReport();

        ApexPages.StandardController stdController = new ApexPages.StandardController(report);
        ContactReportConfigControllerExt controller = new ContactReportConfigControllerExt(stdController);

        List<Survey_Question__c> questions = controller.getRelatedSurveyQuestions();
        System.assert(questions != null && questions.size() == 1);


        // ApexPages.currentPage().setParameter('');
	}

	@isTest
	static void testSaveFilters() {
		createTestReport();

        ApexPages.StandardController stdController = new ApexPages.StandardController(report);
        ContactReportConfigControllerExt controller = new ContactReportConfigControllerExt(stdController);

        Apexpages.currentPage().getParameters().put('selectedBargainingUnits', 'abc');
        Apexpages.currentPage().getParameters().put('selectedJobClasses', 'abc');
        Apexpages.currentPage().getParameters().put('selectedDepartments', 'abc');
        Apexpages.currentPage().getParameters().put('filterSurveyQuestion', surveyQuestion.Id);
        Apexpages.currentPage().getParameters().put('filterSurveyResponse', 'abc');

		System.assertEquals(controller.saveFilters(), null);
        System.assertEquals(controller.getSaveFiltersError(), '');

		MCL_Report__C rep = [Select Id, Employer__c, Template__c, UHW_Campaign__c, Columns__c, 
            Description__c, Orientation__c, Page_Size__c, Bargaining_Units__c, Job_Classes__c, Departments__c,
            Filter_Survey_Question__c, Filter_Survey_Response__c, Sorting_Config__c
            from MCL_Report__C where id = :report.Id];
		System.assertEquals(rep.Bargaining_Units__c, 'abc');
		System.assertEquals(rep.Job_Classes__c, 'abc');
		System.assertEquals(rep.Departments__c, 'abc');
		System.assertEquals(rep.Filter_Survey_Question__c, surveyQuestion.Id);
		System.assertEquals(rep.Filter_Survey_Response__c, 'abc');
	}

	@isTest 
	static void testSaveTemplate() {
		createTestReport();

        ApexPages.StandardController stdController = new ApexPages.StandardController(report);
        ContactReportConfigControllerExt controller = new ContactReportConfigControllerExt(stdController);

        controller.setTemplateContents('String contents');
        System.assertEquals(controller.saveTemplate(), null);
        System.assertEquals(controller.getSaveTemplateError(), '');
        System.assertEquals(controller.getSaveTemplateStatus(), true);
		MCL_Report__C rep = [Select Id, Employer__c, Template__c, UHW_Campaign__c, Columns__c, 
            Description__c, Orientation__c, Page_Size__c, Bargaining_Units__c, Job_Classes__c, Departments__c,
            Filter_Survey_Question__c, Filter_Survey_Response__c, Sorting_Config__c
            from MCL_Report__C where id = :report.Id];
        System.assertEquals(rep.Template__c, controller.getTemplateContents());

	}


}