public with sharing class MCLReportCloneExtension {

    private  MCL_Report__c report;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public MCLReportCloneExtension(ApexPages.StandardController stdController) {
        this.report = (MCL_Report__c)stdController.getRecord();
    }

    public PageReference cloneReport() {
        //Variable to hold the new record
        MCL_Report__c newReport;
        Savepoint sp = Database.setSavepoint();
        try {
            report = [Select Id, Name, Employer__c, Employer__r.Name, Template__c, 
            UHW_Campaign__c, UHW_Campaign__r.Name, Columns__c, Rows__c, 
            Description__c, Orientation__c, Page_Size__c, Bargaining_Units__c,
            Filter_Survey_Question__c, Filter_Survey_Response__c, Sorting_Config__c, Row_Height__c, 
            Filter_Survey_Question__R.Name, Map_Zoom_Level__c, Map_Gamma__c, Add_SOQL_Criteria__c, Code_List__c, Records_with_no_responses__c, 
            Prefilter_By_Current_BU__c, Prefilter_Report_Tags__c             
            from MCL_Report__c where id =:report.id];
            newReport = report.clone(false);
            newReport.Name = newReport.Name + ' - CLONED';
            insert newReport;
            
            List<MCL_Sort_Entry__c> newSortEntries = new List<MCL_Sort_Entry__c>();
            for( MCL_Sort_Entry__c  sortEntry : [SELECT Name, Contact_Field_Name__c, Header__c, 
                MCL_Report__c, Page_Break__c, Sort_Level__c, Sort_Order__c, Survey_Question__c 
                FROM MCL_Sort_Entry__c WHERE MCL_Report__c =:report.id]) {
                 MCL_Sort_Entry__C newSortEntry = sortEntry.clone(false);
                 newSortEntry.MCL_Report__c = newReport.id;
                 newSortEntries.add(newSortEntry);
            }
            insert newSortEntries;
        }
        catch(Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/'+newReport.id);
    }

}