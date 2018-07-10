@isTest (seeAllData=true) private class UnpaidInternshipRemoteController1Test  {

  @isTest static void test1() {
    System.debug('test1() start');
    List <Account> data = UnpaidInternshipRemoteController1.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');
    List <Account> contData = [SELECT Id,Name FROM Account WHERE Name LIKE 'Kaiser%' And BU_Count__c > 0 ORDER BY BU_Count__c ASC NULLS FIRST LIMIT 1];
    Id acccountId;
    String empName;
    acccountId = contData[0].Id;
    empName    = contData[0].Name;
    system.debug('Using ' + empName + ' for test');
    List <Contact> data = UnpaidInternshipRemoteController1.getContactData(acccountId);
    integer l = data.size();
    system.assertNotEquals(l,0);
    System.debug('test2() end');
  }

  @isTest static void test3() {
    System.debug('test3() start');
    List <User> userData = [SELECT Id FROM User WHERE FirstName = 'Graham' And LastName ='Smith' LIMIT 1];
    Id userId;
    userId = userData[0].Id;
    User data = UnpaidInternshipRemoteController1.getUserData(userId);
    system.assertNotEquals(data.Id,null);

    UnpaidInterns1__c data2 = UnpaidInternshipRemoteController1.getResponseData(userId);
    system.assertEquals(data2,null);
    
    System.debug('test3() end');
  }

  @isTest static void test4() {
    System.debug('test4() start');
    List <User> userData = [SELECT Id FROM User WHERE FirstName = 'Graham' And LastName ='Smith' LIMIT 1];
    Id userId;
    userId = userData[0].Id;

    List <Contact> contData = [SELECT Id FROM Contact WHERE FirstName = 'Graham' And LastName ='Smith' LIMIT 1];
    Id contId;
    contId = contData[0].Id;

    Datetime dt = DateTime.parse('11/21/2016 11:46 AM');
    String dtString = dt.format();

    UnpaidInterns1__c tmpResponse;
    tmpResponse = new UnpaidInterns1__c();
    tmpResponse.Interviewer__c   = (String) userId;
    tmpResponse.ContactId__c     = (String) contId;
    tmpResponse.InterviewDate__c = dtString;
    tmpResponse.UpdatedDate__c   = dtString;
    tmpResponse.MemberName__c    = 'Graham';
    tmpResponse.A1__c = 'Y';
    tmpResponse.A2__c = 'N';
    tmpResponse.A3__c = 'Y';
    tmpResponse.A4__c = 'N';
    tmpResponse.A5__c = 'Y';
    tmpResponse.A6__c = 'N';
    tmpResponse.A7__c = 'Y';
    tmpResponse.A8__c = 'N';
    tmpResponse.A9__c = 'Y';
    tmpResponse.A10__c = 'N';
    tmpResponse.A11__c = 'Y';
    tmpResponse.A12__c = 'N';
    tmpResponse.A13__c = 'Y';
    tmpResponse.A14__c = 'N';
    tmpResponse.A15__c = 'Y';

    List <UnpaidInterns1__c> responses = new List<UnpaidInterns1__c>();
    responses.add(tmpResponse);
    List <String> data = UnpaidInternshipRemoteController1.updateResponses(responses);
    List <String> emptyList = new List <String>();
    system.assertEquals(data,emptyList);
    System.debug('test4() end');
  }
  
}