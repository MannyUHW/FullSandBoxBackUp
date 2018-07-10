public class LeaderOutreachController {

    @RemoteAction
    public static List <sObject> getAccountData() {

        integer recLimit;
        if(Test.isRunningTest())
            recLimit = 1;
        else
            recLimit = 9999999;

        List <sObject> data;
        if(data == null) {
            data = [
                Select Id,Region__c,Account_Group__c, Name, Coordinator__r.FirstName, Coordinator__r.LastName, Coordinator__r.Email, Coordinator__r.MobilePhone,
                Organizer_1__r.FirstName,Organizer_1__r.LastName,Organizer_1__r.Email, Organizer_1__r.MobilePhone,
                Organizer_2__r.FirstName,Organizer_2__r.LastName,Organizer_2__r.Email, Organizer_2__r.MobilePhone
                From Account
                Where Account_Group__c In ('Kaiser','Hospital') And Type = 'Employer' Order By Account_Group__c,Account.Name LIMIT :recLimit
        ];
        }
        return data;
    }

    @RemoteAction
    public static List<String> updateLeaderOutreach(List <String> updates) {

        LeaderOutreach__c tmpRec;
        LeaderOutreachTx  txRec;

        List <Database.SaveResult> srList;
        List <String> errorList                  = new List <String>();
        List <LeaderOutreach__c> recordsToInsert = new List <LeaderOutreach__c>();
        Boolean noError = true;
        String userId   = UserInfo.getUserId();

        for (String responseRec : updates) {
            tmpRec = new LeaderOutreach__c();
            txRec  = LeaderOutreachTx.parse(responseRec);
            tmpRec.Answer1__c          = txRec.Answer1;
            tmpRec.Answer2__c          = txRec.Answer2;
            tmpRec.Answer3__c          = txRec.Answer3;
            tmpRec.Answer4__c          = txRec.Answer4;
            tmpRec.LeaderFirstName__c  = txRec.LeaderFirstName;
            tmpRec.LeaderLastName__c   = txRec.LeaderLastName;
            tmpRec.MemberFirstName__c  = txRec.MemberFirstName;
            tmpRec.MemberLastName__c   = txRec.MemberLastName;
            tmpRec.EmpId__c            = txRec.EmpId;
            tmpRec.MemberEmail__c      = txRec.MemberEmail;
            tmpRec.MemberDepartment__c = txRec.memberDepartment;
            tmpRec.MemberCellPhone__c  = txRec.MemberCellPhone;
            tmpRec.MemberEmployeeId__c = txRec.MemberEmpId;
    
            recordsToInsert.add(tmpRec);
        }

    // ------------------------------------------------------------------------------------------- //
    // Insert Responses
    // ------------------------------------------------------------------------------------------- //
    if (!recordsToInsert.isEmpty()) {
        try {
            srList = Database.insert(recordsToInsert, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 1:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {
            errorList.add('Error 2');
            noError = false;
        }
    }

    return errorList;

    }
}