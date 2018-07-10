public class ctrlr_rpt{

    public string daJSONGoals{get; set;}

    public ctrlr_rpt(){
        //get the goals for kaiser and hospital up front dynamically
        string q_goals = 'Select Regional_Director__r.Name rdname, ';
        q_goals += 'Regional_Director__r.Staff_Contact_Id__c rd_cid, Regional_Director__c rdid, ';
        q_goals += 'Coordinator__r.Name cdname, Organizer_1__r.Name repname, ';
        q_goals += 'Coordinator__c cdid, Organizer_1__c repid, ';
        q_goals += 'Coordinator__r.Staff_Contact_Id__c cd_cid, Organizer_1__r.Staff_Contact_Id__c rep_cid, ';
        q_goals += 'Account_Group__c division from Account ';
        q_goals += 'Where BU_Count__c != null and Account_Group__c in (\'Kaiser\',\'Hospital\') ';
        q_goals += 'Group by Regional_Director__r.Name, Regional_Director__r.Staff_Contact_Id__c, ';
        q_goals += 'Coordinator__r.Name, Coordinator__r.Staff_Contact_Id__c, Coordinator__c, Regional_Director__c, ';
        q_goals += 'Organizer_1__r.Name, Organizer_1__c, Organizer_1__r.Staff_Contact_Id__c, Account_Group__c ';
        q_goals += 'Order by Account_Group__c';
                                        
        List<sObject> goals_result = Database.query(q_goals);
        daJSONGoals = JSON.serialize(goals_result);

    }

    @RemoteAction
    public static List<sObject> getData(string pl_query){    
        return Database.query(pl_query);
    }

    @RemoteAction 
    public static SObject[] pl_getRecords(Id offsetId) {
        string query = 'Select Quantity__c, Valid_Signatures__c, Bad_Signatures__c, County__c, ';
        query += 'From_Regional_Director__r.Name,From_Regional_Director__r.Staff_Contact_Id__c,  From_Division__c, ';
        query += 'From_Coordinator__r.Name,From_Coordinator__r.Staff_Contact_Id__c,  ';
        query += 'Transferred_From__r.Name,  Transferred_From__r.Owner.Name, Transferred_From__r.Owner.Staff_Contact_Id__c, ';
        query += 'Transferred_From__r.Division_Type__c, Transferred_To__r.Division_Type__c, ';
        query += 'Transferred_From__r.Account.Organizer_1__r.Name, Transferred_From__r.Department, ';
        query += 'Transferred_From__r.Account.Organizer_1__r.Staff_Contact_Id__c, ';
        query += 'Transferred_To__r.Account.Organizer_1__r.Name, Transferred_To__r.Department, ';
        query += 'Transferred_To__r.Account.Organizer_1__r.Staff_Contact_Id__c, ';
        query += 'To_Regional_Director__r.Name, To_Regional_Director__r.Staff_Contact_Id__c, To_Division__c, ';
        query += 'To_Coordinator__r.Name, To_Coordinator__r.Staff_Contact_Id__c, Transferred_To__r.Name, ';
        query += 'Transferred_To__r.Owner.Name, Transferred_To__r.Owner.Staff_Contact_Id__c, Transfer_Type__c ';
        query += 'FROM Petition_Ledger__c ';
        if(offsetId==null) {
            query += ' ORDER BY Id ASC LIMIT 2000 ';            
        } else {
            query += '  WHERE ID > :offsetId ORDER BY Id ASC LIMIT 2000 ';
        }
        return Database.query(query);
    }
}