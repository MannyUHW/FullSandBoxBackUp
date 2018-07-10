@isTest
public class Contact_Mobile_Email_Clean_Test {
    private static List<Contact> ContactListData(Account a_em){
        List<Contact> myContacts = new List<Contact>();
        // setup test contact data
        Contact c0 = new Contact();
        c0.FirstName='Test';
        c0.LastName='User1';
        c0.Phone='999-999-9998';        
        c0.HomePhone='999-999-9998';
        c0.OtherPhone = '9999999999';        
        c0.FID__c = '9999-15999' + (1001);
        c0.Title = 'LVN';
        c0.MailingPostalCode = '90022';
        c0.email = 'goodemail@hospital.com';
        c0.Other_Emails_Any__c = 'goodemail@hospital.com;bademail@gov.gov;email@test.io';
        c0.account = a_em;
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
        myContacts.add(c1);
        
        Contact c2 = new Contact();
        c2.FirstName='Test';
        c2.LastName='User2';
        c2.Phone='999-999-9997';        
        c2.HomePhone='999-999-9997';        
        c2.Other_Phone_Any__c = '1(234) 567-8910;999-999-9997;555-555-5555';
        c2.FID__c = '9999-15999' + (1003);
        c2.Title = 'LVN';
        c2.MailingPostalCode = '90001';
        c2.Email = 'bademail.com@somedept.gov';
        c2.account = a_em;
        myContacts.add(c2);

        Contact c3 = new Contact();
        c3.FirstName='Test';
        c3.LastName='User3';
        c3.Phone='999-999-9999';        
        c3.HomePhone='999-999-9999';        
        c3.MobilePhone = '1(234) 567-8910';
        c3.FID__c = '9999-15999' + (1004);
        c3.Title = 'LVN';
        c3.MailingPostalCode = '90000';
        c3.account = a_em;
        myContacts.add(c3);

        Contact c4 = new Contact();
        c4.FirstName='Test';
        c4.LastName='User4';
        c4.Phone='999-999-9999';        
        c4.HomePhone='999-999-9999';        
        c4.MobilePhone = '1(234) 567-8910';
        c4.OtherPhone = '999-999-9995';
        c4.Other_Phone_Any__c = '999-999-9997;999-999-9997;999-999-9999;999-999-9995;999-999-9996';
        c4.FID__c = '9999-15999' + (1005);
        c4.Title = 'LVN';
        c4.MailingPostalCode = '90060';
        c4.account = a_em;
        myContacts.add(c4);
        
        Contact c5 = new Contact();
        c5.FirstName='Test';
        c5.LastName='User5';
        c5.Phone='999-999-9990';        
        c5.HomePhone='999-999-9990';        
        c5.MobilePhone = '1(234) 567-8910';
        c5.OtherPhone = '(555) 545-5555';
        c5.FID__c = '9999-15999' + (1006);
        c5.Title = 'LVN';
        c5.MailingPostalCode = '90009';
        c5.account = a_em;
        myContacts.add(c5);
        
        Contact c6 = new Contact();
        c6.FirstName='Test';
        c6.LastName='User6';
        c6.Phone='999-999-9991';        
        c6.HomePhone='999-999-999';        
        c6.MobilePhone = '1(234) 567-8910';
        c6.FID__c = '9999-15999' + (1007);
        c6.Title = 'LVN';
        c6.MailingPostalCode = '90007';
        c6.account = a_em;
        myContacts.add(c6);
        
        Contact c7 = new Contact();
        c7.FirstName='Test';
        c7.LastName='User7';
        c7.Phone='999-999-9999';        
        c7.OtherPhone='2345678912';        
        c7.MobilePhone = '1(234) 567-8911';
        c7.FID__c = '9999-15999' + (1008);
        c7.Title = 'LVN';
        c7.MailingPostalCode = '90008';        
        c7.account = a_em;
        myContacts.add(c7);

        Contact c8 = new Contact();
        c8.FirstName='Test';
        c8.LastName='User8';                
        c8.MobilePhone = '1(234) 567-8888';
        c8.FID__c = '9999-15999' + (1009);
        c8.Title = 'LVN';
        c8.MailingPostalCode = '90009';        
        c8.account = a_em;
        myContacts.add(c8);
        
        Contact c9 = new Contact();
        c9.FirstName='Test';
        c9.LastName='User9';                
        c9.MobilePhone = '1(234) 567-8888';
        c9.OtherPhone = '1(234) 567-8899';
        c9.FID__c = '9999-15999' + (1010);
        c9.Title = 'LVN';
        c9.MailingPostalCode = '90010';        
        c9.account = a_em;
        myContacts.add(c9);
        
        Contact c10 = new Contact();
        c10.FirstName='Test';
        c10.LastName='User10';                
        c10.MobilePhone = '1(234) 567-8988';
        c10.OtherPhone = '1(234) 567-8999';
        c10.Other_Phone_Any__c = '(999) 999-9997';
        c10.FID__c = '9999-15999' + (1011);
        c10.Title = 'LVN';
        c10.MailingPostalCode = '90011';        
        c10.account = a_em;
        myContacts.add(c10);
        
        return myContacts;
    }
        
    static testMethod void TestPhoneTrigger() {
     
        // setup test account data
        Account em = new Account(name='Test Employer');
        insert em;
        
        // Insert test Contacts
        List<Contact> cons = ContactListData(em);       
        insert cons;        
        
                //output data to log before trigger fired
        for(Contact con :cons){
            System.debug('[Phone][Email] Contact Id: ' + con.Id);
            System.debug('[Phone]' + con.Id +' Phone before update trigger fired: ' + con.Phone);
            System.debug('[Phone]' + con.Id +' MobilePhone before update trigger fired:' + con.MobilePhone);
            System.debug('[Phone]' + con.Id +' HomePhone before update trigger fired: ' + con.HomePhone);
            System.debug('[Phone]' + con.Id +' OtherPhone before update trigger fired: ' + con.OtherPhone);
            System.debug('[Phone]' + con.Id +' OtherPhoneAny before update trigger fired: ' + con.Other_Phone_Any__c);
            System.debug('[Email]' + con.Id +' Email before update trigger fired: ' + con.Email);
            System.debug('[Email]' + con.Id +' OtherEmailAny before update trigger fired: ' + con.Other_Emails_Any__c);
        }
        
        // Contact mobile phone field update tests
        cons[0].MobilePhone = '1156459874135';  
        cons[0].Email = 'bademail@gov.gov';
        cons[1].MobilePhone = '(555) 545-5555';
        cons[1].Email = 'dupemail@this.org';
        cons[2].MobilePhone = '999-999-9997';
        cons[2].Email = 'testemail.blah@test.org';
        cons[3].MobilePhone = '(555) 555-5555';
        cons[4].Email = 'test@test.org';
        cons[4].MobilePhone = '011(234) 567-8911';
        cons[5].MobilePhone = '(555) 545-55555555555555';
        cons[6].MobilePhone = '(555) 545-555';
        cons[7].MobilePhone = '1102345678910';
        cons[8].MobilePhone = '';
        cons[9].MobilePhone = '';
        cons[10].MobilePhone = '';
        update cons;
        
        // Retrieve the contact data after the update
        List<Contact> c = [SELECT Phone, MobilePhone, HomePhone, OtherPhone, Other_Phone_Any__c, Email, Other_Emails_Any__c FROM Contact WHERE Id In :cons];
        
        
        //
        //output data to log after trigger fired
        for(Contact con :c){
            System.debug('[Phone][Email] Contact Id: ' + con.Id);
            System.debug('[Phone]' + con.Id +' Phone after update trigger fired: ' + con.Phone);
            System.debug('[Phone]' + con.Id +' MobilePhone after update trigger fired:' + con.MobilePhone);
            System.debug('[Phone]' + con.Id +' HomePhone after update trigger fired: ' + con.HomePhone);
            System.debug('[Phone]' + con.Id +' OtherPhone after update trigger fired: ' + con.OtherPhone);
            System.debug('[Phone]' + con.Id +' OtherPhoneAny after update trigger fired: ' + con.Other_Phone_Any__c);
            System.debug('[Email]' + con.Id +' Email after update trigger fired: ' + con.Email);
            System.debug('[Email]' + con.Id +' OtherEmailAny after update trigger fired: ' + con.Other_Emails_Any__c);
        }
        
        //asserts for after update expected values
        Map<Id, Contact> contcts_afterUpdate = new Map<Id, Contact>(c);
        system.assertEquals('(564) 598-7413', contcts_afterUpdate.get(cons[0].Id).MobilePhone);
        system.assertEquals('bademail@gov.gov', contcts_afterUpdate.get(cons[0].Id).Email);
        system.assertEquals('(555) 545-5555', contcts_afterUpdate.get(cons[1].Id).MobilePhone);
        system.assertEquals('(234) 567-8910', contcts_afterUpdate.get(cons[1].Id).OtherPhone);
        system.assertEquals('dupemail@this.org', contcts_afterUpdate.get(cons[1].Id).Email);
        system.assertEquals('(999) 999-9997', contcts_afterUpdate.get(cons[2].Id).MobilePhone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[2].Id).Phone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[2].Id).HomePhone);
        system.assertEquals('testemail.blah@test.org', contcts_afterUpdate.get(cons[2].Id).Email);
        system.assertEquals('bademail.com@somedept.gov', contcts_afterUpdate.get(cons[2].Id).Other_Emails_Any__c);
        system.assertEquals(null, contcts_afterUpdate.get(cons[3].Id).MobilePhone);
        system.assertEquals('(234) 567-8910', contcts_afterUpdate.get(cons[3].Id).OtherPhone);
        system.assertEquals('(234) 567-8911', contcts_afterUpdate.get(cons[4].Id).MobilePhone);
        system.assertEquals('(234) 567-8910', contcts_afterUpdate.get(cons[4].Id).OtherPhone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[4].Id).HomePhone);
        system.assertEquals('test@test.org', contcts_afterUpdate.get(cons[4].Id).Email);
        system.assertEquals('(555) 545-5555', contcts_afterUpdate.get(cons[5].Id).MobilePhone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[6].Id).MobilePhone);
        system.assertEquals('(234) 567-8910', contcts_afterUpdate.get(cons[7].Id).MobilePhone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[8].Id).MobilePhone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[9].Id).MobilePhone);
        system.assertEquals(null, contcts_afterUpdate.get(cons[10].Id).MobilePhone);
        //test@test.org
    }
}