public with sharing class ResponseMobileContoller2 {
    
  @RemoteAction
  public static List <Survey_Question__c> getSurveyQuestion(List<String> codes) {
    List <Survey_Question__c> data = [SELECT Id,Survey_Code__c,Description__c,Allowed_Responses__c,Add_Info_Control__c FROM Survey_Question__c WHERE Survey_Code__c In :codes AND IsDeleted = false];
    return data;
  }
  
  @RemoteAction
  public static List <Account> getAccountData() {
    List <Account> data = [SELECT Id, Name, Account_Group__c FROM Account WHERE Type = 'Employer' AND Active__c = 'Yes' AND (Hospital_System__c = 'DIGNITY HEALTH' OR Account_Group__c = 'Kaiser' OR Account_Group__c = 'New Organizing') ORDER BY Account_Group__c ASC NULLS LAST, Name ASC NULLS LAST];
    return data;
  }

  @RemoteAction
  public static List <Contact> getContactData(Id accountId, List<String> codes) {
      List <Contact> data;
      String querySoql;
      Integer i;
      String codeList = '( ';

      for (i=0;i<codes.size();i++) {
        if(i > 0) {
          codeList += ', ';
        }
        codeList += '\'' + codes[i] + '\'';
      }
      codeList += ' )';
      System.debug('CodeList: ' + codeList);

      querySoql  = ' SELECT  Id, AccountId, LastName, FirstName, MobilePhone, HomePhone, Phone, DoNotCall, Shift__c, Department, ';
      querySoql += '  (SELECT Id, Survey_Question__r.Survey_Code__c, Response_Value__c, Add_Info__c FROM Survey_Responses__r WHERE Survey_Question__r.Survey_Code__c IN ' + codeList + ') ' ;
      querySoql += ' FROM Contact WHERE AccountId = \'' + accountId + '\'';
//      querySoql += ' FROM Contact WHERE Id = \'003i000001uiG4CAAU\'';
      querySoql += ' ORDER BY LastName,FirstName';
      System.debug( querySoql );

      data =  Database.query(querySoql);
      return data;
  }

  @RemoteAction
  public static List<String> updateResponse(List <String> updates) {  
    Survey_Response__c tmpResponse;
    List <Survey_Response__c> recordsToUpdate = new List <Survey_Response__c>();
    List <Survey_Response__c> recordsToInsert = new List <Survey_Response__c>();
    List <Database.SaveResult> srList;
    List <String> errorList = new List <String>();
    ResponseTx txRec;
    Integer successCount;

    for (String responseRec : updates) {
      txRec       = ResponseTx.parse(responseRec);
      tmpResponse = new Survey_Response__c ();

      tmpResponse.Contact__c         = txRec.ContactId;
      tmpResponse.Response_Value__c  = txRec.Response;
      tmpResponse.Survey_Question__c = txRec.QuestionId;
      tmpResponse.Add_Info__c        = txRec.CommitTime;

system.debug(txRec);
      if(txRec.ResponseId.length() > 0) {
        tmpResponse.Id = txRec.ResponseId;
        recordsToUpdate.add(tmpResponse);
      } else {
        recordsToInsert.add(tmpResponse);
      }
    }
    
    // ------------------------------------------------------------------------------------------- //
    // Update Survey_Response__c records
    // ------------------------------------------------------------------------------------------- //
    successCount = 0;
    if (!recordsToUpdate.isEmpty()) {
      try {
        srList = Database.update(recordsToUpdate, false);
        for (Database.SaveResult sr : srList) {
          if (!sr.isSuccess()) {
              errorList.add('Error 1:' + sr.Errors[0].StatusCode);
          } else {
              successCount++;
              System.debug('Response record ' + sr.getId() + ' updated.');
          }
        }
        System.debug( successCount + ' out of ' + recordsToUpdate.size() + ' records updated. ');
      }
      catch (DmlException e) {
        errorList.add('Error 2');
      }
    }

    // ------------------------------------------------------------------------------------------- //
    // Insert Survey_Response__c records
    // ------------------------------------------------------------------------------------------- //
    successCount = 0;
    if (!recordsToInsert.isEmpty()) {
      try {
        srList = Database.insert(recordsToInsert, false);
        for (Database.SaveResult sr : srList) {
          if (!sr.isSuccess()) {
              errorList.add('Error 3:' + sr.Errors[0].StatusCode);
          } else {
              successCount++;
              System.debug('Response record ' + sr.getId() + ' inserted.');
          }
        }
        System.debug( successCount + ' out of ' + recordsToInsert.size() + ' records inserted. ');
      }
      catch (DmlException e) {
        errorList.add('Error 4');
      }
    }

    return errorList;
  }
}