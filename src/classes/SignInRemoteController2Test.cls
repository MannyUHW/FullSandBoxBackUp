@isTest (seeAllData=true) private class SignInRemoteController2Test  {

  @isTest static void test1() {
    System.debug('test1() start');
    id contactId;
    id recruitRecId;
    boolean attended;
    string credit;
    boolean okToText;
    string ethnicGroup;
    Recruit__c  tmpRecruit;
    RecruitTx   tmpRecruitTx,tmpRecruitTxFromJSON;
    string tmpRecruitTxStr;
    list <string> testResults;
    list <string> testData = new list <string>();
    List <sObject> data = SignInRemoteController2.getData('2016-08-05');
    integer l = data.size();
    system.assertNotEquals(l,0);

    for(sObject rec : data) {
       recruitRecId = (id)  rec.get('Id');
       contactId    = (id)  rec.get('Recruit__c');
       okToText     = true;
       attended     = true;
       credit       = 'full';
       ethnicGroup  = 'Other';

       tmpRecruitTx = new RecruitTx();
       tmpRecruitTx.RecruitRecId = recruitRecId;
       tmpRecruitTx.ContactId    = contactId;
       tmpRecruitTx.OkToText     = okToText;
       tmpRecruitTx.Attended     = attended;
       tmpRecruitTx.Credit       = credit;
       tmpRecruitTx.EthnicGroup  = ethnicGroup;

       System.debug(tmpRecruitTx);
       tmpRecruitTxStr = JSON.serialize(tmpRecruitTx);
       testData.add(tmpRecruitTxStr);

    }

    Savepoint sp = Database.setSavepoint();
    testResults = SignInRemoteController2.RecruitUpdate(testData);
    Database.rollback(sp);

    System.debug('test1() end');
  }

  @isTest static void test2() {
    System.debug('test2() start');

    List <PhonebankLookup__c> data = SignInRemoteController2.getLookupData();    
    integer l = data.size();
    system.assertNotEquals(l,0);

    System.debug('test2() end');
  }
}