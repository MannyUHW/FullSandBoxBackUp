public class SignInRemoteController2 {

  @RemoteAction
  public static List<PhonebankLookup__c> getLookupData() {
    list <PhonebankLookup__c> data;
    data = [SELECT Office__c,Agent__c FROM PhonebankLookup__c ORDER BY Office__c,Agent__c];
    return data;
  }

  @RemoteAction
  public static List<sObject> getData(String cutoffDateStr) {

    date cutoffDate = date.valueOf(cutoffDateStr);
    integer recLimit;

    if (Test.isRunningTest())
      recLimit = 2;
    else
      recLimit = 9999999;

    list < sObject > data;
    if (data == null) {
      data = new List<sObject>();
      integer i, l;
      sObject tmpRec;

      for (list < sObject > dataList : [
        SELECT Recruit__r.Email, Recruit__r.FirstName, Recruit__r.HomePhone, Recruit__r.Id, Recruit__r.LastName, Recruit__r.MobilePhone, Recruit__r.OK_To_Text__c, Recruit__r.Ethnic_Group__c,
          Recruit__r.Cope_Amount__c, Recruit__r.Cope_Payment_Date__c, Recruit__r.Employer1__c, Recruited_By__r.FirstName, Recruited_By__r.LastName,
          Alt_First_Name__c, Alt_Last_Name__c, Alt_Phone__c, Attended__c, Credit__c, Volunteer_Date__c, Id, Location__c, Shift__c, Agent__c
        From Recruit__c
        Where  Volunteer_Date__c >= : cutoffDate And Shift__c != null
        Order By Volunteer_Date__c, location__c, Shift__c Limit : recLimit]) {
        l = dataList.size();
        for (i = 0; i < l; i++) {
          tmpRec = dataList[i];
          data.add(tmpRec);
        }
      }
    }
    return data;
  }

  @RemoteAction
  public static List<String> RecruitUpdate(List <String> updates) {

    List < String > errorList;
    List < Database.DeleteResult > drList;
    List < Database.SaveResult > srList;
    List < Recruit__c > recruitsToUpdate;
    List < Contact > contactsToUpdate;
    List < AppLog__c > logsToInsert;

    RecruitTx  tmpRecruitTx;
    Recruit__c tmpRecruit;
    Contact    tmpContact;
    AppLog__c  tmpAppLog;
    String     userId;

    recruitsToUpdate = new List<Recruit__c>();
    contactsToUpdate = new List<Contact>();
    errorList = new List<String>();
    logsToInsert = new List<AppLog__c>();
    Boolean noError = true;

    userId = UserInfo.getUserId();

    for (String RecruitRec : updates) {
      tmpRecruit   = new Recruit__c();
      tmpRecruitTx = RecruitTx.parse(RecruitRec);
      System.debug('....tmpRecruitTx....');
      System.debug(tmpRecruitTx);

      tmpRecruit.Id = tmpRecruitTx.RecruitRecId;
      if (tmpRecruitTx.Credit != 'empty')
        tmpRecruit.Credit__c = tmpRecruitTx.Credit;

      tmpRecruit.Agent__c    = tmpRecruitTx.Agent;
      tmpRecruit.Attended__c = tmpRecruitTx.Attended;

      if (tmpRecruitTx.Attended) // Recruits with a status of cancelled may still show up, so their status should reflect this.
        tmpRecruit.Recruit_Status__c = 'Signed Up';

      recruitsToUpdate.add(tmpRecruit);

      // Recruit may not be a contact.
      if (!String.IsEmpty(tmpRecruitTx.ContactId)) {

        if (tmpRecruitTx.OkToText || tmpRecruitTx.EthnicGroup != 'empty') {
          tmpContact = new Contact();
          tmpContact.Id = tmpRecruitTx.ContactId;
          tmpContact.OK_To_Text__c = tmpRecruitTx.OkToText;

          if (tmpRecruitTx.EthnicGroup != 'empty')
            tmpContact.Ethnic_Group__c = tmpRecruitTx.EthnicGroup;

          contactsToUpdate.add(tmpContact);
        }
      }
    }

    // ------------------------------------------------------------------------------------------- //
    // Update Recruits
    // ------------------------------------------------------------------------------------------- //
    if (!recruitsToUpdate.isEmpty()) {
      try {
        srList = Database.update(recruitsToUpdate, false);
        for (Database.SaveResult sr : srList) {
          if (!sr.isSuccess()) {
            errorList.add('Error 1:' + sr.Errors[0].StatusCode);
            noError = false;
          }
        }
      }
      catch (DmlException e) {
        errorList.add('Error 2');
        noError = false;
      }
    }

    // ------------------------------------------------------------------------------------------- //
    // Update Contacts
    // ------------------------------------------------------------------------------------------- //
    if (!contactsToUpdate.isEmpty()) {
      try {
        srList = Database.update(contactsToUpdate, false);
        for (Database.SaveResult sr : srList) {
          if (!sr.isSuccess()) {
            errorList.add('Error 3:' + sr.Errors[0].StatusCode);
            noError = false;
          }
        }
      }
      catch (DmlException e) {
        errorList.add('Error 4');
        noError = false;
      }
    }

    srList = Database.insert(logsToInsert);
    for (Database.SaveResult sr : srList) {
      if (sr.isSuccess()) {
        System.debug('Successfully inserted log rec ' + sr.getId());
      }
      else {
        System.debug('Oh dear, what irony!  An error occurred saving the error messages to log.' + sr.getErrors());
      }
    }

    return errorList;
  }
}