global class KHRL_ChangeContactOwner implements Database.Batchable<sObject> {
    public String query;
    public String userId;
    List<Contact> contactsToUpdate;
    public List<String> AccountIdArray = new List<String>();
      
    global Iterable<sObject> start(Database.BatchableContext BC) {
        contactsToUpdate = [SELECT Id, OwnerId FROM Contact WHERE AccountId IN :AccountIdArray];
        return contactsToUpdate;
    }

    global void execute(Database.BatchableContext BC, List <Contact> contactsToChange){

        for(Contact contTemp : contactsToChange){
             contTemp.OwnerId = userId;
        }
        update contactsToChange;
    }
    global void finish(Database.BatchableContext BC){}
}