@isTest(SeeAllData =true)
  public class Test_userTriggerHandler{
  
    public static testMethod void test1(){
          Profile p = [select id from profile where name = 'System Administrator'];
     
          User testUser = new User(alias = 'u1', email='u1@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = p.Id, country='United States',
                                  timezonesidkey='America/Los_Angeles', username='uuuuu@test.com', Vacation__c = 10, Bereavement__c = 10,
                                  Sick__c=10, Unpaid__c=10, Holiday_work_days__c=10, Relieve__c=10, Birthday__c=10, Float__c=10, 
                                  Jury_Duty__c=10, Religious_OPEIU_Only__c=10);
     
          insert testUser;
          testUser.alias='u2';
          update testUser;
    }
 }