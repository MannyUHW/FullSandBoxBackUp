public class TaskTriggerHelper{
         
    public static void afterInsert_SOS_UpdateContactOnRefuseToSign (List<Task> newObject, List<Task> oldObject){
    
        Contact[] updateContacts = new List<Contact>();
        Map<Id, Contact> mapContacts = new Map<Id, Contact>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id, List<Task>> mapTasks = new Map<Id, List<Task>>();
        Boolean checkisExclude = true;
        List<contact> updateList = new List<contact>();        
        set<ID> cIDset = new set<ID>();
                
        for (Task t : newObject) {
            if (t.WhoId != null)
                contactIds.add(t.WhoId);
        }
        
        if (contactIds.size() == 0) {
            return;
        }
        
         // get all the contacts
        for (Contact c : [SELECT Id, Last_Phone_Bank_Task_Subject__c, No_one_home__c, RefusedToSign__c, VisitLast6Months__c FROM Contact WHERE Id IN :contactIds]) {
            mapContacts.put(c.Id, c);
        }
        
        // get all the tasks of the contacts and store in a map
        for (Task t : [SELECT Id, WhoId, Subject FROM Task WHERE WhoId IN :contactIds ORDER BY WhoId, CreatedDate DESC]) {
            List<Task> tasks = mapTasks.get(t.WhoId);
            if (tasks == null) {
                tasks = new List<Task>();
                mapTasks.put(t.WhoId, tasks);
            }
            tasks.add(t);     
        }
     
        for (Id cId : mapContacts.keySet()) {
     
             Contact c = mapContacts.get(cId);
             if (c == null) continue;
             
             Boolean doupdate = false;
        
             List<Task> tasks = mapTasks.get(cId);
             
             Boolean refusetosign = false;
             Boolean signed = false;
             Boolean noonehome = false;
             Boolean visitedlast6months = false;
             
             if (tasks != null) {
             //if (Trigger.isInsert && Trigger.isAfter) {
                //if task insert, copy latest subject to contact.
                for (Task t : tasks) {
                    if (c.Last_Phone_Bank_Task_Subject__c != t.Subject) {
                            c.Last_Phone_Bank_Task_Subject__c = t.Subject;
                            doupdate = true;
                    }
                    break; // just check the first task. Come out of the loop
                }
            //}
            for (Task t : tasks) {
                
                if (t.Subject == null)
                {
                    break;
                }
                
                if (t.Subject.Contains('Refused')) {
                    refusetosign = true;
                    break;
                }
                
                if (t.Subject.Contains('Refused')) {
                    refusetosign = true;
                    break;
                }
                if (t.Subject.Contains('Signed Card')) {
                    signed = true;
                    break;
                }
                if (t.Subject.Contains('Not Home')) {
                    noonehome = true;
                    break;
                }
                if (t.Subject.Contains('Visit') || t.Subject.Contains('Refused')) {
                    visitedlast6months = true;
                    break;
                }
                
              
                }
                
                contact co = new contact();
                co = c;
                co.isExclude__c= false; 
                for (Task t : tasks) 
                {
                    
                    if(checkisExclude == true)
                    {
                        system.debug('value of checkisExclude  ' + checkisExclude );
                        system.debug('value of contact ' + co );
                        system.debug('Subject in task ' + t.Subject);
                        if(t.Subject != null){
                        if (t.Subject.Contains('NLE') || t.Subject.Contains('Bad Address')) {
                            co.isExclude__c= true;  
                            checkisExclude = false;  
                            system.debug('Inside loop' );               
                        }
                        }
                    }
                    
                    if(cIDset.contains(co.id) == false){
                        updateList.add(co);
                        cIDset.add(co.id);
                    }
                }
                
            }
            
              if (refusetosign) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, true, true, false)) {
                    doupdate = true;
                }
              }
              else if (signed) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, false)) {
                    doupdate = true;
                }
              }
              else {
            if (noonehome) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, true)) {
                    doupdate = true;
                }
            }
            else {
                if (visitedlast6months) {
                    // atleast one task on contact which is not 'refused' or 'signed' or 'no one home', so make visitedlastsixmonths to true.
                    if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, false)) {
                        doupdate = true;
                    }
                }
                else {
                    //no tasks on contact, clear all flags
                    if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, false, false)) {
                        doupdate = true;
                    }
                }
            }
        }
            
        if (doupdate) updateContacts.add(c);
             
        }
        updateContacts = updateList;
        if (updateContacts.size() > 0)
            update updateContacts;
        
    }
    
    public static void afterUpdate_SOS_UpdateContactOnRefuseToSign (List<Task> newObject, List<Task> oldObject){
        
        Contact[] updateContacts = new List<Contact>();
        Map<Id, Contact> mapContacts = new Map<Id, Contact>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id, List<Task>> mapTasks = new Map<Id, List<Task>>();
        Boolean checkisExclude = true;
        List<contact> updateList = new List<contact>();
        set<ID> cIDset = new set<ID>();
        
        for (Task t : newObject) {
            if (t.WhoId != null)
                contactIds.add(t.WhoId);
        }
        
        if (contactIds.size() == 0) {
            return;
        }
        
        // get all the contacts
        for (Contact c : [SELECT Id, Last_Phone_Bank_Task_Subject__c, No_one_home__c, RefusedToSign__c, VisitLast6Months__c FROM Contact WHERE Id IN :contactIds]) {
            mapContacts.put(c.Id, c);
        }
        
        for (Task t : [SELECT Id, WhoId, Subject FROM Task WHERE WhoId IN :contactIds ORDER BY WhoId, CreatedDate DESC]) {
            List<Task> tasks = mapTasks.get(t.WhoId);
            if (tasks == null) {
                tasks = new List<Task>();
                mapTasks.put(t.WhoId, tasks);
            }
            tasks.add(t); 
            system.debug('List of tasks ' + tasks );    
        }
        
        system.debug('map of tasks ' + mapTasks);
        for (Id cId : mapContacts.keySet()) {
     
             Contact c = mapContacts.get(cId);
             if (c == null) continue;
             
             Boolean doupdate = false;
        
             List<Task> tasks = mapTasks.get(cId);
             
             Boolean refusetosign = false;
             Boolean signed = false;
             Boolean noonehome = false;
             Boolean visitedlast6months = false;
             
             if (tasks != null) {
             
             for (Task t : tasks) {
                system.debug(' tasks contains  ' + tasks);
                if (t.Subject == null)
                {
                    break;
                }
                
                if (t.Subject.Contains('Refused')) {
                    refusetosign = true;
                    break;
                }
                if (t.Subject.Contains('Signed Card')) {
                    signed = true;
                    break;
                }
                if (t.Subject.Contains('Not Home')) {
                    noonehome = true;
                    break;
                }
                if (t.Subject.Contains('Visit') || t.Subject.Contains('Refused')) {
                    visitedlast6months = true;
                    break;
                }
                
              
                }
                contact co = new contact();
                co = c;
                for (Task t : tasks) {
                    
                    if(checkisExclude == true){
                        system.debug('value of checkisExclude  ' + checkisExclude );
                        system.debug('value of contact ' + co );
                        system.debug('Subject in task ' + t.Subject);
                        if(t.Subject != null){
                        if (t.Subject.Contains('NLE') || t.Subject.Contains('Bad Address')) {
                            co.isExclude__c= true;  
                            checkisExclude = false;  
                            system.debug('Inside loop' );               
                        }
                        else{
                            co.isExclude__c= false; 
                        }
                        }
                    }
                    if(cIDset.contains(co.id) == false){
                        updateList.add(co);
                        cIDset.add(co.id);
                    }
                }
                
              }
            
              if (refusetosign) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, true, true, false)) {
                    doupdate = true;
                }
              }
              else if (signed) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, false)) {
                    doupdate = true;
                }
              }
              else {
            if (noonehome) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, true)) {
                    doupdate = true;
                }
            }
            else {
                if (visitedlast6months) {
                    // atleast one task on contact which is not 'refused' or 'signed' or 'no one home', so make visitedlastsixmonths to true.
                    if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, false)) {
                        doupdate = true;
                    }
                }
                else {
                    //no tasks on contact, clear all flags
                    if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, false, false)) {
                        doupdate = true;
                    }
                }
            }
        }
            
        if (doupdate) updateContacts.add(c);
             
        }
        
        system.debug('list before update contact ' + updateContacts);
        updateContacts = updateList;
        if (updateContacts.size() > 0)
            update updateContacts;
    }
    
    public static void afterDelete_SOS_UpdateContactOnRefuseToSign (List<Task> oldObject){
        
        Contact[] updateContacts = new List<Contact>();
        Map<Id, Contact> mapContacts = new Map<Id, Contact>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id, List<Task>> mapTasks = new Map<Id, List<Task>>();
        Boolean checkisExclude = true;
        List<contact> updateList = new List<contact>();        
        set<ID> cIDset = new set<ID>();
        
        for (Task t : oldObject) {
            if (t.WhoId != null)
                contactIds.add(t.WhoId);
        }
        
        if (contactIds.size() == 0) {
            return;
        }
        
        // get all the contacts
        for (Contact c : [SELECT Id, Last_Phone_Bank_Task_Subject__c, No_one_home__c, RefusedToSign__c, VisitLast6Months__c FROM Contact WHERE Id IN :contactIds]) {
            mapContacts.put(c.Id, c);
        }
        
        for (Task t : [SELECT Id, WhoId, Subject FROM Task WHERE WhoId IN :contactIds ORDER BY WhoId, CreatedDate DESC]) {
            List<Task> tasks = mapTasks.get(t.WhoId);
            if (tasks == null) {
                tasks = new List<Task>();
                mapTasks.put(t.WhoId, tasks);
            }
            tasks.add(t);     
        }
     
        for (Id cId : mapContacts.keySet()) {
     
             Contact c = mapContacts.get(cId);
             if (c == null) continue;
             
             Boolean doupdate = false;
        
             List<Task> tasks = mapTasks.get(cId);
             
             Boolean refusetosign = false;
             Boolean signed = false;
             Boolean noonehome = false;
             Boolean visitedlast6months = false;
             
            if (tasks != null) {
             
            for (Task t : tasks) {
                
                if (t.Subject == null)
                {
                    break;
                }
                if(checkisExclude){
                    if (t.Subject.Contains('NLE') || t.Subject == 'Bad Address') {
                        c.isExclude__c= true;  
                        checkisExclude = false;                 
                    }
                    else{
                        c.isExclude__c= false; 
                    }
                }
                if (t.Subject.Contains('Refused')) {
                    refusetosign = true;
                    break;
                }
                if (t.Subject.Contains('Signed Card')) {
                    signed = true;
                    break;
                }
                if (t.Subject.Contains('Not Home')) {
                    noonehome = true;
                    break;
                }
                if (t.Subject.Contains('Visit') || t.Subject.Contains('Refused')) {
                    visitedlast6months = true;
                    break;
                }
                
              
                }
                
                
                contact co = new contact();
                co = c;
                for (Task t : tasks) {                    
                    if(checkisExclude == true){
                        system.debug('value of checkisExclude  ' + checkisExclude );
                        system.debug('value of contact ' + co );
                        system.debug('Subject in task ' + t.Subject);
                        if(t.Subject != null){
                        if (t.Subject.Contains('NLE') || t.Subject.Contains('Bad Address')) {
                            co.isExclude__c= true;  
                            checkisExclude = false;  
                            system.debug('Inside loop' );               
                        }
                        else{
                            co.isExclude__c= false; 
                        }
                        }
                    }
                    if(cIDset.contains(co.id) == false){
                        updateList.add(co);
                        cIDset.add(co.id);
                    }
                }
                
                
            }
            
              if (refusetosign) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, true, true, false)) {
                    doupdate = true;
                }
              }
              else if (signed) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, false)) {
                    doupdate = true;
                }
              }
              else {
            if (noonehome) {
                if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, true)) {
                    doupdate = true;
                }
            }
            else {
                if (visitedlast6months) {
                    // atleast one task on contact which is not 'refused' or 'signed' or 'no one home', so make visitedlastsixmonths to true.
                    if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, true, false)) {
                        doupdate = true;
                    }
                }
                else {
                    //no tasks on contact, clear all flags
                    if (SOS_UpdateContactOnTaskChanges.updateContact(c, false, false, false)) {
                        doupdate = true;
                    }
                }
            }
        }
            
        if (doupdate) updateContacts.add(c);
             
        }
        
        updateContacts = updateList;
        if (updateContacts.size() > 0)
            update updateContacts;
        
    }
    
    
    
}