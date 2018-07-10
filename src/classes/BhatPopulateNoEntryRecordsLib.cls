public class BhatPopulateNoEntryRecordsLib
{
    

    public Static List<String> DeleteNoEntryRecords() 
    {

            Set<String> ownerIdWithStartDateSET = new Set<String>();
            List<String> InactiveUserList = new List<String>();
            
                BusinessDay bd = new BusinessDay();
                Integer DayInterval = 7;
                Date thisdate;
                // Get Start and End date from Custom Setting
                Common_Settings__c uhwCommentSettings = Common_Settings__c.getValues('UHWCommonSettings');
                                                
                // Get List with Hire Date and Term Date.   
                
                //List<User> UserList = [SELECT Id FROM User where Hire_Date__c > : uhwCommentSettings.BHAT_Update_End_Date__c AND ( Term_Date__c  = NULL OR  Term_Date__c >= : uhwCommentSettings.BHAT_Update_Start_Date__c)];
                List<User> UserList =   [SELECT Id, Hire_Date__c, Term_Date__c, IsActive, Name, Alias FROM User where ( Hire_Date__c < : uhwCommentSettings.BHAT_Update_End_Date__c OR Term_Date__c > : uhwCommentSettings.BHAT_Update_Start_Date__c)  AND ( Term_Date__c  = NULL OR  Term_Date__c >= : uhwCommentSettings.BHAT_Update_Start_Date__c)];
                
                List<Id> ownerIds = new List<Id>();
                for(User usr : UserList)
                {
                    
                    if ( ! usr.IsActive  )
                    {
                        InactiveUserList.add(usr.Name + '(' + usr.Alias + ')');
                        Continue; 
                    }
                    
                    ownerIds.add(usr.Id);
                }
                
                
                delete [Select id from BHAT_Activity_Weekly__c where  Status__c ='No Entry' AND owner.id IN :ownerIds ];
            
                return InactiveUserList;

    }
    
    public Static List<string> Populate(Boolean isUseCustomSetting) 
    {

                Set<String> ownerIdWithStartDateSET = new Set<String>();
                List<String> InactiveUserList = new List<String>();
             
                BusinessDay bd = new BusinessDay();
                Integer DayInterval = 7;
                Date thisdate;

                Date BHAT_Update_End_Date; 
                Date BHAT_Update_Start_Date;


                if (isUseCustomSetting)
                {
                    // Get Start and End date from Custom Setting
                    Common_Settings__c uhwCommentSettings = Common_Settings__c.getValues('UHWCommonSettings');
                    BHAT_Update_End_Date = uhwCommentSettings.BHAT_Update_End_Date__c;
                    BHAT_Update_Start_Date = uhwCommentSettings.BHAT_Update_Start_Date__c;
                }
                else
                {
                    BHAT_Update_End_Date = system.today();
                    BHAT_Update_Start_Date = system.today().AddDays(-8);
                }


   
                system.debug('Sun : BHAT_Update_Start_Date : '+ BHAT_Update_Start_Date);
                system.debug('Sun : BHAT_Update_End_Date : '+ BHAT_Update_End_Date );


                // Get List with Hire Date and Term Date.   
                
                List<User> UserList = [SELECT Id, Hire_Date__c, Term_Date__c, IsActive, Name, Alias FROM User where ( Hire_Date__c < : BHAT_Update_End_Date OR Term_Date__c > : BHAT_Update_Start_Date)  AND ( Term_Date__c  = NULL OR  Term_Date__c >= : BHAT_Update_Start_Date)];

                system.debug('Sun UserList:' + UserList);
                
                

                for(User usr:UserList)
                {
                    if ( ! usr.IsActive  )
                    {
                        InactiveUserList.add(usr.Name + '(' + usr.Alias + ')');
                        Continue; 
                    }
                    
                    
                    Date stDate ;
                    Date endDate ;
                    if (usr.Hire_Date__c > BHAT_Update_Start_Date && usr.Hire_Date__c < BHAT_Update_End_Date )
                    {
                        stDate = bd.getStartWeekData(usr.Hire_Date__c) ;
                    }
                    else
                    {
                        stDate = bd.getStartWeekData(BHAT_Update_Start_Date) ;
                    }

                    if (usr.Term_Date__c > BHAT_Update_Start_Date && usr.Term_Date__c < BHAT_Update_End_Date )
                    {
                        endDate = bd.getEndWeekData(usr.Term_Date__c);
                    }
                    else
                    {
                        endDate = bd.getEndWeekData(BHAT_Update_End_Date);
                    }


                    system.debug('start and end date' + stDate + ','+ endDate );
                    
                    
                    thisdate = stDate;
                    
                    do
                    {
                       ownerIdWithStartDateSET.add(usr.ID + '#_#' + String.valueOf(thisdate));
                       thisdate = thisdate.AddDays(DayInterval);
                    } while (thisdate <= endDate);

                    
                    
                }

                
                //List<WeeklyDate__c> WeeklyList = [select  OwnerIdWithStartDate__c from WeeklyDate__c ];
                //for(WeeklyDate__c week:WeeklyList){
                //  ownerIdWithStartDateSET.add(week.OwnerIdWithStartDate__c);
                //}

                    // Reduce one day from the start date so that it will pick some date as well.
                    Date stDate_cs;
                    Date endDate_cs;
                    stDate_cs  = bd.getStartWeekData(BHAT_Update_Start_Date); 
                    endDate_cs = bd.getEndWeekData(BHAT_Update_End_Date);
                    
                    stDate_cs  = stDate_cs.AddDays(-2);
                    endDate_cs = endDate_cs.AddDays(1);

                    system.debug('sun dates' + stDate_cs + ' ' + endDate_cs);


                Set<String> ownerIdWithStartDateAWSET = new Set<String>();
                List<BHAT_Activity_Weekly__c > BAWeeklyList = [Select OwnerIdWithStartDate__c from BHAT_Activity_Weekly__c where WeekStartDate__c >= :stDate_cs  AND WeekEndDate__c <= :endDate_cs ];
                
                system.debug('Sun BAWeeklyList.size():' + BAWeeklyList.size());
                for(BHAT_Activity_Weekly__c BAWkly : BAWeeklyList)
                {
                    ownerIdWithStartDateAWSET.add(BAWkly.OwnerIdWithStartDate__c);
                }
                
                
                system.debug('Sun : ownerIdWithStartDateSET : '+ ownerIdWithStartDateSET.size());
                system.debug('Sun : ownerIdWithStartDateAWSET : '+ ownerIdWithStartDateAWSET.size());
                
                system.debug('Sun : ownerIdWithStartDateSET : '+ ownerIdWithStartDateSET);
                system.debug('Sun : ownerIdWithStartDateAWSET : '+ ownerIdWithStartDateAWSET);

                
                boolean result = ownerIdWithStartDateSET.RemoveAll(ownerIdWithStartDateAWSET); 
                system.debug('Sun after removal: ownerIdWithStartDateSET : '+ ownerIdWithStartDateSET.size());
                
                //List<BHAT_Activity_Weekly__c > BAWeeklyList = [Select id from BHAT_Activity_Weekly__c where OwnerIdWithStartDate__c  NOT in : ownerIdWithStartDateSET];

                List<BHAT_Activity_Weekly__c > BAWeeklyListNew = new List<BHAT_Activity_Weekly__c >();

                for (string awItem : ownerIdWithStartDateSET) {
                    
                    string[] awItemSplitted = awItem.split('\\#_#');
                    
                    system.debug(awItemSplitted);
                    
                    if (awItemSplitted.size()> 1)
                    {
                        BHAT_Activity_Weekly__c BAWeekItem = new BHAT_Activity_Weekly__c();
                        BAWeekItem.Status__c ='No Entry';
                        BAWeekItem.ownerId = awItemSplitted[0];
                        BAWeekItem.WeekStartDate__c =  Date.valueOf(awItemSplitted[1]);
                        BAWeekItem.WeekEndDate__c = BAWeekItem.WeekStartDate__c.addDays(6);
                        BAWeekItem.Name = bd.getMonthStart(BAWeekItem.WeekStartDate__c) + '-' + bd.getMonthEnd(BAWeekItem.WeekEndDate__c);
                        BAWeeklyListNew.add(BAWeekItem);
                    }
                    
                    
                }

                system.debug('BAWeeklyListNew:' + BAWeeklyListNew);

                insert BAWeeklyListNew;
                
                //removeAll(Set<Object>)

        
                // List<BHAT_Activity_Daily__c> bhatDailyLlist= [SELECT Activity_Date__c FROM  BHAT_Activity_Daily__c 
                //WHERE Owner.IsActive = TRUE  LIMIT 4000];

                return InactiveUserList;
    }

    
    
}