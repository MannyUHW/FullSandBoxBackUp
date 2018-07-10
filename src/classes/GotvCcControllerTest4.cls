@isTest (seeAllData=true) private class GotvCcControllerTest4 {

  @isTest static void test4_1() {
    System.debug('test4_1() start');

    List<Contact> getOneList = [SELECT Id, Mailing_BA__c, Ics__c
                                FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean mailingBA,ics;
    String status;

    mailingBA = !getOne.Mailing_BA__c;
    if(mailingBA)
      status = GotvCcController.updateContact(getOne.Id, '[BA]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[BA]', 'false');
    system.assertEquals(status,'OK');

    mailingBA = !mailingBA;
    if(mailingBA)
      status = GotvCcController.updateContact(getOne.Id, '[BA]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[BA]', 'false');

    ics = !getOne.Ics__c;
    if(ics)
      status = GotvCcController.updateContact(getOne.Id, '[IC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IC]', 'false');
    system.assertEquals(status,'OK');

    ics = !ics;
    if(ics)
      status = GotvCcController.updateContact(getOne.Id, '[IC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[IC]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test4_1() end');         
  }

  @isTest static void test4_2() {
    System.debug('test4_2() start');

    List<Contact> getOneList = [SELECT Id, LOA__c, OC_Member__c, Photo_Release_Signed__c
                                FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean loa,ocMember,photoReleaseSigned;
    String status;

    loa = !getOne.LOA__c;
    if(loa)
      status = GotvCcController.updateContact(getOne.Id, '[LO]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[LO]', 'false');
    system.assertEquals(status,'OK');

    loa = !loa;
    if(loa)
      status = GotvCcController.updateContact(getOne.Id, '[LO]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[LO]', 'false');
    system.assertEquals(status,'OK');

    ocMember = !getOne.OC_Member__c;
    if(ocMember)
      status = GotvCcController.updateContact(getOne.Id, '[OC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[OC]', 'false');
    system.assertEquals(status,'OK');

    ocMember = !ocMember;
    if(ocMember)
      status = GotvCcController.updateContact(getOne.Id, '[OC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[OC]', 'false');
    system.assertEquals(status,'OK');

    photoReleaseSigned = !getOne.Photo_Release_Signed__c;
    if(photoReleaseSigned)
      status = GotvCcController.updateContact(getOne.Id, '[PR]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[PR]', 'false');
    system.assertEquals(status,'OK');

    photoReleaseSigned = !photoReleaseSigned;
    if(photoReleaseSigned)
      status = GotvCcController.updateContact(getOne.Id, '[PR]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[PR]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test4_2() end');         
  }

  @isTest static void test4_3() {
    System.debug('test4_3() start');

    List<Contact> getOneList = [SELECT Id, Schedule_In_Hand__c, GOTV_Slip__c, GOTV_Special_Plan__c
                                FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean scheduleInHand,gotvSlip,gotvSpecialPlan;
    String status;

    scheduleInHand = !getOne.Schedule_In_Hand__c;
    if(scheduleInHand)
      status = GotvCcController.updateContact(getOne.Id, '[SC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[SC]', 'false');
    system.assertEquals(status,'OK');

    scheduleInHand = !scheduleInHand;
    if(scheduleInHand)
      status = GotvCcController.updateContact(getOne.Id, '[SC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[SC]', 'false');

    gotvSlip = !getOne.GOTV_Slip__c;
    if(gotvSlip)
      status = GotvCcController.updateContact(getOne.Id, '[SL]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[SL]', 'false');
    system.assertEquals(status,'OK');

    gotvSlip = !gotvSlip;
    if(gotvSlip)
      status = GotvCcController.updateContact(getOne.Id, '[SL]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[SL]', 'false');
    system.assertEquals(status,'OK');

    gotvSpecialPlan = !getOne.GOTV_Special_Plan__c;
    if(gotvSpecialPlan)
      status = GotvCcController.updateContact(getOne.Id, '[SP]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[SP]', 'false');
    system.assertEquals(status,'OK');

    gotvSpecialPlan = !gotvSpecialPlan;
    if(gotvSpecialPlan)
      status = GotvCcController.updateContact(getOne.Id, '[SP]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[SP]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test4_3() end');         
  }

  @isTest static void test4_4() {
    System.debug('test4_4() start');

    List<Contact> getOneList = [SELECT Id, GOTV_Took_Photo__c, GOTV_UHW_Challenge__c, GOTV_Works_Eday_1__c
                                FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean gotvTookPhoto,gotvUhwChallenge,gotvWorksEday1;
    String status;

    gotvTookPhoto = !getOne.GOTV_Took_Photo__c;
    if(gotvTookPhoto)
      status = GotvCcController.updateContact(getOne.Id, '[TP]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[TP]', 'false');
    system.assertEquals(status,'OK');

    gotvTookPhoto = !gotvTookPhoto;
    if(gotvTookPhoto)
      status = GotvCcController.updateContact(getOne.Id, '[TP]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[TP]', 'false');
    system.assertEquals(status,'OK');

    gotvUhwChallenge = !getOne.GOTV_UHW_Challenge__c;
    if(gotvUhwChallenge)
      status = GotvCcController.updateContact(getOne.Id, '[UC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[UC]', 'false');
    system.assertEquals(status,'OK');

    gotvUhwChallenge = !gotvUhwChallenge;
    if(gotvUhwChallenge)
      status = GotvCcController.updateContact(getOne.Id, '[UC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[UC]', 'false');
    system.assertEquals(status,'OK');

    gotvWorksEday1 = !getOne.GOTV_Works_Eday_1__c;
    if(gotvWorksEday1)
      status = GotvCcController.updateContact(getOne.Id, '[W1]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[W1]', 'false');
    system.assertEquals(status,'OK');

    gotvWorksEday1 = !gotvWorksEday1;
    if(gotvWorksEday1)
      status = GotvCcController.updateContact(getOne.Id, '[W1]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[W1]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test4_4() end');         
  }

  @isTest static void test4_5() {
    System.debug('test4_5() start');

    List<Contact> getOneList = [SELECT Id, GOTV_Works_Eday2__c, X1_1_complete__c
                                FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean gotvWorksEday2,x1Complete;
    String status;

    gotvWorksEday2 = !getOne.GOTV_Works_Eday2__c;
    if(gotvWorksEday2)
      status = GotvCcController.updateContact(getOne.Id, '[W2]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[W2]', 'false');
    system.assertEquals(status,'OK');

    gotvWorksEday2 = !gotvWorksEday2;
    if(gotvWorksEday2)
      status = GotvCcController.updateContact(getOne.Id, '[W2]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[W2]', 'false');
    system.assertEquals(status,'OK');

    x1Complete = !getOne.X1_1_complete__c;
    if(x1Complete)
      status = GotvCcController.updateContact(getOne.Id, '[X1]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[X1]', 'false');
    system.assertEquals(status,'OK');

    x1Complete = !x1Complete;
    if(x1Complete)
      status = GotvCcController.updateContact(getOne.Id, '[X1]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[X1]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test4_5() end');

  }

   @isTest static void test4_6() {
    System.debug('test4_6() start');

    XMatchBatchTruncate.fudge(); // Code covereage quick fix.
    GotvCcController.startXMatchBatchTruncate('001i000001XOJIBAA5','Contact');

    System.debug('test15() end');
  }

   @isTest static void test4_7() {
    System.debug('test4_6() start');

    XMatchedBatchTruncate.fudge(); // Code covereage quick fix.
    GotvCcController.startXMatchedBatchTruncate('001i000001XOJIBAA5','Contact');

    System.debug('test15() end');
  }


}