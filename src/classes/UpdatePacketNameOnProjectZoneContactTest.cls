@isTest(SeeAllData = true)
Public Class UpdatePacketNameOnProjectZoneContactTest
{

    static testMethod void UpdateTest()
    {
    	/*
    	try{
    	    	
    	Account a = new Account(name='Coco');
        insert a;
        
 		Contact c= new Contact();
        Contact c2= new Contact();
        
         c = new Contact(Email='testsfdc2012@gmail.com',lastname='John',accountid=a.id,phone='23456',Bad_Phone_Numbers__c ='5555',
                                Languages__c='English',Employer__c=a.id,mailingStreet='1389 redwood city',mailingstate='abc',
                                mailingcity='Oakland',MailingPostalCode='89678',Signed_Membership_Card__c=true, FID__c='4545455' );
        insert c;

        c2 = new Contact(Email='testsfdc2012@gmail.com',lastname='Sopee',accountid=a.id,phone='23456',Bad_Phone_Numbers__c = '555555',
                                Languages__c='English',Employer__c=a.id,mailingStreet='1389 redwood city',mailingstate='abc',
                                mailingcity='Oakland',MailingPostalCode='89678',Signed_Membership_Card__c=true , FID__c='333344');
        insert c2;
            	
    	
    	//set<Project_Zone_Contact_SOSP__c> Zone_ContactSet = new set<Project_Zone_Contact_SOSP__c>([SELECT Contact__c FROM Project_Zone_Contact_SOSP__c WHERE Project_Packet__c = NULL AND Contact__c != NULL  limit 1]);
    	Project_Zone_Contact_SOSP__c pzc = new Project_Zone_Contact_SOSP__c();
    	List<Project_Zone_SOSP__c>  projZonelist = [SELECT 	Id FROM Project_Zone_SOSP__c limit 1];

		if (projZonelist.size()>0 )
		{
		    	pzc.Contact__c = c.id;
		    	pzc.Project_Zone__c = projZonelist[0].id;
		}
		
		insert pzc;
		
    	}
        catch (Exception x)
        {
            
        }
		*/
		//update pzc;
    	
    	/*

        try
        {        
	    	Zone_ContactSet = new set<Project_Zone_Contact_SOSP__c>([SELECT Contact__c FROM Project_Zone_Contact_SOSP__c where Contact__c != null and  Project_Packet__c!= null  limit 50]);
        }
        catch (Exception x)
        {
            
        }
    	
    	set<Id> contactSet = new set<Id>(); 
    	
    	for (Project_Zone_Contact_SOSP__c a : Zone_ContactSet) {
    		
    		contactSet.add(a.Contact__c);
    	}
    	
        List<Project_Packet_Contact_SOSP__c> ppcList = [SELECT Contact__c,Id,Name,ProjectID__c,Project_Packet__c, Project_Zone_ID__c FROM 
            Project_Packet_Contact_SOSP__c WHERE Contact__c != NULL AND Project_Packet__c != NULL AND Project_Zone_ID__c  != NULL LIMIT 20];

			//Project_Packet_Contact_SOSP__c WHERE Contact__c != NULL AND Project_Packet__c != NULL AND Project_Zone_ID__c  != NULL            AND Contact__c  IN :contactSet LIMIT 1];
    
    	 if (ppcList.size() > 0)
    	 {
         	update  ppcList;
    	 }   
    	 
    	 */
    }

}