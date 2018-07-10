@isTest
private class SOS_ContactMethods3Test {
    static testMethod void TestCreateCompetedTaskTrigger() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = true;
        contact.Cope_Payment_Date__c  = Date.today();
        contact.IsJune5Action__c = false;
        contact.FID__c = '3312-23212491';

        insert contact;   
        System.assertEquals('Test',contact.FirstName);       
    }
    
     static testMethod void TestContactMethodsNEW() 
     {        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = false;
        contact.FID__c = '3312-23212492';
        insert contact;   
        SOS_ContactMethods3.ContactDTO contactDTO = new SOS_ContactMethods3.ContactDTO(contact.Id, false, 'Visit - Signed Card', 'notes', '10', '2014-05-31', false, false,
                                                                                     false,false,false,false,false,false,false,false,false,'');
        SOS_ContactMethods3 contactmethods = new SOS_ContactMethods3();
        contactmethods.UpdateContactRecord(contactDTO);
        contactmethods.GetLast5TasksForTheContact(contactDTO.ContactId);
        contactmethods.UpdateCopeAmount(contactDTO);
        contactmethods.UpdateContactRecordWorkerSite(contactDTO);
        System.assertEquals('Test',contact.FirstName);       
    }
    
    static testMethod void TestContactMethods() {
        
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = false;
        contact.FID__c = '3312-23212492';
        insert contact;   
        SOS_ContactMethods.ContactDTO contactDTO = new SOS_ContactMethods.ContactDTO(contact.Id, false, 'subject', 'notes', '','',true,true);
        SOS_ContactMethods contactmethods = new SOS_ContactMethods();
        contactmethods.UpdateContactRecord(contactDTO);
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
        contact.FID__c = '3312-23212493';
        insert contact;   
        Task t = new Task();
        t.WhoId = contact.Id;
        t.Subject = 'Refused to sign/anti-union';
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
        contact.FID__c = '3312-23212494';
        insert contact;   
        Task t = new Task();
        t.WhoId = contact.Id;
        t.Subject = 'No one home';
        insert t;
        System.assertEquals('Test',contact.FirstName);       
    }
   
}