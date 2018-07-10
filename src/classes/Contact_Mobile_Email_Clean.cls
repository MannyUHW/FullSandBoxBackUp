public class Contact_Mobile_Email_Clean {
/*
 * Contact Mobile/Email Clean - helper class for Contact Triggers to
 *                              validate & cleanse phone and email on update input
 *
 * Version: 1.0
 * 31th July 2017
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
 * - string_numericOnlyStrip(string)
 *  inputs: string value
 *  return: string value or null (if input empty/null)
 *  + strips all non numeric characters from string input.
 *  + used for comparing phone numbers without formatting getting in the way.
 *
 * - string_phoneNumberUS_validMake(string)
 *  inputs: string value
 *  return: string value or null
 *  + applies valid phone number rules and nulls value if string doesn't pass
 *
 * - string_phoneNumberUS_clean(string)
 *  inputs: string value
 *  return: string value or null
 *  + applies non numeric strip and removes leading one from string if found
 *
 * - string_phoneNumberUS_reformat(string)
 *  inputs: string value
 *  return: string value or null
 *  + formats string into (xxx) xxx-xxxx for making phone number strings look good
 *
 * - cntct_mobilePhoneUpdate(contact)
 *  inputs: contact record
 *  return: contact record
 *  + logic for updating mobile phone field
 *
 * - cntct_removeDupPhones(contact)
 *  inputs: contact record
 *  return: contact record
 *  + used to cleanse duplicates amongst contact phone fields
 *
 * - cntct_removeDupOtherAnyPhones(contact)
 *  inputs: contact record
 *  return: contact record
 *  + removes duplicate phone numbers from otherphoneany long text field
 *
 * - cntct_emailValidateUpdate(contact)
 *  inputs: contact record
 *  return: contact record
 *  + moves new email into email field and old email into email other any
 *    while making sure all emails are unique between those two fields.
 *
 * - validateContact(List<Contact>, List<Contact>)
 *  inputs: 2 contact Lists - first one is from trigger.old, second from trigger.new
 *  return: void
 *  + helper method
 *  + called directly by Contact trigger
 *  + logic sequence of contact validation methods
 *
 *
 */

    private static string string_numericOnlyStrip(string inputString){
        //strips non numeric characters from a string
        //returns null if input is empty/null/whitespace
        string outputString;
        if(!string.isEmpty(inputString)){
            outputString = inputString.replaceAll('[^0-9]', '');
        }
        return outputString;
    }

    private static string string_phoneNumberUS_validMake(string inputPhone){
        //make sure that non numeric and leading 1 cleansed first
        //note: [double string_phoneNumberUS_clean() on (111) area code numbers during cleanse
        //      should make them return null since length() < 10 {seems like a nice side effect since bad area code}]
        inputPhone = string_phoneNumberUS_clean(inputPhone);
        //returns valid phone number according to rules or null if invalid
        if(string.isNotBlank(inputPhone)){

            //[null returns go in the else ifs (below) so remaining null evaluations don't return errors]
            //invalid phone length (too short) => make null
            if(inputPhone.length() < 10){
                inputPhone = null;
            }
            //make sure digits 4-6 aren't 555 because those are invalid phones
            else if(inputPhone.mid(3, 3)=='555'){
                inputPhone = null;
            }
        }
        return inputPhone;
    }

    private static string string_phoneNumberUS_clean(string inputPhone){
        //strip input of non numeric characters
        inputPhone = string_numericOnlyStrip(inputPhone);
        if(string.isNotBlank(inputPhone)){
            //remove leading 1s and 0s from phone number
            inputPhone = inputPhone.replaceAll('^[0-1]*(\\d*)', '$1');

            //cut the phone down to first 10 digits
            if(inputPhone.length() > 10){
                inputPhone = inputPhone.substring(0, 10);
            }
        }
        return inputPhone;
    }

    private static string string_phoneNumberUS_reformat(string inputPhone){
        //method assumes inputPhone has been cleaned with 'string_phoneNumberUS_clean'
        //
        string outputPhone;
        if(string.isNotBlank(inputPhone)  && inputPhone.length() >= 10){
            outputPhone = '(' +inputPhone.substring(0, 3) + ') ';
            outputPhone += inputPhone.mid(3, 3) + '-' + inputPhone.mid(6, 4);
        }
        return outputPhone;
    }

    private static Contact cntct_mobilePhoneUpdate(Contact c, string oldmobile){
        string newmobile = string_phoneNumberUS_validMake(c.MobilePhone);
        if(string.isNotBlank(newmobile)){
            if(oldmobile != newmobile){
                if(string.isNotBlank(oldmobile)){
                    //populate mobilephone with new mobile and otherphone with old mobile
                    /***** following code block causes mobile updates to cascade other phone *****/
                    if(string.isNotBlank(c.OtherPhone)){
                        string oldOtherPhone = c.OtherPhone;
                        c.OtherPhone = oldmobile;
                        if(string.isNotBlank(c.Other_Phone_Any__c)){
                            c.Other_Phone_Any__c += ';' + oldOtherPhone;
                        }
                        else{
                            c.Other_Phone_Any__c = oldOtherPhone;
                        }
                    }
                    else{
                        c.OtherPhone = oldmobile;
                    }
                    /*****************************************************************************/
                }
                else{
                    //add new mobile to null mobile field making sure it's valid
                    //we know newmobile isn't null since it's not equal to old mobile, which is null
                    c.MobilePhone = newmobile;
                }
            }
            else{
                //System.debug('[Phone] Same mobile values - no update change; c.id = '+ c.Id);
            }
        }
        else{
            //System.debug('[Phone] new Mobile value null after validation - oldmobile to other; c.Id = ' + c.Id);
            if(string.isNotBlank(c.OtherPhone)){
                string oldOtherPhone = c.OtherPhone;
                c.OtherPhone = oldmobile;
                if(string.isNotBlank(c.Other_Phone_Any__c)){
                    c.Other_Phone_Any__c += ';' + oldOtherPhone;
                }
                else{
                    c.Other_Phone_Any__c = oldOtherPhone;
                }
            }
            else{
                c.OtherPhone = oldmobile;
            }
        }
        return c;
    }

    private static Contact cntct_removeDupPhones(Contact c){

        // put numbers into string after cleaning for comparison
        string newPhone = string_phoneNumberUS_clean(c.Phone);
        string newHomePhone = string_phoneNumberUS_clean(c.HomePhone);
        string newOtherPhone = string_phoneNumberUS_clean(c.OtherPhone);
        string newmobile = string_phoneNumberUS_clean(c.MobilePhone);
        // check for duplicate numbers equal to mobilephone and remove any found
        if(newmobile == newPhone){
            c.Phone = null;
        }
        if(newmobile == newHomePhone){
            c.HomePhone = null;
        }
        if(newmobile == newOtherPhone){
            c.OtherPhone = null;
        }
        // then check for any duplicates from Phone to HomePhone or OtherPhone
        if(newOtherPhone == newPhone){
            c.OtherPhone = null;
        }
        if(newHomePhone == newPhone){
            c.HomePhone = null;
        }
        //check for HomePhone to OtherPhone duplicate number [last dupe check]
        if(newHomePhone == newOtherPhone){
            c.OtherPhone = null;
        }
        return c;
    }

    private static Contact cntct_removeDupOtherAnyPhones(Contact c){
        //other phone any list duplicate mitigation
        if(string.isNotBlank(c.Other_Phone_Any__c)){
            //put current phone values on contact into list for comparison to other phone any list
            List<string> thesePhones = new List<string>();
            thesePhones.add(string_phoneNumberUS_clean(c.Phone));
            thesePhones.add(string_phoneNumberUS_clean(c.HomePhone));
            thesePhones.add(string_phoneNumberUS_clean(c.OtherPhone));
            thesePhones.add(string_phoneNumberUS_clean(c.MobilePhone));

            //System.debug('[Dedupe Phone] check thesePhones List: ' + thesePhones);
            //split otherphoneany numbers into set for comparisons
            string[] OtherPhoneAnys = c.Other_Phone_Any__c.split(';');
            set<string> OtherPhoneAnySet = new set<string>();
            for(string addPhone: OtherPhoneAnys){
                OtherPhoneAnySet.add(string_phoneNumberUS_clean(addPhone));
            }
            //compare and remove otherphoneany duplicates
            for (string p:thesePhones){
                if(OtherPhoneAnySet.contains(p)){
                    OtherPhoneAnySet.remove(p);
                }
            }

            //initialize the otherphoneany field so we only add unique values from the set
            //then build the field out again with phone formatting
            //System.debug('[Dedupe Phone] Other_Phone_Any__c check1: ' +  OtherPhoneAnySet);
            //System.debug('[Dedupe Phone] Other_Phone_Any__c check1.2: ' + c.Other_Phone_Any__c);
            c.Other_Phone_Any__c = '';
            for (string np:OtherPhoneAnySet){
                if(string.isNotBlank(np)){
                    np = string_phoneNumberUS_validMake(np);
                    if(string.isNotBlank(np)) {
                        np = string_phoneNumberUS_reformat(np);
                        c.Other_Phone_Any__c += np + ';';
                    }
                    //System.debug('[Dedupe Phone] Other_Phone_Any__c check1.3: ' + np);
                    //System.debug('[Dedupe Phone] Other_Phone_Any__c check1.4: ' + c.Other_Phone_Any__c);
                }
            }
            //strip off trailing delimiter from string build loop
            c.Other_Phone_Any__c = c.Other_Phone_Any__c.left(c.Other_Phone_Any__c.length() - 1);
            //System.debug('[Dedupe Phone] Other_Phone_Any__c check2: ' +  c.Other_Phone_Any__c);
        }
        return c;
    }

    private static Contact cntct_emailValidateUpdate(Contact c, string oldemail){
        //note: only need email and OtherEmailAny for the validation at the moment.
        //
        string newemail = c.Email;
        if(string.isNotBlank(newemail)){
            if(newemail != oldemail){
                if(string.isNotBlank(oldemail)){
                    //add oldemail to otheremailany since oldemail not blank
                    if(string.isNotBlank(c.Other_Emails_Any__c)){
                        c.Other_Emails_Any__c += ';' + oldemail;
                    }
                    else{
                        c.Other_Emails_Any__c = oldemail;
                    }
                    //system.debug('[Email] c.Id:' + c.Id + ' check 1 for otherEmailAny = ' + c.Other_Emails_Any__c);

                    /****run duplicate mitigation on otheremailsany field*********/
                    //split otheremailany into set for comparisons
                    string[] OtherEmailAnys = c.Other_Emails_Any__c.split(';');
                    set<string> OtherEmailAnySet = new set<string>();
                    for(string addEmail: OtherEmailAnys){
                        if(string.isNotBlank(addEmail)){
                            OtherEmailAnySet.add(addEmail);
                        }
                    }
                    //remove dupe in otheremailany if from new email input
                    if(OtherEmailAnySet.contains(newemail))                                                       {
                        OtherEmailAnySet.remove(newemail);
                    }
                    //rebuild otheremailany field
                    c.Other_Emails_Any__c = '';
                    for (string ne:OtherEmailAnySet){
                        if(string.isNotBlank(ne)){
                            c.Other_Emails_Any__c += ne + ';';
                        }
                    }
                    c.Other_Emails_Any__c = c.Other_Emails_Any__c.left(c.Other_Emails_Any__c.length() - 1);
                    /*****duplicate mitigation end****/
                }
            }
        }
        return c;
    }

    public static void validateContactUpdate(List<Contact> contcts_old, List<Contact> contcts_new){

        //looking up specific Ids to be updated and comparing them to trigger.old with this map
        Map<Id, Contact> contcts_oldMap = new Map<Id, Contact>(contcts_old);
        try{
        //loop through new contact values to be updated and make adjustments
        for (Contact c : contcts_new){
            //start phone update validations
            //old/new mobile phone
            string oldmobile = string_phoneNumberUS_clean(contcts_oldMap.get(c.Id).MobilePhone);

            //remove duplicate phone numbers before logic flow for mobilephone update
            c = cntct_removeDupPhones(c);

            //logic flow to update mobilephone
            c = cntct_mobilePhoneUpdate(c, oldmobile);

            //remove dupes on otherphoneany after update adjustments
            c = cntct_removeDupOtherAnyPhones(c);

            //pass through new trigger values and keep only valid numbers on the update
            //then re format them into (###) ###-#### since this is last step for phone input
            c.Phone         = string_phoneNumberUS_reformat(string_phoneNumberUS_validMake(c.Phone));
            c.MobilePhone   = string_phoneNumberUS_reformat(string_phoneNumberUS_validMake(c.MobilePhone));
            c.HomePhone     = string_phoneNumberUS_reformat(string_phoneNumberUS_validMake(c.HomePhone));
            c.OtherPhone    = string_phoneNumberUS_reformat(string_phoneNumberUS_validMake(c.OtherPhone));

            //start email update validation
            string oldemail = contcts_oldMap.get(c.Id).Email;
            c = cntct_emailValidateUpdate(c, oldemail);
        }
        } catch(Exception e) {
            System.debug('[Phone][Email]The following exception has occurred: ' + e.getMessage());
        }
    }
}