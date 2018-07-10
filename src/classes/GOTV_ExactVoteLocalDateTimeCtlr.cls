public class GOTV_ExactVoteLocalDateTimeCtlr {

    public GOTV_ExactVoteLocalDateTimeCtlr() {
    }
    
    @RemoteAction
    public static List<String> updateData(List<Contact> contactsArray)
    {
        List <Contact> contactsToUpdate;
        List <String> resultList;
        List <Database.SaveResult> srList;
        Contact tempContact;

        contactsToUpdate = new List<Contact>();
        resultList       = new List<String>();
        
        if (!contactsArray.isEmpty()) {
             try {
                srList = Database.update(contactsArray, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        resultList.add('Error 1: ' + sr.Errors[0].StatusCode);
                        break;
                    }
                }
            }
            catch (DmlException e) {resultList.add('Error 2');}
        }
        return resultList;
    }
}