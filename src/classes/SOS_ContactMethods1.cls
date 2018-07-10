public class SOS_ContactMethods1 {
  

    public Boolean UpdateContactRecord(ContactDTO dto) {    
    
        Contact contact = [SELECT Id, Signed_Membership_Card__c, Cope_Payment_Date__c, ID_Leaders__c,
                            Leader_Recruited__c,Verbal_Support__c,Public_Support__c,Organizer_IDd_as_Leader__c,
                            Coworker_IDd_as_Leader__c,Cross_Match_UHW__c,Cross_Match_NUHW__c,Cross_Match_CNA__c, LOA__c, X1_1_complete__c, X1_1_set__c, Previous_Supporter_Target__c , 
                            Verbal_Assessment__c,Field_Work_Notes__c, Subject__c , Shift__c, Card_Assessment__c FROM Contact WHERE Id = :dto.ContactId LIMIT 1]; 
        
        if (contact == null) return false;
        contact.Signed_Membership_Card__c = dto.CardSigned;
        contact.Subject__c = dto.Subject;
        contact.Field_Work_Notes__c = dto.Notes;
        contact.ID_Leaders__c = dto.idLeaders;
        contact.Leader_Recruited__c = dto.leaderRecruited;
        //contact.Verbal_Support__c = dto.verbalSupport; 
        contact.Public_Support__c = dto.publicSupport;
        //contact.Organizer_IDd_as_Leader__c = dto.organiserId;
        //contact.Coworker_IDd_as_Leader__c = dto.coworkerId;
        contact.Cross_Match_UHW__c = dto.uhw;
        contact.Cross_Match_NUHW__c = dto.nuhw;
        contact.Cross_Match_CNA__c = dto.cna;
        contact.LOA__c = dto.loa;
        contact.X1_1_complete__c = dto.X1_1_complete;
        contact.X1_1_set__c = dto.X1_1_set;
        contact.Previous_Supporter_Target__c = dto.Previous_Supporter;
        

        system.debug('dto.cna: ' + dto.cna);
        
        if (dto.assessmentStage =='card')
        {
          contact.Card_Assessment__c = dto.verbalAssessment;
        }
        else
        {
          contact.Verbal_Assessment__c = dto.verbalAssessment;
        }
        
        
        contact.Shift__c = dto.Shift;
        
        if(dto.CopeFlag == true && contact.Cope_Payment_Date__c == null)
        {
            contact.Cope_Payment_Date__c = Date.Today();
        }
        
      
        
        update contact;
        return true;
    }
    
    public Boolean UpdateContactRecordWorkerSite(ContactDTO dto) {
        Contact contact = [SELECT Id, Signed_Membership_Card__c, Cope_Payment_Date__c, ID_Leaders__c,
                            Leader_Recruited__c,Verbal_Support__c,Public_Support__c,Organizer_IDd_as_Leader__c,
                            Coworker_IDd_as_Leader__c,Cross_Match_UHW__c,Cross_Match_NUHW__c,Cross_Match_CNA__c,LOA__c,
                            Verbal_Assessment__c, Field_Work_Notes__c, Subject__c, Shift__c FROM Contact WHERE Id = :dto.ContactId]; 
        
        if (contact == null) return false;
        contact.Signed_Membership_Card__c = dto.CardSigned;
        contact.Subject__c = dto.Subject;
        contact.Field_Work_Notes__c = dto.Notes;
        contact.ID_Leaders__c = dto.idLeaders;
        contact.Leader_Recruited__c = dto.leaderRecruited;
        //contact.Verbal_Support__c = dto.verbalSupport; 
        contact.Public_Support__c = dto.publicSupport;
        //contact.Organizer_IDd_as_Leader__c = dto.organiserId;
        //contact.Coworker_IDd_as_Leader__c = dto.coworkerId;
        contact.Cross_Match_UHW__c = dto.uhw;
        contact.Cross_Match_NUHW__c = dto.nuhw;
        contact.Cross_Match_CNA__c = dto.cna;
        contact.LOA__c = dto.loa;
        
        contact.X1_1_complete__c = dto.X1_1_complete;
        contact.X1_1_set__c = dto.X1_1_set;
        contact.Previous_Supporter_Target__c = dto.Previous_Supporter;
        
        
        contact.Verbal_Assessment__c = dto.verbalAssessment;
        contact.Shift__c = dto.Shift;

        
  
        
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
                          String cDate, Boolean pidLeaders, Boolean pleaderRecruited,
                          Boolean ppublicSupport,
                          Boolean puhw, Boolean pnuhw, boolean pcna, Boolean ploa, 
                          Boolean pX1_1_complete, 
                          Boolean pX1_1_set, 
                          Boolean pPrevious_Supporter, String pverbalAssessment, String Shift, String passessmentStage)
        {
            ContactId = pContactId;
            CardSigned = pCardSigned;
            Subject = pSubject;
            Notes = pNotes;
            copeAmount = cAmount;
            copeDate = cDate;
            //CopeFlag = cFlag;
            //IsJune5Action= pIsJune5Action;
            idLeaders = pidLeaders;
            leaderRecruited = pleaderRecruited;
            //verbalSupport =  pverbalSupport;      
            publicSupport =  ppublicSupport;      
            //organiserId =  porganiserId;      
            //coworkerId = pcoworkerId;       
            uhw = puhw;       
            nuhw = pnuhw;      
            cna= pcna;
            loa = ploa;   
            pX1_1_complete= X1_1_complete;
            pX1_1_set=X1_1_set;
            pPrevious_Supporter = Previous_Supporter;
            
            verbalAssessment = pverbalAssessment;
            assessmentStage = passessmentStage;
        }
        
        public String ContactId { get; set; }
        public Boolean CardSigned { get; set; }
        public String Subject { get; set; }
        public String Notes { get; set; }
        public String copeAmount { get; set; }
        public String copeDate { get; set; }
        public Boolean CopeFlag{get;set;}
        
        //public Boolean IsJune5Action{get;set;}
        public Boolean idLeaders{get;set;}
        public Boolean leaderRecruited{get;set;}
        //public Boolean verbalSupport{get;set;}       
        public Boolean publicSupport{get;set;}       
        //public Boolean organiserId{get;set;}       
        //public Boolean coworkerId{get;set;}       
        public Boolean uhw{get;set;}       
        public Boolean nuhw{get;set;}       
        public Boolean cna{get;set;}
        public Boolean loa{get;set;}
    public boolean X1_1_complete;
        public boolean X1_1_set;
        public boolean Previous_Supporter;          
          
        public string verbalAssessment{get;set;}
        public string assessmentStage{get;set;}
        
        public string Verbal_Assessment;
        public string buildingLocation;
         public string Shift;
        
                
        
         
        
    }
    
        
    
}