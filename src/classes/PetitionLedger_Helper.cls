public class PetitionLedger_Helper {
/*
 * Petition Ledger Helper - helper class for Petition Object Triggers to
 *                          update petition qty on contact object and fill in regional director and coordinator on record
 *
 * Version: 1.0
 * 5th September 2017
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
 * ("Confidential Information").
 *
 *
 * Methods:
 * - peopleinLedger(List<Petition_Ledger__c>)
 *  inputs: list of petition ledgers
 *  return: set of contact Ids
 *  + returns set of contact ids for any contact in the Transferred_To
 *    or Transferred_From fields on the petition ledger list
 *
 * - changePetition_Quantity(set<Id>,List<Petition_Ledger>)
 *  inputs: set of contact Ids to update, List of petition Ledgers changed
 *  return: List of contacts with updated petition quantities
 *  + the set is from contact ids in the current petition ledger
 *    update/insert and the list of petition ledgers are all ledgers
 *    that those people in the set are connected to (From/To).  the
 *    function returns a list of contacts and petition quantity for each
 *
 * - makemap_contact2acct(List<account>)
 *  inputs: list of accounts
 *  return: map from contact name to acct id
 *  + this function makes a map used in looking up account values with
 *    contact names
 *
 * - LedgerChangeList_Before(List<Petition_Ledger__c>)
 *  inputs: petition ledger list from trigger.new
 *  return: void
 *  + logic flow for before update and insert on petition ledger object.
 *  + before trigger is used to update from/to regional director and coordinator on the petition ledger object
 *
 * - LedgerChangeList_After(List<Petition_Ledger__c)
 *  inputs: petition ledger list from trigger.new
 *  return: void
 *  + log flow for after update/insert on petition ledger
 *  + currently only used to update Petition Quantity on the contact object
 */
    private static set<Id> peopleinLedger(List<Petition_Ledger__c> petLst){
        set<Id> pplset = new set<Id>();        
        for(Petition_Ledger__c pl:petLst){
            if(string.isNotBlank(pl.Transferred_To__c)){
                pplset.add(pl.Transferred_To__c);
            }
            if(string.isNotBlank(pl.Transferred_From__c)){
                pplset.add(pl.Transferred_From__c);
            }
        }
        return pplset;
    }

    private static List<Contact> changePetition_Quantity(set<Id> petitionPeopleSet, List<Petition_Ledger__c> allPetLedger_Recalc){
        List<Contact> updatePetQty = new List<Contact>();
        for(Id cid:petitionPeopleSet){
            Contact c = new Contact();
            c.Id = cid;
            double qty = 0;
            for(Petition_Ledger__c pl:allPetLedger_Recalc){
                if(cid==pl.Transferred_To__c){
                    qty += pl.Quantity__c;
                }
                if(cid==pl.Transferred_From__c){
                    qty -= pl.Quantity__c;
                }
            }
            c.PetitionQty__c = qty;
            updatePetQty.add(c);
        }
        return updatePetQty;
    }
    
    private static Map<string,Id> makemap_contact2acct(List<Account> acctvals){
        Map<string,Id> staffMap_acct = new Map<string,Id>();
        
        for(Account a:acctvals){
            string[] ids2map = new string[]{a.Regional_Director__r.Staff_Contact_Id__c,a.Coordinator__r.Staff_Contact_Id__c, a.Organizer_1__r.Staff_Contact_Id__c};
                for(string id2map:ids2map){                
                    if(string.isNotBlank(id2map)){
                        id2map = id2map.substring(0,15);
                        string checkDup = staffMap_acct.get(id2map);
                        if(string.isBlank(checkDup)){
                            staffMap_acct.put(id2map,a.Id);            
                        }               
                    }
                }
        }
        return staffMap_acct;
    }
    
    public static void LedgerChangeList_Before(List<Petition_Ledger__c> petLst_new){        
    
        //create contact Id set of all people in current ledger
        set<Id> peopleSet = peopleinLedger(petLst_new);

        //get contact map to get details of people in ledger
        Map<Id, Contact> contact_Map = new Map<Id, Contact>([SELECT Name, AccountId, RecordTypeId, RecordType.Name, Department, Title FROM Contact Where Id in :peopleSet]);           
        //get contact record type map so I can check which contacts are staff
        Map<ID,Schema.RecordTypeInfo> rt_Map = Contact.sObjectType.getDescribe().getRecordTypeInfosById();               
        
        //get set of related account Ids from the contact map
        Set<ID> acctIdSet = new Set<ID>();                
        for(Contact c:contact_Map.values()){
            acctIdSet.add(c.AccountId);             
        }        
       
        //get acct map to input regional director and coordinator
        //from accounts where people in ledger aren't staff
        Map<Id, Account> acctMap = new Map<Id, Account>([Select Regional_Director__c, Coordinator__c From Account Where Id in :acctIdSet]);
        //get accounts that have a BU_Count to supply 
        //regional director and coordinator heirarchy for staff
        Map<Id, Account> acctMap_Staff = new Map<Id, Account>([Select Id, Regional_Director__c, Regional_Director__r.Staff_Contact_Id__c, Coordinator__c, Coordinator__r.Staff_Contact_Id__c, Organizer_1__c, Organizer_1__r.Name, Organizer_1__r.Staff_Contact_Id__c From Account Where BU_Count__c != null Order by BU_Count__c desc]);        
        Map<string,Id> staffMap_acct = makemap_contact2acct(acctMap_Staff.values());  
        system.debug('[pl]check_contactmap:'+staffMap_acct);

        //apply the mapped regional directors and coordinators to the petition ledger records
        for(Petition_Ledger__c pl:petLst_new){
            if(string.isNotBlank(pl.Transferred_To__c)){   
                string toid = string.valueOf(pl.Transferred_To__c);
                if(rt_map.get(contact_Map.get(toid).RecordTypeId).getName().containsIgnoreCase('staff')){
                    if(string.isNotBlank(staffMap_acct.get(toid.substring(0,15)))){
                        pl.To_Regional_Director__c = acctMap_Staff.get(staffMap_acct.get(toid.substring(0,15))).Regional_Director__c;                    
                        pl.To_Coordinator__c = acctMap_Staff.get(staffMap_acct.get(toid.substring(0,15))).Coordinator__c;    
                    }                    
                }
                else{
                    pl.To_Regional_Director__c = acctMap.get(contact_Map.get(toid).AccountId).Regional_Director__c;
                    pl.To_Coordinator__c = acctMap.get(contact_Map.get(toid).AccountId).Coordinator__c;    
                }
            }
            if(string.isNotBlank(pl.Transferred_From__c)){            
                string fromid = string.valueOf(pl.Transferred_From__c);
                if(rt_map.get(contact_Map.get(fromid).RecordTypeId).getName().containsIgnoreCase('staff')){
                    if(string.isNotBlank(staffMap_acct.get(fromid.substring(0,15)))){
                        pl.From_Regional_Director__c = acctMap_Staff.get(staffMap_acct.get(fromid.substring(0,15))).Regional_Director__c;                    
                        pl.From_Coordinator__c = acctMap_Staff.get(staffMap_acct.get(fromid.substring(0,15))).Coordinator__c;
                    }                   
                }
                else{
                    pl.From_Regional_Director__c = acctMap.get(contact_Map.get(fromid).AccountId).Regional_Director__c;
                    pl.From_Coordinator__c = acctMap.get(contact_Map.get(fromid).AccountId).Coordinator__c;    
                }                               
            }
        }
    }
    
    public static void LedgerChangeList_After(List<Petition_Ledger__c> petLst){
        
        //start by making set of all people Transferred To and From
        //contacts being updated to target contact update changes
        Set<Id> petitionPeopleSet = peopleinLedger(petLst);
        
        //grab all petition ledger records related to the people in the
        //current petiiton ledger update or insert
        List<Petition_Ledger__c> allPetLedger_Recalc = new List<Petition_Ledger__c>([Select Quantity__c, Transferred_From__c, Transferred_To__c, County__c, UHW_Campaign__c From Petition_Ledger__c Where Transferred_To__c in :petitionPeopleSet or Transferred_From__c in :petitionPeopleSet]);
    
        //create list of contacts with new petition qty values to update on
        //the contact record and apply changed quantity values
        List<Contact> updatePetQty = changePetition_Quantity(petitionPeopleSet,allPetLedger_Recalc);        
        update updatePetQty;
    }
}