public with sharing class GotvMobileController {
    
    @RemoteAction
    public static List <Gotv_Universe__c> getUniverseData() {
        List<Gotv_Universe__c> data;
        String filterSoql,querySoql;
        Integer i,l,cnt;

        data = new List<Gotv_Universe__c>();
        for (list <Gotv_Universe__c> dataList : [SELECT Id,Account__c,Name,Description__c,FilterSoql__c,Count__c FROM Gotv_Universe__c ORDER BY Name Asc]) {
            l = dataList.size();
            for(i=0;i<l;i++) {
                filterSoql = dataList[i].FilterSoql__c;
                querySoql  = 'Select Count() From Contact ' + filterSoql + ' AND In_Current_BU__c = true';
                cnt = Database.countQuery(querySoql);
                dataList[i].Count__c = cnt;
                data.add(dataList[i]);
            }
        }
        return data;
    }

    @RemoteAction
    public static List <Contact> getContactData(Id universeId) {
        List <Contact> data;
        List<Gotv_Universe__c> uData;
        String filterSoql,querySoql;
        uData = [SELECT FilterSoql__c FROM Gotv_Universe__c WHERE Id = :universeId];
        filterSoql = uData[0].FilterSoql__c;
        querySoql  = 'SELECT  Id, AccountId, LastName, FirstName, MobilePhone, HomePhone, Phone, DoNotCall, Shift__c, Department,';
        querySoql += 'Three_Touch_ST__c, Three_Touch_VC__c, Three_Touch__c, Reconfirmed_GOTV__c,';
        querySoql += 'GOTV_Exact_Vote_Time__c, GOTV_Inside_Plan_Notes__c, GOTV_Off_Both_Days__c, GOTV_Plan_Type__c, GOTV_Slip__c,';
        querySoql += 'GOTV_Where_After_Voting__c, GOTV_Where_Before_Voting__c, GOTV_Works_Night_Before_Eday1__c,GOTV_Works_Eday_1__c, Assigned_to_VC_Name__c, GOTV_Gettable__c,GOTV_Vote_Block_Time__c ';
        querySoql += 'FROM Contact  ' + filterSoql + ' AND In_Current_BU__c = true';
        querySoql += ' ORDER BY LastName,FirstName ';
        data =  Database.query(querySoql);
        return data;

    }

    @RemoteAction
    public static String updateContact(Id contactId, Boolean stVal, Boolean vcVal) {

        Contact tmpContact = new Contact();
        tmpContact.Id = contactId;
        tmpContact.Three_Touch_ST__c = stVal;
        tmpContact.Three_Touch_VC__c = vcVal;
        
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