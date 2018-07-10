global with sharing class ContactReportConfigControllerExt {

    private final MCL_Report__c reportConfig;

    private String templateContents;
    private boolean saveTemplateStatus = true;
    private String saveTemplateError = '';
    private String saveFiltersError = '';

    public ContactReportConfigControllerExt(ApexPages.StandardController stdController) {
        Id recId = stdController.getRecord().Id;
        System.debug('recId = ' + recId);
        this.reportConfig = (MCL_Report__c)[Select Id, Employer__c, Template__c, UHW_Campaign__c, Columns__c, 
         Description__c, Orientation__c, Page_Size__c, Bargaining_Units__c, Job_Classes__c, Departments__c,
         Filter_Survey_Question__c, Filter_Survey_Response__c, Sorting_Config__c, Code_List__c, Records_with_no_responses__c
         from MCL_Report__C where id = :recId];
        this.templateContents = this.reportConfig.Template__c;
    }

    public List<Survey_Question__c> getRelatedSurveyQuestions() {
        Id campaignId = this.reportConfig.UHW_Campaign__c;
        Survey_Question__c[] questions = [SELECT Id, Survey_Code__c, Description__c, Allowed_Responses__c 
            FROM Survey_Question__c 
            WHERE UHW_Campaign__c = :campaignId];
        for (Survey_Question__c q : questions) {
            q.Allowed_Responses__c = q.Allowed_Responses__c.replaceAll('\r\n', ',');
        }
        /*
        and (UHW_Campaign__r.End_date__C = null or UHW_Campaign__r.End_date__C >= TODAY)
        and (UHW_Campaign__r.Start_Date__C = null or UHW_Campaign__r.Start_Date__c <= TODAY)];
        */
        return questions;
    }

    public List<MCL_Sort_Entry__c> getSortFields() {
        return [Select Id, Name, Contact_Field_Name__c, MCL_Report__c,
            Page_Break__c, Header__c, Sort_Order__c, Sort_Level__c, Survey_Question__c 
            from MCL_Sort_Entry__c 
            where MCL_Report__c = :reportConfig.Id order by Sort_Level__c asc];
    }

/*

    public List<String> getAllBargainingUnits() {
        List<String> values = new List<String>();
        values.add('null');
        AggregateResult[] agRes = [Select BU__c from Contact where AccountId = :this.reportConfig.Employer__c GROUP BY BU__c];
        for (AggregateResult res : agRes)  {
            String bu = (String)res.get('BU__c');
            if (bu != null) {
                values.add(bu);
            }
        }
        return values;
    }

    public List<String> getAllJobClasses() {
        List<String> values = new List<String>();
        values.add('null');
        AggregateResult[] agRes = [Select Title from Contact where AccountId = :this.reportConfig.Employer__c GROUP BY Title];
        for (AggregateResult res : agRes)  {
            String title = (String)res.get('Title');
            if (title != null) {
                values.add(title);
            }
        }
        return values;
    }

    public List<String> getAllDepartments() {
        List<String> values = new List<String>();
        values.add('null');
        AggregateResult[] agRes = [Select Department from Contact where AccountId = :this.reportConfig.Employer__c GROUP BY Department];
        for (AggregateResult res : agRes)  {
            String dept = (String)res.get('Department');
            if (dept != null) {
                values.add(dept);
            }
        }
        return values;
    }

*/

/*
    public List<SelectOption> getBargainingUnitOptions() {
        Id accountId = this.reportConfig.Employer__c;
        List<SelectOption> values = new List<SelectOption>();
        AggregateResult[] agRes = [Select BU__c from Contact where AccountId = :accountId GROUP BY BU__c];
        for (AggregateResult res : agRes)  {
            String bu = (String)res.get('BU__c');
            if (bu != null) {
                values.add(new SelectOption(bu, bu));
            }
        }
        System.debug('returning ' + values.size() + ' bargaining unit options');
        return values;
    }

    public List<SelectOption> getJobClassOptions() {
        Id accountId = this.reportConfig.Employer__c;
        List<SelectOption> values = new List<SelectOption>();
        AggregateResult[] agRes = [Select Title from Contact where AccountId = :accountId GROUP BY Title];
        for (AggregateResult res : agRes)  {
            String title = (String)res.get('Title');
            if (title != null) {
                values.add(new SelectOption(title, title));
            }
        }
        return values;
    }

    public List<SelectOption> getDepartmentOptions() {
        Id accountId = this.reportConfig.Employer__c;
        List<SelectOption> values = new List<SelectOption>();
        AggregateResult[] agRes = [Select Department from Contact where AccountId = :accountId GROUP BY Department];
        for (AggregateResult res : agRes)  {
            String dept = (String)res.get('Department');
            if (dept != null) {
                values.add(new SelectOption(dept, dept));
            }
        }
        return values;
    }

    public void setSelectedBargainingUnits(String[] buList) {
        this.selectedBargainingUnits = buList;
    }
    public String[] getSelectedBargainingUnits() {
        return this.selectedBargainingUnits;
    }

    public void setSelectedJobClasses(String[] jcList) {
        this.selectedJobClasses = jcList;
    }
    public String[] getSelectedJobClasses() {
        return this.selectedJobClasses;
    }

    public void setSelectedDepartments(String[] deptList) {
        this.selectedDepartments = deptList;
    }
    public String[] getSelectedDepartments() {
        return this.selectedDepartments;
    }
    */

    public MCL_Report__c getReportConfig() {
        return this.reportConfig;
    }

    /**
    * Save report filter configuration.
    * Called via <apex:actionFunction> tag in VF page
    */
    public PageReference saveFilters() {
        this.reportConfig.Bargaining_Units__c = Apexpages.currentPage().getParameters().get('selectedBargainingUnits');
        this.reportConfig.Job_Classes__c = Apexpages.currentPage().getParameters().get('selectedJobClasses');
        this.reportConfig.Departments__c = Apexpages.currentPage().getParameters().get('selectedDepartments');
        String questionId = Apexpages.currentPage().getParameters().get('filterSurveyQuestion');
        String response = Apexpages.currentPage().getParameters().get('filterSurveyResponse');
        this.reportConfig.Filter_Survey_Question__c = questionId == null || questionId.equals('') ? null : questionId;
        this.reportConfig.Filter_Survey_Response__c = response == null || response.equals('') ? null : response;
        try {
            update this.reportConfig;
            saveFiltersError = '';
        } catch (Exception e) {
            this.saveFiltersError = e.getMessage();
        }
        return null;
    }

    public String getSaveFiltersError() {
        return this.saveFiltersError;
    }
    public String getTemplateContents() {
        return this.templateContents;
    }
    public void setTemplateContents(String contents) {
        this.templateContents = contents;
    }
    public boolean getSaveTemplateStatus() {
        return this.saveTemplateStatus;
    }
    public void setSaveTemplateStatus(boolean status) {
        this.saveTemplateStatus = status;
    }
    public String getSaveTemplateError() {
        return this.saveTemplateError;
    }

    /**
     * Save the contact record template.
     * Called via <apex:actionFunction> tag in VF page.
     */
    public PageReference saveTemplate() {
        // String newContents = Apexpages.currentPage().getParameters().get('templateContents');
        this.reportConfig.Template__c = this.templateContents;
        try {
            update this.reportConfig;
            this.saveTemplateStatus = true;
        } catch (Exception e) {
            this.saveTemplateStatus = false;
            this.saveTemplateError = e.getMessage();
        }
        return null;
    }

/*
    @RemoteAction
    global static List<String> getBargainingUnitsForEmployers(List<String> accountIds) {
        List<String> values = new List<String>();
        AggregateResult[] agRes = [Select BU__c from Contact where AccountId in :accountIds GROUP BY BU__c];
        for (AggregateResult res : agRes)  {
            values.add((String)res.get('BU__c'));
        }
        return values;
    }

    @RemoteAction
    global static List<String> getDepartmentsForEmployers(List<Id> accountIds) {
        System.debug('Searching for contacts related to accounts');
        List<String> values = new List<String>();
        List<AggregateResult> results = [Select Department from Contact where AccountId in :accountIds GROUP BY Department];
        System.debug('Aggregate query returned ' + results.size() + ' records');
        for (AggregateResult res : results) {
            values.add((String)res.get('Department'));
        }
        return values;
    }

    @RemoteAction
    global static List<String> getJobClassesForEmployers(List<String> accountIds) {
        List<String> values = new List<String>();
        for (AggregateResult res : [Select Title from Contact where AccountId in :accountIds GROUP BY Title]) {
            values.add((String)res.get('Title'));
         }
         return values;
    }

*/

}