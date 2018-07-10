public class SOS_ContactMethods3 {
    public Boolean UpdateContactRecord(ContactDTO dto) {    
    
        Contact contact = [SELECT Id, Signed_Membership_Card__c, Cope_Payment_Date__c, ID_Leaders__c,
                            Leader_Recruited__c,Verbal_Support__c,Public_Support__c,Organizer_IDd_as_Leader__c,
                            Coworker_IDd_as_Leader__c,Cross_Match_UHW__c,Cross_Match_NUHW__c,LOA__c,
                            Verbal_Assessment__c,Field_Work_Notes__c, Subject__c FROM Contact WHERE Id = :dto.ContactId]; 
        
        if (contact == null) return false;
        contact.Signed_Membership_Card__c = dto.CardSigned;
        contact.Subject__c = dto.Subject;
        contact.Field_Work_Notes__c = dto.Notes;
        contact.ID_Leaders__c = dto.idLeaders;
        contact.Leader_Recruited__c = dto.leaderRecruited;
        contact.Verbal_Support__c = dto.verbalSupport; 
        contact.Public_Support__c = dto.publicSupport;
        contact.Organizer_IDd_as_Leader__c = dto.organiserId;
        contact.Coworker_IDd_as_Leader__c = dto.coworkerId;
        contact.Cross_Match_UHW__c = dto.uhw;
        contact.Cross_Match_NUHW__c = dto.nuhw;
        contact.LOA__c = dto.loa;
        contact.Verbal_Assessment__c = dto.verbalAssessment;
        
        if(dto.CopeFlag == true && contact.Cope_Payment_Date__c == null)
        {
            contact.Cope_Payment_Date__c = Date.Today();
        }
        
        if (dto.IsJune5Action)
        {
          contact.IsJune5Action__c = dto.IsJune5Action;
        }
        
        update contact;
        return true;
    }
    
    
    public Boolean UpdateContactRecordWorkerSite(ContactDTO dto) {
        Contact contact = [SELECT Id, Signed_Membership_Card__c, Cope_Payment_Date__c, ID_Leaders__c,
                            Leader_Recruited__c,Verbal_Support__c,Public_Support__c,Organizer_IDd_as_Leader__c,
                            Coworker_IDd_as_Leader__c,Cross_Match_UHW__c,Cross_Match_NUHW__c,LOA__c,
                            Verbal_Assessment__c, Field_Work_Notes__c, Subject__c FROM Contact WHERE Id = :dto.ContactId]; 
        
        if (contact == null) return false;
        contact.Signed_Membership_Card__c = dto.CardSigned;
        contact.Subject__c = dto.Subject;
        contact.Field_Work_Notes__c = dto.Notes;
        contact.ID_Leaders__c = dto.idLeaders;
        contact.Leader_Recruited__c = dto.leaderRecruited;
        contact.Verbal_Support__c = dto.verbalSupport; 
        contact.Public_Support__c = dto.publicSupport;
        contact.Organizer_IDd_as_Leader__c = dto.organiserId;
        contact.Coworker_IDd_as_Leader__c = dto.coworkerId;
        contact.Cross_Match_UHW__c = dto.uhw;
        contact.Cross_Match_NUHW__c = dto.nuhw;
        contact.LOA__c = dto.loa;
        contact.Verbal_Assessment__c = dto.verbalAssessment;
        
        if(dto.CopeFlag == true && contact.Cope_Payment_Date__c == null)
        {
            contact.Cope_Payment_Date__c = Date.Today();
        }
        
        if (dto.IsJune5Action)
        {
          contact.IsJune5Action__c = dto.IsJune5Action;
        }
        
        update contact;
        return true;
    }    
    
     public Boolean UpdateCopeAmount(ContactDTO dto) {
        Contact contact = [SELECT Id, Subject__c, Cope_Payment_Date__c, Cope_Amount__c FROM Contact WHERE Id = :dto.ContactId]; 
        if (contact == null) return false;
        contact.Cope_Payment_Date__c = Date.valueOf(dto.copeDate);
        contact.Cope_Amount__c = Decimal.valueOf(dto.copeAmount);
        contact.Subject__c = string.valueOf(contact.Subject__c);
        update contact;
        return true;
    }
    
    public List<Task> GetLast5TasksForTheContact(String ContactID) {
        return [SELECT Id, Subject, ActivityDate, Description FROM Task WHERE WhoId = :ContactID ORDER BY CreatedDate DESC LIMIT 5];
    }
    
    
    public class ContactDTO {
        public ContactDTO() {}
        public ContactDTO(String pContactId, Boolean pCardSigned, String pSubject,String pNotes, String cAmount, 
                          String cDate, Boolean cFlag, Boolean pIsJune5Action,Boolean pidLeaders, Boolean pleaderRecruited,
                          Boolean pverbalSupport, Boolean ppublicSupport,Boolean porganiserId, Boolean pcoworkerId,
                          Boolean puhw, Boolean pnuhw, Boolean ploa,String pverbalAssessment)
        {
            ContactId = pContactId;
            CardSigned = pCardSigned;
            Subject = pSubject;
            Notes = pNotes;
            copeAmount = cAmount;
            copeDate = cDate;
            CopeFlag = cFlag;
            IsJune5Action= pIsJune5Action;
            idLeaders = pidLeaders;
            leaderRecruited = pleaderRecruited;
            verbalSupport =  pverbalSupport;      
            publicSupport =  ppublicSupport;      
            organiserId =  porganiserId;      
            coworkerId = pcoworkerId;       
            uhw = puhw;       
            nuhw = pnuhw;       
            loa = ploa;   
            verbalAssessment = pverbalAssessment;
        }
        
        public String ContactId { get; set; }
        public Boolean CardSigned { get; set; }
        public String Subject { get; set; }
        public String Notes { get; set; }
        public String copeAmount { get; set; }
        public String copeDate { get; set; }
        public Boolean CopeFlag{get;set;}
        public Boolean IsJune5Action{get;set;}
        public Boolean idLeaders{get;set;}
        public Boolean leaderRecruited{get;set;}
        public Boolean verbalSupport{get;set;}       
        public Boolean publicSupport{get;set;}       
        public Boolean organiserId{get;set;}       
        public Boolean coworkerId{get;set;}       
        public Boolean uhw{get;set;}       
        public Boolean nuhw{get;set;}       
        public Boolean loa{get;set;}  
        public string verbalAssessment{get;set;} 
        
    }
    
        
    
}