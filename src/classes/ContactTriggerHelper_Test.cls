@isTest(seeAlldata=true)
public class ContactTriggerHelper_Test{

public static testmethod void ContactTriggerHelper_Test()
{

    contact c = new contact();
    c.lastName = 'ctst';
    c.VisitLast6Months__c = false;
    c.Last_Phone_Bank_Task_Subject__c = 'test';
    c.No_one_home__c = false;
    c.RefusedToSign__c = true;
    c.Signed_Membership_Card__c = false;
    c.Division_Type__c = 'Kaiser';
    c.FID__c = '3312-23212324';    
    insert c;
    
    //Chatter_Group_Cuztomization__c cgc = new Chatter_Group_Cuztomization__c();
    //cgc.Name = 'Group for Jan 2014 Canvasser';
    //cgc.Active__c = True;
    //insert cgc;
    
    Task t = new task();
    t.WhoId = c.id;
    t.Subject = 'Visit- No Client (NLE)';
    insert t; 
    
    Task t2 = new task();
    t2.WhoId = c.id;
    t2.Subject = 'Call - Verbal Supporter';
    insert t2;
    
    c.Signed_Membership_Card__c = true;
    c.Division_Type__c = 'Hospital';
    update c;
    
    c.Division_Type__c = 'Home Care';    
    update c;
    
    ContactTriggerHelper cth = new ContactTriggerHelper();
    cth.cheese();
    
}
}