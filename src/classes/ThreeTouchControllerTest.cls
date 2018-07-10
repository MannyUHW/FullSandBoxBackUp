@isTest (seeAllData=true) private class ThreeTouchControllerTest {

  @isTest static void test1() {
    System.debug('test1() start');

    List <Account> data = ThreeTouchController.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List<Account> getOneList = [SELECT Id FROM Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' And Active__c = 'YES' LIMIT 1];
    System.debug('Account is:');

    Account getOne = getOneList[0];
    System.debug(getOne.Id);
    List <Contact> data = ThreeTouchController.getContactData(getOne.Id, null);
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test2() end');
  }

  @isTest static void test3() {
    System.debug('test3() start');

    List<Contact> getOneList = [SELECT Id,FirstName,LastName,Department,Division__c,Title,MobilePhone,Phone,Shift__c,Three_Touch_ST__c,Three_Touch_VC__c,Three_Touch__c,GOTV_Assessment__c,GOTV_Vote_Yes_Petition__c
    FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status,firstName,lastName,department,title,cellPhone,phone,shift,gotvAssessment,gotvVoteYes;

    Boolean touchST,touchVC,touchOB;

    touchST = !getOne.Three_Touch_ST__c;
    if(touchST == true)
      status = ThreeTouchController.updateContact(getOne.Id, '[ST]', 'true');
    else
      status = ThreeTouchController.updateContact(getOne.Id, '[ST]', 'false');
      system.assertEquals(status,'OK');

    touchST = !touchST;
    if(touchST == true)
      status = ThreeTouchController.updateContact(getOne.Id, '[ST]', 'true');
    else
      status = ThreeTouchController.updateContact(getOne.Id, '[ST]', 'false');
      system.assertEquals(status,'OK');

    touchVC = !getOne.Three_Touch_VC__c;
    if(touchVC == true)
      status = ThreeTouchController.updateContact(getOne.Id, '[VC]', 'true');
    else
      status = ThreeTouchController.updateContact(getOne.Id, '[VC]', 'false');
      system.assertEquals(status,'OK');

    touchVC = !touchVC;
    if(touchVC == true)
      status = ThreeTouchController.updateContact(getOne.Id, '[VC]', 'true');
    else
      status = ThreeTouchController.updateContact(getOne.Id, '[VC]', 'false');
      system.assertEquals(status,'OK');

    touchOB = !getOne.Three_Touch__c;
    if(touchOB == true)
      status = ThreeTouchController.updateContact(getOne.Id, '[OB]', 'true');
    else
      status = ThreeTouchController.updateContact(getOne.Id, '[OB]', 'false');
      system.assertEquals(status,'OK');

    touchOB = !touchOB;
    if(touchOB == true)
      status = ThreeTouchController.updateContact(getOne.Id, '[OB]', 'true');
    else
      status = ThreeTouchController.updateContact(getOne.Id, '[OB]', 'false');
      system.assertEquals(status,'OK');

    firstName      = getOne.FirstName; 
    status         = ThreeTouchController.updateContact(getOne.Id, 'FirstName', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'FirstName', firstName);
    system.assertEquals(status,'OK');

    lastName       = getOne.LastName;
    status         = ThreeTouchController.updateContact(getOne.Id, 'LastName', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'LastName', lastName);
    system.assertEquals(status,'OK');
    
    department     = getOne.Department;
    status         = ThreeTouchController.updateContact(getOne.Id, 'Department', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'Department', department);
    system.assertEquals(status,'OK');

    title          = getOne.Title;
    status         = ThreeTouchController.updateContact(getOne.Id, 'Title', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'Title', title);
    system.assertEquals(status,'OK');
    
    cellPhone      = getOne.MobilePhone;
    status         = ThreeTouchController.updateContact(getOne.Id, 'CellPhone', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'CellPhone', cellPhone);
    system.assertEquals(status,'OK');

    phone          = getOne.Phone;
    status         = ThreeTouchController.updateContact(getOne.Id, 'Phone', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'Phone', phone);
    system.assertEquals(status,'OK');
    
    shift          = getOne.Shift__c;
    status         = ThreeTouchController.updateContact(getOne.Id, 'Shift', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'Shift', shift);
    system.assertEquals(status,'OK');    
    
    gotvAssessment = getOne.GOTV_Assessment__c;
    status         = ThreeTouchController.updateContact(getOne.Id, 'GotvAssessment', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'GotvAssessment', gotvAssessment);
    system.assertEquals(status,'OK');
    
    gotvVoteYes    = getOne.GOTV_Vote_Yes_Petition__c;
    status         = ThreeTouchController.updateContact(getOne.Id, 'GotvVoteYesPetition', 'Test');
    status         = ThreeTouchController.updateContact(getOne.Id, 'GotvVoteYesPetition', gotvVoteYes);
    system.assertEquals(status,'OK');

    system.assertEquals(status,'OK');

    System.debug('test3() end');         
  }

}