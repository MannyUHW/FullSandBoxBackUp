public class LeaderOutreachReportController {

    class myClass {
        String AccountId;
        String Org1Id;
        Integer Count;
    }

    @RemoteAction
    public static String getCountData(String code) {

        integer recLimit;

        if(Test.isRunningTest())
            recLimit = 2;
        else
            recLimit = 9999999;

        String data;
        List <myClass> myClassList = new List <myClass>();

        if(data == null) {
            for (list <AggregateResult> dataList : [
                SELECT Contact__r.AccountId, 
                       Contact__r.Account.Organizer_1__r.Id,
                       Count(Id)
                FROM Survey_Response__c
                WHERE Survey_Code__c = :code And Contact__r.In_Current_BU__c = true And Response_Value__c = 'yes' 
                GROUP BY Contact__r.AccountId, Contact__r.Account.Organizer_1__r.Id]) {
            
                for (AggregateResult ar : dataList)  {
                    myClass rec = new myClass();
                    rec.AccountId = (String)  ar.get('AccountId');
                    rec.Org1Id    = (String)  ar.get('Id');
                    rec.Count     = (Integer) ar.get('expr0');
                    myClassList.add(rec);
                }
            }
        }
        data = Json.serialize(myClassList); 
        return data;
    }

    @RemoteAction
    public static List <sObject> getData(String code, List <String> accIds) {

      List <Id> accountIdList;
      Boolean restrict = false;
      Id tmpId;
      integer i,l;
      integer recLimit;
      if(Test.isRunningTest())
          recLimit = 1;
      else
          recLimit = 9999999;

      l = accIds.size();
      if(l > 0 ) {
          restrict = true;
          accountIdList = new List <Id>();
          for(i=0;i<l;i++) {
              tmpId = (Id) accIds[i]; 
              accountIdList.add(tmpId);
          }
      }

      List <sObject> data;
      if(data == null) {
          data = new List <sObject>();
        
            if(restrict) {
               for (list <sObject> dataList : [
                    SELECT    
                        Contact__r.Account.Id, 
                        Contact__r.Account.Name,
                        Contact__r.Account.Region__c,
                        Contact__r.Account.Account_Group__c, 
                        Contact__r.Account.Coordinator__r.Id,
                        Contact__r.Account.Coordinator__r.FirstName, 
                        Contact__r.Account.Coordinator__r.LastName, 
                        Contact__r.Account.Coordinator__r.Email, 
                        Contact__r.Account.Coordinator__r.MobilePhone,
                        Contact__r.Account.Organizer_1__r.Id,
                        Contact__r.Account.Organizer_1__r.FirstName,
                        Contact__r.Account.Organizer_1__r.LastName,
                        Contact__r.Account.Organizer_1__r.Email,
                        Contact__r.Account.Organizer_1__r.MobilePhone,
                        Contact__r.Id,
                        Contact__r.FirstName, 
                        Contact__r.LastName, 
                        Contact__r.Email,
                        Contact__r.MobilePhone,
                        Contact__r.Account.BU_Count__c,
                        Collected_By__r.Id,
                        Collected_By__r.FirstName,  
                        Collected_By__r.LastName,
                        Collected_By__r.Email,
                        Collected_By__r.MobilePhone  
                    FROM Survey_Response__c
                    WHERE Survey_Code__c = :code And Contact__r.In_Current_BU__c = true And Response_Value__c = 'yes' And Contact__r.Account.Id IN :accountIdList
                    ORDER BY Contact__r.Account.Id,Contact__r.Account.Organizer_1__r.Id 
                    LIMIT :recLimit]) {
                        l = dataList.size();
                        for(i=0;i<l;i++) {
                            data.add(dataList[i]);
                    }   
                }
            }
            else {
               for (list <sObject> dataList : [
                    SELECT    
                        Contact__r.Account.Id, 
                        Contact__r.Account.Name,
                        Contact__r.Account.Region__c,
                        Contact__r.Account.Account_Group__c, 
                        Contact__r.Account.Coordinator__r.Id,
                        Contact__r.Account.Coordinator__r.FirstName, 
                        Contact__r.Account.Coordinator__r.LastName, 
                        Contact__r.Account.Coordinator__r.Email, 
                        Contact__r.Account.Coordinator__r.MobilePhone,
                        Contact__r.Account.Organizer_1__r.Id,
                        Contact__r.Account.Organizer_1__r.FirstName,
                        Contact__r.Account.Organizer_1__r.LastName,
                        Contact__r.Account.Organizer_1__r.Email,
                        Contact__r.Account.Organizer_1__r.MobilePhone,
                        Contact__r.Id,
                        Contact__r.FirstName, 
                        Contact__r.LastName, 
                        Contact__r.Email,
                        Contact__r.MobilePhone,
                        Contact__r.Account.BU_Count__c,
                        Collected_By__r.Id,
                        Collected_By__r.FirstName,  
                        Collected_By__r.LastName,
                        Collected_By__r.Email,
                        Collected_By__r.MobilePhone  
                FROM Survey_Response__c
                WHERE Survey_Code__c = :code And Contact__r.In_Current_BU__c = true And Response_Value__c = 'yes'
                ORDER BY Contact__r.Account.Id,Contact__r.Account.Organizer_1__r.Id 
                LIMIT :recLimit]) {
                    l = dataList.size();
                    for (i=0;i<l;i++) {
                        data.add(dataList[i]);
                    }
                }
            }
        }
        return data;
    }

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
                SELECT Id, Coordinator__r.Id,Coordinator__r.FirstName,Coordinator__r.LastName, Organizer_1__r.Id, Organizer_1__r.FirstName,Organizer_1__r.LastName, Account_Group__c, Region__c, Name, BU_Count__c 
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
}