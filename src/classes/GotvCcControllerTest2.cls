@isTest (seeAllData=true) private class GotvCcControllerTest2 {

  @isTest static void test2_1() {
    System.debug('test2_1 start');

    List<Contact> getOneList = [SELECT Id,ID_Leaders__c,In_Current_BU__c,Inoculated__c FROM Contact 
     WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true AND ID_Leaders__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean idLeaders,inCurrentBu,inoculated;
    String status;

    String idStr = getOne.Id;
    system.debug('ID: ' + idStr);
    
    idLeaders = !getOne.ID_Leaders__c;
    if(idLeaders)
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'false');
    system.assertEquals(status,'OK');

    idLeaders = !idLeaders;
    if(idLeaders)
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'false');
    system.assertEquals(status,'OK');

    inCurrentBu = !getOne.In_Current_BU__c;
    if(inCurrentBu)
      status = GotvCcController.updateContact(getOne.Id, '[IB]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IB]', 'false');
    system.assertEquals(status,'OK');

    inCurrentBu = !inCurrentBu;
    if(inCurrentBu)
      status = GotvCcController.updateContact(getOne.Id, '[IB]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IB]', 'false');
    system.assertEquals(status,'OK');

    inoculated = !getOne.Inoculated__c;
    if(inoculated)
      status = GotvCcController.updateContact(getOne.Id, '[IN]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IN]', 'false');
    system.assertEquals(status,'OK');

    inoculated = !inoculated;
    if(inoculated)
      status = GotvCcController.updateContact(getOne.Id, '[IN]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IN]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test2_1() end');         
  }

  @isTest static void test2_1b() {
    System.debug('test2_1b() start');

    List<Contact> getOneList = [SELECT Id,ID_Leaders__c,In_Current_BU__c,Inoculated__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true AND ID_Leaders__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean idLeaders,inCurrentBu,inoculated;
    String status;

    String idStr = getOne.Id;
    system.debug('ID: ' + idStr);

    idLeaders = !getOne.ID_Leaders__c;
    if(idLeaders)
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'false');
    system.assertEquals(status,'OK');

    idLeaders = !idLeaders;
    if(idLeaders)
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IL]', 'false');

    system.assertEquals(status,'OK');
        System.debug('test2_1b() end');         
  }

  @isTest static void test2_1c() {
    System.debug('test2_1c() start');

    List<Contact> getOneList = [SELECT Id,GOTV_Works_Night_Before_Eday1__c,Works_Night_Before_Eday2__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean gotvWorksNightBeforeEday1,gotvWorksNightBeforeEday2;
    String status;

    gotvWorksNightBeforeEday1 = !getOne.GOTV_Works_Night_Before_Eday1__c;
    if(gotvWorksNightBeforeEday1)
      status = GotvCcController.updateContact(getOne.Id, '[N1]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[N1]', 'false');
    system.assertEquals(status,'OK');

    gotvWorksNightBeforeEday1 = !gotvWorksNightBeforeEday1;
    if(gotvWorksNightBeforeEday1)
      status = GotvCcController.updateContact(getOne.Id, '[N1]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[N1]', 'false');

    gotvWorksNightBeforeEday2 = !getOne.Works_Night_Before_Eday2__c;
    if(gotvWorksNightBeforeEday2)
      status = GotvCcController.updateContact(getOne.Id, '[N2]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[N2]', 'false');
    system.assertEquals(status,'OK');

    gotvWorksNightBeforeEday2 = !gotvWorksNightBeforeEday2;
    if(gotvWorksNightBeforeEday2)
      status = GotvCcController.updateContact(getOne.Id, '[N2]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[N2]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test2_1c() end');         
  }

  @isTest static void test2_2() {
    System.debug('test2_2() start');

    String data = GotvCcController.getUrl();
    Integer l = data.length();
    System.assertNotEquals(l,0);
    
    System.debug('test2_2() end');
  }

  @isTest static void test2_3() {
    System.debug('test2_3() start');
    Id accountId = '001i000001XOJIBAA5';
    List <Contact> data = GotvCcController.getContactMatches(accountId);
    System.debug('test2_3() end');
  }

}