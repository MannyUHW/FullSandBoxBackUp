public class ctrlr_mo{

    public string JSONLocationDates{get;set;}

    public ctrlr_mo(){
        //phone bank location based shift custom settings list
        List<Phone_Bank_Location__c> pbl = Phone_Bank_Location__c.getall().values();
        JSONLocationDates = JSON.serialize(pbl);
    }

    @RemoteAction
    public static List<sObject> getData(string query){    
        return Database.query(query);
    }

    @RemoteAction 
    public static SObject[] getRecords(Id offsetId, string query) {        
        if(offsetId==null) {
            query += ' ORDER BY Id ASC LIMIT 2000 ';            
        } else {
            query += '  AND ID > :offsetId ORDER BY Id ASC LIMIT 2000 ';
        }
        return Database.query(query);
    }
}