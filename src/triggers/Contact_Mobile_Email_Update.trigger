trigger Contact_Mobile_Email_Update on Contact (before update) {
    
    //system.debug('[Phone][Email] Update Trigger Start');
      
    if(trigger.isupdate){            
        Contact_Mobile_Email_Clean.validateContactUpdate(Trigger.old, Trigger.new);               
    }
    
    //system.debug('[Phone][Email] Update Trigger End');
}