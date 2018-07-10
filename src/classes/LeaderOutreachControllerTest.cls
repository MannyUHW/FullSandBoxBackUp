@isTest (seeAllData=true) private class LeaderOutreachControllerTest  {

  @isTest static void test1() {
    System.debug('test1() start');
    List <Account> data = LeaderOutreachController.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');
    String   txRecStr;
    LeaderOutreach__c tmpRec;
    tmpRec = new LeaderOutreach__c();
    tmpRec.Answer1__c          = 'Positively';
    tmpRec.Answer2__c          = 'cats are cool';
    tmpRec.Answer3__c          = 'purr';
    tmpRec.Answer4__c          = 'Somewhat agree';
    tmpRec.LeaderFirstName__c  = 'Graham';
    tmpRec.LeaderLastName__c   = 'Smith';
    tmpRec.MemberFirstName__c  = 'Jake';
    tmpRec.MemberLastName__c   = 'Decker';
    tmpRec.EmpId__c            = '999';
    tmpRec.MemberEmail__c      = 'test@email.com';
    tmpRec.MemberDepartment__c = 'Emergency';
    tmpRec.MemberCellPhone__c  = '123 456 7890';
    tmpRec.MemberEmployeeId__c = '666';
    
    txRecStr = JSON.serialize(tmpRec);
    
    List <String> responses = new List<String>();
    responses.add(txRecStr);
    
    List <String> errorData = LeaderOutreachController.updateLeaderOutreach(responses);
    List <String> emptyList = new List <String>();
    
    system.assertEquals(errorData,emptyList);
    System.debug('test2() end');
  }

}