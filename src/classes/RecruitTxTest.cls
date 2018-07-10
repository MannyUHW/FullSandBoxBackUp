@isTest (seeAllData=true) private class RecruitTxTest {
  
  @isTest static void test1() {

    System.debug('test1() start');
    
      id contactId;
      id recruitRecId;
      boolean attended;
      string credit;
      boolean okToText;
      string ethnicGroup;
      string agent;
      Recruit__c  tmpRecruit;
      RecruitTx   tmpRecruitTx,tmpRecruitTxFromJSON;
      string tmpRecruitTxStr;
      
    for(sObject rec : [
      SELECT Id,Recruit__r.id
      FROM Recruit__c 
      WHERE Volunteer_Date__c = 2016-05-30 LIMIT 5]) {
        tmpRecruit   = (Recruit__c) rec;
        recruitRecId = tmpRecruit.id;
        contactId    = tmpRecruit.Recruit__c;
        okToText     = true;
        attended     = true;
        credit       = 'full';
        ethnicGroup  = 'Other';
        agent        = 'Oakland Test1';

        tmpRecruitTx = new RecruitTx();
        tmpRecruitTx.Agent        = agent;
        tmpRecruitTx.ContactId    = contactId;
        tmpRecruitTx.RecruitRecId = recruitRecId;
        tmpRecruitTx.OkToText     = okToText;
        tmpRecruitTx.Attended     = attended;
        tmpRecruitTx.Credit       = credit;
        tmpRecruitTx.EthnicGroup  = ethnicGroup;

        System.assertEquals(tmpRecruitTx.Agent,        agent);
        System.assertEquals(tmpRecruitTx.ContactId,    contactId);
        System.assertEquals(tmpRecruitTx.RecruitRecId, recruitRecId);
        System.assertEquals(tmpRecruitTx.ContactId,    contactId);
        System.assertEquals(tmpRecruitTx.OkToText,     okToText);
        System.assertEquals(tmpRecruitTx.Attended,     attended);
        System.assertEquals(tmpRecruitTx.Credit,       credit);
        System.assertEquals(tmpRecruitTx.EthnicGroup,  ethnicGroup);

        tmpRecruitTxStr      = JSON.serialize(tmpRecruitTx);
        tmpRecruitTxFromJSON = RecruitTx.parse(tmpRecruitTxStr);
        System.assertEquals(tmpRecruitTx.Agent,        tmpRecruitTxFromJSON.Agent);
        System.assertEquals(tmpRecruitTx.ContactId,    tmpRecruitTxFromJSON.ContactId);
        System.assertEquals(tmpRecruitTx.RecruitRecId, tmpRecruitTxFromJSON.RecruitRecId);
        System.assertEquals(tmpRecruitTx.ContactId,    tmpRecruitTxFromJSON.ContactId);
        System.assertEquals(tmpRecruitTx.OkToText,     tmpRecruitTxFromJSON.OkToText);
        System.assertEquals(tmpRecruitTx.Attended,     tmpRecruitTxFromJSON.Attended);
        System.assertEquals(tmpRecruitTx.Credit,       tmpRecruitTxFromJSON.Credit);
        System.assertEquals(tmpRecruitTx.EthnicGroup,  tmpRecruitTxFromJSON.EthnicGroup);
    }
        System.debug('test1() end');
  }
}