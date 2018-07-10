trigger UpdateContactStatus on Project_Zone_Contact_SOSP__c (after insert, after update) 
{ 
    
    List<ID> contactIDList = new List<ID>();
    List<Contact> ContactsToUpdate = new List<Contact>();

    MAP<ID,String> contactID_MAP = new MAP<ID,String>();
    MAP<ID,String> BadPhoneNumbers_MAP = new MAP<ID,String>();
    MAP<ID,String> FieldWorkNotes_MAP = new MAP<ID,String>();
  
    for(Project_Zone_Contact_SOSP__c p : Trigger.New)
    {
    	
    	system.debug('Trigger.oldMap: ' + Trigger.oldMap);
    	
    	Project_Zone_Contact_SOSP__c oldPZC = null;
    	if ( Trigger.oldMap != null )
    	{
    		oldPZC = Trigger.oldMap.get(p.Id);
    	}
    	system.debug('oldPZC: ' + oldPZC);
    	
    	
        if(p.contact__c != null && ( oldPZC == null || (p.Subject__c != oldPZC.Subject__c || p.Bad_Phone_Numbers__c != oldPZC.Bad_Phone_Numbers__c  || p.Field_Work_Notes__c != oldPZC.Field_Work_Notes__c ) ))
        {
            contactIDList.add(p.contact__c);
            if( p.Subject__c != null)
            {
                 contactID_MAP.put(p.contact__c, p.Subject__c);
            }
            if( p.Bad_Phone_Numbers__c != null)
            {
                 BadPhoneNumbers_MAP.put(p.contact__c, p.Bad_Phone_Numbers__c);
            }
            if( p.Field_Work_Notes__c != null)
            {
                 FieldWorkNotes_MAP.put(p.contact__c, p.Field_Work_Notes__c);
            }
        }
        
    }
    
    List<Contact> Contacts = [Select id, Subject__c, Bad_Phone_Numbers__c,Field_Work_Notes__c  from Contact where id IN: contactIDList];
    
    if(contactIDList.size() > 0  && (contactID_MAP.size() > 0 ||  BadPhoneNumbers_MAP.size() > 0  || FieldWorkNotes_MAP.size() > 0 ))
    {
        for(Contact c : Contacts)
        {
            if(c.Subject__c != contactID_MAP.get(c.id))
            {
               c.Subject__c = contactID_MAP.get(c.id);
            }            
            if(c.Bad_Phone_Numbers__c != BadPhoneNumbers_MAP.get(c.id))
            {
               c.Bad_Phone_Numbers__c = BadPhoneNumbers_MAP.get(c.id);
            }
            if(c.Field_Work_Notes__c != FieldWorkNotes_MAP.get(c.id))
            {
               c.Field_Work_Notes__c = FieldWorkNotes_MAP.get(c.id);
            }
            ContactsToUpdate.add(c);
        }
    }
    
    if(ContactsToUpdate.size() > 0) 
    {
       update  ContactsToUpdate;
    }

}