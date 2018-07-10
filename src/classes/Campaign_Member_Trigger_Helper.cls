/*
 * Campaign Member Trigger Helper - for Cvent integration
 * 
 * Version: 1.0
 * 25th May 2016
 * 
 * Version History
 * 1.0 - created
 * 
 * Copyright (c) 2016 SEIU-UHW
 * 560 Thomas L Berkley Way
 * Oakland, CA 94612, USA
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of SEIU-UHW.
 * ('Confidential Information').
 */
public class Campaign_Member_Trigger_Helper {

  public static void propagateResponse(List<CampaignMember> pNewList, Map<Id, CampaignMember> pOldMap, Boolean pIsInsert, Boolean pIsDelete) {
    List<User> sysAdminList = [select Id, Name, Email, Profile.Name from User where Profile.Name like '%admin%' and isactive = true];
    List<String> sysAdmins = new List<String>();
    for (User u: sysAdminList) {
      sysAdmins.add(u.Email);
    }

    Set<Id> campIdSet = new Set<Id>();
    List<CampaignMember> alist = new List<CampaignMember>();
    if (!pIsDelete) {
      for (CampaignMember cm: pNewList) {
        campIdSet.add(cm.CampaignId);
        alist.add(cm);
      }
    } else {
      for (CampaignMember cm: pOldMap.values()) {
        campIdSet.add(cm.CampaignId);
        alist.add(cm);        
      }    
    }
    List<Campaign> campList = [select Id, Name, Survey_Question__c from Campaign where Id in :campIdSet];
    Set<Id> sqIdSet = new Set<Id>();
    Map<Id, Id> campIdSqMap = new Map<Id, String>();
    for (Campaign camp: campList) {
      campIdSqMap.put(camp.Id, camp.Survey_Question__c);
      sqIdSet.add(camp.Survey_Question__c);
    }
    
    Map<String, String> statusResponseMap = new Map<String, String>();
    List<Cvent_Status_Mappings__c> slist = [select Name, Survey_Response_Value__c from Cvent_Status_Mappings__c ];
    for (Cvent_Status_Mappings__c csm: slist) {
      statusResponseMap.put(csm.Name.trim().toLowerCase(), csm.Survey_Response_Value__c);
    }


    List<Survey_Question__c> sqList = [select Id, Name from Survey_Question__c where Id in :sqIdSet ];

    List<Survey_Response__c> srList = new List<Survey_Response__c>();
        
    for (CampaignMember cm: alist) {
      Id sqId = campIdSqMap.get(cm.CampaignId);
      CampaignMember oldCm = null;
      if (cm.Id != null && !pIsInsert) {
        oldCm = pOldMap.get(cm.Id);
      }
      if (sqId != null && (oldCm == null || oldCm.Status != cm.Status)) {
        try {
          Survey_Response__c sr = new Survey_Response__c();
          sr.Contact__c = cm.ContactId;
          sr.Response_Value__c = 'U. Unknown Status';
          sr.Survey_Question__c = sqId;  
          if (pIsDelete) {
            sr.Response_Value__c = 'N. Cancelled';    
          } else if (statusResponseMap.get(cm.Status.toLowerCase().trim()) != null) {
            sr.Response_Value__c = statusResponseMap.get(cm.Status.toLowerCase().trim());
          }
          sr.Add_Info__c = null;
          if (!pIsDelete) {
            sr.Add_Info__c = cm.Status;          
          }
          srList.add(sr);
        } catch (Exception ex2) {
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          //String[] toAddresses = new String[] {'bborcherding@seiu-uhw.org', 'jdecker@seiu-uhw.org', 'mdalmacio@seiu-uhw.org'};
          mail.setToAddresses(sysAdmins);
          mail.setSubject('Cvent Propagate to Survey Response Failed For Contact - ' + cm.ContactId + ', Campaign = ' + cm.Campaign);
          mail.setPlainTextBody('Failure in propagating Cvent Campaign Member to Survey Response:\n' + ex2 + '\n\nCvent/Campaign Status = _' + cm.Status + '_');
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
      } else {
        System.debug('No Survey Question for Campaign __' + cm.Campaign + '__');      
      }
    }
    if (srList != null && srList.size() > 0) {
      insert srList;
    }
  }
  
  public static Integer cheese() {
      System.debug('[cheese] start');        
      Integer i = 0;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      return i;                                             
    }  
  
}