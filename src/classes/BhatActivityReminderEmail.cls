public class BhatActivityReminderEmail  {

    /* 
          Send reminders to users who are not having their 'BHAT_Activity_Weekly__c' record's status to be wither: ( Status=Overtime or Status=Complete) 
          And per new logic:
          1. Any week in last 4 weeks, if is incomplete, will send 30 days reminder.
          2. Any week in 5th week to 8th week, if is incomplete, will send 60 days reminder.
          3. Any week in 9th week to 12th week, if is incomplete, will send 90 days reminder.
    */

    public ReminderEmail remdinerEmailList =new ReminderEmail();
    public list<ReminderEmailReport> ReminderEmailReportList {get;set;}
    
    Private Date fourWeeksEarlier;        
    Private Date eightWeeksEarlier;
    Private Date twelveWeeksEarlier;
    Private Date sixteenWeeksEarlier;
    Private Date NthWeeksEarlier;

    public BhatActivityReminderEmail()
    {
               
    
    
    
    }
    
    
    public List<ReminderEmailReport> GetBhatActivityPendingList(List<Id> userFilterList, list<Integer> PeriodValuesSelected)
    {

        List<Id> allUserList = new List<Id>(); 
        List<Id> remainingUserList = new List<Id>(); 
        
        List<string> useridList = new List<string>(); 
        List<Id> userIdNeedReminder = new List<Id>(); 
        
        List<ReminderEmailReport> pendingList = new List<ReminderEmailReport>();
        SetStartDateEndDates();
        InsertBhatActivityLog();
        
        // Get max Period if anything selected for assign the from date.
        
        if (PeriodValuesSelected.size() > 0 )
        {
            PeriodValuesSelected.sort();
              
            Integer maxWeek = PeriodValuesSelected.get(PeriodValuesSelected.size()-1);
            
            if (maxWeek == 90)
            {
                NthWeeksEarlier = sixteenWeeksEarlier ;
            }
            else if (maxWeek == 60)
            {
               NthWeeksEarlier = twelveWeeksEarlier;
            }
            else 
            {
               NthWeeksEarlier = eightWeeksEarlier;
            }
            
            system.debug('sun maxWeek  ' + maxWeek );
            
        }
        else
        {
            NthWeeksEarlier =  sixteenWeeksEarlier ;
        }
        
        
        system.debug('sun userFilterList.size() :' + userFilterList.size() );
        
        if(userFilterList.size() > 0)
        {
            allUserList = userFilterList;
        }
        else
        {
            //userList = (Set<String>)JSON.deserialize(JSON.serialize(GetValidUserList()), Set<String>.class);
            allUserList= GetValidUserList();
            system.debug('sun test');
        }
        
        
        remainingUserList = allUserList;
        //useridList.addAll(userList );
        
        //
        
        AggregateResult[] bhatActivities;
        List<Id> bhatActivitiesOwnerIds;
        
        system.debug('sixteenWeeksEarlier:' + sixteenWeeksEarlier);
        system.debug('allUserList:' + allUserList);
        system.debug('fourWeeksEarlier:' + fourWeeksEarlier);

        
        bhatActivities = [SELECT OwnerId, MIN(WeekStartDate__c) startDate FROM BHAT_Activity_Weekly__c 
                                    WHERE WeekStartDate__c >= :sixteenWeeksEarlier AND WeekStartDate__c < :fourWeeksEarlier 
                                    AND (Status__c != 'Complete' AND Status__c != 'Overtime') AND OwnerId IN:allUserList  
                                    GROUP BY OwnerId, Owner.LastName ORDER BY Owner.LastName ASC ];

        bhatActivitiesOwnerIds = new List<Id>();
        for (AggregateResult ar : bhatActivities) bhatActivitiesOwnerIds.add((Id)ar.get('OwnerId'));

        system.debug('Sun   size ' + allUserList.size()   + 'bhatActivities  size' + bhatActivities.size()  );


        for (AggregateResult ar : bhatActivities) 
        {

            Date startDate = (Date)ar.get('startDate');
            
            
            ReminderEmailReport ReminderEmailReport1 = new ReminderEmailReport();
            
            system.debug('startDate: ' + startDate  + ' -- twelveWeeksEarlier:' + twelveWeeksEarlier + ' -- eightWeeksEarlier:' + eightWeeksEarlier +   ' -- fourWeeksEarlier:' + fourWeeksEarlier+  ' -- :');
            
            if (startDate  < twelveWeeksEarlier && isPeriodApplicable(PeriodValuesSelected, 90) )
            {
                ReminderEmailReport1.NoOfDays = 90;
                
                ReminderEmailReport1.ownerId  =(Id)ar.get('OwnerId');
                pendingList.add(ReminderEmailReport1);
                userIdNeedReminder.add((Id)ar.get('OwnerId'));
            
            }
            else if (startDate >= twelveWeeksEarlier && startDate  < eightWeeksEarlier  && isPeriodApplicable(PeriodValuesSelected, 60) )
            {
                ReminderEmailReport1.NoOfDays = 60;
                ReminderEmailReport1.ownerId  =(Id)ar.get('OwnerId');
                pendingList.add(ReminderEmailReport1);
                userIdNeedReminder.add((Id)ar.get('OwnerId'));
            }
            else if (startDate  >= eightWeeksEarlier && startDate  < fourWeeksEarlier  && isPeriodApplicable(PeriodValuesSelected, 30))
            {
                ReminderEmailReport1.NoOfDays = 30;
                ReminderEmailReport1.ownerId  =(Id)ar.get('OwnerId');
                pendingList.add(ReminderEmailReport1);
                userIdNeedReminder.add((Id)ar.get('OwnerId'));
            }
            else
            {
                continue;
            }
            
          
        }            


        pendingList = fillUserAttribute(pendingList);
        
        pendingList = fillReminderSentDate(pendingList);
        
        pendingList = fillBhatPendingWeeks(pendingList);

        system.debug('pendingList:' + pendingList);
   
       return pendingList;    
    }

    
    
    public boolean isPeriodApplicable(list<Integer> periodList,Integer period)
    {
    
        boolean returnFalg = false;
    
        if (periodList.size()>0)
        {
            for (Integer p : periodList) 
            {
            
                if (period == p)
                {
                  returnFalg = true;      
                  break;
                }
            }
            
        }
        else
        {
          returnFalg = true;
        }
    
        return returnFalg;
    
    }
  
  
    
    
    
     public List<ReminderEmailReport> fillBhatPendingWeeks(List<ReminderEmailReport> reminderList)
     {
    
        integer icounter = 0;
        boolean recordFound = false;
    
        List<string> idList = GetUserList(reminderList);
        
        List<BHAT_Activity_Weekly__c> bhatweeklyList=  [SELECT Id, name, ownerId, Status__c, WeekStartDate__c  FROM BHAT_Activity_Weekly__c WHERE  WeekStartDate__c >= :NthWeeksEarlier 
                                 AND WeekStartDate__c < :fourWeeksEarlier  
                                AND Status__c != 'Complete' 
                                AND  Status__c != 'Overtime'
                                AND OwnerId IN :idList  ORDER BY ownerId ASC, WeekStartDate__c DESC LIMIT 3000];
    
        for (ReminderEmailReport rpt : reminderList) 
        {
            
            recordFound = false;
            
            for (BHAT_Activity_Weekly__c bhwk: bhatweeklyList) 
            {
                
                if (bhwk.ownerId == rpt.OwnerId )
                {
                
                    recordFound = true;
                    icounter  = icounter +1;
                
                    BhatWeeklyPending wkpending = new BhatWeeklyPending();
                    
                    wkpending.BhatWeekName = bhwk.name;
                    wkpending.BhatWeekId =  bhwk.Id;
                    wkpending.Status =  bhwk.Status__c;
                    

                     if (bhwk.WeekStartDate__c < twelveWeeksEarlier )
                     {
                            rpt.BhatWeekly90PendingList.add(wkpending); 
                     }
                     else if (bhwk.WeekStartDate__c < eightWeeksEarlier )
                     {
                            rpt.BhatWeekly60PendingList.add(wkpending);  
                     }
                     else if (bhwk.WeekStartDate__c < fourWeeksEarlier )
                     {
                            rpt.BhatWeekly30PendingList.add(wkpending);  
                     }

                }


                //Avoid looping the whole list, exit when all the records filled for the current owner id.
                if (recordFound == true && bhwk.ownerId != rpt.OwnerId)
                {
                    break;
                }

            }    
           
        }
        
        return reminderList;
    
     }            
     
     


     public List<ReminderEmailReport> fillReminderSentDate(List<ReminderEmailReport> reminderList)
     {
    
    
        List<string> idList = GetUserList(reminderList);
        list<date> reminderDates = new list<date>();
        
        List<BHAT_Activity_Reminder_Log__c> bhatreminderList =  [SELECT Id, Email_For_30_Day_Sent_On__c, Email_For_60_Day_Sent_On__c, Email_For_90_Day_Sent_On__c, User__c FROM BHAT_Activity_Reminder_Log__c
                      WHERE   User__c IN :idList];
    
        for (ReminderEmailReport rpt : reminderList) 
        {
        
            for (BHAT_Activity_Reminder_Log__c reminderObj: bhatreminderList) 
            {
                
                if (reminderObj.User__c == rpt.OwnerId )
                {
                
                    reminderDates.clear();

                    if (reminderObj.Email_For_30_Day_Sent_On__c != null)
                        reminderDates.add(reminderObj.Email_For_30_Day_Sent_On__c );
                        
                      
                    if (reminderObj.Email_For_60_Day_Sent_On__c != null)
                        reminderDates.add(reminderObj.Email_For_60_Day_Sent_On__c);
                          
                          
                    if (reminderObj.Email_For_90_Day_Sent_On__c != null)
                         reminderDates.add(reminderObj.Email_For_90_Day_Sent_On__c );


                    if (reminderDates.size() > 0 )
                    {
                        reminderDates.sort();
                        
                    
                        rpt.LastReminderSentOn  = reminderDates[reminderDates.size()-1].format();
                    
                    }
                    
                    
                    rpt.reminderLog  = reminderObj;
                    
                    break;
                }
            }    
           
        }
        
        return reminderList;
    
     }                  


    public List<ReminderEmailReport> fillUserAttribute(List<ReminderEmailReport> reminderList)
    {
    
        List<string> idList = GetUserList(reminderList);
        
        List<User> userObjList = [SELECT Id, Email, FirstName, LastName, ManagerId, Manager_Email__c, Department, Division, UserRoleId, Manager.Name FROM User WHERE Id IN :idList];
    
        for (ReminderEmailReport rpt : reminderList) 
        {
        
            for (User userObj : userObjList ) 
            {
                
                if (userObj.id == rpt.OwnerId )
                {
                    rpt.FirstName =userObj.FirstName;    
                    rpt.LastName =userObj.LastName;
                    rpt.Division=userObj.Division;
                    rpt.ManagerEmail=userObj.Manager_Email__c;
                    rpt.ManagerName=userObj.Manager.Name; 
                        
                    rpt.UserEmailId  = userObj.Email;
                    break;
                }
            }    
           

        }

        return reminderList;
    
    }

    public List<string> GetUserList(List<ReminderEmailReport> reminderList)
    {
        List<string> idListTemp = new List<string>();
        
        for (ReminderEmailReport rpt : reminderList) 
        {
           idListTemp.add(rpt.ownerId);
        }   
        
        return idListTemp;
    }

    public void UpdateReminderLog(List<ReminderEmailReport> reminderList)
    {
        list<BHAT_Activity_Reminder_Log__c> reminderLogList= new list<BHAT_Activity_Reminder_Log__c>();    
        for(ReminderEmailReport rpt: reminderList)
        {
            reminderLogList.add(rpt.reminderLog);
        }
    
        if (reminderLogList.size() > 0)
        {
            update reminderLogList;
        }
    
    }
    

    
    public void SetStartDateEndDates()
    {
    
        Date fixedMonday = Date.newInstance(2014, 6, 16); // 16 june 2014 is monday
        Date todaysDate = Date.today();
        Date mondayOfThisWeek = todaysDate;
        while (Math.mod(fixedMonday.daysBetween(mondayOfThisWeek), 7) != 0) {
            mondayOfThisWeek = mondayOfThisWeek.addDays(-1);
        }
        
        fourWeeksEarlier = mondayOfThisWeek.addDays(-28);        
        eightWeeksEarlier = mondayOfThisWeek.addDays(-56);
        twelveWeeksEarlier = mondayOfThisWeek.addDays(-84);
        sixteenWeeksEarlier = mondayOfThisWeek.addDays(-112);
    
    }
    
    
    public List<Id> GetValidUserList()
    {
         List<Id> validUserList = new  List<Id>();
         List<Id> excludeUserList = GetExcludeUserList();
         
         map<Id, User> nmap = new Map<Id, User> ([SELECT Id, Name FROM User WHERE  IsActive = true AND Term_Date__c = null AND Id NOT IN:excludeUserList  LIMIT 1000]);
         validUserList.addall(nmap.keyset());
         
         return validUserList;     
    }
    
    public List<Id> GetExcludeUserList()
    {
        List<Id> excludeUserList = new List<Id>();
        Common_Settings__c uhwCommentSettings = Common_Settings__c.getValues('UHWCommonSettings');
        string Exclude_Logins = uhwCommentSettings.Exclude_Login_for_BAR__c;
        List<String> Exclude_LoginsList = Exclude_Logins.split('\\,');

        if (Exclude_Logins!= null && Exclude_Logins.length() > 0)
        {
            map<Id, User> nmap = new Map<Id, User> ([SELECT Id, Name FROM User WHERE Username IN:Exclude_LoginsList  LIMIT 10]);
            excludeUserList .addall(nmap.keyset());
        }

        return excludeUserList;
    
    }
    
    //Find all the active users with No logs in the BHAT_Activity_Reminder_Log__c object and insert them with 0 email count.
    public void InsertBhatActivityLog()
    {
    
        User[] usersWithNoLog = [SELECT Id FROM User WHERE IsActive = true AND Id NOT IN (SELECT User__c FROM BHAT_Activity_Reminder_Log__c)];
    
        List<BHAT_Activity_Reminder_Log__c> newLogs = new List<BHAT_Activity_Reminder_Log__c>();
        
        for (User u : usersWithNoLog) {
            BHAT_Activity_Reminder_Log__c blog = new BHAT_Activity_Reminder_Log__c();
            blog.User__c = u.Id;
            blog.Email_Count__c = 0;
            newLogs.add(blog);
        }
        
        if (newLogs.size() > 0) {
            insert newLogs;
        }
    
    }
    
    public List<User> getChiefOfStaff()
    {
    
        List<User> chiefOfStaff = new List<User>();
        List<String> chiefOfStaffEmails = new List<String>(); 
        UserRole[] roles = [SELECT Id, Name FROM UserRole WHERE Name = 'Chief of Staff' LIMIT 1];
        if (roles.size() > 0) {
            chiefOfStaff = [SELECT Name, Email FROM User WHERE IsActive = true AND UserRoleID = :roles[0].Id AND Email like '%seiu-uhw.org%'];
            for(User u : chiefOfStaff) {
                chiefOfStaffEmails.add(u.Email);
            }
        }
        
        return chiefOfStaff ; 
    
    }
    
    
    public List<User> getDirectors()
    {
        List<User> directorUsers = new List<User>();
        Map<Id,UserRole> mapUserRole = new Map<Id,UserRole>();
        Map<Id,List<User>> mapDirectorUsers = new Map<Id,List<User>>();
            Set<Id> directorRoleIds = new Set<Id>();
            UserRole[] allroles = [SELECT Id, Name, ParentRoleId FROM UserRole];
            for(UserRole ur : allroles) {
                mapUserRole.put(ur.Id, ur);
                if (ur.Name.toLowerCase().contains('director')) {
                    directorRoleIds.add(ur.Id);
                }
            }

            /*                  
            List<User> directorUsers = [SELECT Id, Name, Email, AA_Email__c, UserRoleId  FROM User WHERE UserRoleId IN :directorRoleIds AND isActive = true 
                                            AND Email like '%seiu-uhw.org%'
                                            AND Id NOT IN :excludedUsers]; 
            */
                              
           directorUsers = [SELECT Id, Name, Email, AA_Email__c, UserRoleId  FROM User WHERE UserRoleId IN :directorRoleIds AND isActive = true 
                                            AND Email like '%seiu-uhw.org%'];

                                            
            for (User u : directorUsers) {
                List<User> users = mapDirectorUsers.get(u.UserRoleId);
                if (users == null) {
                    users = new List<User>();
                    mapDirectorUsers.put(u.UserRoleId, users);
                }
                users.add(u);
            }            
    
        return directorUsers ;
    }
    
    
    
    public Map<string,User> GetBhatActivityReminderSenderMap()
    {

        Map<string,User> mapUser = new Map<string,User>();
        
        list<Bhat_Activity_Reminder_Sender_List__c>  remList = Bhat_Activity_Reminder_Sender_List__c.getAll().values();
        
        list<string> userLoginList = new list<string>();
        for(Bhat_Activity_Reminder_Sender_List__c rl: remList)
        {
            userLoginList.add(rl.Division_Head_Login__c);
        }
        
        list<User> userList = [select id, Username, FirstName, LastName, email FROM User where Username IN:userLoginList LIMIT 500]; 
        
        
        for(Bhat_Activity_Reminder_Sender_List__c rl: remList)
        {
            for(User u:userList)
            {
                if (rl.Division_Head_Login__c.toLowerCase() == u.UserName.toLowerCase())
                {
                     mapUser.put(rl.Division__c.toLowerCase(),u);
                     break;
                }
            
            }
        
        }
                
        return mapUser;
    }
    
    public  Map<id,BHAT_Reviewer_Staff__c>  GetReviewerStaffMap(List<ReminderEmailReport> reminderList)
    {
    
        list<id> staffids = new list<id>();
        for (ReminderEmailReport rpt: reminderList)
        {
            staffids.add(rpt.ownerId);
        } 
        
        map<Id, BHAT_Reviewer_Staff__c> myMap = new  map<Id, BHAT_Reviewer_Staff__c>(); 
        myMap = new Map<ID, BHAT_Reviewer_Staff__c>([SELECT Staff__c, Reviewer__r.Reviewer__r.Email FROM BHAT_Reviewer_Staff__c  WHERE Staff__c IN :staffids]);
        
        
        
        return myMap;
    }
    
    public void SendEmailReminder(List<ReminderEmailReport> reminderList)
    {
    
        List<Messaging.SingleEmailMessage> messages =  GetEmailMessage(reminderList);
        system.debug('sun messages:' + messages);
        system.debug(':sun end' );
        Messaging.sendEmail(messages);
    
    }
        
    public User GetUserByDivision(string division, Map<string,User> divisionSenderMap)
    {
                 User divUser = divisionSenderMap.get(division.tolowercase());
                 if (divUser != null)
                 {
                    return divUser;
                 }
                 else
                 {
                     return divisionSenderMap.get('Default'.tolowercase());
                 }    
    }            
    
    
    public List<Messaging.SingleEmailMessage> GetEmailMessage(List<ReminderEmailReport> reminderList)
    {
    
        Date todaysDate = Date.today();
        Map<id,BHAT_Reviewer_Staff__c>  reviewStaffMap = GetReviewerStaffMap(reminderList);
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>(); 
        
        Map<string,User> divisionSenderMap = GetBhatActivityReminderSenderMap();
        
        
        EmailTemplate emailTemplate30Days = new EmailTemplate();  
        EmailTemplate emailTemplate60Days = new EmailTemplate();  
        EmailTemplate emailTemplate90Days = new EmailTemplate();
        try {
            emailTemplate30Days = [select id, subject, name, htmlvalue from EmailTemplate where name='EmailFor30DaysDelinquent'];
            emailTemplate60Days = [select id, subject, name, htmlvalue from EmailTemplate where name='EmailFor60DaysDelinquent'];
            emailTemplate90Days = [select id, subject, name, htmlvalue from EmailTemplate where name='EmailFor90DaysDelinquent'];
        }
        catch (Exception e) {
        } 
        
        
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address LIKE  'noreply@%' limit 1];
        
        String htmlBody='';
        string LastReminderSentOn='';
        string bhatPendingWeeklyString = '';
         
        for (ReminderEmailReport rpt: reminderList)
        {
        
             Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
             bhatPendingWeeklyString = '';
             LastReminderSentOn='';            
             
             if (rpt.NoOfDays == 30)
             {
                 htmlBody = emailTemplate30Days.HtmlValue;
                 email.Subject=emailTemplate30Days.subject; 
                 email.setCcAddresses(new String[] {rpt.ManagerEmail });
                 rpt.reminderLog.Email_For_30_Day_Sent_On__c = todaysDate ;
                 
             }
             else if (rpt.NoOfDays == 60)
             {
             
                 User divUser  = GetUserByDivision(rpt.Division, divisionSenderMap);
                 if (divUser != null)
                 {
                     email.setCcAddresses(new String[] {divUser.Email});
                 }
             
                 htmlBody = emailTemplate60Days.HtmlValue;
                 email.Subject=emailTemplate60Days.subject; 
                 rpt.reminderLog.Email_For_60_Day_Sent_On__c = todaysDate ;

                 
             }
             else if (rpt.NoOfDays == 90)
             {
                 htmlBody = emailTemplate90Days.HtmlValue;
             
                 User divUser  = GetUserByDivision('CHIEF OF STAFF', divisionSenderMap);
                 if (divUser != null)
                 {
                     email.setCcAddresses(new String[] {divUser.Email});
                     htmlBody = htmlBody.replace('{!ChiefOfStaffName}', 'Send on behalf of '+ divUser.FirstName + ' ' + divUser.LastName + '<br/><br/>');
                 }
                 else
                 {
                     htmlBody = htmlBody.replace('{!ChiefOfStaffName}', '');
                 }
             
                email.Subject=emailTemplate90Days.subject; 
                rpt.reminderLog.Email_For_90_Day_Sent_On__c = todaysDate ;

                
             }
             
                 if (rpt.LastReminderSentOn != null && rpt.LastReminderSentOn.trim() != '')
                 {
                     LastReminderSentOn = 'On '+ rpt.LastReminderSentOn + ', you received an email directing you to complete your delinquent activity reports.  ';
                 }

                 for(BhatWeeklyPending p: rpt.BhatWeekly30PendingList)
                 {
                    bhatPendingWeeklyString =  bhatPendingWeeklyString  + p.BhatWeekName  + ',';
                 }

                 for(BhatWeeklyPending p: rpt.BhatWeekly60PendingList)
                 {
                    bhatPendingWeeklyString =  bhatPendingWeeklyString  + p.BhatWeekName  + ',';
                 }

                 
                 for(BhatWeeklyPending p: rpt.BhatWeekly90PendingList)
                 {
                    bhatPendingWeeklyString =  bhatPendingWeeklyString  + p.BhatWeekName  + ',';
                 }

                 if (bhatPendingWeeklyString != '')
                 {
                    bhatPendingWeeklyString = 'Weeks of delinquent:' + bhatPendingWeeklyString.SubString(0,bhatPendingWeeklyString.length()-1);
                 }   
             
                 
                 htmlBody = htmlBody.replace('{!PendingWeeks}', bhatPendingWeeklyString );


             htmlBody = htmlBody.replace('{!FirstName}', rpt.FirstName);
             htmlBody = htmlBody.replace('{!LastName}', rpt.LastName);
             htmlBody = htmlBody.replace('{!LastReminderSentOn}', LastReminderSentOn);
             
             
             email.setHtmlBody(htmlBody) ;
             
            //String htmlBody = templateId90Days;
            //htmlBody = htmlBody.replace('{!BHAT_Activity_Reminder_Log__c.Email_For_30_Day_Sent_On__c}', rpt.LastReminderSentOn.format());
            //htmlBody = htmlBody.replace('{!BHAT_Activity_Reminder_Log__c.Email_For_60_Day_Sent_On__c}', rpt.LastReminderSentOn.format());
            //email.setHtmlBody(htmlBody);
           
         
             email.setToAddresses(new String[] {rpt.UserEmailId});
             
             email.setSaveAsActivity(false);
             email.setUseSignature(false);
             
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }

             
             messages.add(email);
             }
    
            return messages ;
    
    }
    
}