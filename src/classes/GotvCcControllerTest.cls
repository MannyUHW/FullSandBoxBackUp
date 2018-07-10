@isTest (seeAllData=true) private class GotvCcControllerTest {

  @isTest static void test1() {
    System.debug('test1() start');

    List <Account> data = GotvCcController.getAccountData();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test1() end');
  }

  @isTest static void test4() {
    System.debug('test4() start');

    List<Account> getOneList = [SELECT Id FROM Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' And Active__c = 'YES' LIMIT 1];
    System.debug('Account is:');
    Account getOne = getOneList[0];
    System.debug(getOne.Id);
    String res = GotvCcController.initialize(getOne.Id);
    system.assertEquals(res,'OK');
  
  }

  @isTest static void test5() {
    System.debug('test5() start');

    List<Contact> getOneList = [
      SELECT AccountId, Activist__c, Assigned_to_VC__c, AssignedLeader__r.Name, AssistantName, BU__c, Build_OC_Support__c, Captain__c, Captain_s_OC__c, Card_Assessment__c, Cross_Match_UHW__c, CrossMatchFacility__c, Department, Dialysis_Build_OC__c, Dialysis_Employer__c, Dialysis_Phases__c, Dignity_Region__c, Dignity_Sub_Region__c, Div_Sub_Region__c, Division__c, DoNotCall ,FirstName ,GOTV_Assessment__c ,GOTV_Board_Challenge__c ,GOTV_Card_Signed_Date__c ,GOTV_Challenge__c ,GOTV_Challenge_Reason__c ,GOTV_Exact_Vote_Time__c ,GOTV_Hard_Pull__c ,GOTV_Hard_Pull_Reason__c ,GOTV_Inside_Plan_Notes__c ,GOTV_Off_Both_Days__c ,GOTV_Outside_Plan__c ,GOTV_Plan_Type__c ,GOTV_Shift_Scheduler__c ,GOTV_Slip__c ,GOTV_Special_Plan__c ,GOTV_Special_Plan_Notes__c ,GOTV_Took_Photo__c ,GOTV_UHW_Challenge__c ,GOTV_Vote_Block_Time__c ,GOTV_Vote_Yes_Petition__c ,GOTV_Where_After_Voting__c ,GOTV_Where_Before_Voting__c ,GOTV_Works_Eday_1__c ,HomePhone ,Id ,ID_Leaders__c ,In_Current_BU__c ,Inoculated__c ,LastModifiedDate ,LastName ,Lic_List_Phone__c ,Mailing_BA__c ,MailingCity ,MailingPostalCode ,MailingState ,MailingStreet ,MobilePhone ,New_Org_Card_Signed_By__c ,New_Org_Card_Signed_By__r.Name ,Notes_Consolidated__c ,OC_Member__c ,OtherPhone ,Phone ,Photo_Release_Signed__c ,Purple_UP__c ,Reconfirmed_GOTV__c ,Schedule_In_Hand__c ,Shift__c ,SignedOrVerified__c ,Staffing_17__c ,Staffing_17_Collected_By__c ,Staffing_17_Collected_By__r.Name ,Sticker_Up_Actions__c ,Stretch_Member_Card_Signed__c ,Three_Touch_ST__c ,Title ,Vote_Captain__c ,Work_Days_at_Primary_Worksite__c ,Work_Status__c ,Works_Night_Before_Eday2__c ,Worksite__c
      FROM Contact 
      WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status,firstName,lastName,department,title,cellPhone,phone,shift,gotvAssessment,gotvVoteYes;
    Boolean touchST,touchVC,touchOB,gettable,doNotCall,gotvHardPull,activist,gotvBoardChallenge,gotvOffBothDays,captain;
    Boolean reconfirmed, voteCaptain;

    activist = !getOne.Activist__c;
    if(activist)
      status = GotvCcController.updateContact(getOne.Id, '[AC]', 'true');      
    else
      status = GotvCcController.updateContact(getOne.Id, '[AC]', 'false');      
    system.assertEquals(status,'OK');

    activist = !activist;
    if(activist)
      status = GotvCcController.updateContact(getOne.Id, '[AC]', 'true');      
    else
      status = GotvCcController.updateContact(getOne.Id, '[AC]', 'false');      
    system.assertEquals(status,'OK');

    gotvBoardChallenge = !getOne.GOTV_Board_Challenge__c;
    if(gotvBoardChallenge)
      status = GotvCcController.updateContact(getOne.Id, '[BC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[BC]', 'false');
    system.assertEquals(status,'OK');

    gotvBoardChallenge = !gotvBoardChallenge;
    if(gotvBoardChallenge)
      status = GotvCcController.updateContact(getOne.Id, '[BC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[BC]', 'false');
    system.assertEquals(status,'OK');

    gotvOffBothDays = !getOne.GOTV_Off_Both_Days__c;
    if(gotvOffBothDays)
      status = GotvCcController.updateContact(getOne.Id, '[BO]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[BO]', 'false');
    system.assertEquals(status,'OK');

    gotvOffBothDays = !gotvOffBothDays;
    if(gotvOffBothDays)
      status = GotvCcController.updateContact(getOne.Id, '[BO]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[BO]', 'false');
    system.assertEquals(status,'OK');

    captain = !getOne.Captain__c;
    if(captain)
      status = GotvCcController.updateContact(getOne.Id, '[CA]', 'true');      
    else
      status = GotvCcController.updateContact(getOne.Id, '[CA]', 'false');      
    system.assertEquals(status,'OK');

    captain = !captain;
    if(captain)
      status = GotvCcController.updateContact(getOne.Id, '[CA]', 'true');      
    else
      status = GotvCcController.updateContact(getOne.Id, '[CA]', 'false');      
    system.assertEquals(status,'OK');

    doNotCall = !getOne.DoNotCall;
    if(doNotCall)
      status = GotvCcController.updateContact(getOne.Id, '[DC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[DC]', 'false');
    system.assertEquals(status,'OK');

    doNotCall = !doNotCall;
    if(doNotCall)
      status = GotvCcController.updateContact(getOne.Id, '[DC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[DC]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test5g() end');         
  }


  @isTest static void test6() {
    System.debug('test6() start');

    List<Contact> getOneList = [
      SELECT AccountId, Activist__c, Assigned_to_VC__c, AssignedLeader__r.Name, AssistantName, BU__c, Build_OC_Support__c, Captain__c, Captain_s_OC__c, Card_Assessment__c, Cross_Match_UHW__c, CrossMatchFacility__c, Department, Dialysis_Build_OC__c, Dialysis_Employer__c, Dialysis_Phases__c, Dignity_Region__c, Dignity_Sub_Region__c, Div_Sub_Region__c, Division__c, DoNotCall ,FirstName ,GOTV_Assessment__c ,GOTV_Board_Challenge__c ,GOTV_Card_Signed_Date__c ,GOTV_Challenge__c ,GOTV_Challenge_Reason__c ,GOTV_Exact_Vote_Time__c ,GOTV_Gettable__c ,GOTV_Hard_Pull__c ,GOTV_Hard_Pull_Reason__c ,GOTV_Inside_Plan_Notes__c ,GOTV_Off_Both_Days__c ,GOTV_Outside_Plan__c ,GOTV_Plan_Type__c ,GOTV_Shift_Scheduler__c ,GOTV_Slip__c ,GOTV_Special_Plan__c ,GOTV_Special_Plan_Notes__c ,GOTV_Took_Photo__c ,GOTV_UHW_Challenge__c ,GOTV_Vote_Block_Time__c ,GOTV_Vote_Yes_Petition__c ,GOTV_Where_After_Voting__c ,GOTV_Where_Before_Voting__c ,GOTV_Works_Eday_1__c ,HomePhone ,Id ,ID_Leaders__c ,In_Current_BU__c ,Inoculated__c ,LastModifiedDate ,LastName ,Lic_List_Phone__c ,Mailing_BA__c ,MailingCity ,MailingPostalCode ,MailingState ,MailingStreet ,MobilePhone ,New_Org_Card_Signed_By__c ,New_Org_Card_Signed_By__r.Name ,Notes_Consolidated__c ,OC_Member__c ,OtherPhone ,Phone ,Photo_Release_Signed__c ,Purple_UP__c ,Reconfirmed_GOTV__c ,Schedule_In_Hand__c ,Shift__c ,SignedOrVerified__c ,Staffing_17__c ,Staffing_17_Collected_By__c ,Staffing_17_Collected_By__r.Name ,Sticker_Up_Actions__c ,Stretch_Member_Card_Signed__c,
      Three_Touch_ST__c, Three_Touch_VC__c, Three_Touch__c, Title ,Vote_Captain__c ,Work_Days_at_Primary_Worksite__c ,Work_Status__c ,Works_Night_Before_Eday2__c ,Worksite__c
      FROM Contact 
      WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status,firstName,lastName,department,title,cellPhone,phone,shift,gotvAssessment,gotvVoteYes;
    Boolean touchST,touchVC,touchOB,gettable,doNotCall,gotvHardPull,activist,gotvBoardChallenge,gotvOffBothDays,captain;
    Boolean reconfirmed, voteCaptain;

    gettable = !getOne.GOTV_Gettable__c;
    if(gettable)
      status = GotvCcController.updateContact(getOne.Id, '[GT]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[GT]', 'false');
      system.assertEquals(status,'OK');

    gettable = !gettable;
    if(gettable)
      status = GotvCcController.updateContact(getOne.Id, '[GT]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[GT]', 'false');
      system.assertEquals(status,'OK');

    gotvHardPull = !getOne.GOTV_Hard_Pull__c;
    if(gotvHardPull) 
      status = GotvCcController.updateContact(getOne.Id, '[HP]', 'true');      
    else
      status = GotvCcController.updateContact(getOne.Id, '[HP]', 'false');      
    system.assertEquals(status,'OK');
    
    gotvHardPull = !gotvHardPull;
    if(gotvHardPull) 
      status = GotvCcController.updateContact(getOne.Id, '[HP]', 'true');      
    else
      status = GotvCcController.updateContact(getOne.Id, '[HP]', 'false');      
    system.assertEquals(status,'OK');

    touchOB = !getOne.Three_Touch__c;
    if(touchOB)
      status = GotvCcController.updateContact(getOne.Id, '[OB]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[OB]', 'false');
      system.assertEquals(status,'OK');

    touchOB = !touchOB;
    if(touchOB)
      status = GotvCcController.updateContact(getOne.Id, '[OB]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[OB]', 'false');
      system.assertEquals(status,'OK');


    touchST = !getOne.Three_Touch_ST__c;
    if(touchST)
      status = GotvCcController.updateContact(getOne.Id, '[ST]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[ST]', 'false');
      system.assertEquals(status,'OK');

    touchST = !touchST;
    if(touchST)
      status = GotvCcController.updateContact(getOne.Id, '[ST]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[ST]', 'false');
      system.assertEquals(status,'OK');

    touchVC = !getOne.Three_Touch_VC__c;
    if(touchVC)
      status = GotvCcController.updateContact(getOne.Id, '[VC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[VC]', 'false');
      system.assertEquals(status,'OK');

    touchVC = !touchVC;
    if(touchVC)
      status = GotvCcController.updateContact(getOne.Id, '[VC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[VC]', 'false');
      system.assertEquals(status,'OK');

    System.debug('test6() end');         
  }

  @isTest static void test7() {
    System.debug('test7() start');

    List<Contact> getOneList = [SELECT Id,Cross_Match_UHW__c,Vote_Captain__c,Reconfirmed_GOTV__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean crossMatchUHW, voteCaptain, reconfirmed;
    String status;

    crossMatchUHW = !getOne.Cross_Match_UHW__c;
    if(crossMatchUHW)
      status = GotvCcController.updateContact(getOne.Id, '[CU]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[CU]', 'false');
    system.assertEquals(status,'OK');

    crossMatchUHW = !crossMatchUHW;
    if(crossMatchUHW)
      status = GotvCcController.updateContact(getOne.Id, '[CU]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[CU]', 'false');
    system.assertEquals(status,'OK');

    voteCaptain = !getOne.Vote_Captain__c;
    if(voteCaptain)
      status = GotvCcController.updateContact(getOne.Id, '[CV]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[CV]', 'false');
    system.assertEquals(status,'OK');

    voteCaptain = !voteCaptain;
    if(voteCaptain)
      status = GotvCcController.updateContact(getOne.Id, '[CV]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[CV]', 'false');
    system.assertEquals(status,'OK');

    reconfirmed = !getOne.Reconfirmed_GOTV__c;
    if(reconfirmed)
      status = GotvCcController.updateContact(getOne.Id, '[RC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[RC]', 'false');
    system.assertEquals(status,'OK');

    reconfirmed = !reconfirmed;
    if(reconfirmed)
      status = GotvCcController.updateContact(getOne.Id, '[RC]', 'true');
    else
      status = GotvCcController.updateContact(getOne.Id, '[RC]', 'false');
    system.assertEquals(status,'OK');

    System.debug('test7() end');         
  }


  @isTest static void test7b() {
    System.debug('test7b() start');

    List<Contact> getOneList = [SELECT Id,ID_Leaders__c,In_Current_BU__c,Inoculated__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Boolean idLeaders,inCurrentBu,inoculated;
    String status;

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

    System.debug('test7b() end');         
  }


  @isTest static void test8() {
    System.debug('test8() start');

    List<Contact> getOneList = [SELECT Id,FirstName,LastName FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status,firstName,lastName,department,title,cellPhone,phone,shift,gotvAssessment,gotvVoteYes;
    Boolean touchST,touchVC,touchOB,gettable;

    firstName      = getOne.FirstName; 
    status         = GotvCcController.updateContact(getOne.Id, 'FirstName', 'Test');
    status         = GotvCcController.updateContact(getOne.Id, 'FirstName', firstName);
    system.assertEquals(status,'OK');

    lastName       = getOne.LastName;
    status         = GotvCcController.updateContact(getOne.Id, 'LastName', 'Test');
    status         = GotvCcController.updateContact(getOne.Id, 'LastName', lastName);
    system.assertEquals(status,'OK');
    
    System.debug('test8() end');         
  }

  @isTest static void test9() {
    System.debug('test9() start');

    List<Contact> getOneList = [SELECT Id,Department,Title FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status,firstName,lastName,department,title,cellPhone,phone,shift,gotvAssessment,gotvVoteYes;
    Boolean touchST,touchVC,touchOB,gettable;

    department     = getOne.Department;
    status         = GotvCcController.updateContact(getOne.Id, 'Department', 'Test');
    status         = GotvCcController.updateContact(getOne.Id, 'Department', department);
    system.assertEquals(status,'OK');

    title          = getOne.Title;
    status         = GotvCcController.updateContact(getOne.Id, 'Title', 'Test');
    status         = GotvCcController.updateContact(getOne.Id, 'Title', title);
    system.assertEquals(status,'OK');
    
    System.debug('test9() end');         
  }

  @isTest static void test10() {
    System.debug('test10() start');

    List<Contact> getOneList = [SELECT Id,GOTV_Assessment__c,GOTV_Vote_Yes_Petition__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    String status,firstName,lastName,department,title,cellPhone,phone,shift,gotvAssessment,gotvVoteYes;
    Boolean touchST,touchVC,touchOB,gettable;

    gotvAssessment = getOne.GOTV_Assessment__c;
    status         = GotvCcController.updateContact(getOne.Id, 'GotvAssessment', 'Test');
    status         = GotvCcController.updateContact(getOne.Id, 'GotvAssessment', gotvAssessment);
    system.assertEquals(status,'OK');
    
    gotvVoteYes    = getOne.GOTV_Vote_Yes_Petition__c;
    status         = GotvCcController.updateContact(getOne.Id, 'GotvVoteYesPetition', 'Test');
    status         = GotvCcController.updateContact(getOne.Id, 'GotvVoteYesPetition', gotvVoteYes);
    system.assertEquals(status,'OK');

    System.debug('test10() end');         
  }

  @isTest static void test11() {
    System.debug('test11() start');

    List<Account> getOneList = [SELECT Id FROM Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' And Active__c = 'YES' LIMIT 1];
    Account getOne = getOneList[0];
    
    // Create
    ID res = GotvCcController.saveUniverse(getOne.Id,'D','Test', 'Test', 'Test','Test');
    system.assertNotEquals(res,null);

    // Update 
    res = GotvCcController.updateUniverse(res,'Test2','Test2', 'Test2','Test2');
    
    // Delete
    ID res2 = GotvCcController.deleteUniverse(res);
  
    System.debug('test11() end');
  }

  @isTest static void test12() {
    System.debug('test12() start');

    String status,res;
    List<String> Ids = new List<String>();
    List<Contact> getOneList = [SELECT Id,GOTV_Vote_Block_Time__c FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    Ids.add(getOne.Id);
    status = GotvCcController.updateContact(getOne.Id, 'GotvVoteBlockTime', 'Test');
    status = GotvCcController.updateContact(getOne.Id, 'GotvVoteBlockTime', getOne.GOTV_Vote_Block_Time__c);
    system.assertEquals(status,'OK');
    res = GotvCcController.assignVoteBlock('Test',Ids);
    system.assertEquals(res,'OK');
  
    System.debug('test12() end');
  }

  @isTest static void test13() {
    System.debug('test13() start');

    List <GOTV_Views__c> data = GotvCcController.getViews();
    integer l = data.size();
    system.assertNotEquals(l,0);
    
    System.debug('test13() end');
  }

  @isTest static void test14() {
    System.debug('test14() start');

    List<User> getOneListUser = [SELECT Id FROM User WHERE IsActive = true AND Department = 'OPS/FIN-DATA' LIMIT 1];
    Id getOneUserId = getOneListUser[0].Id;

    // Create
    ID res = GotvCcController.saveView('Test', 'Test', 'D', 'G', 'Test','Test');
    system.assertNotEquals(res,null);

    // Update 
    res = GotvCcController.updateView( res,'Test2', 'Test2', 'P', 'Test2', 'Test2');
    
    // Delete
    ID res2 = GotvCcController.deleteView(res);
  
    System.debug('test14() end');
  }

  @isTest static void test15() {
    System.debug('test15() start');

    Integer batchSize = 9;
    Id accountId = '001i000001XOJIBAA5';
    String whereOption = 'AccountId =  \'001i000001XOJIBAA5\' OR (Account.Account_Group__c = \'Hospital\')';
    System.debug(batchSize);
    System.debug(accountId);
    System.debug(whereOption);
    List <XMatch__c> test = GotvCcController.queueMatchData(batchSize, accountId, whereOption, 'Contact');
    System.assertNotEquals(test.size(),0);
    String startStatus = GotvCcController.startXMatchBatch(accountId,'Contact');
    System.assertEquals(startStatus,'ok');
    System.debug('test15() end');
  }

   @isTest static void test16() {
    System.debug('test16() start');

    String data = GotvCcController.getUrl();
    Integer l = data.length();
    System.assertNotEquals(l,0);
    
    System.debug('test16() end');
  }

}