public class MclDuplicationController {
    
    @RemoteAction
    public static List <Account> getAccountData() {

        integer recLimit;
        if(Test.isRunningTest())
            recLimit = 1;
        else
            recLimit = 9999999;

        List <Account> accountData;
        if(accountData == null) {
           accountData = [
                Select Id,Account_Group__c,Region__c,Name,Hospital_System__c
                From Account
                Where Account_Group__c In ('New Organizing','Kaiser','Hospital') and Type In ('Prospect','Employer') Order By Account_Group__c,Account.Name LIMIT :recLimit
            ];
        }
        return accountData;
    }

    @RemoteAction
    public static List <sObject> getMclData() {

        integer recLimit;
        if(Test.isRunningTest())
            recLimit = 1;
        else
            recLimit = 9999999;

        List <sObject> mclActData;
        if(mclActData == null) {
            mclActData = [
                SELECT Employer__c,Id,Name,LastModifiedDate,lastModifiedBy.Name,Employer__r.Id,Employer__r.Region__c,Employer__r.Account_Group__c, Employer__r.Name
                FROM MCL_Report__c ORDER BY Name,LastModifiedDate DESC
            ];
        }
        return mclActData;
    }

    @RemoteAction
    public static List <String> createDuplicates(ID id, String baseName, String accountIds,  Boolean srOpt, Boolean filterOpt, Boolean sortOpt) {

        Integer i,j,accountLen,recLimit;
        MCL_Report__c tmpRec;
        MCL_Sort_Entry__c tmpSortRec;
        Account tmpActRec;
        Id mclId;
        Boolean noError = true;
        String name;
        String description;

        List<String> idArray = accountIds.split(',');
        List <Account> accountData;
        List <MCL_Report__c> mclData;
        List <MCL_Report__c> mclRecordsToInsert = new List <MCL_Report__c>();
        List <Id> mclInsertedIds = new List <Id>(); 
        List <MCL_Sort_Entry__c> sortData;
        List <MCL_Sort_Entry__c> sortRecordsToInsert = new List <MCL_Sort_Entry__c>();
        List <Database.SaveResult> srList;
        List <String> errorList = new List <String>();

        if (Test.isRunningTest())
            recLimit = 1;
        else
            recLimit = 9999999;

        if (accountData == null) {
            accountData = [SELECT Id,Name FROM Account WHERE Id In :idArray ORDER BY Name LIMIT: recLimit];
            accountLen  = accountData.size();
        }

        if (mclData == null) {
            mclData = [
                SELECT Add_SOQL_Criteria__c,Bargaining_Units__c,Code_List__c,Columns__c, Coordinator__c, Departments__c,Description__c,Division__c,Employer__c,
                       Filter_Survey_Question__c,Filter_Survey_Response__c,Job_Classes__c,Map_Gamma__c,Map_Height__c,Map_Width__c,Map_Zoom_Level__c,
                       Organizer__c,Orientation__c,Page_Size__c,Prefilter_By_Current_BU__c,Prefilter_Report_Tags__c,Rows__c,Row_height__c,Sorting_Config__c,Template__c,UHW_Campaign__c,Records_with_no_responses__c
                FROM MCL_Report__c
                WHERE Id = :id
                ORDER BY LastModifiedDate DESC NULLS FIRST
                LIMIT: recLimit
                
            ];

            sortData = [
                SELECT Contact_Field_Name__c,Header__c,MCL_Report__c,Page_Break__c,Sort_Level__c,Sort_Order__c,Survey_Question__c FROM MCL_Sort_Entry__c WHERE MCL_Report__c = :id AND IsDeleted = false
            ];
            if(mclData.size() > 0 ) {
                system.debug(sortData);
            }
            else {
                system.debug('No sort data for this MCL');
            }

            if(mclData.size() > 0 ) {
                if(accountLen > 0) {
                    description = mclData[0].Description__c;
                    if(String.isEmpty(description))
                       description  = '[Created with MclDuplicator]';
                    else
                       description += '\n[Created with MclDuplicator]';

                    for(i=0;i<accountLen;i++) {
                        tmpActRec = accountData[i];
                        tmpRec = new MCL_Report__c();
                        tmpRec.Add_SOQL_Criteria__c       = mclData[0].Add_SOQL_Criteria__c;
                        tmpRec.Columns__c                 = mclData[0].Columns__c;
                        tmpRec.Description__c             = description;
                        tmpRec.Employer__c                = tmpActRec.Id;
                        tmpRec.Filter_Survey_Question__c  = mclData[0].Filter_Survey_Question__c;
                        tmpRec.Filter_Survey_Response__c  = mclData[0].Filter_Survey_Response__c;
                        tmpRec.Map_Gamma__c               = mclData[0].Map_Gamma__c;
                        tmpRec.Map_Height__c              = mclData[0].Map_Height__c;
                        tmpRec.Map_Width__c               = mclData[0].Map_Width__c;
                        tmpRec.Map_Zoom_Level__c          = mclData[0].Map_Zoom_Level__c;
                        tmpRec.Name                       = baseName + ' (' + tmpActRec.Name + ')';
                        tmpRec.Orientation__c             = mclData[0].Orientation__c;
                        tmpRec.Page_Size__c               = mclData[0].Page_Size__c;
                        tmpRec.Prefilter_By_Current_BU__c = mclData[0].Prefilter_By_Current_BU__c;
                        tmpRec.Prefilter_Report_Tags__c   = mclData[0].Prefilter_Report_Tags__c;
                        tmpRec.Rows__c                    = mclData[0].Rows__c;
                        tmpRec.Row_height__c              = mclData[0].Row_height__c;
                        tmpRec.Sorting_Config__c          = mclData[0].Sorting_Config__c;
                        tmpRec.Template__c                = mclData[0].Template__c;
                        tmpRec.UHW_Campaign__c            = mclData[0].UHW_Campaign__c;
                        if(srOpt) {
                            tmpRec.Records_with_no_responses__c = mclData[0].Records_with_no_responses__c;
                            tmpRec.Code_List__c                 = mclData[0].Code_List__c;
                        }
                        if(filterOpt) {
                            tmpRec.Job_Classes__c         = mclData[0].Job_Classes__c;
                            tmpRec.Departments__c         = mclData[0].Departments__c;
                            tmpRec.Bargaining_Units__c    = mclData[0].Bargaining_Units__c;
                        }
                        mclRecordsToInsert.add(tmpRec);
                    }
                    // ------------------------------------------------------------------------------------------- //
                    // Insert Mcl Records 
                    // ------------------------------------------------------------------------------------------- //
                    if (!mclRecordsToInsert.isEmpty()) {
                        try {
                            srList = Database.insert(mclRecordsToInsert, false);
                            for (Database.SaveResult sr : srList) {
                                if (!sr.isSuccess()) {
                                    errorList.add('Error 1:' + sr.Errors[0].StatusCode);
                                    noError = false;
                                }
                                else {
                                    mclId = sr.getId();
                                    mclInsertedIds.add(mclId);
                                }
                            }
                        }
                        catch (DmlException e) {
                            errorList.add('Error 2');
                            noError = false;
                        }

                        if(sortOpt && sortData.size() > 0) {
                            if(mclInsertedIds.size() > 0 ) {
                                for(i=0;i<mclInsertedIds.size();i++) {
                                    mclId = mclInsertedIds[i];
                                    for(j=0;j<sortData.size();j++) {
                                        tmpSortRec = new MCL_Sort_Entry__c();
                                        tmpSortRec.MCL_Report__c         = mclId;
                                        tmpSortRec.Contact_Field_Name__c = sortData[j].Contact_Field_Name__c;
                                        tmpSortRec.Header__c             = sortData[j].Header__c;
                                        tmpSortRec.Page_Break__c         = sortData[j].Page_Break__c;
                                        tmpSortRec.Sort_Level__c         = sortData[j].Sort_Level__c;
                                        tmpSortRec.Sort_Order__c         = sortData[j].Sort_Order__c;
                                        tmpSortRec.Survey_Question__c    = sortData[j].Survey_Question__c;
                                        sortRecordsToInsert.add(tmpSortRec);
                                    }
                                }
                                try {
                                    srList = Database.insert(sortRecordsToInsert, false);
                                    for (Database.SaveResult sr : srList) {
                                        if (!sr.isSuccess()) {
                                            errorList.add('Error 3:' + sr.Errors[0].StatusCode);
                                            noError = false;
                                    }
                                }
                            }
                            catch (DmlException e) {
                                errorList.add('Error 4');
                                noError = false;
                                }
                            }
                        }
                    }
                }
            }
        }
        return errorList;
    }
}