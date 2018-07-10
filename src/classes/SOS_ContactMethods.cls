public class SOS_ContactMethods {
    public Boolean UpdateContactRecord(ContactDTO dto) {
        Contact contact = [SELECT Id, Signed_Membership_Card__c, Cope_Payment_Date__c, 
                            Field_Work_Notes__c, Subject__c FROM Contact WHERE Id = :dto.ContactId]; 
        
        if (contact == null) return false;
        contact.Signed_Membership_Card__c = dto.CardSigned;
        contact.Subject__c = dto.Subject;
        contact.Field_Work_Notes__c = dto.Notes;
        
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
        public ContactDTO(String pContactId, Boolean pCardSigned, String pSubject, String pNotes, String cAmount, String cDate, Boolean cFlag, Boolean pIsJune5Action) {
            ContactId = pContactId;
            CardSigned = pCardSigned;
            Subject = pSubject;
            Notes = pNotes;
            copeAmount = cAmount;
            copeDate = cDate;
            CopeFlag = cFlag;
            IsJune5Action= pIsJune5Action;
        }
        public String ContactId { get; set; }
        public Boolean CardSigned { get; set; }
        public String Subject { get; set; }
        public String Notes { get; set; }
        public String copeAmount { get; set; }
        public String copeDate { get; set; }
        public Boolean CopeFlag{get;set;}
        public Boolean IsJune5Action{get;set;}
        
        
    }
    
        
    
}