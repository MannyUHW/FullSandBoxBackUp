public class UnpaidInternsReportController {

@RemoteAction
    public static List <sObject> getEmpData() {

        User [] hospitalCoords = [Select Id From User Where FirstName In ('Jean', 'Kristin') And LastName In ('Cronin','Eldridge')];
        Id id1 = hospitalCoords[0].Id;
        Id id2 = hospitalCoords[1].Id;

        sObject [] empData;
        if(empData == null) {
            empData = [
                Select Id,Name,Coordinator__r.Id,Coordinator__r.FirstName,Coordinator__r.LastName,Coordinator__r.Email, Coordinator__r.MobilePhone,
                Organizer_1__r.Id,Organizer_1__r.FirstName,Organizer_1__r.LastName,Organizer_1__r.Email, Organizer_1__r.MobilePhone
                From Account
                Where (Type = 'Employer' And Active__c = 'YES' And Constituency__r.Name != null ) And
            (Account_Group__c = 'Kaiser' OR Coordinator__c = :id1 OR Coordinator__c = :id2 )
            Order By Account.Name ];
        }
        return empData;
    }

    @RemoteAction
    public static List <sObject> getRespData() {

        integer i,l;
        sObject [] respData = new List <sObject>();

        for (list <sObject> dataList : [
            SELECT Id,A1__c,A2__c,A3__c,A4__c,A5__c,A5_Other__c,A6__c,A7__c,A8__c,A9__c,A10__c,A11__c,A12__c,A13__c,A14__c,A15__c,
            MemberName__c,InterviewDate__c,InterviewerId__c,UpdatedDate__c,
            ContactId__r.AccountId,ContactId__r.Account.Name,ContactId__r.Account.Account_Group__c,
            ContactId__c, ContactId__r.FirstName,ContactId__r.LastName, ContactId__r.Email, ContactId__r.MobilePhone,ContactId__r.Phone,
            ContactId__r.Account.Coordinator__r.Id,  ContactId__r.Account.Coordinator__r.LastName, ContactId__r.Account.Coordinator__r.FirstName,
            ContactId__r.Account.Organizer_1__r.Id, ContactId__r.Account.Organizer_1__r.LastName,  ContactId__r.Account.Organizer_1__r.FirstName,
            InterviewerId__r.FirstName,InterviewerId__r.LastName
            FROM UnpaidInterns2__c
            ORDER BY ContactId__c, CreatedDate Desc]) {
            l = dataList.size();
            for(i=0;i<l;i++) {
                respData.add(dataList[i]);
            }
        }
        return respData;
    }

}