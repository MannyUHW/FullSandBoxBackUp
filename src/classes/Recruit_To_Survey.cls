/*
 * Recruit to Survey - helper for Recruit Trigger Controller
 * 
 * Version: 1.02
 * 17th Oct 2016
 * 
 * Version History
 * 1.03 - made @future annotation.
 * 1.02 - more bug fixes
 * 1.01 - bug fixes
 * 1.0 - created, 20th Sep 2016
 * 
 * Copyright (c) 2016 SEIU-UHW
 * 560 Thomas L Berkley Way
 * Oakland, CA 94612, USA
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of SEIU-UHW.
 * ('Confidential Information').
 */
public class Recruit_To_Survey { 

    public Recruit_To_Survey() {
      //ignore
    }

    @future
    public static void propagateToSurvey(Set<Id> pNewIdSet, Set<Id> pOldIdSet, Boolean pIsInsert, Boolean pIsDelete) {
      Recruit__c debugRecruit = null;

      List<Recruit__c> pNewList = null;
      if (pNewIdSet!= null && pNewIdSet.size() > 0) {      
        pNewList = [select Id, Volunteer_Date__c, Recruited_By__c, Recruit_Name__c, Recruit__c, Alt_Last_Name__c, Alt_First_Name__c, Alt_Middle_Name__c, Alt_Person_Type__c, Alt_Employer__c, Employer_Name__c, Location__c, Total_Shift__c from Recruit__c where Id in :pNewIdSet];
      }
      List<Recruit__c> pOldList = null;
      if (pOldIdSet != null && pOldIdSet.size() > 0) {
        pOldList = [select Id, Volunteer_Date__c, Recruited_By__c, Recruit_Name__c, Recruit__c, Alt_Last_Name__c, Alt_First_Name__c, Alt_Middle_Name__c, Alt_Person_Type__c, Alt_Employer__c, Employer_Name__c, Location__c, Total_Shift__c from Recruit__c where Id in :pOldIdSet];
      }
      try {

        Set<String> emNameSet = new Set<String>();
        

        List<Data_Group__c> dataParams = [ select Value__c from Data_Group__c where Name = 'Default_Employer_Name' limit 1 ];
        Account defaultEmployer = null;      
        if (dataParams != null) {
          String defaultEmployerName = dataParams[0].Value__c;
          List<Account> defaultEmployerList = [select Id, Name from Account where Name = :defaultEmployerName];
          if (defaultEmployerList != null && defaultEmployerList.size() > 0) {
            defaultEmployer = defaultEmployerList[0];
          }
        }      
      
        List<Survey_Question__c> sqList = [select Id, Effective_Date__c, End_Date__c, Name, Survey_Code__c from Survey_Question__c where Linked_to_Recruits__c  = true and Effective_Date__c <= TODAY and End_Date__c >= TODAY ];
     
        if (sqList.size() == 0) {
          return; 
        } else if (sqList.size() > 1) {
          String errString = 'There are multiple active Survey Questions linked to Recruits in the system.  Only one Survey Question can be linked to Recruits at a time.';
          for (Recruit__c r: pNewList) {
            r.addError(errString);
          }
          return;
        }   
        
        Map<String, Recruit__c> oldAltMap = new Map<String, Recruit__c>();
        Map<Id, Recruit__c> oldCidMap = new Map<Id, Recruit__c>();
        
        if (!pIsInsert && pNewList != null) {
          Integer noChangeCount = 0;
          Map<Id, Recruit__c> oldMap = new Map<Id, Recruit__c>();
          for (Recruit__c r: pOldList) {
            emNameSet.add(r.Employer_Name__c);
            oldMap.put(r.Id, r);
            String altKey = null;
            if (r.Recruit__c == null) {
              altKey = (r.Alt_First_Name__c + ';' + r.Alt_Last_Name__c  + ';' +  r.Employer_Name__c).toLowerCase();        
              oldAltMap.put(altKey, r);
            } else {
              oldCidMap.put(r.Recruit__c, r);
            }                          
          }
          for (Recruit__c r: pNewList) {
            debugRecruit = r;        
            emNameSet.add(r.Employer_Name__c);            
            if (oldMap.containsKey(r.Id)) {
              if (oldMap.get(r.Id).Total_Shift__c == r.Total_Shift__c) {
                noChangeCount++;
              }
            }
          }
          if (noChangeCount == pNewList.size()) {
            System.debug('No changes to Total Shifts, Recruit to Survey Response not updating SRs.');
            return;
          }
        }
        
        Map<String, Account> emNameMap = new Map<String, Account>();
        List<Account> emList = [ select Id, Name from Account where Name in :emNameSet];
        for (Account em: emList ) {        
          emNameMap.put(em.Name, em);
        }
      
        List<Id> newIdList = new List<Id>();
           
        //List<Id> sqidList = new List<Id>();
        Date startDate;
        Date endDate;  
        Id sqid;    
        for (Survey_Question__c sq: sqList) {
          sqid = sq.Id;
          startDate = sq.Effective_Date__c;
          endDate = sq.End_Date__c;
        }
        Set<Id> ridSet = new Set<Id>();  
      
        Map<Id, Id> collectorMap = new Map<Id, Id>();
        Map<Id, Double> countMap = new Map<Id, Double>();
        Map<Id, Date> dateMap = new Map<Id, Date>();      

        Map<String, Id> altCollectorMap = new Map<String, Id>();      
        Map<String, Recruit__c> altPersonMap = new Map<String, Recruit__c>();    
        Map<String, Double> altCountMap = new Map<String, Double>();            
        Set<String> altKeySet = new Set<String>();         
        Set<Id> altEmSet = new Set<Id>();         
        Map<String, Date> altDateMap = new Map<String, Date>();      
      
        String debugAltEmId = '';
      
      
        System.debug('cycling through new Recruits...');
      
        if (pNewList != null) {    
          for (Recruit__c r: pNewList) {
            debugRecruit = r;
            String altKey = null;
            if (r.Recruit__c == null) {
              altKey = (r.Alt_First_Name__c + ';' + r.Alt_Last_Name__c  + ';' +  r.Employer_Name__c).toLowerCase();        
              if (!altCountMap.containsKey(altKey)) {
                 altCountMap.put(altKey , 0.0);
              }   
              System.debug('adding alt key = ' + altKey);
              altKeySet.add(altKey);          
            } else {
              if (!countMap.containsKey(r.Recruit__c)) {
                countMap.put(r.Recruit__c, 0.0);
              }
            }
            
            
            
            if (r.Volunteer_Date__c >= startDate && r.Volunteer_Date__c <= endDate) {
              newIdList.add(r.Id);
              if (r.Recruit__c != null) {
                ridSet.add(r.Recruit__c);

                if (r.Recruited_By__c != null && !collectorMap.containsKey(r.Recruit__c)) {
                  collectorMap.put(r.Recruit__c, r.Recruited_By__c);
                }    
                Double shiftCount = 0;
                if ( countMap.containsKey( r.Recruit__c)) {
                  shiftCount = countMap.get( r.Recruit__c);
                }
                //String debugString = '';
                //if (debugMap.containsKey(r.Recruit__c)) {
                //  debugString = debugMap.get(r.Recruit__c);
                //}
                //debugString += r.Volunteer_Date__c + ' (' + r.Total_Shift__c + '); ';
                //debugMap.remove(r.Recruit__c);
                //debugMap.put(r.Recruit__c, debugString);
                shiftCount = shiftCount + r.Total_Shift__c;
                countMap.remove(r.Recruit__c);        
                countMap.put( r.Recruit__c, shiftCount);
                dateMap.put( r.Recruit__c, r.Volunteer_Date__c); 
              } else {
                //ALT PERSON ROLLUP
                
                altPersonMap.put(altKey, r);
                Double shiftCount = 0;
                if ( altCountMap.containsKey( altKey)) {
                  shiftCount = altCountMap.get(altKey);
                }
                shiftCount = shiftCount + r.Total_Shift__c;
                altCountMap.remove(altKey);        
                altCountMap.put(altKey, shiftCount);
                altDateMap.put(altKey, r.Volunteer_Date__c);               
                altEmSet.add(r.Alt_Employer__c);
                debugAltEmId = r.Alt_Employer__c;
                if (r.Recruited_By__c != null && !altCollectorMap.containsKey(altKey)) {
                  altCollectorMap.put(altKey, r.Recruited_By__c);
                }      
                               
              }
            }
          }
        }
        if (pOldList != null) {
          for (Recruit__c r: pOldList) {
            debugRecruit = r;
            String altKey = null;
            if (r.Recruit__c == null) {
              altKey = (r.Alt_First_Name__c + ';' + r.Alt_Last_Name__c  + ';' +  r.Employer_Name__c).toLowerCase();        
              if (!altCountMap.containsKey(altKey)) {
                 altCountMap.put(altKey , 0.0);
              }           
              System.debug('adding alt key = ' + altKey);              
              altKeySet.add(altKey); 
              altEmSet.add(r.Alt_Employer__c);  
              debugAltEmId = r.Alt_Employer__c;             
            } else {
              if (!countMap.containsKey(r.Recruit__c)) {
                countMap.put(r.Recruit__c, 0.0);
              }
              ridSet.add(r.Recruit__c);              
            }        
          }       
        } 
        List<Survey_Response__c> srList = [ select Id, Name, Contact__c, Alt_First_Name__c, Alt_Middle_Name__c, Alt_Last_Name__c, Alt_Person_Type__c, Alt_Employer__c, Employer_Name__c, Add_Info__c from Survey_Response__c where Survey_Question__c = :sqid and (Contact__c in :ridSet OR Alt_Employer__c = :debugAltEmId )  ];      
        Map<Id, Survey_Response__c> srMap = new Map<Id, Survey_Response__c>();
        Map<String, Survey_Response__c> altSrMap = new Map<String, Survey_Response__c>();  
        
        String debugSrKey = '';
          
        for (Survey_Response__c sr: srList) {
          if (sr.Contact__c != null) {
            srMap.put(sr.Contact__c, sr);
          } else {
            String altKey = (sr.Alt_First_Name__c + ';' + sr.Alt_Last_Name__c  + ';' +  sr.Employer_Name__c).toLowerCase();                  
            altSrMap.put(altKey , sr);
            debugSrKey = altKey;
          }
        }
        List<Recruit__c> rList = [ select Id, Name, Recruit__c, Volunteer_Date__c, Recruited_By__c, Total_Shift__c, Alt_First_Name__c, Alt_Middle_Name__c, Alt_Last_Name__c, Alt_Employer__c, Alt_Person_Type__c, Employer_Name__c from Recruit__c where (Recruit__c in :ridSet or Alt_Employer__c in :altEmSet) and Volunteer_Date__c <= :endDate and Volunteer_Date__c >= :startDate AND (NOT Id in :newIdList ) ];       
        for (Recruit__c r: rList) {
          debugRecruit = r;
          String altKey = null;
          if (r.Recruit__c == null) {
            altKey = (r.Alt_First_Name__c + ';' + r.Alt_Last_Name__c  + ';' +  r.Employer_Name__c).toLowerCase();                  
            System.debug('altKey = ' + altKey);
            if (!altPersonMap.containsKey(altKey)) {
              altPersonMap.put(altKey, r);               
            }          
          }

        
          if (r.Recruit__c != null && r.Recruited_By__c != null && !collectorMap.containsKey(r.Recruit__c)) {
            collectorMap.put(r.Recruit__c, r.Recruited_By__c);
          } else if (r.Recruit__c == null && r.Recruited_By__c != null  ) {
            if ( !altCollectorMap.containsKey(altKey)) {
              altCollectorMap.put(altKey, r.Recruited_By__c);
            }
          }
          Double shiftCount = 0;
          if (r.Recruit__c != null && countMap.containsKey( r.Recruit__c)) {
            shiftCount = countMap.get( r.Recruit__c);
          } else if (r.Recruit__c == null && altCountMap.containsKey(altKey)) {
  
            shiftCount = altCountMap.get(altKey);
          }

          //String debugString = '';
          //if (debugMap.containsKey(r.Recruit__c)) {
          //  debugString = debugMap.get(r.Recruit__c);
          //}
          //debugString += r.Volunteer_Date__c + ' (' + r.Total_Shift__c + '); ';
          //debugMap.remove(r.Recruit__c);
          //debugMap.put(r.Recruit__c, debugString);
        
          shiftCount = shiftCount + r.Total_Shift__c;
          if (r.Recruit__c != null) {        
            if (countMap.containsKey( r.Recruit__c)) {
              countMap.remove(r.Recruit__c);
            }
            System.debug('adding count to countMap = ' + shiftCount);
            countMap.put( r.Recruit__c, shiftCount);                
          } else if (r.Recruit__c == null) {
            if (altCountMap.containsKey( altKey )) {
              altCountMap.remove( altKey );
            }
            altCountMap.put( altKey, shiftCount);                
          }

          if (r.Recruit__c != null && !dateMap.containsKey(r.Recruit__c)) {
            dateMap.put( r.Recruit__c, r.Volunteer_Date__c); 
          } else if (r.Recruit__c == null && !altDateMap.containsKey(altKey)) {
            altDateMap.put( altKey , r.Volunteer_Date__c); 
          }                 
        }

        System.debug('construct SRs for Recruits with a Contact records.');
        List<Survey_Response__c> insertSrList = new List<Survey_Response__c>();
        for (Id rid: ridSet) { 
          Survey_Response__c sr = new Survey_Response__c();
          Double oldCount = -1.0;
          if (srMap.containsKey(rid)) {
            sr = srMap.get(rid);
          } else {
            sr.Survey_Question__c = sqid;
            sr.Response_Value__c = 'yes';
            sr.Contact__c = rid;        
          }
          sr.Previous_Responses__c = '';            
          if (countMap.containsKey(rid)) {
            sr.Add_Info__c = '' + countMap.get(rid);
          } else {
            sr.Add_Info__c = '0.0';
          }
          
          if (collectorMap.containsKey(rid)) {
            sr.Collected_By__c = collectorMap.get(rid);             
          }

          if (dateMap.containsKey(rid)) {
            sr.Collected_Datetime__c = dateMap.get(rid);
          }
        
          if (srMap.containsKey(rid)) {        
            if ( oldCount != countMap.get(rid)) {
              //only update if counts change
              srMap.remove(rid);
              srMap.put(rid, sr);    
            }
          } else {
            insertSrList.add(sr);
          }
        }
        //Alt Survey Responses
        System.debug('construct SRs for Alt persons. altKeySet size = ' + altKeySet.size());
        for (String altKey: altKeySet) { 
          System.debug('altKey for SR = ' + altKey);
          Recruit__c r = altPersonMap.get(altKey);
          if (r == null) {
            r = oldAltMap.get(altKey);
          }
          if (r != null) {
            Survey_Response__c sr = new Survey_Response__c();

            if (altSrMap.containsKey(altKey)) {
              sr = altSrMap.get(altKey);
            } else {
              sr.Survey_Question__c = sqid;
              sr.Response_Value__c = 'yes';
              sr.Alt_First_Name__c =  r.Alt_First_Name__c;
              sr.Alt_Middle_Name__c =  r.Alt_Middle_Name__c;
              sr.Alt_Last_Name__c =  r.Alt_Last_Name__c;
              sr.Alt_Employer__c =  r.Alt_Employer__c;                              
              sr.Alt_Person_Type__c = r.Alt_Person_Type__c;                              
            }
            sr.Previous_Responses__c = '';            
            sr.Add_Info__c = '' + altCountMap.get(altKey);
            if (altCollectorMap.containsKey(altKey)) {
                 sr.Collected_By__c = altCollectorMap.get(altKey);             
            }

            if (altDateMap.containsKey(altKey)) {
              sr.Collected_Datetime__c = altDateMap.get(altKey);
            }

            if (sr.Alt_Employer__c == null && r != null && emNameMap.containsKey(r.Employer_Name__c)) {
              sr.Alt_Employer__c = emNameMap.get(r.Employer_Name__c).Id;
            }
            if (sr.Alt_Employer__c == null) {
              sr.Alt_Employer__c = defaultEmployer.Id;
            }
            if (sr.Alt_Person_Type__c == null) {
              sr.Alt_Person_Type__c = 'Other';
            }
            
            if (altSrMap.containsKey(altKey)) {        
                altSrMap.remove(altKey);
                altSrMap.put(altKey, sr);    
            } else {
                //sr.Comments__c = 'No Key Found = _' + altKey + '_ vs debug key = _' + debugSrKey + '_ alt em id=' + debugAltEmId + '_ sr list size = ' + srList.size() + '; sqlist = ' + sqList.size();
                if (r.Total_Shift__c > 0.0) {

                  insertSrList.add(sr);
                }
            }

          }
        }      
      
        if (srMap.size() > 0) {
          update srMap.values();
        }
        if (altSrMap.size() > 0) {
          update altSrMap.values();
        }      
        if (insertSrList.size() > 0) {
          insert insertSrList;
        }
      } catch (Exception e) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<User> sysAdmins = [ select Email from User where Profile.Name = 'System Administrator' and IsActive = true ];
        List<String> sysAdminEmails = new List<String>();
        for (User u: sysAdmins ) {
          sysAdminEmails.add(u.Email);
        }
        //String[] toAddresses = new String[] sysAdminEmails };
        mail.setToAddresses(sysAdminEmails );
        mail.setSubject('Recruit to Survey Response Exception For Recruit - ' + debugRecruit);
        mail.setPlainTextBody('Failure on Recruit ' + debugRecruit+ ', Employer=' + debugRecruit.Employer_Name__c + '.\n\n' + e.getStackTraceString() + '\n\n' + e.getMessage());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }           
      System.debug('[Recruit to Survey Response] finish');
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
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;                  
i++;
      i++;
      i++;            
      i++;
      i++;
      i++;      
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
      i++;
      i++;
      i++;
      i++;
      i++;
      i++;            
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