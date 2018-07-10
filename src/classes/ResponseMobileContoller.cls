public with sharing class ResponseMobileContoller {
    
  @RemoteAction
  public static List <Survey_Question__c> getSurveyQuestion(String code) {
    List <Survey_Question__c> data = [SELECT Id,Survey_Code__c,Description__c,Allowed_Responses__c FROM Survey_Question__c WHERE Survey_Code__c = :code AND IsDeleted = false];
    return data;
  }
  
  @RemoteAction
  public static List <Account> getAccountData() {
    List <Account> data = [SELECT Id, Name, Account_Group__c FROM Account WHERE Type = 'Employer' AND Active__c = 'Yes' AND (Hospital_System__c = 'DIGNITY HEALTH' OR Account_Group__c = 'Kaiser') ORDER BY Account_Group__c ASC NULLS LAST, Name ASC NULLS LAST];
    return data;
  }

  @RemoteAction
  public static List <Contact> getContactData(Id accountId, String code) {
      List <Contact> data;
      String querySoql;
      querySoql  = ' SELECT  Id, AccountId, LastName, FirstName, MobilePhone, HomePhone, Phone, DoNotCall, Shift__c, Department,';
      querySoql += ' ( SELECT Id, Response_Value__c '; 
      querySoql += '   FROM Survey_Responses__r WHERE Survey_Question__r.Survey_Code__c = \'' + code + '\' )';
      querySoql += ' FROM Contact WHERE AccountId = \'' + accountId + '\'';
      querySoql += ' ORDER BY LastName,FirstName ';
      System.debug( querySoql );
      data =  Database.query(querySoql);
      return data;
  }

  @RemoteAction
  public static String updateResponse(String userId, Id contactId, Id surveyQuestionId, Boolean attend, String respId) {  

    Survey_Response__c tmpResponse = new Survey_Response__c();
    tmpResponse.Response_Value__c  = 'yes';
    String retVal = 'ok';

    if(!String.isBlank(respId)) {
      tmpResponse.Id = respId;
      if(attend == true) {
        // ------------------------------------------------------------------------------------------- //
        // Update Response
        // ------------------------------------------------------------------------------------------- //
        try {
          Update tmpResponse;
          System.debug('Survey Response record updated. ');
        } catch(Exception e) {
          System.debug('Error updating Survey Response record. ' + e.getMessage());
          retVal = 'error';
        }
      } else {
        List<Survey_Response__c> responseArray = new List<Survey_Response__c>();
        responseArray.add(tmpResponse);
        // ------------------------------------------------------------------------------------------- //
        // Delete Response
        // ------------------------------------------------------------------------------------------- //
        Database.DeleteResult[] drList = Database.delete(responseArray, false);
        for (Database.DeleteResult dr : drList) {
          if(!dr.isSuccess()) {
            retVal = 'error';
            for(Database.Error err : dr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
            }
            }
          }          
      }
    } else {
      tmpResponse.Survey_Question__c = surveyQuestionId;
//      tmpResponse.Collected_By__c = userId;
      tmpResponse.Contact__c = contactId;
      // ------------------------------------------------------------------------------------------- //
      // Insert Response
      // ------------------------------------------------------------------------------------------- //
      List<Survey_Response__c> responseArray = new List<Survey_Response__c>();
      responseArray.add(tmpResponse);
      Database.SaveResult[] srList = Database.insert(responseArray, false);
      for (Database.SaveResult sr : srList) {
        if(sr.isSuccess()) {
          System.debug('Successfully inserted record.');
        }
        else {
          retVal = 'error';
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
            }
        }
        }
    }

    return retVal;
  }
}