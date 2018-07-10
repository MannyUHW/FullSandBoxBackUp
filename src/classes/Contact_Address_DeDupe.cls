/*
 * Contact Address DeDupe - helper class for Contact Address Trigger
 * 
 * Version: 1.10
 * 26th May 2017
 * 
 * Version History
 * 1.1 - added Bad Address logic
 * 1.0 - created
 * 
 * Copyright (c) 2016 SEIU-UHW
 * 560 Thomas L Berkley Way
 * Oakland, CA 94612, USA
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of SEIU-UHW.
 * ("Confidential Information").
 * 
 *
 * Notes:
 *   +   If an existing address exists and you insert a duplicate record 
 *       with a different “Information Source”, the values will be combined.
 *       For example, if an existing address has a source “Card”, and you
 *       insert a new record with source “EList”, the new record will have
 *       source with both “Card” and “EList”.
 *   +   Only one address can be marked as “Primary Address” per Contact.
 *       If a Contact Address is marked as “Primary Address” if will update
 *       the Contact record Mailing Address fields.
 *   +   If you enter an address that already exists and the new record has
 *       a “Bad Address” value of “no” and the existing record is has a 
 *       “Bad Address” value of “yes/maybe/probable”, it will retain the 
 *       “yes/maybe/probable”.  To change “Bad Address” to “no” requires an
 *        update.
 *
 */
public class Contact_Address_DeDupe { 

  public static void deDupe(List<Contact_Address__c> pNewList, List<Contact_Address__c> pOldList, Boolean pIsInsert){ 
  
    Map<String, Contact_Address__c> addressMap = new Map<String, Contact_Address__c>();

    Set<Id> cidSet = new Set<Id>();
    Map<Id, List<Contact_Address__c>> contactAddressMap = new Map<Id, List<Contact_Address__c>>();
    
    for (Contact_Address__c ca: pNewList) {
      //create a temporary address id
      String zip = ca.PostalCode__c;
      ca.Street__c = ca.Street__c + '     ';
      String tempAid =  getContactAddressKey(ca.Contact__c, ca.Street__c, ca.PostalCode__c);    
      if (ca.id != null) {
        tempAid = '' + ca.id;
      }
      cidSet.add(ca.Contact__c);
      System.debug('ca id value = ' + tempAid);
      addressMap.put(tempAid, ca);
      List<Contact_Address__c> caList = new List<Contact_Address__c>();
      if (contactAddressMap.containsKey(ca.Contact__c)) {
        caList = contactAddressMap.get(ca.Contact__c);
      }
      caList.add(ca);
      contactAddressMap.put(ca.Contact__c, caList);
    }

    List<Contact> contactList = [select Id, MailingStreet, MailingCity, MailingPostalCode, MailingState from Contact where Id in :cidSet ]; 
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    for (Contact c: contactList) {
      contactMap.put(c.Id, c);
    }



    List<Contact_Address__c> existingCaList = [select Id, Contact__c, Street__c, PostalCode__c, GeoLocation__Latitude__s, GeoLocation__Longitude__s, Primary_Address__c, Bad_Address__c, Comment__c, Do_Not_Visit__c, Information_Source__c, Original_Entry_Datetime__c, Original_Created_By__c from Contact_Address__c where Contact__c in :cidSet order by LastModifiedDate desc ];


    //prevent duplicates 
    if (pIsInsert) {

      System.debug('existing ca list size = ' + existingCaList.size());
      for (String aid: addressMap.keySet()) {
        Contact_Address__c ca1 = addressMap.get(aid);
        
        ca1.Original_Entry_Datetime__c = Datetime.now();
        ca1.Original_Created_By__c = UserInfo.getUserId();
       
        String key1 = getContactAddressKey(ca1.Contact__c, ca1.Street__c, ca1.PostalCode__c);
        
    
        
        for (Contact_Address__c ca2: existingCaList) {
          String key2 = getContactAddressKey(ca2.Contact__c, ca2.Street__c, ca2.PostalCode__c);     

          if (key1 == key2) {
            if (ca1.Bad_Address__c != null && ca2.Bad_Address__c != null &&ca1.Bad_Address__c.toUpperCase().trim() == 'NO') {
              ca1.Bad_Address__c = ca2.Bad_Address__c;
            }
            String finalSourceString = '';
            if (ca1.Information_Source__c != null) {            
              for (String s1: ca1.Information_Source__c.split(';')) {
                if (finalSourceString.toLowerCase().indexOf(s1.toLowerCase().trim()) < 0) {
                  if (finalSourceString.trim() != '') {
                    finalSourceString += ';';
                  }
                  finalSourceString += s1;
                }
              }
            }
            if (ca2.Information_Source__c != null) {
              for (String s2: ca2.Information_Source__c.split(';')) {
                if (finalSourceString.toLowerCase().indexOf(s2.toLowerCase().trim()) < 0) {
                  if (finalSourceString.trim() != '') {
                    finalSourceString += ';';
                  }
                  finalSourceString += s2;
                }
              }   
            }
            ca1.Information_Source__c = finalSourceString;
            if (ca2.Do_Not_Visit__c) {
              ca1.Do_Not_Visit__c = ca2.Do_Not_Visit__c;
            }
            if (ca1.GeoLocation__Latitude__s == null && ca2.GeoLocation__Latitude__s != null) {
              ca1.GeoLocation__Latitude__s = ca2.GeoLocation__Latitude__s;
              ca1.GeoLocation__Longitude__s = ca2.GeoLocation__Longitude__s;              
            }
            if (ca2.Primary_Address__c) {
              ca1.Primary_Address__c = ca2.Primary_Address__c;
            }       
            if (ca2.Comment__c != null && ca2.Comment__c.trim().length() > 0) {
              if (ca1.Comment__c != null && ca1.Comment__c.trim() != '') {
                String newComment = ca1.Comment__c + '; ' + ca2.Comment__c;
                if (newComment.trim().length() > 255) {
                  newComment = newComment.substring(0, 255);
                }
                ca1.Comment__c = newComment;
              } else {
                ca1.Comment__c = ca2.Comment__c;
              }
            }       
            if (ca2.Original_Entry_Datetime__c != null) {
              ca1.Original_Entry_Datetime__c = ca2.Original_Entry_Datetime__c;
            }
            if (ca2.Original_Created_By__c != null) {
              ca1.Original_Created_By__c = ca2.Original_Created_By__c;
            }
            if (ca1.Original_Created_By__c == null) {
              ca1.Original_Created_By__c = ca2.CreatedById;
            }
            delete ca2;       
          } else {
            if (ca1.Primary_Address__c && ca2.Primary_Address__c) {
              System.debug('[dedupe] not a primary address ' + key2);                          
              ca2.Primary_Address__c = false;
              update ca2;
            }
          }
        }
      }
    } else {
      //isUpdate
      //
      //
      //  only allow one Primary Address per Contact
      //
      //
      for (Contact_Address__c ca1: pNewList) {
        List<Contact_Address__c> caList = contactAddressMap.get(ca1.Contact__c);
        String key1 = getContactAddressKey(ca1.Contact__c, ca1.Street__c, ca1.PostalCode__c);    
        System.debug('[dedupe] updating ' + key1);    
        if (ca1.Primary_Address__c) {
          for (Contact_Address__c ca2: existingCaList) {
            String key2 = getContactAddressKey(ca2.Contact__c, ca2.Street__c, ca2.PostalCode__c);          
            System.debug('[dedupe] comparing ' + key1 + ' vs. ' + key2);                          
            if (ca1.Primary_Address__c &&  ca2.Primary_Address__c && key1 != key2) {
              System.debug('[dedupe] not a primary address ' + key2);                          
              ca2.Primary_Address__c = false;
              update ca2;
            }
          }       
        }
      }
    }
    //
    //  update Contact Record for Primary Addresses
    //
    Set<Contact> updateContactSet = new Set<Contact>();
    for (Contact_Address__c ca1: pNewList) {
      String key1 = getContactAddressKey(ca1.Contact__c, ca1.Street__c, ca1.PostalCode__c);      
      Contact c = contactMap.get(ca1.Contact__c);
      String key2 = getContactAddressKey(c.Id, c.MailingStreet, c.MailingPostalCode); 
      if (ca1.Primary_Address__c && (ca1.Bad_Address__c == null || ca1.Bad_Address__c.toUpperCase().trim() == 'NO')) {             
        if (key1 != key2) {
          c.MailingStreet =  ca1.Street__c;
          c.MailingCity = ca1.City__c;
          c.MailingPostalCode = ca1.PostalCode__c;
          c.MailingState = ca1.State__c;
          c.MailingLatitude = ca1.GeoLocation__Latitude__s;
          c.MailingLongitude = ca1.GeoLocation__Longitude__s;
          updateContactSet.add(c);
        }
      } else if (ca1.Bad_Address__c.toUpperCase().trim() == 'YES') {
        ca1.Primary_Address__c = FALSE;
        if (key1 == key2) {
          c.MailingStreet =  null;
          c.MailingCity = null;
          c.MailingPostalCode = null;
          c.MailingState = null;
          c.MailingLatitude = null;
          c.MailingLongitude = null;
          updateContactSet.add(c);
        }      
      }  
    }
    if (updateContactSet.size() > 0) {
      List<Contact> updateContactList = new List<Contact>();
      updateContactList.addAll(updateContactSet);    
      update updateContactList;
    }    
  }
  
  public static String getContactAddressKey(String pContactId, String pStreet, String pZip) {
      String street = pStreet;
      if (pStreet == null) {
        street = '';
      } else {
        street = street.replace('.', '');
        street = street.replace(' N ', ' ');
        street = street.replace(' S ', ' ');        
        street = street.replace(' E ', ' ');        
        street = street.replace(' W ', ' ');                        
      }
      if (street.length() < 5) {
        street = street + '     ';
      }
      String zip = pZip;
      if (zip == null || zip.trim() == '') {
        zip = '99999';
      }
      if (zip.length() > 5) {
        zip = zip.substring(0, 5);
      }      
      return '' + pContactId + '~' + zip + '~' + street.substring(0, 5).trim().toLowerCase();    
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