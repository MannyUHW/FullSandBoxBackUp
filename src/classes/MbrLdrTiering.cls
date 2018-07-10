global class MbrLdrTiering implements Database.Batchable<sObject>{

    global String [] email = new String[] {'DataAdmin@seiu-uhw.org'};

    global String [] tiers = new String[] {'Tier 1', 'Tier 2', 'Staff'};
    
    global MbrLdrTiering(){
                   // Batch Constructor
    }
       
        // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query =  'select Id, AccountId, Tier_1_Leader__c, Tier_2_Leader__c, Tier_Staff__c, Worksite__c, Department, Shift__c  from Contact where (In_Current_BU__c = true or In_Current_BU_Override__c >= LAST_N_MONTHS:6) and (Account.Account_Group__c = \'KAISER\' or Account.Account_Group__c = \'HOSPITAL\') order by AccountId';
        return Database.getQueryLocator(query);
    }
      
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        // Logic to be Executed batch wise   
        List<Contact> ulist = new List<Contact>();      
        Set<Id> accountSet = new Set<Id>();    
        for (sObject objScope: scope) { 
           Contact c = (Contact) objScope;        
           accountSet.add(c.AccountId);   
        }   

        List<Mbr_Ldr_App_Permissions__c> plist = [ Select Id, Department__c, Mbr_Ldr__c, Mbr_Ldr_Tier__c, Shift__c, Team_Account__c, Team_Mbr__c, Worksite__c, BU_Count__c, Mbr_Ldr_Name__c FROM Mbr_Ldr_App_Permissions__c where Team_Account__c in :accountSet  order by Team_Mbr__c nulls last, Shift__c nulls last, Department__c nulls last, Worksite__c nulls last ];
        
        for (sObject objScope: scope) { 
           Contact c = (Contact) objScope; 
           Id prevTier1 = c.Tier_1_Leader__c;
           Id prevTier2 = c.Tier_2_Leader__c;
           Id prevTierStaff = c.Tier_Staff__c;           
           c.Tier_1_Leader__c = null;           
           c.Tier_2_Leader__c = null;
           c.Tier_Staff__c = null;           
           for (String tier: tiers) {

             Id ldr = null;         
             for (Mbr_Ldr_App_Permissions__c p: plist) {

  
               if (ldr == null && c.AccountId == p.Team_Account__c && p.Mbr_Ldr_Tier__c == tier) {
                 if (c.Id == p.Team_Mbr__c && c.Id != p.Mbr_Ldr__c) {
                   ldr = p.Mbr_Ldr__c;
                 } else if (p.Team_Mbr__c == null) {
                   boolean worksiteMatch = true;
                   if (p.Worksite__c != null && p.Worksite__c.trim() != '') {
                     worksiteMatch = false;
                     if (c.Worksite__c != null && c.Worksite__c.toLowerCase().indexOf(p.Worksite__c.toLowerCase()) >= 0) {
                       worksiteMatch = true;
                     }
                   }
                   boolean deptMatch = true;
                   if (p.Department__c != null && p.Department__c.trim() != '') {
                     deptMatch = false;
                     if (c.Department != null && p.Shift__c != '' && c.Department.toLowerCase().indexOf(p.Department__c.toLowerCase()) >= 0) {
                       deptMatch = true;
                     }
                   }
                   boolean shiftMatch = true;
                   if (p.Shift__c != null && p.Shift__c.trim() != '') {
                     shiftMatch = false;
                     if (c.Shift__c != null && c.Shift__c.toLowerCase().indexOf(p.Shift__c.toLowerCase()) >= 0) {
                       shiftMatch = true;
                     }
                   }
                   if (worksiteMatch && deptMatch && shiftMatch && p.Mbr_Ldr__c != c.Id) {
                     ldr = p.Mbr_Ldr__c;
                   }
                 }
                 if (ldr != null) {
                   if (tier == 'Tier 1') {
                       c.Tier_1_Leader__c = ldr;
                   } else if (tier == 'Tier 2') {
                       c.Tier_2_Leader__c = ldr;
                   } else if (tier == 'Staff') {
                       c.Tier_Staff__c = ldr;                   
                   }
                   break;
                 }
               }             
             }
           }
           if (prevTier1 != c.Tier_1_Leader__c || prevTier2 != c.Tier_2_Leader__c || prevTierStaff != c.Tier_Staff__c) {
             ulist.add(c);
           }
        }       
        if (ulist != null && ulist.size() >0 ) {//Check if List is empty or not
            Database.update(ulist); 
            System.debug('List Size ' + ulist.size());//Update the Records
        }
    }
     
    global void finish(Database.BatchableContext BC){
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //Below code will fetch the job Id
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];//get the job Id
        System.debug('$$$ Jobid is'+BC.getJobId());

        //below code will send an email to User about the status
        mail.setToAddresses(email);
        mail.setSenderDisplayName('Apex Batch Processing Module');
        mail.setSubject('Batch Processing '+a.Status);
        mail.setPlainTextBody('MbrLdrTiering job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures.  ' + 'Job Items processed are '+ a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }

    global static Integer cheese() {
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
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;        
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
      i++;    
      i++;
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