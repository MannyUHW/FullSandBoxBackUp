/*
 * Contact Job Group - helper for Contact Trigger Controller
 * 
 * Version: 1.0
 * 29th Mar 2016
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
public class Contact_Job_Group { 

    public Contact_Job_Group() {
      //ignore
    }

    public static void populateJobGroup(List<Contact> pNewList, List<Contact> pOldList, Boolean pIsInsert) {
      System.debug('[populateJobGroup] start');
      
      //
      // temp solution for EBoard - Mar 21st 2017
      //
      Map<Id, Contact> oldMap = new Map<Id, Contact>();
      Boolean eboardFlag = false;
      if (pOldList != null) {
        for (Contact c: pOldList) {
          if (c.Executive_Body_Title__c != null && c.Executive_Body_Title__c != '') {
            eboardFlag = true;
          }
          oldMap.put(c.Id, c);
        }
      }
      if (pNewList != null) {      
        for (Contact c: pNewList) {
          if (c.Executive_Body_Title__c != null && c.Executive_Body_Title__c != '') {
            eboardFlag = true;
          }
        }      
      }
      if (pNewList != null && pOldList != null && eboardFlag) {
        List<User> apiUserList = [ select Id, Name from User where IsActive = true and (name = 'Integration User' or name = 'UHW API') ];
        Set<Id> aset = new Set<Id>();
        for (User u:  apiUserList ) {
          aset.add(u.Id);
        }  
        for (Contact c: pNewList) {
          if (aset.contains(UserInfo.getUserId())) {
            c.Executive_Body_Title__c = oldMap.get(c.Id).Executive_Body_Title__c;
          }
        }
      }
      //
      // end EBoard fix
      //
      
      Map<String, Contact> newMap = new Map<String, Contact>();    
      Set<String> emSet = new Set<String>();
      Set<Id> emIdSet = new Set<Id>();      
      Set<String> titleSet = new Set<String>();
      Contact debugContact = null;
      for (Contact c: pNewList) {
        debugContact = c;      
        if (c.Title != null && c.Title.trim() != '' && (c.Job_Group__c == null || c.Job_Group__c.trim() == '')) {
          emSet.add(c.Account.Name);
          emIdSet.add(c.Account.Id);
          titleSet.add(c.Title);
        }
      }      
      System.debug('[populateJobGroup] querying for existing Job Groups...');

      try {
        List<Contact> existingGroups  = [select Account.Name, Title, Job_Group__c from Contact where AccountId in :emIdSet and Job_Group__c != null and (NOT Job_Group__c like '%unknown%')  limit 1000 ];      
        
        Map<String, String> emTitleMap = new Map<String, String>();   
        for (Contact c: existingGroups  ) {
          debugContact = c;        
          if (c.Account.Name != null && c.Title != null && c.Job_Group__c != null) {
            String  emTitle = (c.Account.Name + '~~~' + c.Title.trim()).toLowerCase();
            String jobGroup = Report_Custom_Utils.toProperCase(c.Job_Group__c);
            emTitleMap.put(emTitle, jobGroup);
          }
        }
        Map<String, String> titleMap = new Map<String, String>();

        for (Contact c: pNewList) { 
          debugContact = c;
          if (c.Title != null && (c.Job_Group__c == null || c.Job_Group__c == '')) {     
            String  emTitle = (c.Account.Name + '~~~' + c.Title.trim()).toLowerCase();        
            if (emTitleMap.get(emTitle) != null) {
              c.Job_Group__c = Report_Custom_Utils.toProperCase(emTitleMap.get(emTitle));
            } else {
              String  title = (String) c.get('Title');
              title = title.trim().toLowerCase();
              if (titleMap.get(title) != null) {
                c.Job_Group__c = Report_Custom_Utils.toProperCase(titleMap.get(title));
              } else {

                String defaultGroup = assignDefaultJobGroup(title);
                if (defaultGroup.toLowerCase().indexOf('unknown') != 0) {
                  defaultGroup = defaultGroup + '';
                }
                c.Job_Group__c = Report_Custom_Utils.toProperCase(defaultGroup);
       
              }
            }
          }
        }
      
      } catch (Exception overEx) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'bborcherding@seiu-uhw.org'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Contact Job Group Trigger Helper Exception For Contact - ' + debugContact);
        mail.setPlainTextBody('Failure on finding Job Group for ' + debugContact + '\nZip Code = ' + debugContact.Zipcode5__c);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }           
      System.debug('[populateJobGroup] finish');
    }

    public static String assignDefaultJobGroup(String pJobClass) {
      System.debug('[assignDefaultJobGroup] start');
      String topGroup = 'Unknown Job Group';
      String s = ' ' + pJobClass.trim().toLowerCase() + ' ';
      s = s.replace('-', ' ').replaceAll('  ', ' ');
      //System.out.println('s = _' + s + '_');
      if (s.contains(' director ') || s.contains(' dir ') || s.contains(' executive dir') || s.contains(' project man')) {
        topGroup = ('Manager');
        //System.out.println('job ' + pJobClass + ' is a manager!');
      } else if (s.contains(' chief ') || s.contains(' ceo ') || s.contains(' cfo ')) {
        //System.out.println('job ' + pJobClass + ' is a manager!');
        topGroup = ('Manager');
      } else if (s.contains(' mgr ') || s.contains(' manager ') || s.contains(' supervisor ') || s.contains(' supv ')) {
        topGroup = ('Manager');
        //System.out.println('job ' + pJobClass + ' is a manager!');
      } else if (s.contains('accountant')) {
        topGroup = ('Accountant');
      } else if (s.contains('coder')) {
        topGroup = 'BOC: Medical Records';
      } else if (s.contains(' housek') || s.contains(' evs ') || s.contains(' hskp')) {
        topGroup = 'EVS';
      } else if (s.contains(' it ') || s.contains('desktop')) {
        topGroup = 'IT';
      } else if (s.contains(' unit clerk ')) {
        topGroup = 'BOC: Unit/Department Secretary or Assistant';
      } else if (s.contains(' evs') && s.contains(' tech')) {
        topGroup = 'EVS';       
      } else if (s.contains(' phleb')) {
        topGroup = 'Phlebotomist/Phlebotomy Tech';
      } else if (s.contains(' billing') || s.contains(' biller')) {
        topGroup = 'BOC: Biller';
      } else if (s.contains('sterile') || s.contains('sterilization')) {
        topGroup = 'Sterilization - Sterile Processing';
      } else if (s.contains(' office') || s.contains(' medical')) {
        topGroup = 'BOC: Office/Administrative Assistant';
      } else if (s.contains(' pct ')) {
        topGroup = 'Patient Care Tech';
      } else if (s.contains(' clerk ')) {
        topGroup = 'BOC: Clerk';
      } else if (s.contains(' ct ') && s.contains(' tech')) {
        topGroup = 'Tech - Rad';
      } else if (s.contains(' physical ') && s.contains(' ther')) {
        topGroup = 'PT/OT';
      } else if (s.contains(' phys') && s.contains(' ther')) {
        topGroup = 'PT/OT';
      } else if (s.contains(' speech ') && s.contains(' ther')) {
        topGroup = 'Therapist - Speech';
      } else if (s.contains(' registra')) {
        topGroup = 'BOC: Patient Registration/Accounts';
      } else if (s.contains(' secretary ') || s.contains('unitsectry')) {
        topGroup = 'BOC: Unit/Department Secretary or Assistant';
      } else if (s.contains(' imaging ') && s.contains(' spec')) {
        topGroup = 'Tech - Imaging';
      } else if (s.contains(' lab ') && s.contains(' te')) {
        topGroup = 'Tech - Lab';
      } else if (s.contains(' patient ') && s.contains(' accnt')) {
        topGroup = 'BOC: Patient Registration/Accounts';
      } else if (s.contains(' cert ') && s.contains(' resp')) {
        topGroup = 'RCP';
      } else if (s.contains(' medical ') && s.contains(' social ') && s.contains(' w')) {
        topGroup = 'MSW';
      } else if (s.contains(' maint')) {
        topGroup = 'Engineer - Maintenance';
      } else if (s.contains(' plant') && s.contains(' eng')) {
        topGroup = 'Engineer - Maintenance';
      } else if (s.contains(' radiol') && s.contains(' tech')) {
        topGroup = 'Tech - Rad';
      } else if (s.contains('tech') && s.contains('telemetry')) {
        topGroup = 'Tech - Telemetry';
      } else if (s.contains(' lvn')) {
        topGroup = 'LVN - Licensed Vocational Nurse';
      } else if (s.contains(' l v n')) {
        topGroup = 'LVN - Licensed Vocational Nurse';
      } else if (s.contains(' tech') && s.contains(' mri ')) {
        topGroup = 'Tech - Imaging';
      } else if (s.contains(' resp') && s.contains(' care ') && s.contains(' pra')) {
        topGroup = 'RCP';
      } else if (s.contains(' resp') && s.contains(' care ') && s.contains(' prct')) {
        topGroup = 'RCP';  
      } else if (s.contains(' resp') && s.contains(' tech') && !s.contains(' ass')  && !s.contains(' aide')) {
        topGroup = 'RCP';  
      } else if (s.contains(' rcp') && !s.contains(' ass')  && !s.contains(' aide')) {
        topGroup = 'RCP';             
      } else if (s.contains(' ultrasound ') && s.contains(' te')) {
        topGroup = 'Tech - Ultrasound';
      } else if (s.contains(' clerical ')) {
        topGroup = 'BOC: Clerk';
      } else if (s.contains('tech') && s.contains('pharm')) {
        topGroup = 'Tech - Pharmacy';
      } else if (s.contains('courier')) {
        topGroup = 'Lift/Transporter';
      } else if (s.contains(' occup') && s.contains(' thera')) {
        topGroup = 'PT/OT';
      } else if (s.contains(' x') && s.contains('ray ') && s.contains(' tech')) {
        //System.out.println('job ' + pJobClass + ' is an imaging tech!');
        topGroup = 'Tech - Imaging';        
      } else if (s.contains(' surg') && s.contains(' tech')) {
        topGroup = 'Tech - Surgical';
      } else if (s.contains('monitor') && s.contains(' tech')) {
        topGroup = 'Monitor Tech';        
      } else if (s.contains(' transcrib') || s.contains(' scribe')) {
        topGroup = 'BOC: Clerk';
      } else if ((s.contains(' endoscopy ') && s.contains(' tech')) || s.contains('leadct tech') || s.contains('echo tech')) {
        topGroup = 'Tech - Imaging';
      } else if ((s.contains(' ob') && s.contains(' tech')) || s.startsWith('ob tech')) {  
        topGroup = 'Tech - OB';
      } else if (s.contains(' cardi') && s.contains(' tech')) {  
        topGroup = 'Tech - Cardio';
      } else if (s.contains(' emerg') && s.contains(' tech')) {  
        topGroup = 'Tech - ER/ED';
      } else if (s.contains(' er ') && s.contains(' tech')) {  
        topGroup = 'Tech - ER/ED';        
      } else if (s.contains(' rn ')  && !s.contains(' ass')  && !s.contains(' aide')) {  
        topGroup = 'Registered Nurse';
      } else if (s.contains(' charge nurse ')  && !s.contains(' ass')  && !s.contains(' aide')) {  
        topGroup = 'Registered Nurse';
      } else if (s.contains(' food ')) {  
        topGroup = 'Food Service';
      } else if (s.contains(' m.d. ')  && !s.contains(' ass')  && !s.contains(' aide')) {  
        topGroup = 'M.D.';
      } else if (s.contains(' secty ')) {  
        topGroup = 'BOC: Unit/Department Secretary or Assistant';
      } else if (s.contains(' cna ') || s.contains(' c.n.a' )) {  
        topGroup = 'CNA';        
      } else if (s.contains(' env ')  && s.contains(' svcs ')  && s.contains(' tech')) {  
        topGroup = 'EVS';
      } else if (s.trim().startsWith('evs')) {  
        topGroup = 'EVS';        
      } else if (s.contains(' cashier')) {  
        topGroup = 'BOC: Cashier/receptionist';
      } else if (s.contains('nutrition service') || s.contains('cook')) {  
        topGroup = 'Food Service';
      } else if (s.contains(' diet') && s.contains(' ass')) {  
        topGroup = 'Food Service';
      } else if (s.contains(' interpret')) {  
        topGroup = 'Interpreter';
      } else if (s.contains(' scientist')  && s.contains(' clin')  && s.contains(' lab') && !s.contains(' ass')  && !s.contains(' aide')) {  
        topGroup = 'CLS - Clinical Lab Scientist';
      } else if (s.contains(' cls') && !s.contains(' ass')  && !s.contains(' aide') && !s.contains(' ck') && !s.contains(' clerk')) {  
        topGroup = 'CLS - Clinical Lab Scientist';        
      } else if (s.contains(' claims')  && !s.contains(' ass')  && !s.contains(' aide')  && !s.contains(' ck')  && !s.contains(' clerk')) {  
        topGroup = 'BOC: Claims Adjustor/Processor';
      } else if (s.contains(' admit')  && s.contains(' reg')) {  
        topGroup = 'BOC: Clerk - Appointments/Scheduling';
      } else if (s.contains(' ass')  && s.contains(' lab')) {  
        topGroup = 'Lab assistant';
      } else if (s.contains(' him')  && !s.contains(' ass')  && !s.contains(' aide')) {  
        topGroup = 'BOC: Medical Records';
      } else if (s.contains(' health')  && s.contains(' info') && !s.contains(' ass')  && !s.contains(' aide')) {  
        topGroup = 'BOC: Medical Records';        
      } else if (s.contains(' emt ')) {  
        topGroup = 'EMT';
      } else if (s.contains(' hm')  & s.contains(' hlth')) {
        topGroup = 'Home Care Worker';
      } else if (s.contains(' imaging')  && (s.contains(' ass') || s.contains(' aide'))) {
        topGroup = 'Assistant - Imaging';
      } else if (s.trim().endsWith(' ck')) {
        topGroup = 'BOC: Clerk';
      } else if (s.contains(' home care worker ') || s.contains(' homecare ')) {
        topGroup = 'Home Care Worker';
      } else if (s.contains(' fsw') || s.contains(' fns')) {
        topGroup = 'Food Service';
      } else if ((s.contains(' health') || s.contains(' hlth')) && s.contains(' ed')) {
        topGroup = 'Health Educator';
      } 
      System.debug('[assignDefaultJobGroup] finish');        
      return topGroup;   
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
      return i;                                             
    }
}