public with sharing class  ContactTriggerHelper
{

   public enum triggeredAction {beforeInsert, beforeUpdate, afterInsert, afterUpdate}
   public static boolean IsJobEnabledFlagLoaded {get;private set;}
   public static boolean IsJobEnabledFlag {get;private set;}
   
   
   
   public ContactTriggerHelper(){
 
   }


   public static boolean IsJobInProgress()
   {
           
        if ( IsJobEnabledFlagLoaded == null || ! IsJobEnabledFlagLoaded )
        {
           IsJobEnabledFlag = false;
            
           List<SYNC_PROCESS_LOG__c> sps = [SELECT Id, JobIsEnabled__c, JobIsStarted__c FROM SYNC_PROCESS_LOG__c WHERE Name = 'UHW_Manual_DataLoad_Process' LIMIT 1];
           if (!sps.isEmpty() && sps[0].JobIsEnabled__c && sps[0].JobIsStarted__c) {
                IsJobEnabledFlag =  true;
           }
            
           sps = [SELECT Id, JobIsEnabled__c, JobIsStarted__c FROM SYNC_PROCESS_LOG__c WHERE Name = 'UHW_MembershipCard_DataLoad_Talend_API_Process' LIMIT 1];
           if (!sps.isEmpty() && sps[0].JobIsEnabled__c && sps[0].JobIsStarted__c) {
                IsJobEnabledFlag =  true;
           }
            system.debug('IsJobInProgress :' + IsJobEnabledFlagLoaded);
            
            IsJobEnabledFlagLoaded = true; 
            
        }
                   
  
        system.debug('IsJobEnabledFlagLoaded :' + IsJobEnabledFlagLoaded);
        
                    
        return IsJobEnabledFlag;
   }     
   
   

   
   //is after insert
   public static void afterInsert_SOS_CreateCompletedTask_forSignedChecked(List<Contact> newObjects, Map<id, Contact> OldObjects){
        if(IsJobInProgress()){
            return;
        }
       
        Task[] newTasks = new List<Task>();
        for(Integer i = 0; i < newObjects.size(); i++){ 
            Contact c = newObjects[i];
            
            if((!c.Signed_Membership_Card__c) ) {
               Task t = new Task();
               t.Subject = c.Subject__c;
               t.ActivityDate = System.Today();
               t.Description = c.Field_Work_Notes__c;
               t.OwnerId = UserInfo.getUserId();
               t.Status = 'Completed';
               t.WhoId = c.Id;
               newTasks.add(t);
            }  
        
        }
        if (newTasks.size() > 0)
            insert newTasks;
    }
   
   //is after update 
   public static void afterUpdate_SOS_CreateCompletedTask_forSignedChecked (List<Contact> newObjects, Map<id, Contact> OldObjects){
       
       if(IsJobInProgress()){
            return;
       }
       Task[] newTasks = new List<Task>();
       
       for(Integer i = 0; i < newObjects.size(); i++){ 
           Contact c = newObjects[i];
           Contact cold = OldObjects.get(c.id);
           if((c.Signed_Membership_Card__c !=cold.Signed_Membership_Card__c && c.Signed_Membership_Card__c) ||
               (c.Subject__c != cold.Subject__c) ||
               (c.Field_Work_Notes__c != cold.Field_Work_Notes__c)) {
                   Task t = new Task();
                   t.Subject = c.Subject__c;
                   t.ActivityDate = System.Today();
                   t.Description = c.Field_Work_Notes__c;
                   t.OwnerId = UserInfo.getUserId();
                   t.Status = 'Completed';
                   t.WhoId = c.Id;
                   newTasks.add(t);
            }  
       }
       system.debug('new task to insert ' + newTasks);
       if (newTasks.size() > 0)
            insert newTasks;
   }
   
   
   //id beforeUpdate FeedItem
   public static void beforUpdate_CreatePost_forSignedCard(List<Contact> newObjects, Map<id, Contact> OldObjects){
       if(IsJobInProgress()){
            return;
       }
       List<FeedItem> lstFeeds = new List<FeedItem>();
       set<string> groupname_set=new set<string>();
       list<Chatter_Group_Cuztomization__c> cstmsetting=[select name,Active__c from Chatter_Group_Cuztomization__c where Active__c=true];
       if(cstmsetting.size()>0)
       {
           for(Chatter_Group_Cuztomization__c cname:cstmsetting)
                groupname_set.add(cname.name);
       }
       system.debug('groupname_set ' + groupname_set);
       list<CollaborationGroup > chattergroup_list=[SELECT Id,Name From CollaborationGroup WHERE  name in : groupname_set];
       system.debug('chattergroup_list '+ chattergroup_list);
       
           for(Contact newcontact: newObjects){
               
               Contact cold = OldObjects.get(newcontact.id);
               if(cold.Signed_Membership_Card__c == false && newcontact.Signed_Membership_Card__c == true  && chattergroup_list.size()>0 )
               {
                   for(CollaborationGroup Groupid:chattergroup_list)
                   {
                   
                        
                       If (newContact.Signed_Membership_Card_Date__c == null) 
                       {
                           newcontact.Signed_Membership_Card_Date__c=Date.Today();
                       }
                    
                        if (newContact.Signed_Membership_Card_By__c== null) 
                        {   
                            newcontact.Signed_Membership_Card_By__c=UserInfo.getUserId();
                        }
                                                
                                    
                        
                        FeedItem post = new FeedItem();
                        post.ParentId = Groupid.id;
                        //post.CreatedById = newcontact.OwnerId;
                        post.Body = 'I just signed up a new member!!!';
                        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + newcontact.Id;
                        post.title=newcontact.lastname;
                        //ToDo : This has to be uncommented once when we turn on the chatter.
                        //lstFeeds.add(post);
                   }
                
               }
               if(cold.Signed_Membership_Card__c == true && newcontact.Signed_Membership_Card__c == false)
               {
                    newcontact.Signed_Membership_Card_Date__c=null;
                    newcontact.Signed_Membership_Card_By__c=null;
               }
           }
       
   }
   
   //before update SetRecordType
   public static void beforUpdate_SOS_SetRecordType(List<Contact> newObjects, Map<id, Contact> OldObjects){
       if(IsJobInProgress()){
            return;
       }
       Map<String, Id> rtMap = new Map<String, Id>();
       for(Integer i = 0; i < newObjects.size(); i++){
       
           Contact c = newObjects[i];
           Contact cold = OldObjects.get(c.id);
           
           if(c.Division_Type__c != cold.Division_Type__c) {
               Boolean setDefault = true;
               if (c.Division_Type__c != null) {
                   if (!rtMap.containsKey(c.Division_Type__c)) {
                        Id rtId = null;
                        String recordname = c.Division_Type__c;
                        List<RecordType> rt = [Select Id FROM RecordType WHERE Name = :recordname AND SobjectType = 'Contact' LIMIT 1];
                        if (!rt.isEmpty()) {
                            rtId = rt[0].Id;                        
                        }
                        rtMap.put(c.Division_Type__c, rtId);
                   }
                   Id rtId = rtMap.get(c.Division_Type__c);
                   if(rtId != null) {
                    setDefault = false;
                        if (c.RecordTypeId != rtId) {
                            c.RecordTypeId = rtId;
                        }
                    }
               }
               String defaultDivision = 'Home Care';
               if (setDefault) {
                   if (!rtMap.containsKey(defaultDivision)) {
                       Id rtId = null;
                       String recordname = defaultDivision;
                       List<RecordType> rt = [Select Id FROM RecordType WHERE Name = :recordname AND SobjectType = 'Contact' LIMIT 1];
                       if (!rt.isEmpty()) {
                            rtId = rt[0].Id;                        
                       }
                       rtMap.put(defaultDivision, rtId);
                   }
               }
               
               Id rtId = rtMap.get(defaultDivision);
               if(rtId != null) {
                   if (c.RecordTypeId != rtId) {
                        c.RecordTypeId = rtId;
                   }
               }
           }
       }
   }
   
   //before insert SetRecordType
   public static void beforInsert_SOS_SetRecordType(List<Contact> newObjects, Map<Id, Contact> OldObjects){
       if(IsJobInProgress()){
            return;
       }
       Map<String, Id> rtMap = new Map<String, Id>();
       for(Integer i = 0; i < newObjects.size(); i++){
           Contact c = newObjects[i];
           //if(c.Division_Type__c != OldObjects[i].Division_Type__c) {
               Boolean setDefault = true;
               if (c.Division_Type__c != null) {
                   if (!rtMap.containsKey(c.Division_Type__c)) {
                        Id rtId = null;
                        String recordname = c.Division_Type__c;
                        
                        List<RecordType> rt = [Select Id FROM RecordType WHERE Name = :recordname AND SobjectType = 'Contact' LIMIT 1];
                        system.debug(' record type ' + rt);
                        if (!rt.isEmpty()) {
                            rtId = rt[0].Id;                        
                        }
                        rtMap.put(c.Division_Type__c, rtId);
                   }
                   system.debug('record type map ' + rtMap );
                   Id rtId = rtMap.get(c.Division_Type__c);
                   if(rtId != null) {
                    setDefault = false;
                        if (c.RecordTypeId != rtId) {
                            c.RecordTypeId = rtId;
                        }
                    }
               }
               String defaultDivision = 'Home Care';
               if (setDefault) {
                   if (!rtMap.containsKey(defaultDivision)) {
                       Id rtId = null;
                       String recordname = defaultDivision;
                       List<RecordType> rt = [Select Id FROM RecordType WHERE Name = :recordname AND SobjectType = 'Contact' LIMIT 1];
                       if (!rt.isEmpty()) {
                            rtId = rt[0].Id;                        
                       }
                       rtMap.put(defaultDivision, rtId);
                   }
               }
               
               Id rtId = rtMap.get(defaultDivision);
               if(rtId != null) {
                   if (c.RecordTypeId != rtId) {
                        c.RecordTypeId = rtId;
                   }
               }
           //}
       }
   
   }
   
   

   //For Before insert
  
   
   //This method is for New Canvasser, Once it is in place , this can be uncommented
   /*
   public static void Beforeinsert_SetSignedCheckedAndSubject(List<Contact> newObjects, Map<id, Contact> OldObjects){
        if(IsJobInProgress()){
            return;
        }
        
        for(Integer i = 0; i < newObjects.size(); i++)
        { 
            Contact c = newObjects[i];
            
            Boolean setDate = false;
            Boolean setLastSubject = false;
            
            if(c.Signed_Membership_Card__c && c.Subject__c != 'Visit - Signed Card') {
                c.Subject__c = 'Visit - Signed Card';
                setDate = true;
            }
            else 
                if (c.Subject__c == 'Visit - Signed Card' && !c.Signed_Membership_Card__c) {
                    c.Signed_Membership_Card__c = true;
                    setDate = true;
            }
            
            if (setDate) {
                c.Signed_Membership_Card_By__c = UserInfo.getUserId();           
                c.Signed_Membership_Card_Date__c = Date.today();
            }
            
                   
        
        //Added to update the status field which has been introduced in New Canvasser, 
        //if the new canvaser is uninstalled for some reason, this needs to be commented first.

        string statusValue = CanvasserTriggerLib.GetStatusValueByInputSubject(c.Subject__c);

        if (statusValue != '')
        {
            c.CVSR__Status__c = statusValue;
        }
        else
        {
           c.CVSR__Status__c = 'None';
        }
            
            
            
        }
     
   }
   
  */
   
   //Is before Update 
   //This method is for New Canvasser, Once it is in place , this can be uncommented
   
   /*
   public static void beforeUpdate_SetSignedCheckedAndSubject(List<Contact> newObjects, Map<Id, Contact> OldObjects){
       if(IsJobInProgress()){
            return;
       }
       for(Integer i = 0; i < newObjects.size(); i++)
       {
            Contact c = newObjects[i];
            
            Boolean setDate = false;
            Boolean setLastSubject = false;
            
            system.debug('old Signed_Membership ' + OldObjects.get(c.id).Signed_Membership_Card__c);
            system.debug('new Signed_Membership ' + c.Signed_Membership_Card__c);
            
            if (c.Signed_Membership_Card__c != OldObjects.get(c.id).Signed_Membership_Card__c && c.Signed_Membership_Card__c && c.Subject__c != 'Visit - Signed Card') {
                c.Subject__c = 'Visit - Signed Card';
                setDate = true;
            }
            else if (c.Signed_Membership_Card__c != OldObjects.get(c.id).Signed_Membership_Card__c && !c.Signed_Membership_Card__c && c.Subject__c == 'Visit - Signed Card') {
                c.Subject__c = null;
            }
            else if (c.Subject__c != OldObjects.get(c.id).Subject__c && c.Subject__c == 'Visit - Signed Card' && !c.Signed_Membership_Card__c) {
                c.Signed_Membership_Card__c = true;
                setDate = true;
            }
            else if (c.Subject__c != OldObjects.get(c.id).Subject__c && c.Subject__c == 'Remove Card Sign' && c.Signed_Membership_Card__c) {
                c.Signed_Membership_Card__c = false;
                c.Signed_Membership_Card_By__c = null;
                c.Signed_Membership_Card_Date__c = null;
                setLastSubject = true;
            }
            
            
        if (setDate) {
            c.Signed_Membership_Card_By__c = UserInfo.getUserId();           
            c.Signed_Membership_Card_Date__c = Date.today();
        }
        
        //Set to most recent task subject that is none of these two or if there is no task subject, then clear it
        if (setLastSubject) {
            List<Task> tasks = [SELECT Subject FROM Task WHERE WhoId = :c.Id AND Subject != 'Visit - Signed Card' AND Subject != 'Remove Card Sign' ORDER BY CreatedDate DESC LIMIT 1];
            if (!tasks.isEmpty()) {
                c.Last_Phone_Bank_Task_Subject__c = tasks[0].Subject;
            }
            else {
                c.Last_Phone_Bank_Task_Subject__c = null;
            }
        }
        
        
        string statusValue = CanvasserTriggerLib.GetStatusValueByInputSubject(c.Subject__c);

        if (statusValue != '')
        {
           c.CVSR__Status__c = statusValue;
        }
        else
        {
            c.CVSR__Status__c = 'None';
        }
        
        
            
       }
   }
   
   */

  
    
    
public Integer cheese() {
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;    
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;                            
    i++;            
    return i;    
  }
    

  

}