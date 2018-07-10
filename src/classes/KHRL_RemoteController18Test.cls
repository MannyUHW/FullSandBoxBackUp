@isTest (seeAllData=true) private class KHRL_RemoteController18Test {

 // Note: due to batch test limits, must use an Account with < 200 contacts (caused if Contact ownership changes).

 @isTest static void test1() {

  System.debug('Test 1 - pass all ids');

  List<Account> testData = [
    SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c , Contract_Specialist__c 
    FROM Account 
    WHERE Name = 'KAISER-BAKERSFIELD' Limit 1];

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.Constituency__c       = 'KS1B';
  tmpKHRL.CoordinatorId__c      = testData[0].Coordinator__c;
  tmpKHRL.CsId__c               = testData[0].Contract_Specialist__c;
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EmpAccountId__c       = testData[0].Id;
  tmpKHRL.Note__c               = 'Gabby on leave through July 12';
  tmpKHRL.Org1Id__c             = testData[0].Organizer_1__c;
  //tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;
  tmpKHRL.UpdateEboard__c       = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'R';
  tmpKHRL.Org1Flag__c           = 'R';
  tmpKHRL.Org2Flag__c           = 'R';
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.RowPtr__c             = 1;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.KhrlUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

   @isTest static void test2() {

   List<Account> testData = [
    SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c , Organizer_2__c, Contract_Specialist__c  
    FROM Account 
    WHERE Name = 'KAISER-BAKERSFIELD' Limit 1];

  System.debug('Test 2 - not passing Org1Id');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.Constituency__c       = 'KS1B';
  tmpKHRL.CoordinatorId__c      = testData[0].Coordinator__c;
  tmpKHRL.CsId__c               = testData[0].Contract_Specialist__c;
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EmpAccountId__c       = testData[0].Id;
  tmpKHRL.Note__c               = 'Gabby on leave through July 12';
  tmpKHRL.Org1Id__c             = '';
  tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;
  tmpKHRL.UpdateEboard__c       = 0;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'R';
  tmpKHRL.Org1Flag__c           = 'R';
  tmpKHRL.Org2Flag__c           = 'R';
  tmpKHRL.RowPtr__c             = 1;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.KhrlUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

 @isTest static void test3() {

   List<Account> testData = [
    SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c , Organizer_2__c, Contract_Specialist__c  
    FROM Account 
    WHERE Name = 'KAISER-BAKERSFIELD' Limit 1];

  System.debug('Test 3 - not passing Org1Id or CoordinatorId__c');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.Constituency__c       = 'KS1B';
  tmpKHRL.CoordinatorId__c      = '';
  tmpKHRL.CsId__c               = testData[0].Contract_Specialist__c;
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EmpAccountId__c       = testData[0].Id;
  tmpKHRL.Note__c               = 'Gabby on leave through July 12';
  tmpKHRL.Org1Id__c             = '';
  tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;  
  tmpKHRL.UpdateEboard__c       = 0;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'R';
  tmpKHRL.Org1Flag__c           = 'R';
  tmpKHRL.Org2Flag__c           = 'R';
  tmpKHRL.RowPtr__c             = 1;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.KhrlUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

   @isTest static void test4() {

 List<Account> testData = [
   SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c , Organizer_2__c, Contract_Specialist__c  
   FROM Account 
   WHERE Name = 'KAISER-BAKERSFIELD' Limit 1];

  System.debug('Test 4 - no Ids just reset flags');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.Constituency__c       = 'KS1B';
  tmpKHRL.CoordinatorId__c      = '';
  tmpKHRL.CsId__c               = '';
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EmpAccountId__c       = testData[0].Id;
  tmpKHRL.Note__c               = '';
  tmpKHRL.Org1Id__c             = '';
  tmpKHRL.Org2Id__c             = '';
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;  
  tmpKHRL.UpdateEboard__c       = 0;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'R';
  tmpKHRL.Org1Flag__c           = 'R';
  tmpKHRL.Org2Flag__c           = 'R';
  tmpKHRL.RowPtr__c             = 1;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.KhrlUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

 @isTest static void test5a() {

   List<Account> testData = [
    SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c, Contract_Specialist__c , EBoard_Seats__c
    FROM Account 
    WHERE Account_Group__c = 'Kaiser' AND Active__c = 'yes' AND 
          Regional_Director__c   != null AND 
          Coordinator__c         != null AND 
          Organizer_1__c         != null AND 
          Contract_Specialist__c != null Limit 1];

  System.debug('Test 5a - Eboard update (reset)');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.CoordinatorId__c      = testData[0].Coordinator__c;
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EboardId__c           = testData[0].EBoard_Seats__c;
  tmpKHRL.Org1Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;
  tmpKHRL.UpdateEboard__c       = 1;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'R';
  tmpKHRL.Org1Flag__c           = 'R';
  tmpKHRL.Org2Flag__c           = 'R';

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.EbUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

 @isTest static void test5b() {

   List<Account> testData = [
    SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c, EBoard_Seats__c
    FROM Account 
    WHERE Account_Group__c = 'Hospital' AND Active__c = 'yes' AND 
          Regional_Director__c   != null AND 
          Coordinator__c         != null AND 
          Organizer_1__c         != null AND 
          EBoard_Seats__c        != null Limit 1];

  System.debug('Test 5b - Eboard update (change)');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.CoordinatorId__c      = testData[0].Coordinator__c;
  tmpKHRL.DivisionCode__c       = 'H';
  tmpKHRL.EboardId__c           = testData[0].EBoard_Seats__c;
  tmpKHRL.Org1Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;
  tmpKHRL.UpdateEboard__c       = 1;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'C';
  tmpKHRL.Org1Flag__c           = 'C';
  tmpKHRL.Org2Flag__c           = 'C';
  tmpKHRL.ResetCoordinator__c   = 0;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.EbUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

 @isTest static void test6() {

   Contact SmudgeContact = new Contact();
   SmudgeContact.FirstName = 'Smudge';
   SmudgeContact.LastName  = 'Cat';
   SmudgeContact.Fid__c    = 'DummyFid_3';
   insert SmudgeContact;

   Contact PussContact = new Contact();
   PussContact.FirstName = 'Puss';
   PussContact.LastName  = 'Cat';
   PussContact.Fid__c    = 'DummyFid_1';
   insert PussContact;

   Contact WuggleContact = new Contact();
   WuggleContact.FirstName = 'Wuggle';
   WuggleContact.LastName  = 'Cat';
   WuggleContact.Fid__c    = 'DummyFid_2';
   insert WuggleContact;

   ContractSpecialists__c tmpCsRecToUpdate = new ContractSpecialists__c();
   tmpCsRecToUpdate.Contact__c   = PussContact.Id;
   tmpCsRecToUpdate.Division__c  = 'Kaiser';
   tmpCsRecToUpdate.Email__c     = 'test@test.com';
   tmpCsRecToUpdate.CellPhone__c = '123 456 7890';
   insert tmpCsRecToUpdate;
 
   ContractSpecialists__c tmpCsRecToDelete = new ContractSpecialists__c();
   tmpCsRecToDelete.Contact__c   = WuggleContact.Id;
   tmpCsRecToDelete.Division__c  = 'Kaiser';
   tmpCsRecToDelete.Email__c     = 'test@test.com';
   tmpCsRecToDelete.CellPhone__c = '123 456 7890';
   insert tmpCsRecToDelete;

   List<String> emptyStringArray  = new List<String>();
   List <KHRLObject__c> testArray = new List <KHRLObject__c>();
   List<String> results;
   KHRLobject__c tmpKHRLobject;

   tmpKHRLobject                 = new KHRLobject__c();
   tmpKHRLobject.CsId__c         = PussContact.Id;
   tmpKHRLobject.CsEmail__c      = '';
   tmpKHRLobject.CsPhone__c      = '';
   tmpKHRLobject.CsOp__c         = 'Add';
   tmpKHRLobject.DivisionCode__c = 'K';
   testArray.add(tmpKHRLobject);

   tmpKHRLobject                 = new KHRLobject__c();
   tmpKHRLobject.CsRecId__c      = tmpCsRecToUpdate.Id;
   tmpKHRLobject.CsEmail__c      = 'test@email.com';
   tmpKHRLobject.CsPhone__c      = '(916) 444-8530';
   tmpKHRLobject.CsOp__c         = 'Chg';
   testArray.add(tmpKHRLobject);

   tmpKHRLobject                 = new KHRLobject__c();
   tmpKHRLobject.CsId__c         = WuggleContact.Id;         // Contact gets its CS flag reset.
   tmpKHRLobject.CsRecId__c      = tmpCsRecToDelete.Id;
   tmpKHRLobject.CsOp__c         = 'Del';
   testArray.add(tmpKHRLobject);

   results = KHRL_RemoteController18.CsUpdate(testArray);
   System.assertEquals(emptyStringArray, results); // results array should be empty.
 }

 @isTest static void test7() {

   List<Account> testData = [
   SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c , Organizer_2__c, Contract_Specialist__c  
   FROM Account 
   WHERE Name = 'KAISER-BAKERSFIELD' Limit 1];

  System.debug('Test 7a - passing R flags');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.Constituency__c       = 'KS1B';
  tmpKHRL.CoordinatorId__c      = '';
  tmpKHRL.CsId__c               = testData[0].Contract_Specialist__c;
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EmpAccountId__c       = testData[0].Id;
  tmpKHRL.Note__c               = '';
  tmpKHRL.Org1Id__c             = '';
  tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;  
  tmpKHRL.UpdateEboard__c       = 0;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = '';
  tmpKHRL.CoordFlag__c          = 'R';
  tmpKHRL.Org1Flag__c           = 'R';
  tmpKHRL.Org2Flag__c           = 'R';
  tmpKHRL.ResetCS__c            = 1;
  tmpKHRL.RowPtr__c             = 1;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.KhrlUpdate(testArray);
  System.assertEquals(emptyStringArray, results); // results array should be empty.

 }

 @isTest static void test7b() {

 List<Account> testData = [
    SELECT Id, Regional_Director__c, Coordinator__c, Organizer_1__c 
    FROM Account 
    WHERE Name = 'KAISER-BAKERSFIELD' Limit 1];

  System.debug('Test 7b - passing C flags');

  List<String> emptyStringArray  = new List<String>();
  List <KHRLObject__c> testArray = new List <KHRLObject__c>();
  KHRLobject__c tmpKHRL          = new KHRLobject__c();
  List<String> results;

  tmpKHRL.Constituency__c       = 'KS1B';
  tmpKHRL.CoordinatorId__c      = testData[0].Coordinator__c;
  tmpKHRL.CsId__c               = '';
  tmpKHRL.DivisionCode__c       = 'K';
  tmpKHRL.EmpAccountId__c       = testData[0].Id;
  tmpKHRL.Note__c               = '';
  tmpKHRL.Org1Id__c             = testData[0].Organizer_1__c;
  //tmpKHRL.Org2Id__c             = testData[0].Organizer_1__c;
  tmpKHRL.Regional_Director__c  = testData[0].Regional_Director__c;  
  tmpKHRL.UpdateEboard__c       = 0;
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.DirectorFlag__c       = 'C';
  tmpKHRL.CoordFlag__c          = 'C';
  tmpKHRL.Org1Flag__c           = 'C';
  tmpKHRL.Org2Flag__c           = 'C';
  tmpKHRL.ResetCS__c            = 0;
  tmpKHRL.RowPtr__c             = 1;

  testArray.add(tmpKHRL);

  results = KHRL_RemoteController18.KhrlUpdate(testArray);
  System.assertNotEquals(emptyStringArray, results); // results array should be empty.

 }

}