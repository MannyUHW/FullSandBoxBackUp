@isTest
private class MCLReportCloneExtensionTest {
	

	private static UHW_Campaign__c createTestCampaign() {
		UHW_Campaign__c campaign = new UHW_Campaign__c(name='Test Campaign');
		insert campaign;
		return campaign;
	}

	private static Account createTestAccount() {
		Account a = new Account(Name = 'Test Account 1');
		insert a;
		return a;
	}

	private static Survey_Question__c createTestQuestion(UHW_Campaign__c campaign) {
		Survey_Question__c surveyQuestion = new Survey_Question__c(Name='test question', Description__c='Is this a test?', 
			UHW_Campaign__c=campaign.Id,Allowed_Responses__c='Yes\nNo', Survey_Code__c='000');
		insert surveyQuestion;
		return surveyQuestion;		
	}

	private static MCL_Report__c createTestReport(Account account, UHW_Campaign__c campaign) {
		MCL_Report__c report = new MCL_Report__c(name = 'Test Report', UHW_Campaign__c = campaign.Id,Columns__c=2, Employer__c=account.Id, Rows__c=8);
		insert report;
		return report;
	}

	private static MCL_Report__c queryReport(String reportId) {
		return [SELECT Name, UHW_Campaign__c,Columns__c,Employer__c,Rows__c,
			(Select Name, Contact_Field_Name__c, Header__c, Survey_Question__c, 
				Survey_Question__r.Name, Survey_Question__r.Description__c,
                MCL_Report__c, Page_Break__c, Sort_Level__c, Sort_Order__c from MCL_Sort_Entries__r)
			FROM MCL_Report__c where ID = :reportId];
	}
	
	private static String customClone(MCL_Report__c report) {
        ApexPages.StandardController stdController = new ApexPages.StandardController(report);
        MCLReportCloneExtension extension = new MCLReportCloneExtension(stdController);
        PageReference ref = extension.cloneReport();
        return ref.getUrl().substringAfter('/');
	}

	@isTest static void testCloneWithFieldSortEntry() {
		Account a = createTestAccount();
		UHW_Campaign__c campaign = createTestCampaign();
		MCL_Report__c report = createTestReport(a, campaign);
		MCL_Sort_Entry__c sortEntry = new MCL_Sort_Entry__c(Contact_Field_Name__c = 'Name', Header__c = false, 
                MCL_Report__c = report.Id, Page_Break__c = true, Sort_Level__c = 1, Sort_Order__c = 'Asc');
		insert sortEntry;

		customClone(report);

		MCL_Report__c cloned = queryReport(report.Id);
		System.assert(cloned != null && cloned.MCL_Sort_Entries__r.size() == 1 
			&& cloned.MCL_Sort_Entries__r[0].Contact_Field_Name__c == 'Name');
	}

	@isTest static void testCloneWithQuestionSortEntry() {
		Account a = createTestAccount();
		UHW_Campaign__c campaign = createTestCampaign();
		MCL_Report__c report = createTestReport(a, campaign);
		Survey_Question__c q = createTestQuestion(campaign);
		MCL_Sort_Entry__c sortEntry = new MCL_Sort_Entry__c(Survey_Question__c = q.Id, Header__c = false, 
                MCL_Report__c = report.Id, Page_Break__c = true, Sort_Level__c = 1, Sort_Order__c = 'Asc');
		insert sortEntry;

		customClone(report);

		MCL_Report__c cloned = queryReport(report.Id);
		System.assert(cloned != null && cloned.MCL_Sort_Entries__r.size() == 1 
			&& cloned.MCL_Sort_Entries__r[0].Survey_Question__r.Name == 'test question');
	}


	@isTest static void testCloneWithoutSortEntries() {
		// Implement test code
	}
	
}