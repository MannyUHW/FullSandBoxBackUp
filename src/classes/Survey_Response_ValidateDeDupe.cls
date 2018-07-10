/*
 * Survey Response Validate and DeDupe - helper for Survey Response Controller
 * 
 * Version: 1.14
 * 13th Mar 2017
 * 
 * Version History
 * 1.14 - added support for Original Coordinator and Original Organizer
 * 1.13 - propagate Report Group values from previous to new
 * 1.12 - minor tweak for update and Previous Values
 * 1.11 - corrected Add Info check for null
 * 1.10 - add Add Info and Related to Member field support
 * 1.02 - removed "with Sharing"
 * 1.01 - updated
 * 1.0 - created
 * 
 * Copyright (c) 2016 SEIU-UHW
 * 560 Thomas L Berkley Way
 * Oakland, CA 94612, USA
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of SEIU-UHW.
 * ("Confidential Information").
 */
public class Survey_Response_ValidateDeDupe { 

  public static void validateDeDupe(List<Survey_Response__c> pNewList, List<Survey_Response__c> pOldList, Boolean pIsInsert){ 
  
    //DEVELOPMENT TO DO:
    //1. add info to Surveys Consolidated and Surveys Encoded on the Contact object
    //2. add Scope functionality to propagate Survey Responses to second (or third) jobs
    //
  
    //check to make sure either contact or alternative contact is populatd
    for (Survey_Response__c sr: pNewList) {
      if (sr.contact__c == null) {
        if (sr.alt_last_name__c == null || sr.alt_last_name__c.trim() == '' || sr.alt_first_name__c == null || sr.alt_first_name__c.trim() == '' || sr.alt_employer__c == null) {
          sr.name.addError('Either a Contact record must be associated with a Survey Response OR an Alt Last Name, Alt First Name, and Alt Employer are required.');
        }
      }
      //add original Coordinator and Organizer
      if (pIsInsert) {
        sr.Coordinator_Original__c = sr.Coordinator__c;
        sr.Organizer_1_Original__c = sr.Organizer_1__c ; 
      }
    }
    
    
  
    Map<String, Survey_Response__c> responseMap = new Map<String, Survey_Response__c>();
    Map<String, Id> ridQidMap = new Map<String, Id>();
    Map<Id, String> questionMap = new Map<Id, String>();
    Set<Id> qidSet = new Set<Id>();
    Set<Id> cidSet = new Set<Id>();
    for (Survey_Response__c sr: pNewList) {
      //create a temporary response id because no id exists on a before insert
      String tempRid = '' + sr.Contact__c + sr.Contact_Name__c + sr.Employer_Name__c + sr.Survey_Question__c;
      if (sr.id != null) {
        tempRid = '' + sr.id;
      }
      System.debug('sr id value = ' + tempRid);
      responseMap.put(tempRid, sr);
      System.debug('sr value = ' + sr.Response_Value__c);
      System.debug('question = ' + sr.Survey_Question__c);
      ridQidMap.put(tempRid, sr.Survey_Question__c);
    qidSet.add(sr.Survey_Question__c);
    cidSet.add(sr.Contact__c);
    System.debug('allowed(' + sr.Survey_Question__r.id  + ') = ' + sr.Survey_Question__r.Allowed_Responses__c);
  }
  


      System.debug('qid set size = ' + qidSet.size());
      List<Survey_Question__c> sqList = [select Id, Allowed_Responses__c from Survey_Question__c where Id in :qidSet ];
      System.debug('sq list size = ' + sqList.size());
      for (Survey_Question__c sq: sqList) {
        questionMap.put(sq.id, sq.Allowed_Responses__c);
      }

  
  for (String rid: responseMap.keySet()) {
    Survey_Response__c sr = responseMap.get(rid);
    Id qid = ridQidMap.get(rid);
    //Survey_Question__c sq = questionMap.get(qid);
    //System.debug('allowed = ' + sq.Allowed_Responses__c);
    List<String> allowedList = questionMap.get(qid).split('\n');
    String rv = '';
    if (sr.Response_Value__c != null) {
      rv = sr.Response_Value__c.toLowerCase();
    }
    boolean found = false;
    for (String av: allowedList) {
      if (av.toLowerCase().startsWith(rv)) {
        sr.Response_Value__c = av;
        found = true;
        break;
      }
    }
    if (!found && pIsInsert) {
      sr.name.addError('Response must be equal to start with the response value.  Invalid response = ' +  sr.Response_Value__c);
    }
  }
  
  
  //prevent duplicates 
  if (pIsInsert) {
  List<Survey_Response__c> existingSrList = [select Id, Contact__c, Survey_Question__c, Response_Value__c, Previous_Responses__c, Collected_Datetime__c, Add_Info__c, Alt_Related_Member__c, Collected_By__c, Report_Group__c, Organizer_1_Original__c, Coordinator_Original__c from Survey_Response__c where Survey_Question__c in :qidSet and Contact__c!=null AND Contact__c in :cidSet order by Collected_Datetime__c desc ];
  System.debug('existing sr list size = ' + existingSrList.size());
  for (String rid: responseMap.keySet()) {
    Survey_Response__c sr = responseMap.get(rid);
    for (Survey_Response__c sr2: existingSrList) {
      if (sr2.contact__c != null && sr.contact__c != null && sr2.contact__c == sr.contact__c && sr2.Survey_Question__c == sr.Survey_Question__c && sr.id != sr2.id) {
        System.debug('this should be an update, not an insert ('  + sr.contact__c + ', ' + sr.Survey_Question__c + ')');
        if (sr2.Previous_Responses__c == null) {
          sr2.Previous_Responses__c = '';
        }
        sr.Previous_Responses__c = sr2.Response_Value__c + ' (' + sr2.Collected_Datetime__c + ')\n' + sr2.Previous_Responses__c.trim();
        if (sr.Previous_Responses__c.length() > 512) {
          sr.Previous_Responses__c = sr.Previous_Responses__c.substring(0, 512);
        }
        
        sr.Coordinator_Original__c = sr2.Coordinator_Original__c;
        sr.Organizer_1_Original__c = sr2.Organizer_1_Original__c;        

        if (sr2.Add_Info__c != null && sr2.Add_Info__c.trim() != '' && (sr.Add_Info__c == null || sr.Add_Info__c.trim() == '')) {
          sr.Add_Info__c = sr2.Add_Info__c;
        }

        if (sr2.Alt_Related_Member__c != null && sr.Alt_Related_Member__c == null) {
          sr.Alt_Related_Member__c = sr2.Alt_Related_Member__c;
        }
        if (sr2.Collected_By__c != null && sr.Collected_By__c == null) {
          sr.Collected_By__c = sr2.Collected_By__c;
        }
        if (sr2.Report_Group__c != null && sr.Report_Group__c == null) {
          sr.Report_Group__c = sr2.Report_Group__c;
        }
        
        delete sr2;       
      }
    }
  }
  } else {
    Map<Id, Survey_Response__c> oldMap = new Map<Id, Survey_Response__c>();
    for (Survey_Response__c sr2: pOldList) {
      oldMap.put(sr2.id, sr2);
    }
    for (String rid: responseMap.keySet()) {
      Survey_Response__c sr = responseMap.get(rid);
      Survey_Response__c sr2 = oldMap.get(sr.id);
      String prevResponses = '';
      if ( sr2.Previous_Responses__c != null) {
        prevResponses = sr2.Previous_Responses__c;
      }
      if (sr2.Response_Value__c.substring(0,1) != sr.Response_Value__c.substring(0,1)) {
        sr.Previous_Responses__c = sr2.Response_Value__c + ' (' + sr2.Collected_Datetime__c + ')\n' + prevResponses.trim();
      }
      if (sr.Previous_Responses__c != null && sr.Previous_Responses__c.length() > 512) {
        sr.Previous_Responses__c = sr.Previous_Responses__c.substring(0, 512);
      }
    }
    
  }
  }
  
}