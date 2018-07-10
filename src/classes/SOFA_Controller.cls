public class SOFA_Controller {

    public class ResultsRecord {
        String   ResStatus;
        String[] ResErrors;
        private ResultsRecord(String pStatus, String[] pErrors) {
            ResStatus = pStatus;
            ResErrors = pErrors;
        }
    }

    public class GlobalObjectRecord {
        Boolean ObjectIsCustom,ObjectIsCreatable,ObjectIsQueryable;
        String ObjectName,ObjectAPIName;
        
        public GlobalObjectRecord(String pObjectName, String pObjectAPIName, Boolean pObjectIsCustom, Boolean pObjectIsCreatable, Boolean pObjectIsQueryable)
        {
            ObjectName        = pObjectName;
            ObjectAPIName     = pObjectAPIName;
            ObjectIsCustom    = pObjectIsCustom;
            ObjectIsCreatable = pObjectIsCreatable;
            ObjectIsQueryable = pObjectIsQueryable;
        }
    }

    public class FieldDescribeRecord {
        Boolean FieldIsCalculated,FieldIsCustom,FieldIsCreatable,FieldIsFilterable,FieldIsUpdateable;
        String ObjectAPIName,FieldName,FieldAPIName,FieldFormula,FieldType;
        Integer FieldLength;
        
        public FieldDescribeRecord(String pObjectAPIName, String pFieldName, String pFieldAPIName, String pFieldFormula, String pFieldType, Integer pFieldLength, Boolean pFieldIsCalculated, Boolean pFieldIsCustom, Boolean pFieldIsCreatable, Boolean pFieldIsFilterable, Boolean pFieldIsUpdateable)
        {
            ObjectAPIName     = pObjectAPIName;
            FieldName         = pFieldName;
            FieldAPIName      = pFieldAPIName;
            FieldFormula      = pFieldFormula;
            FieldType         = pFieldType;
            FieldLength       = pFieldLength;
            FieldIsCalculated = pFieldIsCalculated;
            FieldIsCustom     = pFieldIsCustom;
            FieldIsCreatable  = pFieldIsCreatable;
            FieldIsFilterable = pFieldIsFilterable;
            FieldIsUpdateable = pFieldIsUpdateable;
        }
    }

    @RemoteAction
    public static string verifySoql(String pObjectAPIName, String pSoql) {

        String query = 'SELECT Id FROM ' + pObjectAPIName + ' WHERE '  + pSoql + ' LIMIT 1';
        System.debug(pObjectAPIName);
        System.debug(pSoql);
        System.debug(query);

        String retVal = 'SOQL OK';
        String[] errLines;
        String errMessages;
        Object testOK;

        try {
            Database.QueryLocator          q = Database.getQueryLocator(query);
            Database.QueryLocatorIterator it =  q.iterator();
            if(it.hasNext()) {
                testOK = it.next();
                System.debug(testOK);
            }
        }
        catch(Exception e) {
            errMessages = e.getMessage();
            errLines    = errMessages.split('\\.');
            if(errLines.size() > 0) {
                retVal = errLines[0];
            }
        }

        return retVal;
    }

    @RemoteAction
    public static string startJob() {

        String sofaJobItemId,sofaJobId, objectAPIName,fieldAPIName;
        SOFA_Job__c sofaJob;
        List <SOFA_Job__c> existingJob;
        List<SOFA_JobItem__c> jobItems = [SELECT Id, ObjectAPIName__c, FieldAPIName__c , SOFA_JobId__c
                                          FROM SOFA_JobItem__c 
                                          WHERE (FieldType__c Not IN ('ADDRESS','LOCATION','TEXTAREA')) AND FieldIsFilterable__c = true AND JobStatus__c = 'Queued' LIMIT 1];
        if(jobItems.size() == 0) {
            System.debug('All fields counted');
        } else {
            sofaJobItemId = jobItems[0].Id;
            sofaJobId     = jobItems[0].SOFA_JobId__c;
            objectAPIName = jobItems[0].ObjectAPIName__c;
            fieldAPIName  = jobItems[0].FieldAPIName__c;
            System.debug('SOFA_Controller : startJob...making batch call');
            Database.executeBatch(new SOFA_BatchCount(sofaJobId,objectAPIName,fieldAPIName,sofaJobItemId), 2000);   
        }
        System.debug('SOFA_Controller : startJob Finished');
        return objectAPIName + ':' + fieldAPIName;
    }

    @RemoteAction
    public static ResultsRecord createJob(String pObjectAPIName,List<String> pFieldArray) {

        Database.SaveResult saveRes;
        List <SOFA_Job__c> existingJob;
        List <SOFA_JobItem__c> existingJobItems;
        List <Database.SaveResult> srList;
        List <String> errorList;
        List<SOFA_JobItem__c> sofaJobItemsToUpdate;
        Map <String,String> existingJobItemsMap;
        Map <String,Boolean> selectedFieldMap;
        Set<String> existingJobItemsSet;
        SOFA_JobItem__c rec;
        SOFA_JobItem__c sofaJobItem;
        Boolean noError, objectIsCustom,objectIsCreatable,objectIsQueryable;
        String objectName,objectAPIName,jobStartStatus = '';
        Integer i,len,successCount;
        String SOFA_JobId;
        String fieldAPIName,fieldType;
        Integer myCount = 0;

        List<SOFA_JobItem__c> sofaJobItemsToAdd = new List<SOFA_JobItem__c>();
        FieldDescribeRecord[] objectFieldList   = getObjectFields(pObjectAPIName);

        sofaJobItemsToUpdate = new List<SOFA_JobItem__c>();
        existingJobItemsMap  = new Map<String,String>();
        existingJobItemsSet  = new Set<String>();
        selectedFieldMap     = new Map <String,Boolean>();

        errorList = new List <String>();
        noError   = true;

        SOFA_Job__c sofaJob = new SOFA_Job__c();

        System.debug('---------------------------------------------------------------------------');
        System.debug(pFieldArray);
        System.debug('---------------------------------------------------------------------------');
        len = pFieldArray.size();
        for(i=0;i<len;i++) {
            fieldAPIName = pFieldArray[i];
            selectedFieldMap.put(fieldAPIName,true);
        }

        existingJob = [SELECT Id FROM SOFA_Job__c WHERE ObjectAPIName__c = :pObjectAPIName];        
        if(existingJob.size() > 0) {
            System.debug('existingJob.size(): ' + existingJob.size() );
            sofaJob.Id = existingJob[0].Id;
            // ------------------------------------------------------------------------------------------- //
            // Delete SOFA_Job__c record (need new Id, as that is used to relate Items.)
            // ------------------------------------------------------------------------------------------- //
            try {
                Delete sofaJob;
                System.debug('existing SOFA_Job__c record deleted. ');
            } catch(Exception e) {
                noError = false;
                System.debug('Error deleting SOFA_Job__c record. ' + e.getMessage());
                errorList.add('Error 1:' + e.getMessage());
            }
        }

        sofaJob.Id                = null;
        sofaJob.CountStart__c     = System.Now();
        sofaJob.JobStatus__c      = 'Started';
        sofaJob.ObjectAPIName__c  = pObjectAPIName;
        sofaJob.Soql__c           = '';

        // ------------------------------------------------------------------------------------------- //
        // Create SOFA_Job__c record
        // ------------------------------------------------------------------------------------------- //
        try {
            saveRes = Database.insert(sofaJob, false);
            SOFA_JobId = saveRes.getId();
            System.debug('  ***************************************************************** SOFA_JobId ');
            System.debug('SOFA_Job__c record created with ID: ' + SOFA_JobId);
        } catch(Exception e) {
            noError = false;
            System.debug('Error creating SOFA_Job__c record. ' + e.getMessage());
            errorList.add('Error 2:' + e.getMessage());
        }

        existingJobItems = [SELECT Id, SOFA_JobId__c, ObjectAPIName__c, FieldAPIName__c, CountStart__c, CountStop__c, Count__c, JobErrors__c, JobId__c, JobItemsTotal__c, JobItems__c, JobStatus__c 
                            FROM SOFA_JobItem__c  WHERE ObjectAPIName__c = :pObjectAPIName];
        len = existingJobItems.size();
        if(len > 0) {
            System.debug('existing JobItems found:');            
            for(i=0;i<len;i++) {
                rec = existingJobItems[i];
                fieldAPIName = rec.FieldAPIName__c;
                if(selectedFieldMap.containsKey(fieldAPIName)) {
                    sofaJobItem = new SOFA_JobItem__c();
                    sofaJobItem.Id               = rec.Id;
                    sofaJobItem.FieldAPIName__c  = rec.FieldAPIName__c;
                    sofaJobItem.JobStatus__c     = 'Queued';
                    sofaJobItem.CountStart__c    = null;
                    sofaJobItem.CountStop__c     = null;
                    sofaJobItem.Count__c         = null;
                    sofaJobItem.JobErrors__c     = null; 
                    sofaJobItem.JobId__c         = null;
                    sofaJobItem.JobItemsTotal__c = null;
                    sofaJobItem.JobItems__c      = null;
                    sofaJobItem.SOFA_JobId__c    = SOFA_JobId;
                    sofaJobItemsToUpdate.add(sofaJobItem);
                    existingJobItemsSet.add(rec.FieldAPIName__c);
                }
            }
            // ------------------------------------------------------------------------------------------- //
            // Update SOFA_JobItem__c records
            // ------------------------------------------------------------------------------------------- //
            successCount = 0;
            if (noError && !sofaJobItemsToUpdate.isEmpty()) {
                try {
                srList = Database.update(sofaJobItemsToUpdate, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        errorList.add('Error 3:' + sr.Errors[0].StatusCode);
                        noError = false;
                    } else {
                        successCount++;
                    }
                }
                System.debug( successCount + ' out of ' + sofaJobItemsToUpdate.size() + ' SOFA_JobItem__c records updated. ');
            }
            catch (DmlException e) {errorList.add('Error 4');noError = false;}
            }
        }
        else {
            System.debug('****** NO existing JobItems found:'); 
        }

        for(FieldDescribeRecord record : objectFieldList) {
            fieldAPIName = record.FieldAPIName;
            if(selectedFieldMap.containsKey(fieldAPIName)) {
                myCount++;
                System.debug('myCount: ' + myCount);
                fieldType    = record.FieldType;
                System.debug('fieldAPIName: ' + fieldAPIName);
                if(existingJobItemsSet.contains(fieldAPIName)) {
                    System.debug(fieldAPIName + ' skipping, should have been updated in SOFA_JobItem__c');
                } 
                else {
                    if(fieldType != 'ADDRESS' && fieldType != 'LOCATION' && fieldType != 'TEXTAREA') {
                        System.debug(fieldAPIName + ' will be inserted into SOFA_JobItem__c');
                        sofaJobItem = new SOFA_JobItem__c();
                        sofaJobItem.SOFA_JobId__c        = SOFA_JobId;
                        sofaJobItem.JobStatus__c         = 'Queued';
                        sofaJobItem.ObjectAPIName__c     = pObjectAPIName;
                        sofaJobItem.FieldAPIName__c      = fieldAPIName;
                        sofaJobItem.FieldType__c         = record.FieldType;                                 
                        sofaJobItem.FieldName__c         = record.FieldName;
                        sofaJobItem.FieldFormula__c      = record.FieldFormula;
                        sofaJobItem.FieldLength__c       = record.FieldLength;       
                        sofaJobItem.FieldIsCalculated__c = record.FieldIsCalculated; 
                        sofaJobItem.FieldIsCustom__c     = record.FieldIsCustom;     
                        sofaJobItem.FieldIsCreatable__c  = record.FieldIsCreatable;  
                        sofaJobItem.FieldIsFilterable__c = record.FieldIsFilterable; 
                        sofaJobItem.FieldIsUpdateable__c = record.FieldIsUpdateable; 
                        sofaJobItemsToAdd.add(sofaJobItem);
                    }
                    else {
                        System.debug(fieldType + ' will be skipped, as it cannot be queried.');
                    }
                }
            }
        }
        // ------------------------------------------------------------------------------------------- //
        // Create SOFA_JobItem__c records
        // ------------------------------------------------------------------------------------------- //
        successCount = 0;
        if (noError && !sofaJobItemsToAdd.isEmpty()) {
            try {
                srList = Database.insert(sofaJobItemsToAdd, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        errorList.add('Error 5:' + sr.Errors[0].StatusCode);
                        noError = false;
                    } else {
                        successCount++;
                    }
                }
                System.debug( successCount + ' out of ' + sofaJobItemsToAdd.size() + ' SOFA_JobItem__c records created. ');
            }
            catch (DmlException e) {errorList.add('Error 6');noError = false;}
        }

        // ------------------------------------------------------------------------------------------- //
        // Start batch jobs
        // ------------------------------------------------------------------------------------------- //
        if (noError)
            jobStartStatus = startJob(); // pObjectAPIName

        ResultsRecord result = new ResultsRecord(jobStartStatus, errorList);
        return result;
     }

    @RemoteAction
    public static Map<String, SOFA_Job__c> getJobData() {

        integer recLimit,i,l;
        SOFA_Job__c rec, sofaJob;
        Map<String, SOFA_Job__c> sofaJobMap = new Map<String, SOFA_Job__c>();

        if(Test.isRunningTest())
            recLimit = 2;
        else
            recLimit = 9999999;

        for (list <SOFA_Job__c> dataList : [
             SELECT Id, ObjectAPIName__c, Soql__c,JobStart__c,JobStatus__c,JobStop__c
             FROM SOFA_Job__c 
             ORDER BY ObjectAPIName__c ASC LIMIT :recLimit]) {
             l = dataList.size();
             for(i=0;i<l;i++) {
                rec = dataList[i];
                sofaJob = new SOFA_Job__c();
                sofaJob.Id                    = rec.Id;
                sofaJob.ObjectAPIName__c      = rec.ObjectAPIName__c;
                sofaJob.Soql__c               = rec.Soql__c;
                sofaJob.JobStart__c           = rec.JobStart__c;
                sofaJob.JobStatus__c          = rec.JobStatus__c;
                sofaJob.JobStop__c            = rec.JobStop__c;
                sofaJobMap.put(rec.ObjectAPIName__c,sofaJob);
            }
        }
        return sofaJobMap;
    }

    @RemoteAction
    public static Map<String, SOFA_JobItem__c>  getJobItemData() {

        integer recLimit,i,l;
        SOFA_JobItem__c rec, sofaJobItem;
        Map<String, SOFA_JobItem__c> sofaJobItemMap = new Map<String, SOFA_JobItem__c>();

        if(Test.isRunningTest())
            recLimit = 2;
        else
            recLimit = 9999999;

        for (list <SOFA_JobItem__c> dataList : [
             SELECT Id, SOFA_JobId__c, ObjectAPIName__c, FieldAPIName__c, CountStart__c, CountStop__c, Count__c, JobErrors__c, JobId__c, JobItemsTotal__c, JobItems__c, JobStatus__c 
             FROM SOFA_JobItem__c 
             ORDER BY FieldIsFilterable__c ASC NULLS FIRST, ObjectAPIName__c , FieldAPIName__c LIMIT :recLimit]) {
             l = dataList.size();
             for(i=0;i<l;i++) {
                 rec = dataList[i];
                 sofaJobItem = new SOFA_JobItem__c();
                 sofaJobItem.Id               = rec.Id;
                 sofaJobItem.SOFA_JobId__c    = rec.SOFA_JobId__c;
                 sofaJobItem.ObjectAPIName__c = rec.ObjectAPIName__c;
                 sofaJobItem.FieldAPIName__c  = rec.FieldAPIName__c;
                 sofaJobItem.CountStart__c    = rec.CountStart__c;
                 sofaJobItem.CountStop__c     = rec.CountStop__c;
                 sofaJobItem.Count__c         = rec.Count__c;
                 sofaJobItem.JobErrors__c     = rec.JobErrors__c;
                 sofaJobItem.JobId__c         = rec.JobId__c;
                 sofaJobItem.JobItemsTotal__c = rec.JobItemsTotal__c;
                 sofaJobItem.JobItems__c      = rec.JobItems__c;
                 sofaJobItem.JobStatus__c     = rec.JobStatus__c;
                 sofaJobItemMap.put(rec.FieldAPIName__c,sofaJobItem);
             }
         }
        return sofaJobItemMap;
    }

    @RemoteAction
    public static GlobalObjectRecord[] getObjects() {
        GlobalObjectRecord record;
        List<GlobalObjectRecord> records = new List<GlobalObjectRecord>();
        Boolean objectIsCustom,objectIsCreatable,objectIsQueryable;
        String objectName,objectAPIName;

        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (Schema.SObjectType obj : gd.values()){
            objectName        = obj.getDescribe().getLabel();
            objectAPIName     = obj.getDescribe().getName();
            objectIsCustom    = obj.getDescribe().isCustom();
            objectIsCreatable = obj.getDescribe().isCreateable();
            objectIsQueryable = obj.getDescribe().isQueryable();
            record            = new GlobalObjectRecord(objectName,objectAPIName,objectIsCustom,objectIsCreatable,objectIsQueryable);
            records.add(record);
        }
        return records;
     }

    @RemoteAction
    public static FieldDescribeRecord[] getObjectFields(String pObjectAPIName) {
        Boolean fieldIsCalculated,fieldIsCustom,fieldIsCreateable,fieldIsFilterable,fieldIsUpdateable;
        String fieldName,fieldAPIName,fieldFormula,formulaOrPicklist,fieldTypeStr;
        String regExp,replacement,s;
        Integer fieldLength;
        Schema.DisplayType fieldType;
        Boolean picklistUsed;
        regExp = '&amp;';
        replacement = '&';

        Set<String> excludeSet = new Set<String>{'CreatedDate','CreatedById','LastModifiedDate','LastModifiedById','SystemModstamp','LastViewedDate','LastReferencedDate'};

        List<FieldDescribeRecord> fieldDescribeList = new List<FieldDescribeRecord>();
        FieldDescribeRecord record;

        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        // Get the token for the sobject based on the type.

        Schema.SObjectType st = gd.get(pObjectAPIName);

        // Instantiate the sobject from the token.
        Sobject objectToDescribe = st.newSobject();
        // see https://salesforce.stackexchange.com/questions/48019/how-to-get-the-runtime-type-of-an-object-dynamically-for-primitive-data-types-a
        Map<String,Schema.SObjectField> fieldMap = ((SObject)objectToDescribe).getSObjectType().getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.describefieldresult dfield = sfield.getDescribe();
            
            fieldAPIName      = dfield.getName();
            if(!excludeSet.contains(fieldAPIName)) {
                fieldName         = dfield.getLabel();
                fieldType         = dfield.getType(); 
                fieldLength       = dfield.getLength();
                fieldIsCalculated = dfield.isCalculated();
                fieldIsCustom     = dfield.isCustom();
                fieldIsCreateable = dfield.isCreateable();
                fieldIsFilterable = dfield.isFilterable();
                fieldIsUpdateable = dfield.isUpdateable();
                fieldTypeStr      = String.valueOf(fieldType);
                fieldFormula      = dfield.getCalculatedFormula();
                
                if(fieldFormula == null) fieldFormula = 'no formula';
                formulaOrPicklist = fieldFormula;

                if(fieldTypeStr == 'PICKLIST' || fieldTypeStr == 'MULTIPICKLIST') {
                    formulaOrPicklist = '';
                    List<Schema.PicklistEntry> fieldPickList = dfield.getPicklistValues();
                    if(fieldPickList.size() > 0) {
                        for(Schema.PicklistEntry plItem : fieldPickList) {
                            formulaOrPicklist += plItem.getValue() + ',';
                        } 
                    }
                } 

                s = formulaOrPicklist.replaceAll(regExp, replacement);
                formulaOrPicklist = s.normalizeSpace();

                record = new FieldDescribeRecord(pObjectAPIName,fieldName,fieldAPIName,formulaOrPicklist,fieldTypeStr,fieldLength,fieldIsCalculated,fieldIsCustom,fieldIsCreateable,fieldIsFilterable,fieldIsUpdateable);
                fieldDescribeList.add(record);
            }
        }
        return fieldDescribeList;
    }
}