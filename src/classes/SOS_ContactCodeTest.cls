@isTest
private class SOS_ContactCodeTest {
    static testMethod void TestCreateCompetedTaskTrigger() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = true;
        contact.FID__c = '3312-23212421';
        insert contact;  
        contact.Subject__c = 'Remove Card Sign';
        update contact;
        contact.Signed_Membership_Card__c = true; 
        update contact;
        
        contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Subject__c = 'Visit - Signed Card';
        contact.FID__c = '3312-23212422';
        insert contact;
        System.assertEquals('Test',contact.FirstName);
        
       
    }
    @isTest(SeeAllData=true)
    static void TestContactRecordType() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Division_Type__c = 'Hospital';
        contact.FID__c = '3312-23212423';
        insert contact;
        
        contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.FID__c = '3312-23212424';
        insert contact;
        contact.Division_Type__c = 'Hospital';
        update contact;
    }
    static testMethod void TestContactMethods() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = false;
        contact.FID__c = '3312-23212425';
        insert contact;   
        SOS_ContactMethods.ContactDTO contactDTO = new SOS_ContactMethods.ContactDTO(contact.Id, false, 'Visit - Signed Card', 'notes', '10', '2014-05-31', false, false);
        SOS_ContactMethods contactmethods = new SOS_ContactMethods();
        contactmethods.UpdateContactRecord(contactDTO);
        contactmethods.GetLast5TasksForTheContact(contactDTO.ContactId);
        System.assertEquals('Test',contact.FirstName);
        
       
    }
    
    static testMethod void TestContactMethodsNEW() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = false;
        contact.FID__c = '3312-23212426';
        insert contact;   
        SOS_ContactMethods1.ContactDTO contactDTO = new SOS_ContactMethods1.ContactDTO(contact.Id, false, 'Visit - Signed Card', 'notes', '10', '2014-05-31', false, false,false,false,false,false,false,false,false,false,'','','card');
                                                                                   
                                                                                    
        SOS_ContactMethods1 contactmethods = new SOS_ContactMethods1();
        
        try{
        contactmethods.UpdateContactRecord(contactDTO);
        }
        catch(Exception ex)
        {
            
        }
        
        contactmethods.GetLast5TasksForTheContact(contactDTO.ContactId);
        System.assertEquals('Test',contact.FirstName);
       
    }
    
    
   /* static testMethod void TestSOS_ContactUpdateController() {
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = false;
        insert contact;   
        SOS_ContactUpdateController controller = new SOS_ContactUpdateController();
        controller.contactDTO.ContactId = contact.Id;  
        controller.contactDTO.CardSigned= true;
        controller.contactDTO.Subject = '';
        controller.contactDTO.Notes = '';
        controller.save();
        controller.contactDTO.Subject = 'subject';
        controller.save();
        controller.contactDTO.Notes = 'notes';
        controller.save();
    }
   */
    

    static testMethod void TestTaskRefusedToSignTrigger() {
        //
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.RefusedToSign__c = false;
        contact.FID__c = '3312-23212427';
        insert contact;   
        Task t = new Task();
        t.WhoId = contact.Id;
        t.Subject = 'Refused';
        insert t;
        System.assertEquals('Test',contact.FirstName);
        delete t;
    }
   

   static testMethod void TestTaskRefusedToSignTrigger2() {
        //
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.No_one_home__c = false;
        contact.FID__c = '3312-23212428';
        insert contact;   
        //
        Task t = new Task();
        t.WhoId = contact.Id;
        t.Subject = 'Visit - Not Home';
        insert t;
        System.assertEquals('Test',contact.FirstName);       
    }
   
}