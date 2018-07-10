@isTest (seeAllData=true) private class ResponseMobileContoller2Test {

  @isTest static void test1() {
    System.debug('test1() start');

    List<String> questions = new List<String>();
    questions.add('S02');
    List <Survey_Question__c> data = ResponseMobileContoller2.getSurveyQuestion(questions);
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List <Account> data = ResponseMobileContoller2.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test2() end');
  }

  @isTest static void test3() {
    System.debug('test3() start');

    List<Account> getOneList = [SELECT Id FROM Account WHERE Type = 'Employer' AND Active__c = 'Yes' AND Account_Group__c = 'Kaiser' LIMIT 1];
    Account getOne = getOneList[0];
    System.debug(getOne.Id);
    List<String> codes = new List<String>();
    codes.add('S02');
    List <Contact> data = ResponseMobileContoller2.getContactData(getOne.Id,codes);
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test3() end');
  }

   @isTest static void test4() {
    System.debug('test4() start');

    String userId = UserInfo.getUserId();

    List<Contact> getOneContactList = [SELECT Id FROM Contact WHERE AccountId in ('0010H00002NeI1dQAF','001i000002EcRlb') AND FirstName = 'Test' And LastName = 'Rec' LIMIT 1];
    Contact getOneContact = getOneContactList[0];
    String testContactId = getOneContact.Id;

    List <String> testData1 = new List <String>();
    List <String> testData2 = new List <String>();

    List<String> errors;
    String testStr1;
    String testStr2;
    List <String> updates = new List <string>();

// 0: "{\"QuestionId\":\"a0ti000000DhqhNAAR\",\"ContactId\":\"003i00000153Cr2AAE\",\"SurveyCode\":\"J02\",\"Response\":\"yes\",\"ResponseId\":\"a0u0U0000006h3SQAQ\"}"
// 1: "{\"QuestionId\":\"a0t0H00000EFyI5QAL\",\"ContactId\":\"003i00000153Cr2AAE\",\"SurveyCode\":\"P43\",\"Response\":\"yes\",\"ResponseId\":\"\"}"

    List <Survey_Response__c> getOneResponseList = [SELECT Id, Contact__c,  Survey_Question__c, Survey_Question__r.Survey_Code__c, Response_Value__c
        FROM Survey_Response__c WHERE Contact__r.AccountId = '001i000000lPaB3' AND Contact__r.In_Current_BU__c = true AND Survey_Question__r.Survey_Code__c = 'S02' AND Response_Value__c = 'yes' LIMIT 1];

    Survey_Response__c tmpRec1 = getOneResponseList[0];

    ResponseTx tmpRespTx = new ResponseTx();
    tmpRespTx.QuestionId = tmpRec1.Survey_Question__c;
    tmpRespTx.ContactId  = tmpRec1.Contact__c;
    tmpRespTx.SurveyCode = tmpRec1.Survey_Question__r.Survey_Code__c;
    tmpRespTx.Response   = tmpRec1.Response_Value__c;
    tmpRespTx.ResponseId = tmpRec1.Id;

    // Test Update
    updates.add(JSON.serialize(tmpRespTx));

    tmpRespTx.ContactId  = testContactId; // Mr. Test Rec
    tmpRespTx.ResponseId = '';
    // Test Insert
    updates.add(JSON.serialize(tmpRespTx));

    System.debug(updates);

    errors = ResponseMobileContoller2.updateResponse(updates);
    system.assertEquals(errors.size(),0);

    // To do: Really should delete the newly inserted record, but time dictates this gets migrated asap.
    System.debug('test4() end');         
  }

}