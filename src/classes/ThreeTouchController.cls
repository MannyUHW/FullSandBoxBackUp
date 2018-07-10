public class ThreeTouchController {
    
    @RemoteAction
    public static List <Account> getAccountData() {

        integer recLimit;
        AggregateResult[] buCounts;
        AggregateResult[] asCounts;
        List<Id> nonNoIdList = new List<Id>();

        Id accountId;
        Integer cnt;
        Map<Id,Integer> buMap = new Map<Id,Integer>();
 
        // Include non New Organizing accounts that have Assessments
        asCounts = [Select Account.Account_Group__c, AccountId, Count(Id) Cnt
                    From Contact
                    Where Account.Account_Group__c != 'New Organizing' And GOTV_Assessment__c != null And Account.Type = 'Employer' And Account.Active__c = 'yes'
                    Group By Account.Account_Group__c,AccountId];

        for(AggregateResult asCount : asCounts) {
            accountId = (Id) asCount.get('AccountId');
            nonNoIdList.add(accountId);
        }

        // Count contacts, as BU_Count is null for New Organizing
        buCounts = [Select AccountId,Count(Id) Cnt
                    From Contact
                    Where Account.Account_Group__c = 'New Organizing' And Account.Type = 'Employer' And Account.Active__c = 'YES' AND In_Current_BU__c = true
                    Group By AccountId];

        for(AggregateResult buCount : buCounts) {
            accountId = (Id) buCount.get('AccountId');
            cnt       = (Integer) buCount.get('Cnt');
            buMap.put(accountId,cnt);
            System.debug('Id: ' + accountId + '  Cnt: ' + cnt);
        }

        list <Account> data;
        Account rec;
        if(data == null) {
            data = new List <Account>();
            integer i,l;

            // Account List: Any Non N.O. that have Assessments, plus N.O acccounts that have a BU count:
            for (list <Account> dataList : [
                SELECT Id,Name, Account_Group__c,Region__c,Hospital_System__c,BU_Count__c
                FROM Account Where (Account_Group__c = 'New Organizing' And Type = 'Employer' And Active__c = 'YES') Or Id In :nonNoIdList
                ORDER BY Account_Group__c Desc, Name Asc]) {
                l = dataList.size();
                for(i=0;i<l;i++) {
                    rec = dataList[i];
                    if(rec.Account_Group__c == 'New Organizing') {
                        if(buMap.containsKey(rec.Id)) {
                            dataList[i].BU_Count__c = buMap.get(rec.Id);
                            rec.BU_Count__c = buMap.get(rec.Id);
                            data.add(rec);
                        }
                    } else {
                        data.add(rec);
                    }
                }
            }
        }
        return data;
    }

    @RemoteAction
    public static List <Contact> getContactData(Id accountId, List<Integer> dtArray) {

        integer recLimit, utcD,utcM,utcY,utcH,utcZ,utcS;
        list <Contact> data;
        data = new List <Contact>();
        integer i,l;

        if(Test.isRunningTest())
            recLimit = 2;
        else
            recLimit = 9999999;

        if(dtArray != null) {
            utcD = dtArray[0];
            utcM = dtArray[1];
            utcY = dtArray[2];
            utcH = dtArray[3];
            utcZ = dtArray[4];
            utcS = dtArray[5];
            DateTime cutoffDT = DateTime.newInstance(utcY, utcM, utcD, utcH, utcZ, utcS);
            System.debug('------------------------------------------------');
            System.debug(cutoffDT);

            for (list <Contact> dataList : [
                SELECT Id, AccountId, LastName, FirstName, Department, Division__c, Title, MobilePhone, Phone, Shift__c, SignedOrVerified__c, Signed_Membership_Card_By__c, Signed_Membership_Card_Date__c, Signed_Membership_Card__c, Three_Touch_Count__c, Three_Touch_ST__c, Three_Touch_VC__c, Three_Touch__c, Reconfirmed_GOTV__c, GOTV_Assessment__c, GOTV_Vote_Yes_Petition__c, GOTV_Assess__c, GOTV_Board_Challenge__c, GOTV_Card_Signed_Date__c, GOTV_Exact_Vote_Time__c, GOTV_Inside_Plan_Notes__c, GOTV_Off_Both_Days__c, GOTV_Outside_Plan__c, GOTV_Plan_Type__c, GOTV_Shift_Scheduler__c, GOTV_Slip__c, GOTV_Special_Plan_Notes__c, GOTV_Special_Plan__c, GOTV_UHW_Challenge__c, GOTV_Where_After_Voting__c, GOTV_Where_Before_Voting__c, GOTV_Works_Night_Before_Eday1__c,
                       MailingStreet,MailingCity,MailingState,MailingPostalCode,OwnerId,Owner_Name__c , Assigned_to_VC__c, Assigned_to_VC_Name__c
                FROM Contact
                WHERE AccountId = :accountId AND In_Current_BU__c = true And LastModifiedDate >= :cutoffDT
                ORDER BY LastName,FirstName LIMIT :recLimit]) {
                l = dataList.size();
                System.debug('recent changes size: ' + l );
                for(i=0;i<l;i++) {
                    data.add(dataList[i]);
                }
            }
        } else {
            for (list <Contact> dataList : [
                SELECT Id, AccountId, LastName, FirstName, Department, Division__c, Title, MobilePhone, Phone, Shift__c, SignedOrVerified__c, Signed_Membership_Card_By__c, Signed_Membership_Card_Date__c, Signed_Membership_Card__c, Three_Touch_Count__c, Three_Touch_ST__c, Three_Touch_VC__c, Three_Touch__c, Reconfirmed_GOTV__c, GOTV_Assessment__c, GOTV_Vote_Yes_Petition__c, GOTV_Assess__c, GOTV_Board_Challenge__c, GOTV_Card_Signed_Date__c, GOTV_Exact_Vote_Time__c, GOTV_Inside_Plan_Notes__c, GOTV_Off_Both_Days__c, GOTV_Outside_Plan__c, GOTV_Plan_Type__c, GOTV_Shift_Scheduler__c, GOTV_Slip__c, GOTV_Special_Plan_Notes__c, GOTV_Special_Plan__c, GOTV_UHW_Challenge__c, GOTV_Where_After_Voting__c, GOTV_Where_Before_Voting__c, GOTV_Works_Night_Before_Eday1__c,
                       MailingStreet,MailingCity,MailingState,MailingPostalCode,OwnerId,Owner_Name__c , Assigned_to_VC__c, Assigned_to_VC_Name__c
                FROM Contact
                WHERE AccountId = :accountId AND In_Current_BU__c = true
                ORDER BY LastName,FirstName LIMIT :recLimit]) {
                l = dataList.size();
                for(i=0;i<l;i++) {
                    data.add(dataList[i]);
                }
            }
        }

        return data;
    }

    @RemoteAction
    public static String updateContact(ID contactId, String fieldName, String setTo) {

        Contact tmpContact = new Contact();
        tmpContact.Id = contactId;

        if(fieldName == '[ST]') {
            if(setTo == 'true') {
                tmpContact.Three_Touch_ST__c = true;
            }
            else {
                tmpContact.Three_Touch_ST__c = false;
            }
        } else if(fieldName == '[VC]') {
            if(setTo == 'true') {
                tmpContact.Three_Touch_VC__c = true;
            } else {
                tmpContact.Three_Touch_VC__c = false;
            }
        } else if(fieldName == '[OB]') {
            if(setTo == 'true') {
                tmpContact.Three_Touch__c = true;
            } else {
                tmpContact.Three_Touch__c = false;
            }
        } else if(fieldName == 'FirstName') {
            tmpContact.FirstName = setTo;
        } else if(fieldName == 'LastName') {
            tmpContact.LastName = setTo;
        } else if(fieldName == 'Department') {
            tmpContact.Department = setTo;
        } else if(fieldName == 'GotvAssessment') {
            tmpContact.GOTV_Assessment__c = setTo;
        } else if(fieldName == 'GotvVoteYesPetition') {
            tmpContact.GOTV_Vote_Yes_Petition__c = setTo;
        } else if(fieldName == 'Shift') {
            tmpContact.Shift__c = setTo;
        } else if(fieldName == 'Title') {
            tmpContact.Title = setTo;
        } else if(fieldName == 'CellPhone') {
            tmpContact.MobilePhone = setTo;
        } else if(fieldName == 'Phone') {
            tmpContact.Phone = setTo;
        }

        // ------------------------------------------------------------------------------------------- //
        // Update Contact
        // ------------------------------------------------------------------------------------------- //
        try {
            Update tmpContact;
            System.debug('Contact record updated. ');
            return 'OK';
        } catch(Exception e) {
            System.debug('Error updating Contact record. ' + e.getMessage());
            return 'Error';
        }
    }
}