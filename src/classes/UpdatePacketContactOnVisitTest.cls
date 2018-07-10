@isTest(SeeAllData = True)

public class UpdatePacketContactOnVisitTest
{
    public static testMethod void test1()
    {   
 
        Contact contact= new Contact();
        contact.FirstName='Test';
        contact.LastName='Contact';
        contact.Signed_Membership_Card__c = false;
        contact.FID__c = '1234-656567';
        insert contact;   

        CVRSOS__Visits__c visit =new CVRSOS__Visits__c(CVRSOS__Contact__c=contact.Id,CVRSOS__Is_latest__c=false,CVRSOS__Notes__c='', CVRSOS__Project_Group__c=null,CVRSOS__Result__c='Visit - Signed',CVRSOS__Survey__c = null );
        insert visit ;
 

        
    }
}