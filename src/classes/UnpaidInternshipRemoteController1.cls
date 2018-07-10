public class UnpaidInternshipRemoteController1 {

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
    public static UnpaidInterns1__c getResponseData(Id contactId) {

        List <UnpaidInterns1__c> ui = [
            SELECT A1__c,A2__c,A3__c,A4__c,A5__c,A6__c,A7__c,A8__c,A9__c,A10__c,A11__c,A12__c,A13__c,A14__c,A15__c,ContactId__c,Id,InterviewDate__c,Interviewer__c
            FROM UnpaidInterns1__c
            WHERE ContactId__c = :contactId LIMIT 1
        ];

        if(ui.size() > 0)
            return ui[0];
        else
            return null;

    }

    @RemoteAction
    public static List<String> updateResponses(List <UnpaidInterns1__c> updates) {

        UnpaidInterns1__c tmpResponse;
        AppLog__c  tmpAppLog;
        List <Database.SaveResult> srList;
        List <Database.UpsertResult> urList;
        List <AppLog__c> logsToInsert              = new List <AppLog__c>();
        List <String> errorList                    = new List <String>();
        List <UnpaidInterns1__c> responsesToInsert = new List <UnpaidInterns1__c>();
        List <UnpaidInterns1__c> responsesToUpdate = new List <UnpaidInterns1__c>();
        Boolean noError = true;
        String userId   = UserInfo.getUserId();

system.debug('update count:');
system.debug(updates.size());

        for (UnpaidInterns1__c recruitRec : updates) {
          tmpResponse = new UnpaidInterns1__c();
          tmpResponse.Interviewer__c   = recruitRec.Interviewer__c;
          tmpResponse.ContactId__c     = recruitRec.ContactId__c;
          tmpResponse.InterviewDate__c = recruitRec.InterviewDate__c;
          tmpResponse.UpdatedDate__c   = recruitRec.UpdatedDate__c;
          tmpResponse.MemberName__c    = recruitRec.MemberName__c;
          tmpResponse.A1__c = recruitRec.A1__c;
          tmpResponse.A2__c = recruitRec.A2__c;
          tmpResponse.A3__c = recruitRec.A3__c;
          tmpResponse.A4__c = recruitRec.A4__c;
          tmpResponse.A5__c = recruitRec.A5__c;
          tmpResponse.A6__c = recruitRec.A6__c;
          tmpResponse.A7__c = recruitRec.A7__c;
          tmpResponse.A8__c = recruitRec.A8__c;
          tmpResponse.A9__c = recruitRec.A9__c;
          tmpResponse.A10__c = recruitRec.A10__c;
          tmpResponse.A11__c = recruitRec.A11__c;
          tmpResponse.A12__c = recruitRec.A12__c;
          tmpResponse.A13__c = recruitRec.A13__c;
          tmpResponse.A14__c = recruitRec.A14__c;
          tmpResponse.A15__c = recruitRec.A15__c;

//            if(RecruitRec.Id != null) {
//                System.debug('adding to update array ');
//                responsesToUpdate.add(tmpResponse);
//            }
//            else {
                System.debug('adding to insert array ');
                responsesToInsert.add(tmpResponse);
//            }
            System.debug(tmpResponse);
        }

        // ------------------------------------------------------------------------------------------- //
        // Update Responses
        // ------------------------------------------------------------------------------------------- //
        // if (!responsesToUpdate.isEmpty()) {
        //     try {
        //         srList = Database.update(responsesToUpdate, false);
        //         for (Database.SaveResult sr : srList) {
        //             if (!sr.isSuccess()) {
        //                 tmpAppLog             = new AppLog__c();
        //                 tmpAppLog.App__c      = 'Unpaid Interns 1';
        //                 tmpAppLog.DateTime__c = datetime.now();
        //                 tmpAppLog.Error__c    = 'Error 1:' + sr.Errors[0].StatusCode;
        //                 tmpAppLog.UserId__c   = UserId;
        //                 logsToInsert.add(tmpAppLog);
        // 
        //                 errorList.add('Error 1:' + sr.Errors[0].StatusCode);
        //                 noError = false;
        //             }
        //         }
        //     }
        //     catch (DmlException e) {
        //         tmpAppLog             = new AppLog__c();
        //         tmpAppLog.App__c      = 'Unpaid Interns 1';
        //         tmpAppLog.DateTime__c = datetime.now();
        //         tmpAppLog.Error__c    = 'Error 2:' + e.getDmlMessage(0);
        //         tmpAppLog.UserId__c   = UserId;
        //         logsToInsert.add(tmpAppLog);
        // 
        //         errorList.add('Error 2');
        //         noError = false;
        //     }
        // }

        // ------------------------------------------------------------------------------------------- //
        // Upsert Responses
        // ------------------------------------------------------------------------------------------- //
        if (!responsesToInsert.isEmpty()) {
            try {
                urList = Database.upsert(responsesToInsert, false);
                for (Database.UpsertResult sr : urList) {
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