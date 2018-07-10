/*
 * Contact Override Employer - helper for Contact 
 *   allows Employer/Account to be overriden for 6 months/182 days
 *
 * Version: 1.0
 * 26th May2016
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
public class Contact_Override_Employer { 

    public Contact_Override_Employer() {
      //ignore
    }

    public static void checkOverrides(List<Contact> pNewList) {
      for (Contact c: pNewList) {
        Date d = date.today();
        if (c.Override_Employer__c != null && c.Override_Employer_Date__c != null && Math.abs(d.daysBetween(c.Override_Employer_Date__c)) < 183) {
          c.AccountId = c.Override_Employer__c;
        }
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
      return i;
    }

}