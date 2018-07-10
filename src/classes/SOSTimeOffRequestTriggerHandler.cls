public class SOSTimeOffRequestTriggerHandler {    
    public static void totalHoursUpdate(List<SOS_Time_Off_Request__c> TriggerNew, List<SOS_Time_Off_Request__c> TriggerOld, Boolean isUpdate) {
        User usr = [Select Id,Non_Exempt_Employee__c,Show_Balance_In_Days__c, username, Next_Automated_Approver__c, userroleid, ManagerId from user where id =: userinfo.getUserId() limit 1]; 
        if(!isUpdate) {
            usr.Next_Automated_Approver__c = usr.ManagerId;
            update usr;   
        }    
        
        
        
        
        
        for(Integer i = 0; i < Triggernew.size(); i++) {
            if(isUpdate && (Triggernew[i].Status__c == 'Approved' ||  Triggernew[i].Status__c == 'Rejected'))
                Triggernew[i].Approved_Rejectd_by__c = userinfo.getUserId();
            if(Triggernew[i].recordTypeId == system.label.Time_Off_Request_Id && (!isUpdate || (isUpdate && Triggerold[i].Total_Hours_Requested__c != Triggernew[i].Total_Hours_Requested__c))) {
                if(!isUpdate)
                    Triggernew[i].Is_Non_Exempt__c = usr.Show_Balance_In_Days__c;
                if(! usr.Show_Balance_In_Days__c)
                        Triggernew[i].Total_Hours_Requested_Hour_Day__c = Triggernew[i].Total_Hours_Requested__c+((Triggernew[i].Total_Hours_Requested__c == 0 || Triggernew[i].Total_Hours_Requested__c == 1)?' Hour':' Hours');
                else
                    Triggernew[i].Total_Hours_Requested_Hour_Day__c = Triggernew[i].Total_Hours_Requested__c+((Triggernew[i].Total_Hours_Requested__c == 0 || Triggernew[i].Total_Hours_Requested__c == 1)?' Day':' Days');
            }            
        }           
    }

    public static void onBeforeInsert(List<SOS_Time_Off_Request__c> TriggerNew) {        
        User usr = [Select Id,Non_Exempt_Employee__c,Show_Balance_In_Days__c, username, Next_Automated_Approver__c, userroleid, ManagerId from user where id =: userinfo.getUserId() limit 1];
        totalHoursUpdate(TriggerNew,null,false);  
        Map<Id,SOS_Time_Off_Balance__c> tobmap = new Map<Id,SOS_Time_Off_Balance__c>();
        for(SOS_Time_Off_Balance__c tob :[Select Id,Employee_Name__c from SOS_Time_Off_Balance__c where Employee_Name__c =: userinfo.getUserId()]) {
            tobmap.put(tob.Employee_Name__c,tob);
        }
        List<Holiday> holidaylst = [Select h.ActivityDate, h.Name, h.IsRecurrence From Holiday h];
        for(Integer i = 0; i < Triggernew.size(); i++) {  
            /** START of SHK's fix for SickNotification email to Manager**/
            if (Triggernew[i].Type__c == 'Sick' && usr.ManagerId != null) {
                Triggernew[i].Manager__c = usr.ManagerId;
            }         
            /** End of SHK's fix for SickNotification email to Manager**/
            
            If(tobmap.containsKey(userinfo.getUserId()) && Triggernew[i].RecordTypeId == System.Label.Time_Off_Request_Id ) {
                Triggernew[i].Time_Off_Balance__c = tobmap.get(userinfo.getUserId()).id;
            }
            else {
                //Triggernew[i].addError('Time Off Balance is not available for you, Please contact your System Administrator');
            }
            
            /** START **/
            if(Triggernew[i].recordTypeId == system.label.Time_Off_Request_Id) {            
                Integer totalholidays = 0;
                for(Holiday h : holidaylst) {
                    if(h.ActivityDate >= Triggernew[i].Start_Date__c && h.ActivityDate <= Triggernew[i].End_Date__c ) {
                        totalholidays += 1;
                    }
                }
                Integer j = 0;   
                Datetime sdate = Datetime.newInstance(Triggernew[i].Start_Date__c, Time.newInstance(12, 0, 0, 0)); 
                Datetime edate = Datetime.newInstance(Triggernew[i].end_Date__c, Time.newInstance(12, 0, 0, 0));  
                Integer totalnumberDays = Triggernew[i].Start_Date__c.daysBetween(Triggernew[i].end_Date__c) + 1;
                while (sdate <= edate) {
                    if (sdate.format('E') == 'Sat' | sdate.format('E') == 'Sun'){
                        j = j + 1;
                    }
                    sdate = sdate.addDays(1);
                }    
                if(totalholidays != null)
                    j += totalholidays;
                Integer workingdays = (totalnumberDays - j);            
                if(usr.Show_Balance_In_Days__c && Triggernew[i].Total_Hours_Requested__c > workingdays)             
                    Triggernew[i].Total_Hours_Requested__c.addError('Total Days requested are exceeding the date range selected.');
                if(!usr.Show_Balance_In_Days__c && Triggernew[i].Total_Hours_Requested__c > (workingdays * 8))
                    Triggernew[i].Total_Hours_Requested__c.addError('Total Hours requested are exceeding the date range selected.');
            }
            /**     End **/                                     
        }        
    }
    
    public static void onBeforeUpdate(Map<Id,SOS_Time_Off_Request__c> triggerNewMap, Map<Id,SOS_Time_Off_Request__c> triggeroldMap) {       
        totalHoursUpdate(triggerNewMap.values(),triggeroldMap.values(),true);
    }
    
    public static void onAfterEvents(List<SOS_Time_Off_Request__c> TriggerOld, List<SOS_Time_Off_Request__c> TriggerNew, 
    Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Map<Id,SOS_Time_Off_Request__c> triggerNewMap) {
        User usr;
        User usrsMgr;
        if(!ProcessorControl.inFutureContext) {            
            If(isInsert)
                usr = [Select Id,Non_Exempt_Employee__c,Show_Balance_In_Days__c, username, Next_Automated_Approver__c, userroleid, ManagerId from user where id =: userinfo.getUserId() limit 1];
            else if(isUpdate || isUndelete)
                usr = [Select Id,Non_Exempt_Employee__c,Show_Balance_In_Days__c, username, Next_Automated_Approver__c, userroleid, ManagerId from user where id =: TriggerNew[0].createdById limit 1];
            /***  STARTS *****/
            User mgrUser;
            UserRole usrRle;
            List<user> usrSetUdt;
            String devRleNavg;
            UserRole mgrRleId = null;
            User excepApprover;
            if(!isDelete) {   
            if(usr.ManagerId != null)
                    usrsMgr = [Select Id,Non_Exempt_Employee__c,Show_Balance_In_Days__c, username, Next_Automated_Approver__c, userroleid, ManagerId from user where id =: usr.ManagerId limit 1]; 
                usrSetUdt = new List<user>();               
                if(usr.userroleid != null)
                    usrRle = [Select Id, Name from UserRole where Id =: usr.userroleid limit 1];                
                Set<String> rleLst;
                if(Director_Role_Navigation__c.getall() != null && Director_Role_Navigation__c.getall().size() > 0)
                    rleLst = Director_Role_Navigation__c.getall().keyset();
                if(usrRle != null && rleLst != null && usrRle.name != '') {
                    if(rleLst.contains(usrRle.name))
                        devRleNavg = Director_Role_Navigation__c.getValues(String.valueOf(usrRle.name)).Division_Manager_Role__c; 
                }
                System.Debug('@@@devRleNavg:'+devRleNavg);                
                if(devRleNavg != null && devRleNavg != '') {
                    /** START of SHK's fix the error msg that user gets for TimeOffRequest**/
                    UserRole[] roles = [Select Id, Name from UserRole where name =: devRleNavg];
                    if (roles.size() > 0) {
                        mgrRleId = roles[0];
                    }
                    /** END of SHK's fix  **/
                }
                if(mgrRleId != null) {
                    /** START of SHK's fix the error msg that user gets for TimeOffRequest**/
                    User[] musers = [Select Id, Name, userroleid from User where userroleid =: mgrRleId.id ];
                    if (musers.size() > 0) {
                        mgrUser = musers[0];
                    }
                    /** END of SHK's fix  **/
                }
                System.Debug('@@@mgrUser:'+mgrUser);
                excepApprover = [Select Id, username from user where username =: system.label.Exception_Approver];
            }
            /**** ENDS ******/
            Set<Id> torCreators = new Set<Id>();
            Integer triggerSize;
            if(isInsert || isUpdate || isUndelete)
                triggerSize = Triggernew.size();
            if(isUpdate || isDelete)
                triggerSize = Triggerold.size();
            Map<Id,SOS_Time_Off_Balance__c> updateTobs = new Map<Id,SOS_Time_Off_Balance__c>();
            System.Debug('@@triggersize:'+triggerSize);
            for (Integer i = 0; i < triggerSize; i++) {
                if(isDelete)
                    torCreators.add(Triggerold[i].CreatedById);
                else
                    torCreators.add(Triggernew[i].CreatedById);  
            }
            Map<Id,User> sosTORMap = new Map<Id,User>([Select Id, ManagerId from User where Id in: torCreators]);
            for (Integer i = 0; i < triggerSize; i++) {             
                /*** STARTS ***/
                if(!isDelete) {
                if(Triggernew[i].type__c == 'overtime' && (usrSetUdt == null || usrSetUdt.size() ==0)) {
                    if(isUpdate && Triggernew[i].status__c == 'Manager Pending') {
                        System.Debug('@@Other Status: '+Triggernew[i].status__c);
                        if(SOS_Utility.isSrchStrPresent(string.valueOf(system.label.Approval_Exception_Emails),string.valueOf(usr.username))) {
                            System.Debug('@@@Role Present: '+SOS_Utility.isSrchStrPresent(string.valueOf(system.label.Approval_Exception_Emails),string.valueOf(usr.username)));
                            usrsMgr.Next_Automated_Approver__c = excepApprover.id;
                            usrSetUdt.add(usrsMgr);
                        }
                        else if(devRleNavg != '' && mgrUser != null) {
                            usrsMgr.Next_Automated_Approver__c = mgrUser.id;
                            usrSetUdt.add(usrsMgr);
                            System.Debug('@@@mgr Present: '+devRleNavg);
                        }
                        else {
                            System.Debug('@@@else : '+excepApprover.id);
                            usrsMgr.Next_Automated_Approver__c = excepApprover.id;
                            usrSetUdt.add(usrsMgr);
                        }
                    }                
                } 
                }
            /*** ENDS ***/
    
                if(isInsert || isUpdate ) {
                    if ((Triggernew[i].Manager_Name__c != '' && Triggernew[i].Manager_Name__c != null) && 
                    ( (isInsert && (Triggernew[i].Type__c=='Holiday work days' || Triggernew[i].Type__c=='Jury Duty')) 
                    || (isUpdate && (Triggerold[i].Status__c != 'HR Approved' && Triggernew[i].Status__c == 'HR Approved')))||
                    (isInsert && Triggernew[i].Type__c=='Overtime' && Triggernew[i].Status__c == 'New')) {                      
                       if(Triggernew[i].recordTypeId == system.label.Time_Off_Request_Id) {
                            // create the new approval request to submit
                            //SHK Added this condition check for these two types, for Jira #92 issue - Mar_28_2014
                            if (!(isUpdate && (Triggernew[i].Type__c=='Holiday work days' || Triggernew[i].Type__c=='Jury Duty'))) {
                                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                                req.setComments('Submitted for approval. Please approve.');
                                req.setObjectId(Triggernew[i].Id);
                                If(sosTORMap.containsKey(Triggernew[i].CreatedById))
                                    req.setNextApproverIds(new Id[] {sosTORMap.get(Triggernew[i].CreatedById).ManagerId});
                                // submit the approval request for processing
                                Approval.ProcessResult result = Approval.process(req);
                                // display if the reqeust was successful
                                System.debug('Submitted for approval successfully: '+result.isSuccess());  
                            }                          
                        }
                        else if(Triggernew[i].recordTypeId == system.label.OvertimeRecordtype && usr.Next_Automated_Approver__c != null) {
                            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                            req.setComments('Submitted for approval. Please approve.');
                            req.setObjectId(Triggernew[i].Id);                            
                            // submit the approval request for processing
                            Approval.ProcessResult result = Approval.process(req);
                        }             
                    }
                }
                //Creating Roll Up Summary Fields
                if((!isDelete && Triggernew[i].recordTypeId == system.label.Time_Off_Request_Id) ||
                  (isDelete && Triggerold[i].recordTypeId == system.label.Time_Off_Request_Id)) {
                    if(isInsert || isUpdate || isUndelete)
                        if(Triggernew != null)
                            updateTobs.put(Triggernew[i].Time_Off_Balance__c,null);
                    if(isUpdate || isDelete)
                        if(Triggerold != null)
                            updateTobs.put(Triggerold[i].Time_Off_Balance__c,null); 
                }        
            }
            if(updateTobs != null || isDelete)
                for(Id tobId:updateTobs.keyset())
                    updateTobs.put(tobId,new SOS_Time_Off_Balance__c(id=tobId,
                    Sick_Time_Approved__c=0, Unpaid_Time_Approved__c=0, Holiday_work_days_Time_Approved__c=0, 
                    Relieve_Time_Approved__c=0, Birthday_Time_Approved__c=0, Float_Time_Approved__c=0,Bereavement_Time_Approved__c=0,
                    Jury_Duty_Time_Approved__c=0,Religious_OPEIU_Only_Time_Approved__c=0,Sick_Time_Pending__c=0,Unpaid_Time_Pending__c=0,
                    Holiday_work_days_Time_Pending__c=0,Relieve_Time_Pending__c=0,Birthday_Time_Pending__c=0,Float_Time_Pending__c=0,
                    Bereavement_Time_Pending__c=0,Jury_Duty_Time_Pending__c=0,Religious_OPEIU_Only_Time_Pending__c=0, Vacation_Time_Approved__c=0,
                    Vacation_Time_Pending__c=0 ));
                
            map< string, list< schema.sobjectfield > > fieldMap =
            new map< string, list< schema.sobjectfield > > {
                'Vacation' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Vacation_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Vacation_Time_Approved__c
                    },
                'Sick' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Sick_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Sick_Time_Approved__c
                    },
                'Unpaid' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Unpaid_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Unpaid_Time_Approved__c
                        
                    },
                'Holiday work days' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Holiday_work_days_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Holiday_work_days_Time_Approved__c
                        
                    },
                'Relief' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Relieve_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Relieve_Time_Approved__c
                    },
                'Birthday' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Birthday_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Birthday_Time_Approved__c
                    },
                'Float' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Float_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Float_Time_Approved__c
                    },
                'Bereavement' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Bereavement_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Bereavement_Time_Approved__c
                    },
                'Jury Duty' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Jury_Duty_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Jury_Duty_Time_Approved__c
                    },
                'Religious (OPEIU Only)' =>
                    new list< schema.sobjectfield > {
                        SOS_Time_Off_Balance__c.Religious_OPEIU_Only_Time_Pending__c,
                        SOS_Time_Off_Balance__c.Religious_OPEIU_Only_Time_Approved__c
                    }
            };
            
            EstimatedBalanceDate__c estBalDt = EstimatedBalanceDate__c.getValues('SOS Time Off Balance Date Update');
            Date Last_Upload_Date = estBalDt.Data_Load_Date__c;
            
            
            for(SOS_Time_Off_Request__c tor : [SELECT Id, Total_Hours_Requested__c, Status__c, Type__c, Time_Off_Balance__c, Time_Off_Balance__r.Show_In_Days__c, Is_Non_Exempt__c, recordTypeId
                FROM  SOS_Time_Off_Request__c WHERE Time_Off_Balance__c IN :updateTobs.keySet() AND 
                Type__c in ('Vacation','Sick','Unpaid','Holiday work days','Relief','Birthday','Float','Bereavement','Jury Duty','Religious (OPEIU Only)') AND Status__c in ('Approved','Manager Pending', 'HR Pending') and Start_Date__c >=:Last_Upload_Date  ]){
                if(tor.recordTypeId == system.label.Time_Off_Request_Id) {
                    System.Debug(fieldmap.get( tor.Type__c )[0]+'@@@updateTobs:@'+'inside'+updateTobs);                 
                    If(tor.Status__c == 'Approved' || tor.Status__c == 'Manager Pending' || tor.Status__c == 'HR Pending') {
                        
                        system.debug('Is_Non_Exempt__c:' + tor.Is_Non_Exempt__c);
                        system.debug('tor:' + tor);

                        if(tor.Time_Off_Balance__r.Show_In_Days__c)
                        {
                            updateTobs.get( tor.Time_Off_Balance__c).put(fieldmap.get( tor.Type__c)[(tor.Status__c == 'Approved') ? 1 : 0],
                            ( Decimal )( updateTobs.get( tor.Time_Off_Balance__c ).get( fieldmap.get( tor.Type__c )[(tor.Status__c == 'Approved') ? 1 : 0]))+tor.Total_Hours_Requested__c );
                            
                        }   
                        else
                        {
                            updateTobs.get( tor.Time_Off_Balance__c).put(fieldmap.get( tor.Type__c)[(tor.Status__c == 'Approved') ? 1 : 0],
                            ( Decimal )( updateTobs.get( tor.Time_Off_Balance__c ).get( fieldmap.get( tor.Type__c )[(tor.Status__c == 'Approved') ? 1 : 0]))+(tor.Total_Hours_Requested__c ));
                            
                        }
                    } 
                }            
           }      
           if(updateTobs != null)
           
                Database.update(updateTobs.values());  
                
            /** **/ 
            if(isUpdate)
                approvalUpdate(triggerNewMap.keyset());
            /** **/
            if(!isDelete && usrSetUdt.size()>0)
                update usrSetUdt; 
        }
    }
    
   @future
   public static void approvalUpdate(Set<Id> sosTORSet) {
       List<SOS_Time_Off_Request__c> updLst = new List<SOS_Time_Off_Request__c>();
       Map<Id,SOS_Time_Off_Request__c> sosTORMapAppr = new Map<Id,SOS_Time_Off_Request__c>(
        [Select Id, Comments__c,Manager_Comments__c, Status__c, Type__c,(Select TargetObjectId, SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, OriginalActorId, 
        IsPending, IsDeleted, Id, CreatedDate, CreatedById, Comments, ActorId From ProcessSteps order by SystemModstamp desc) from SOS_Time_Off_Request__c 
        where Id in :sosTORSet]);      
        System.Debug('@@@sosTORMapAppr:@@'+sosTORMapAppr);
        for(SOS_Time_Off_Request__c tor : sosTORMapAppr.values()) {           
            if(tor.Status__c == 'Approved' || tor.Status__c == 'Rejected') {
                if(tor.Type__c == 'Overtime') {
                    if(!sosTORMapAppr.get(tor.id).ProcessSteps.isEmpty()) {
                        tor.HR_Comments__c = sosTORMapAppr.get(tor.id).ProcessSteps[0].Comments;
                        updLst.add(tor);
                        System.Debug('@@@Overtime HR:'+tor.HR_Comments__c);
                    }
                }                   
                else {
                    if(!sosTORMapAppr.get(tor.id).ProcessSteps.isEmpty()) {
                        tor.Manager_Comments__c = sosTORMapAppr.get(tor.id).ProcessSteps[0].Comments;
                        updLst.add(tor);
                        System.Debug('@@@Time Off Mgr:'+tor.Manager_Comments__c);
                    }
                }
            }
            else if(tor.Status__c == 'HR/Div. Direcor Pending' && tor.Type__c == 'Overtime'){
                tor.Manager_Comments__c = sosTORMapAppr.get(tor.id).ProcessSteps[0].Comments;
                updLst.add(tor);
                System.Debug('@@@Overtime HR:'+tor.Manager_Comments__c);
            }
        }
       if(updLst.size() > 0 && updLst != null) {
            ProcessorControl.inFutureContext = true;
            Database.update(updLst,false);            
       }
    }
}