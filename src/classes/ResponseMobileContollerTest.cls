@isTest (seeAllData=true) private class ResponseMobileContollerTest {

  @isTest static void test1() {
    System.debug('test1() start');

    List <Survey_Question__c> data = ResponseMobileContoller.getSurveyQuestion('S02');
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List <Account> data = ResponseMobileContoller.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test2() end');
  }

  @isTest static void test3() {
    System.debug('test3() start');

    List<Account> getOneList = [SELECT Id FROM Account WHERE Type = 'Employer' AND Active__c = 'Yes' AND Account_Group__c = 'Kaiser' LIMIT 1];
    Account getOne = getOneList[0];
    System.debug(getOne.Id);
    List <Contact> data = ResponseMobileContoller.getContactData(getOne.Id,'S02');
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test3() end');
  }

   @isTest static void test4() {
    System.debug('test4() start');

    String userId = UserInfo.getUserId();

    List<Contact> getOneContactList = [SELECT Id FROM Contact WHERE In_Current_BU__c = true AND Account.Type = 'Employer' AND Account.Active__c = 'Yes' AND Account.Account_Group__c = 'Kaiser' LIMIT 1];
    Contact getOneContact = getOneContactList[0];

    List <Survey_Question__c> getOneQuestionList = ResponseMobileContoller.getSurveyQuestion('S02');
    Survey_Question__c getOneQuestion = getOneQuestionList[0];

    Id surveyQuestionId = getOneQuestionList[0].Id;

    String status;
    // Test Insert
    status = ResponseMobileContoller.updateResponse(userId, getOneContact.Id, surveyQuestionId, true, '');
    system.assertEquals(status,'ok');

    List <Survey_Response__c> getOneResponseList = [SELECT Contact__c,  Survey_Question__c, Response_Value__c
    FROM Survey_Response__c WHERE Contact__r.AccountId = '001i000000lPaB3' AND Contact__r.In_Current_BU__c = true AND Survey_Question__r.Survey_Code__c = 'S02' AND Response_Value__c = 'yes' LIMIT 1];
    Survey_Response__c getOneResponse = getOneResponseList[0];

    // Test Update
    status = ResponseMobileContoller.updateResponse(userId, getOneContact.Id, surveyQuestionId, true, getOneResponse.Id);
    system.assertEquals(status,'ok');

    // Test Delete
    status = ResponseMobileContoller.updateResponse(userId, getOneContact.Id, surveyQuestionId, false, getOneResponse.Id);
    system.assertEquals(status,'ok');

    System.debug('test4() end');         
  }

}