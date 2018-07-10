@isTest(SeeAllData = true)
    public class sickTimeRequestController_TEST {
    
        public static testMethod void sickTimeRequestMethod(){
            sickTimeRequestController controller = New sickTimeRequestController();
            controller.cheese();
            controller.today = true;
            controller.tomarrow= true;
            controller.submitRequest();
            controller.today = false;
            controller.tomarrow= true;
            controller.submitRequest();
            controller.today = true;
            controller.tomarrow= false;
            controller.submitRequest(); 
            controller.cancel();  
        
            List <Profile> pList;
            Profile p;
            pList = [Select Id From Profile];
            p = pList[0];

            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, department = 'STP',
                        TimeZoneSidKey='America/Los_Angeles', UserName=Math.random() + '@test.com',Non_Exempt_Employee__c = false);
            insert u;
        }
    }