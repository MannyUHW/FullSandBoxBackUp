@isTest
public class PetitionLedger_Helper_Test {
    private static List<Contact> ContactListData(Account a_em){
        List<Contact> myContacts = new List<Contact>();
        
        Contact c0 = new Contact();
        //testLast_rd
        c0.FirstName='Jim';
        c0.LastName='testLast_rd';
        c0.Phone='999-999-9998';        
        c0.HomePhone='999-999-9998';
        c0.OtherPhone = '9999999999';        
        c0.FID__c = '9999-15999' + (1001);
        c0.Title = 'LVN';
        c0.MailingPostalCode = '90022';
        c0.email = 'goodemail@hospital.com';
        c0.Other_Emails_Any__c = 'goodemail@hospital.com;bademail@gov.gov;email@test.io';
        c0.account = a_em;
        c0.AccountId = a_em.Id;
        myContacts.add(c0); 
        
        Contact c1 = new Contact();
        c1.FirstName='Test';
        c1.LastName='Dude';
        c1.Phone='999-999-9999';
        c1.MobilePhone = '234-567-8910';
        c1.OtherPhone = '9999999999';
        c1.Other_Phone_Any__c = '1(234) 567-8910';
        c1.HomePhone='999-999-9999';        
        c1.FID__c = '9999-15999' + (1002);
        c1.Title = 'LVN';
        c1.MailingPostalCode = '90000';
        c1.Email = 'dupemail@this.org';
        c1.account = a_em;
        c1.AccountId = a_em.Id;
        myContacts.add(c1);
        
        Contact c2 = new Contact();
        c2.FirstName = 'Claudia';
        c2.LastName = 'Rodriguez';
        c2.RecordTypeId = '012i0000000xkjW';
        c2.FID__c = '9999-15999' + (1003);
        myContacts.add(c2);
        return myContacts;
    }
    static testMethod void TestPetitionLedgerTrigger(){
        
        // setup test account data
        Account em = new Account(name='Test Employer');
        //userfields
        //UserName, LastName, Email, Alias, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey
        User u_rd = new User(username = 'testusername_rd@test.com',FirstName='Jim', LastName='testLast_rd', Email='test1@test.com',Alias='tester1',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',ProfileId='00ei0000001lsbx',LanguageLocaleKey='en_US');
        insert u_rd;
        User u_claudRod = new User(username = 'crodriguez@seiu-uhw.org.test',FirstName='Claudia', LastName='Rodriguez', Email='crodriguez=seiu-uhw.org@example.com',Alias='Rodrigue',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',ProfileId='00ei0000001lsbx',LanguageLocaleKey='en_US',Department='KAISER',Division='KAISER');
        insert u_claudRod;
        User u_cr = new User(username = 'testusername_cr@test.com', LastName='testLast_cr', Email='test2@test.com',Alias='tester2',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',ProfileId='00ei0000001lsbx',LanguageLocaleKey='en_US');
        insert u_cr;
        //User u_rd = [SELECT Id, IsActive FROM User WHERE username = 'crodriguez@seiu-uhw.org.seiudev14'];
        //User u_cr = [SELECT Id, IsActive FROM User WHERE username = 'kmartin@seiu-uhw.org.seiudev14'];
        em.Regional_Director__c = u_claudRod.Id;        
        em.Coordinator__c = u_cr.Id;
        em.Organizer_1__c = u_rd.Id;
        //system.debug('[PetLed] Coordinator Id:'+u_cr.Id);
        em.County__c = 'Los Angeles';
        em.BU_Count__c = 25;
        insert em;
        //system.debug('[PetLed] acct check:' + em)        ;
        // Insert test Contacts
        List<Contact> cons = ContactListData(em);       
        insert cons;
        
        UHW_Campaign__c uhwcamp = new UHW_Campaign__c();
        uhwcamp.Name = 'Test Campaign Consolation 2017';        
        insert uhwcamp;
        
        system.debug('[PetLed] Start');
        
        List<Petition_Ledger__c> pls = new List<Petition_Ledger__c>();
        
        //
        
        //test petition ledger trigger
        Petition_Ledger__c pl = new Petition_Ledger__c();
        pl.UHW_Campaign__c = uhwcamp.Id;
        pl.Transferred_To__c = cons[2].Id;
        pl.Transfer_Type__c = 'P. Printed Petitions Delivered To';
        pl.Quantity__c = 500;
        pl.County__c = 'Los Angeles';                
               
        pls.add(pl);
        
        Petition_Ledger__c pl2 = new Petition_Ledger__c();
        pl2.UHW_Campaign__c = uhwcamp.Id;
        pl2.Transferred_To__c = cons[1].Id;
        pl2.Transfer_Type__c = 'M. Member Leader Check-Out';
        pl2.Transferred_From__c = cons[2].Id;
        pl2.Quantity__c = 100;
        pl2.County__c = 'Los Angeles'; 
        
        pls.add(pl2);
        
        Petition_Ledger__c pl3 = new Petition_Ledger__c();
        pl3.UHW_Campaign__c = uhwcamp.Id;
        pl3.Transferred_To__c = cons[0].Id;
        pl3.Transfer_Type__c = 'S. Staff Check-Out';
        pl3.Transferred_From__c = cons[1].Id;
        pl3.Quantity__c = 50;
        pl3.County__c = 'Los Angeles';
        pls.add(pl3);
        
        insert pls;
        
        pls[0].Quantity__c = 400;        
        update pls;
        
        List<Contact> c = [Select LastName, Id, PetitionQty__c From Contact Where Id in :cons];
        for(Contact person:c){
            system.debug('[PetLed] quantity for '+person.LastName+':'+person.PetitionQty__c);
            if(person.LastName == cons[0].LastName){
                system.assertEquals(50, person.PetitionQty__c);
            }
            if(person.LastName == cons[1].LastName){
                system.assertEquals(50, person.PetitionQty__c);
            }
            if(person.LastName == cons[2].LastName){
                system.assertEquals(300, person.PetitionQty__c);
            }
        }
        
        system.debug('[PetLed] End');
    }
    static testMethod void TestPLController(){
        PageReference pageRef = Page.PetitionTracking;
        Test.setCurrentPage(pageRef);                
        
        try{
            //get exception with no active petition campaigns
            plController ctlr0 = new plController();
        }catch(Exception e){
        }        

        UHW_Campaign__c uhwcamp = new UHW_Campaign__c();
        uhwcamp.Name = 'Test Campaign 2017'; 
        uhwcamp.Petition_Campaign__c = true;
        insert uhwcamp;                
        
        // setup test account data
        Account em = new Account(name='Test Employer');
		insert em;
        List<Contact> testContacts = ContactListData(em);
		insert testContacts;
        User u = new User(username = 'testusername_rd@test.com',FirstName='Jim', LastName='testLast', Email='test1@test.com',Alias='tester1',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',ProfileId='00ei0000001lsbx',LanguageLocaleKey='en_US',Staff_Contact_Id__c = testContacts[0].Id);
        insert u;
        
        System.RunAs(u){
            plController ctlr = new plController();            
        }        

        //test contact name search method
        List<Contact> test_sosl_cntcts = plController.sosl_remote('test',u.username,false);
        
        //testing recent contact controller method
        List<Contact> listRecentCntcs = new List<Contact>();
        listRecentCntcs = plController.listContacts_recentv1(u.username, true);

        List<Contact> c_test = new List<Contact>([Select Id From Contact LIMIT 20]);
        
        //making serialized json pl ledger entries for test saves from page
        //single entry case                
        /*
        system.debug('[PL_Cntlr]Finding contact ID for ledger entries - size:'+testContacts.size());
        system.debug('[PL_Cntlr]Finding contact ID for ledger entries - object list:'+testContacts);
        system.debug('[PL_Cntlr]Finding contact ID for ledger entries - size:'+listRecentCntcs.size());
        system.debug('[PL_Cntlr]Finding contact ID for ledger entries - object list:'+listRecentCntcs);
        system.debug('[PL_Cntlr]Finding contact ID for ledger entries - size:'+c_test.size());
        system.debug('[PL_Cntlr]Finding contact ID for ledger entries - object list:'+c_test);
        */

        Petition_Ledger__c pl_s = new Petition_Ledger__c();

        pl_s.Transferred_To__c = c_test[0].Id;
        pl_s.Transferred_From__c = c_test[1].Id;
        pl_s.Transfer_Type__c = 'S. Staff Check-Out';
        pl_s.Quantity__c = 40;
        pl_s.UHW_Campaign__c = uhwcamp.Id;
        system.debug('[pl_cntrlr] single entry object:'+pl_s);
        string json_singlePL = JSON.serialize(pl_s);
        system.debug('[pl_cntrlr] single entry serialized json:'+json_singlePL);
        plController.saveXfrEntry(json_singlePL);
                
        //multiple entry case
        List<Petition_Ledger__c> pl_l = new List<Petition_Ledger__c>();
        string json_ListPL = JSON.serialize(pl_l);
        try{
            plController.saveCheckInEntries(json_ListPL);
        }catch(Exception e){
        }
        pl_l.add(pl_s);
        json_ListPL = JSON.serialize(pl_l);
        plController.saveCheckInEntries(json_ListPL);

        ctrlr_rpt cr = new ctrlr_rpt();
        List<Petition_Ledger__c> all_pl = ctrlr_rpt.getData('Select Id From Petition_Ledger__c');
        List<Petition_Ledger__c> new_pl_data = ctrlr_rpt.pl_getRecords(null);
        
    }
}