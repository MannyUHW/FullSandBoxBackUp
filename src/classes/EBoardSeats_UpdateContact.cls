public class EBoardSeats_UpdateContact
{
    public static void updateContact ( List<EBoardSeats__c> newList, Map<Id, EBoardSeats__c> oldMap, boolean isUpdate)
    {
        if (isUpdate)
        {
            Set<Id> cidSet = new Set<Id>();
            
            for (EBoardSeats__c ebs : newList)
            {
                if (ebs.SeatHolder__c == null && oldMap.get(ebs.Id).SeatHolder__c != null )
                {
                    cidSet.Add(oldMap.get(ebs.Id).SeatHolder__c);
                }
            }
            List<Contact> existingContacts  = [select Id, Executive_Body_Title__c from Contact where Id in :cidSet ];
            
            for (Contact c : existingContacts)
            {
                c.Executive_Body_Title__c = null;
            }
            update existingContacts;
        }
    }
}