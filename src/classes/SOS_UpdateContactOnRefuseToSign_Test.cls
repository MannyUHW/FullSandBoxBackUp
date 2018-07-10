@isTest
public class SOS_UpdateContactOnRefuseToSign_Test{

    public static TestMethod void SOS_UpdateContactOnRefuseToSign_Test(){
    
        Contact c = new Contact();
        c.lastName = 'conatct Last Name';
        c.Last_Phone_Bank_Task_Subject__c = 'Visit - Not Home';
        c.No_one_home__c = True;
        c.RefusedToSign__c = True;
        c.VisitLast6Months__c  = True;
        c.isExclude__c = False;
        c.Division_Type__c = 'conatct test';
        c.FID__c = '3312-23212441';
        insert c;
        
        Task t = new Task();
        t.Ownerid = UserInfo.getUserId();
        t.Subject = 'Call - Not Home';
        t.Status = 'Not Started';
        t.Priority = 'High';
        t.Whoid = c.id;
        insert t;
        
        Task t1 = new Task();
        t1.Ownerid = UserInfo.getUserId();
        t1.Subject = 'Call - Not Home';
        t1.Status = 'Visit- No Client (NLE)';
        t1.Priority = 'High';
        t1.Whoid = c.id;
        insert t1;
        
        t1.Status = 'Call - Not Home';
        update t1;
        
        delete t1;
        /*
        
        List<Contact> cLst = new List<Contact>();
        cLst  = [SELECT isExclude__c FROM Contact WHERE Id = :c.id];
        
        system.assert(cLst[0].isExclude__c, true);
        
        
        t1.Status = 'Call - Not Home';
        update t1;
        
        List<Contact> cLst1 = new List<Contact>();
        cLst1  = [SELECT isExclude__c FROM Contact WHERE Id = :c.id];
        
        system.assert(cLst1[0].isExclude__c, False);
        
        */
        
    }
}