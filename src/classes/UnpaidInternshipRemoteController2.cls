public class UnpaidInternshipRemoteController2 {

    @RemoteAction
    public static List <Account> getAccountData() {

        integer recLimit;

        if(Test.isRunningTest())
            recLimit = 2;
        else
            recLimit = 9999999;

        list <Account> data;
        if(data == null) {
            data = new List <Account>();
            integer i,l;

            for (list <Account> dataList : [
                SELECT Id,Name, Account_Group__c,Hospital_System__c,BU_Count__c
                FROM Account Where Account_Group__c In ('Kaiser','Hospital') And Type = 'Employer' And Active__c = 'YES'
                ORDER BY Account_Group__c, Name LIMIT :recLimit]) {
                l = dataList.size();
                for(i=0;i<l;i++) {
                    data.add(dataList[i]);
                }
            }
        }
        return data;
    }

    @RemoteAction
    public static List <Contact> getContactData(Id accountId) {

        integer recLimit;

        if(Test.isRunningTest())
        recLimit = 2;
        else
        recLimit = 9999999;

        list <Contact> data;
        if(data == null) {
            data = new List <Contact>();
            integer i,l;

            for (list <Contact> dataList : [
                SELECT Id,FirstName,LastName,Birthdate,Hire_Date__c,Gender__c,Title,HomePhone,MobilePhone,MailingCity,MailingPostalCode,AccountId,Department,Email,Ethnic_Group__c,LanguagePrimary__c
                FROM Contact
                WHERE  AccountId = :accountId AND In_Current_BU__c = TRUE
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
    public static User getUserData(Id userId) {

        List <User> ul = [
            SELECT ActingDivision__c,ActingTitle__c
            FROM User
            WHERE Id = :userId LIMIT 1
        ];
        if(ul.size() > 0)
          return ul[0];
        else
          return null;
    }

    @RemoteAction
    public static UnpaidInterns2__c getResponseData(Id contactId) {

        List <UnpaidInterns2__c> ui = [
            SELECT A1__c,A2__c,A3__c,A4__c,A5__c,A6__c,A7__c,A8__c,A9__c,A10__c,A11__c,A12__c,A13__c,A14__c,A15__c,ContactId__c,Id,InterviewDate__c,InterviewerId__c,UpdatedDate__c,Updated__c
            FROM UnpaidInterns2__c
            WHERE ContactId__c = :contactId LIMIT 1
        ];

        if(ui.size() > 0)
            return ui[0];
        else
            return null;

    }

    @RemoteAction
    public static List<String> updateResponses2(List <String> updates) {

        // Note: This needs fixing to update existing responses when time allows.

        UnpaidInterns2__c tmpRec;
        UnpaidInternsTx   txRec;
        AppLog__c  tmpAppLog;
        List <Database.SaveResult> srList;
        List <AppLog__c> logsToInsert              = new List <AppLog__c>();
        List <String> errorList                    = new List <String>();
        List <UnpaidInterns2__c> responsesToInsert = new List <UnpaidInterns2__c>();
        Boolean noError = true;
        String userId   = UserInfo.getUserId();

        for (String responseRec : updates) {
            tmpRec = new UnpaidInterns2__c();
            txRec  = UnpaidInternsTx.parse(responseRec);
            tmpRec.ContactId__c     = txRec.ContactId;
            tmpRec.InterviewerId__c = txRec.InterviewerId;
            tmpRec.InterviewDate__c = txRec.InterviewDate;
            tmpRec.MemberName__c    = txRec.MemberName;
            tmpRec.UpdatedDate__c   = txRec.UpdatedDate;
            tmpRec.Updated__c       = txRec.Updated;
            tmpRec.A1__C            = txRec.A1;
            tmpRec.A2__C            = txRec.A2;
            tmpRec.A3__C            = txRec.A3;
            tmpRec.A4__C            = txRec.A4;
            tmpRec.A5__C            = txRec.A5;
            tmpRec.A5_Other__c      = txRec.A5_Other;
            tmpRec.A6__C            = txRec.A6;
            tmpRec.A7__C            = txRec.A7;
            tmpRec.A8__C            = txRec.A8;
            tmpRec.A9__C            = txRec.A9;
            tmpRec.A10__C           = txRec.A10;
            tmpRec.A11__C           = txRec.A11;
            tmpRec.A12__C           = txRec.A12;
            tmpRec.A13__C           = txRec.A13;
            tmpRec.A14__C           = txRec.A14;
            tmpRec.A15__C           = txRec.A15;

            responsesToInsert.add(tmpRec);
        }

        // ------------------------------------------------------------------------------------------- //
        // Insert Responses
        // ------------------------------------------------------------------------------------------- //
        if (!responsesToInsert.isEmpty()) {
            try {
                srList = Database.insert(responsesToInsert, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        tmpAppLog             = new AppLog__c();
                        tmpAppLog.App__c      = 'Unpaid Interns 1';
                        tmpAppLog.DateTime__c = datetime.now();
                        tmpAppLog.Error__c    = 'Error 3:' + sr.Errors[0].StatusCode;
                        tmpAppLog.UserId__c   = UserId;
                        logsToInsert.add(tmpAppLog);

                        errorList.add('Error 3:' + sr.Errors[0].StatusCode);
                        noError = false;
                    }
                }
            }
            catch (DmlException e) {
                tmpAppLog             = new AppLog__c();
                tmpAppLog.App__c      = 'Unpaid Interns 1';
                tmpAppLog.DateTime__c = datetime.now();
                tmpAppLog.Error__c    = 'Error 4:' + e.getDmlMessage(0);
                tmpAppLog.UserId__c   = UserId;
                logsToInsert.add(tmpAppLog);

                errorList.add('Error 4');
                noError = false;
            }
        }

        if(!logsToInsert.isEmpty()) {
            srList = Database.insert(logsToInsert);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted log rec ' + sr.getId() );
                }
                else {
                    errorList.add('Error 5');
                    System.debug('Oh dear, what irony!  An error occurred saving the error messages to log.' + sr.getErrors() );
                }
            }
        }
        return errorList;
    }
}