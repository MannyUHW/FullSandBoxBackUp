global with sharing class bhatindexcontroller {

    public class MyException extends Exception {}

    public BhatGlobalData bhatGlobalData {get;set;}
    public String ThisWeekStartDate  {get;set;}
    public Date TodayDate  {get;set;}
    date d = system.today();
    public static List<BHAT_Activity_Code__c> g_AllActivityCodelist = new List<BHAT_Activity_Code__c>();
    public Static Decimal default_Hour{get;set;}
    public static string BhatSubCategoryNoneID;
    public static string BhatSubCategoryLunchID;
    Public static list<BHAT_Activity__c> CopiedActivity_List = new list<BHAT_Activity__c>();
    Public static list<BHAT_Activity__c> NewActivity_List = new list<BHAT_Activity__c>();
    Public static list<BHAT_Activity__c> UpdateActivity_List = new list<BHAT_Activity__c>();
    Public Static List<ActiveEntryDate__c>  ActiveDateOfEntry_List{get;set;}

    public bhatindexcontroller()
    {
        ThisWeekStartDate = '10/21/2013';
        TodayDate = System.today();
        BhatSubCategoryNoneID ='';

        bhatGlobalData = new BhatGlobalData();
    }

    public static List<BHATActivityCodeDto> GetAllActivityCodeList_NEW()  {
        List<BHAT_Activity_Code__c> activitycodeList_New = new List<BHAT_Activity_Code__c>();

        Date today;
        today = date.today();

        activitycodeList_New = [SELECT Id,name,Activity_Code_Category__c, Long_Description__c, Short_Description__c ,
        (SELECT id,name,Activity_Note_Description__c,BHAT_Activity_Code__c,SortOrder__c
         FROM BHAT_Activity_Notes__r
         WHERE Valid_From_Date__c <= :today And Valid_Until_Date__c >= :today
         ORDER BY SortOrder__c,name ASC) FROM BHAT_Activity_Code__c where id!=null ORDER BY name ];


        BHAT_Activity_Note__c bhatActivityCodeNone = new BHAT_Activity_Note__c();
        bhatActivityCodeNone.id=BhatSubCategoryNoneID;
        bhatActivityCodeNone.name ='0';
        bhatActivityCodeNone.Activity_Note_Description__c ='None';

        List<BHATActivityCodeDto> ActivityDtoList = new List<BHATActivityCodeDto>();

        for (BHAT_Activity_Code__c acode: activitycodeList_New) {
            BHATActivityCodeDto activity = new BHATActivityCodeDto();
            activity.Id                  = acode.Id ;
            activity.name                = acode.Name ;
            activity.BHAT_Activity_Code  = acode.name ;
            activity.Short_Description   = acode.Short_Description__c;
            activity.SortSequence        = 1;

          List<BHAT_Activity_Note__c> bhatActivityNotesList = new List<BHAT_Activity_Note__c>();
          if (acode.BHAT_Activity_Notes__r != NULL)
              activity.BHATActivityNotesList =  acode.BHAT_Activity_Notes__r;
          else
            activity.BHATActivityNotesList =  bhatActivityNotesList ;

          if (activity.BHATActivityNotesList.size() > 0)
             activity.BHATActivityNotesList.add(0, bhatActivityCodeNone);
          else
              activity.BHATActivityNotesList.add( bhatActivityCodeNone);

           ActivityDtoList.add(activity);
        }
        return  ActivityDtoList ;
    }

    public static List<BHAT_Activity_Code__c> GetAllActivityCodeList() {
        List<BHAT_Activity_Code__c> activitycodeList = new List<BHAT_Activity_Code__c>();
        activitycodeList = [ select id,name,Activity_Code_Category__c, Long_Description__c, Short_Description__c
                             from BHAT_Activity_Code__c where id!=null order by name];
     return activitycodeList;
    }

     /*******Start of Delete button functionality**************/
    @RemoteAction
    global static string DeleteSelectedActivities_OLD(String activitiesJSON)   {
      List<BhatItem> ActivityID_List= (List<BhatItem>) JSON.deserialize(activitiesJSON, List<BhatItem>.class);
      List<String> ActivityID_String = new  List<String>();

      for(integer i=0; i< ActivityID_List.size() ; i++) {
           ActivityID_String.add(ActivityID_List[i].ItemValue);
      }

       List<Bhat_Activity__c> ActivityList = [Select id,Activity_Date__c from Bhat_Activity__c where id IN : ActivityID_String ];
       List<Bhat_Activity__c> ActivityList_ToDelete = new List<Bhat_Activity__c>();

       String result;

       if(ActivityList.size() > 0 && !isNotEditable(ActivityList[0].Activity_Date__c)) {
           delete ActivityList;
           result = 'Success';
       }
       else{
           result = 'Record on this date has been closed out. Please Contact HR if you have questions.';
       }
       return result;
    }

   /*******End of Delete button functionality**************/

    // VF Remoting method.
    // Double the string value passed, where double means:
    //   if integer, multiple reslt by 2.
    //   if exact string "exception", throw an exception event (to demonstrate an exception in VF Remoting).
    //   if any other string, double each character.
    @RemoteAction
    global static  string valueDoubler(String inputValue) {
        String result = '';

        if (inputValue == 'exception')
            throw new MyException('Forced Exception');

        if (inputValue.isNumeric())
            result = String.valueOf(Integer.valueOf(inputValue) * 2);
        else
            for (Integer i=0; i<inputValue.length(); i++)
                result += inputValue.mid(i,1) + inputValue.mid(i,1);

        return result;
    }

    @RemoteAction
    global static Account getAccountCity(String actName){
        try{
                return [select BillingStreet,BillingCity from Account where name = :actName][0];
       }
        catch(Exception e){
                return null;
        }
    }

    @RemoteAction
    global static string GetBhatGlobalData(){

         BhatGlobalData bhatGlobalDataObj = new BhatGlobalData();
         bhatGlobalDataObj.BHATActivityCodeList = GetAllActivityCodeList_NEW();

     return JSON.serialize(bhatGlobalDataObj);
    }


    @RemoteAction
    global static string GetAllActivityCodeListForUI()
    {
       return JSON.serialize(GetAllActivityCodeList());
    }

    @RemoteAction
    global static string getActivityList(date startDate)
    {
        startDate = getStartWeekData(startDate);
        startDate = date.newInstance(startDate.year(), startDate.month(),startDate.day());

        ActivityDailyHours activityDailyHours = new ActivityDailyHours();
        List < Activitywrap > lstwrap = new List < Activitywrap > ();
        Decimal totalHoursReported = 0;
        Integer noOfDays = 6;

        try {
            List < BHAT_Activity_Daily__c> lstacc = [SELECT Activity_Date__c, Daily_Hours_Spent__c ,Daily_Hours_Total__c, Status__c
                                        FROM BHAT_Activity_Daily__c WHERE ownerId=: UserInfo.getUserId()
                                            AND Activity_Date__c <= :startDate.addDays(noOfDays)
                                            AND Activity_Date__c >= :startDate  ORDER BY Activity_Date__c ASC  ];
            Integer daycounter = -1;
            date runningDate = startDate;
            for (BHAT_Activity_Daily__c a: lstacc)
            {

                    Activitywrap awrap = new Activitywrap ();
                    awrap.ActivityDate = a.Activity_Date__c;

                    // format function is not suppoed with date type, hence converting into datetime.
                    DateTime dtConverted = Datetime.newInstance(a.Activity_Date__c.year(), a.Activity_Date__c.month(),a.Activity_Date__c.day(),0,0,0);
                    awrap.ActivityDayText= dtConverted.format('EEEE') + ' ' + dtConverted.format('MMM d,  yyyy');
                    awrap.DailyHoursSpent = a.Daily_Hours_Spent__c;
                    awrap.DailyHoursTotal = a.Daily_Hours_Total__c;

                    awrap.Status= a.Status__c;
                    if (a.Daily_Hours_Spent__c != NULL)
                    {
                        totalHoursReported = totalHoursReported + a.Daily_Hours_Total__c;
                    }
                    lstwrap.add(awrap);
            }

           //loop through the list and add if a particular date is not exists.
            for(Integer a = 0; a <= noOfDays  ; a++)
            {
                runningDate = startDate.addDays(a);
                Boolean foundFlag  ;
                for (Activitywrap  aw: lstwrap)
                {
                   if (runningDate.format() == aw.ActivityDate.format())
                   {
                     foundFlag  = true;
                   }
                }

                if (foundFlag != true  )
                {
                    Activitywrap awrap = new Activitywrap ();
                    awrap.ActivityDate = runningDate;
                    awrap.Status = 'No Entry';
                    DateTime dtConverted = Datetime.newInstance(runningDate.year(), runningDate.month(),runningDate.day(),0,0,0);
                    awrap.ActivityDayText= dtConverted.format('EEEE') + ' ' + dtConverted.format('MMM d,  yyyy');
                    lstwrap.add(awrap);
                }
            }


           // Add the activies to a activity daily Object
           activityDailyHours.ActivitiyDaily = lstwrap;
           activityDailyHours.TotalHoursExpected = 40.00;
           activityDailyHours.TotalHoursReported = totalHoursReported;
           activityDailyHours.WeekStartDay = getStartWeekData(system.today());
           activityDailyHours.UserFullName = UserInfo.getName();

        }
        catch(Exception e) {  }
        return JSON.serialize(activityDailyHours);
     }


 //Get Summary
    @RemoteAction
   global static string GetActivitySummary(Date StartDate)
    {
        startDate = getStartWeekData(startDate);
        startDate = date.newInstance(startDate.year(), startDate.month(),startDate.day());
        Integer noOfWeeks = 8;

        List<ActivityWeeklyDto> ActivityWeeklyDtoList = new List<ActivityWeeklyDto>();
        List<Bhat_Activity_Weekly__c> weeklyList = new List<Bhat_Activity_Weekly__c>();

         weeklyList = [select id, name, Status__c, WeekEndDate__c, WeeklyTotalHours__c,
                            Weekly_Hours_Total__c ,
                            WeekStartDate__c from BHAT_Activity_Weekly__c
                            where ownerId=: UserInfo.getUserId()
                            AND WeekStartDate__c <= :StartDate
                            AND WeekStartDate__c > :StartDate.addDays(-(noOfWeeks * 7))
                            ORDER BY WeekStartDate__c DESC  ];

           Integer weeklyListArrayCount = 0;

           for(Integer i = 0 ; i < noOfWeeks; i++)
           {
                Date d = StartDate - ( i * 7);

                if( weeklyListArrayCount  < WeeklyList.size() && weeklyList[weeklyListArrayCount].WeekStartDate__c.format() == d.format()  )
                {
                    ActivityWeeklyDto activitywkDto = new ActivityWeeklyDto();
                    activitywkDto.WeekName = weeklyList[weeklyListArrayCount ].Name;
                    activitywkDto.WeekStartDate = weeklyList[weeklyListArrayCount ].WeekStartDate__c ;
                    activitywkDto.WeekEndDate = weeklyList[weeklyListArrayCount ].WeekEndDate__c ;
                    activitywkDto.WeeklyTotalHours = weeklyList[weeklyListArrayCount ].WeeklyTotalHours__c;
                    activitywkDto.WeeklyHoursTotal =   weeklyList[weeklyListArrayCount ].Weekly_Hours_Total__c;
                    activitywkDto.Status = weeklyList[weeklyListArrayCount ].Status__c;

                   ActivityWeeklyDtoList.add(activitywkDto);
                   weeklyListArrayCount = weeklyListArrayCount + 1;
                }
                else
                {
                    BusinessDay b = new BusinessDay();
                    Date endd = b.getEndWeekData(d);
                    String s1 = b.getMonthStart(d);
                    String s2 = b.getMonthStart(endd );

                    String weekname = s1 + '-' + s2;

                    ActivityWeeklyDto activitywkDto = new ActivityWeeklyDto();

                    activitywkDto.WeekName = WeekName;
                    activitywkDto.WeekStartDate = d ;
                    activitywkDto.WeekEndDate = endd ;
                    activitywkDto.WeeklyTotalHours = 0;
                    activitywkDto.WeeklyHoursTotal = 0;

                    ActivityWeeklyDtoList.add(activitywkDto);
                }
         }
        return  JSON.serialize(ActivityWeeklyDtoList);
    }


 /**********STARTING of Code for CopyYesterDay Button functionality************/
 @RemoteAction
   global static string GetBHATPreviousActivityByDate(String stringDate)
   {
       Date tempDate = Date.Parse(stringDate);
       Date dt = Date.valueOf(tempDate);
       BhatActivityDailyDataDto bhatActivityDailyDataDto = new BhatActivityDailyDataDto();

        List<BHAT_Activity_Daily__c> bhatDailyPreviousList = [Select id,ownerId, Name, Activity_Date__c, status__c from BHAT_Activity_Daily__c
                                                                where OwnerId =: userinfo.getUserId() and Activity_Date__c <: dt
                                                                and status__c != 'No Entry' ORDER BY Activity_Date__c DESC limit 1];
       if( bhatDailyPreviousList.size() > 0)
       {
           bhatActivityDailyDataDto = GetBHATActivityDtoByDate(bhatDailyPreviousList[0].Activity_Date__c);
          //To change the date back to the current date reffered for saving purpose
           BhatActivityDailyDataDto.activityDate = dt;
           BhatActivityDailyDataDto.IsCopyPrevious = true;
       }
       else{
            BhatActivityDailyDataDto.activityDate = dt;
            BhatActivityDailyDataDto.IsCopyPrevious = false;
       }
     return JSON.serialize(bhatActivityDailyDataDto);
   }
 /*********ENDING of Code for CopyYesterDay Button functionality*************/




/*********STARTING of displaying the data of activities that are Not-created/Created with the code********/
  @RemoteAction
   global static string GetBHATActivityByDate(String stringDate)
   {
       Date tempDate = Date.Parse(stringDate);
       Date dt = Date.valueOf(tempDate);
       BhatActivityDailyDataDto  bhatActivityDailyDataDto = GetBHATActivityDtoByDate(dt);

       return  JSON.serialize(bhatActivityDailyDataDto);
   }

/*****ENDING of displaying the data of activities that are not created with the code********/


/*****START of displaying the data of activities that are not created with the code********/
public static BhatActivityDailyDataDto  GetBHATActivityDtoByDate(Date dt)
{
      dt = date.newInstance(dt.year(), dt.month(),dt.day());
      BhatActivityDailyDataDto bhatActivityDailyDataDto = new BhatActivityDailyDataDto();
      bhatActivityDailyDataDto.ActivityDate =  Date.ValueOf(dt);

      boolean WeeklyReviewStatus = false;

       date weekStartDate = getStartWeekData(dt);

       List<BHAT_Activity_Weekly__c>  weeklyList = [select id, name, Review_Status__c from BHAT_Activity_Weekly__c
                            where ownerId=: UserInfo.getUserId()
                            AND WeekStartDate__c = :weekStartDate
                            ORDER BY WeekStartDate__c DESC  ];
        system.debug('weekStartDate:' + weekStartDate);

        if (weeklyList.size()> 0 )
        {
            system.debug('weekStartDate:' + weekStartDate);
            system.debug('weeklyList[0].Review_Status__c:' + weeklyList[0].Review_Status__c);
            WeeklyReviewStatus = (weeklyList[0].Review_Status__c == 'Approved');

        }

      //bhatActivityDailyDataDto.IsOPEIUGraveYard =  true;


      Integer uniqueid = 0;

        //Set Lunch Id
         List<BHAT_Activity_Note__c > bhatctivityNotesList =  [select Id, name from BHAT_Activity_Note__c where name='Lunch'];
         if (bhatctivityNotesList.size() > 0)
         {
            BhatSubCategoryLunchID= bhatctivityNotesList[0].Id;
         }


        List<BHAT_Activity_Daily__c> bhatDailyList  = [Select id, Name, Activity_Date__c,BHAT_Activity_Weekly__c,OPEIU_Graveyard_Swing__c,
                                                       Daily_Hours_Spent__c, Work_Hour_End_Time__c, Work_Hour_Start_Time__c
                                                       from BHAT_Activity_Daily__c where  ownerId =: UserInfo.getUserId()
                                                       and Activity_Date__c =: Date.ValueOf(dt) limit 1];

        User u = [Select id,name, Work_End_Time__c, Work_Start_Time__c, Hourly_Employee__c,
                 Non_Exempt_Employee__c from user where id =: UserInfo.getUserId() limit 1];

         // Set Hourly Employee
         if (u.Non_Exempt_Employee__c == false && u.Hourly_Employee__c == false)
         {
             bhatActivityDailyDataDto.IsHourlyEmployee = false;
         }
         else
         {
             bhatActivityDailyDataDto.IsHourlyEmployee = true;
         }

       if (u.Work_Start_Time__c != null && u.Work_End_Time__c != null)
       {
           bhatActivityDailyDataDto.WorkHourStartTime =  u.Work_Start_Time__c;
           bhatActivityDailyDataDto.WorkHourEndTime =  u.Work_End_Time__c;
       }
       else
       {
           // update all the 4 field in the user object.
           u.Work_Start_Time__c = '09:00 AM';
           u.Work_End_Time__c = '05:30 PM';

           update u;

           bhatActivityDailyDataDto.WorkHourStartTime =  '09:00 AM';
           bhatActivityDailyDataDto.WorkHourEndTime =  '05:30 PM';
       }

     if(bhatDailyList.size() > 0)
     {
             bhatActivityDailyDataDto.IsOPEIUGraveYard =  bhatDailyList[0].OPEIU_Graveyard_Swing__c;
             if( bhatDailyList[0].Work_Hour_Start_Time__c != null && bhatDailyList[0].Work_Hour_End_Time__c != null)
             {
                   bhatActivityDailyDataDto.WorkHourStartTime =  bhatDailyList[0].Work_Hour_Start_Time__c;
                   bhatActivityDailyDataDto.WorkHourEndTime =  bhatDailyList[0].Work_Hour_End_Time__c;
                   bhatActivityDailyDataDto.DailyTotalHours =  bhatDailyList[0].Daily_Hours_Spent__c;
             }
     }


     List<ActivityDto> ActivityDtoList = new List<ActivityDto>();
     List<Bhat_Activity_code__c> codes = new List<Bhat_Activity_code__c>();

     List<BHAT_Activity__c>  BHATs =   [ Select id,name,Activity_Date__c, BHAT_Activity_Code__c,BHAT_Activity_Note__r.name,
                                           BHAT_Activity_Code__r.Name,BHAT_Activity_Code__r.Short_Description__c,Hours_Spent__c,
                                           BHAT_Activity_Code__r.Long_Description__c, BHAT_Activity_Daily__c,
                                           BHAT_Activity_Note_Other__c,  BHAT_Activity_Note__c from BHAT_Activity__c where
                                           ownerId =: userinfo.getUserID() and Activity_Date__c =: Date.ValueOf(dt) ORDER BY name ASC ];

      /*******START of Checking the U & K alone or other activity existance***************/
         Boolean IsOtherActivityWithHoursExists = false;
         for(integer k=0; k < BHATs.size(); k++)
         {
             if(BHATs[k].BHAT_Activity_Code__r.Name != 'u' &&  BHATs[k].BHAT_Activity_Code__r.Name  != 'k' && BHATs[k].Hours_Spent__c  > 0)
             {
                IsOtherActivityWithHoursExists = true;
                break;
             }
         }

         if(IsOtherActivityWithHoursExists == false)
         {
            default_Hour = 0.5;
         }
         else if(IsOtherActivityWithHoursExists == true)
         {
            default_hour = 0;
         }
      /*******END of Checking the U & K alone exists or not***************/

       set<string> codeIDset = new set<string>();
       g_AllActivityCodelist = GetAllActivityCodeList();

       for(BHAT_Activity__c bh : BHATs )
       {
          codeIDset.add(bh.Bhat_Activity_Code__c);
                    ActivityDto activity = new ActivityDto();
                    activity.ActivityID = bh.id;
                    activity.ActivityCodeID = bh.BHAT_Activity_Code__c;
                    activity.ActivityCode = bh.BHAT_Activity_Code__r.Name ;
                    activity.ShortDescription = bh.BHAT_Activity_Code__r.Short_Description__c;
                    activity.LongDescription = bh.BHAT_Activity_Code__r.Long_Description__c;
                    //activity.WeeklyReviewStatus = WeeklyReviewStatus;


                    if (bh.BHAT_Activity_Note__c != null)
                    {
                         activity.SubCategoryID = bh.BHAT_Activity_Note__c;
                    }
                    else
                    {
                        activity.SubCategoryID = '';
                    }

                    activity.SubCategory = bh.BHAT_Activity_Note__r.name;
                    activity.Description = bh.BHAT_Activity_Note_Other__c;
                    activity.Hours =  bh.Hours_Spent__c;
                    activity.IsDelete = false;
                    activity.SortSequence = 1;
                    activity.UniqueId = uniqueid++;

                    if( ( (activity.ActivityCode).toLowerCase() == 'u' ||  (activity.ActivityCode).toLowerCase() == 'k' || (activity.ActivityCode).toLowerCase() == 'o') && bhatActivityDailyDataDto.IsHourlyEmployee == FALSE )
                    {
                        activity.IsNonHourlyEmployeeAndDefaultACode = true;
                        activity.Hours = 0;
                    }
                    else
                    {
                        activity.IsNonHourlyEmployeeAndDefaultACode = false;
                    }

                    ActivityDtoList.add(activity);

       }
          for(Bhat_Activity_code__c code1 : g_AllActivityCodelist)
          {
             if(!codeIDset.contains(code1.id))
             {
                   ActivityDto activity = new ActivityDto();

                    activity.ActivityID = null;
                    activity.ActivityCode = code1.name ;
                    activity.ActivityCodeID = code1.id ;
                    activity.ShortDescription = code1.Short_Description__c;
                    activity.LongDescription = code1.Long_Description__c;
                    //activity.WeeklyReviewStatus = WeeklyReviewStatus;
                    activity.SubCategoryID = BhatSubCategoryNoneID;
                    activity.SubCategory = null;
                    activity.Description = null;
                    activity.IsDelete = false;
                    activity.SortSequence = 1;
                    activity.UniqueId = uniqueid++;

                    // if hourly set 0.5 for unpaid and paid lunch
                    if( ( (code1.name).toLowerCase() == 'u' ||  (code1.name).toLowerCase() == 'k' ) && bhatActivityDailyDataDto.IsHourlyEmployee )
                    {
                        activity.Hours =  default_Hour;
                        activity.IsNonHourlyEmployeeAndDefaultACode = false;

                        if ((code1.name).toLowerCase() == 'u')
                        {
                            activity.SubCategoryID= BhatSubCategoryLunchID;
                        }

                    }
                    else if( ( (code1.name).toLowerCase() == 'u' ||  (code1.name).toLowerCase() == 'k'|| (code1.name).toLowerCase() == 'o' ) && bhatActivityDailyDataDto.IsHourlyEmployee == FALSE )
                    {
                        activity.Hours =  0;
                        activity.IsNonHourlyEmployeeAndDefaultACode = true;
                    }
                    else
                    {
                        activity.Hours =  0;
                        activity.IsNonHourlyEmployeeAndDefaultACode = false;
                    }
                    ActivityDtoList.add(activity);
             }
         }

        bhatActivityDailyDataDto.ActivityDtoList = ActivityDtoList;

        bhatActivityDailyDataDto.WeeklyReviewStatus = WeeklyReviewStatus;


       return  bhatActivityDailyDataDto;
}

 /*****ENDING of displaying the data of activities that are not created with the code********/


 /*******Checking the active entry date***********/

     public static boolean isNotEditable(Date currentDate )
     {
        ActiveDateOfEntry_List = [select name, StartDate__c from ActiveEntryDate__c  limit 1];

       if(  ActiveDateOfEntry_List.size() > 0)
       {
            if(currentDate < ActiveDateOfEntry_List[0].StartDate__c)
            {
                return true;
            }
            else
            {
                return false;
            }
       }
       else{
           return false;
       }
     }

 /*******End of Checking the active entry date***********/



/********************STARTING of Update/Delete/Insert Bhat Activity Based on some condition************************/
@RemoteAction
global static string UpdateBhatActivity(String activitiesJSON)
{
      system.debug('activty jason...............'+activitiesJSON);
      bhatActivityDailyDataDto ActivityDeserialized = (bhatActivityDailyDataDto) JSON.deserialize(activitiesJSON, bhatActivityDailyDataDto.class);
      Date dt = Date.Today(); //This is for current date
      String Result;

   //   ActiveDateOfEntry = [select name, StartDate__c from ActiveEntryDate__c  limit 1];

    //  System.Debug('Active date from cutom setting...!'+ActiveDateOfEntry.StartDate__c +'.....edited date is.....'+ActivityDeserialized.ActivityDate);


     /*******Checking the U & K alone exists or not***************/
         Boolean IsOtherActivityWithHoursExists = false;
         for(integer k=0; k < ActivityDeserialized.ActivityDtoList.size(); k++)
         {
             if(ActivityDeserialized.ActivityDtoList[k].ActivityCode != 'u' &&  ActivityDeserialized.ActivityDtoList[k].ActivityCode != 'k' && ActivityDeserialized.ActivityDtoList[k].hours > 0)
             {
                IsOtherActivityWithHoursExists = true;
                break;
             }
         }

         // Set Sub Category None with 'null' and make subcategory id as null for empty value while saving into record
         for(integer k=0; k < ActivityDeserialized.ActivityDtoList.size(); k++)
         {
             if(ActivityDeserialized.ActivityDtoList[k].ActivityCodeID == BhatSubCategoryNoneID  )
             {
                    ActivityDeserialized.ActivityDtoList[k].ActivityCodeID = null;
             }
             if(ActivityDeserialized.ActivityDtoList[k].SubCategoryID == ''  )
             {
                    ActivityDeserialized.ActivityDtoList[k].SubCategoryID = null;
             }

         }

        if(isNotEditable(ActivityDeserialized.ActivityDate))
        {
            return 'Record on this date has been closed out. Please Contact HR if you have questions.';
        }
        else if (!IsOtherActivityWithHoursExists)
         {
            Result = 'No Data';
            for(integer j=0; j < ActivityDeserialized.ActivityDtoList.size(); j++)
            {
               if((ActivityDeserialized.ActivityDtoList[j].ActivityCode == 'u' || ActivityDeserialized.ActivityDtoList[j].ActivityCode == 'k') &&  ActivityDeserialized.ActivityDtoList[j].hours > 0)
               {
                   ActivityDeserialized.ActivityDtoList[j].hours = 0;
               }
            }
         }
         else{
              Result = 'Success';
         }


         if(ActivityDeserialized.IsOPEIUGraveYard == null)
         {
             ActivityDeserialized.IsOPEIUGraveYard = false;
         }


     /*******END of checking U & K alone exists or not*******/


    // if IsCopyPrevious button is clicked, Delete the existing records on that date and insert the copied data in activity

      if(!isNotEditable(ActivityDeserialized.ActivityDate))
      {
         if (ActivityDeserialized.IsCopyPrevious == TRUE)
         {
            // Delete all the records for the given date.
            List<BHAT_Activity__c> oldActivties = [ Select id,Activity_Date__c,ownerID from BHAT_Activity__c
                                                    where ownerId =: userinfo.getUserID()  and
                                                    Activity_Date__c =: Date.valueOf(ActivityDeserialized.ActivityDate)];
            if(oldActivties.size() > 0){
               for(BHAT_Activity__c bhact :  oldActivties){
                    delete bhact;
               }
            }

           //loop throught the activities and Insert all the copied records.
            for(integer i=0; i < ActivityDeserialized.ActivityDtoList.size() ; i++)
            {
                  if(ActivityDeserialized.ActivityDtoList[i].Hours != 0)
                  {
                       BHAT_Activity__c CopiedActivity = new BHAT_Activity__c();
                       CopiedActivity.Activity_Date__c = Date.valueOf(ActivityDeserialized.ActivityDate);
                       CopiedActivity.BHAT_Activity_Code__c =  ActivityDeserialized.ActivityDtoList[i].ActivityCodeID ;
                       CopiedActivity.BHAT_Activity_Note__c =  ActivityDeserialized.ActivityDtoList[i].SubCategoryID ;
                       CopiedActivity.BHAT_Activity_Note_Other__c =  ActivityDeserialized.ActivityDtoList[i].Description;
                       CopiedActivity.Hours_Spent__c =  ActivityDeserialized.ActivityDtoList[i].Hours;

                         CopiedActivity_List.add(CopiedActivity);

                  }
             }
             if(CopiedActivity_List.size()>0)
             insert CopiedActivity_List;
         }

          else {
              for(integer i=0; i < ActivityDeserialized.ActivityDtoList.size() ; i++)
              {
                  //Checking for activty id is not null to loop through for existing records
                  if(ActivityDeserialized.ActivityDtoList[i].ActivityID != null){

                       List<BHAT_Activity__c> ActivityList   =   [ Select id,Activity_Date__c,BHAT_Activity_Code__c,
                                                                   BHAT_Activity_Note__c,BHAT_Activity_Note_Other__c,
                                                                   Hours_Spent__c from BHAT_Activity__c where
                                                                   ownerId =: userinfo.getUserID() and
                                                                   id =: ActivityDeserialized.ActivityDtoList[i].ActivityID];
                       if(ActivityList.size() > 0)
                       {
                          if(ActivityDeserialized.ActivityDtoList[i].Hours != 0)
                          {
                             ActivityList[0].BHAT_Activity_Code__c =  ActivityDeserialized.ActivityDtoList[i].ActivityCodeID ;
                             ActivityList[0].BHAT_Activity_Note__c =  ActivityDeserialized.ActivityDtoList[i].SubCategoryID ;
                             ActivityList[0].BHAT_Activity_Note_Other__c =  ActivityDeserialized.ActivityDtoList[i].Description;
                             ActivityList[0].Hours_Spent__c =  ActivityDeserialized.ActivityDtoList[i].Hours;
                             UpdateActivity_List.add(ActivityList[0]);

                           }
                           else if(ActivityDeserialized.ActivityDtoList[i].Hours == 0   ){
                               delete ActivityList[0];
                           }
                        }
                     }
                     //If activity Id is null the display the code with null values
                      else {
                            if(ActivityDeserialized.ActivityDtoList[i].Hours != 0)
                            {
                              BHAT_Activity__c NewBhatActivity = new BHAT_Activity__c();
                                 NewBhatActivity.Activity_Date__c = Date.valueOf(ActivityDeserialized.ActivityDate);
                                 NewBhatActivity.BHAT_Activity_Code__c =  ActivityDeserialized.ActivityDtoList[i].ActivityCodeID ;
                                 NewBhatActivity.BHAT_Activity_Note__c =  ActivityDeserialized.ActivityDtoList[i].SubCategoryID ;
                                 NewBhatActivity.BHAT_Activity_Note_Other__c =  ActivityDeserialized.ActivityDtoList[i].Description;
                                 NewBhatActivity.Hours_Spent__c =  ActivityDeserialized.ActivityDtoList[i].Hours;

                             //System.debug('This is the current data to insert : ------------>>>>'+ NewBhatActivity.BHAT_Activity_Code__c );
                                NewActivity_List.add(NewBhatActivity);

                            }
                      }
              }
              if(UpdateActivity_List.size()>0)
              update UpdateActivity_List;

              if(NewActivity_List.size()>0)
              insert NewActivity_List;

          } //end of else part for copy previous is not true

     // Update Bhat Activity Daily with Start end End date
     list<BHAT_Activity_Daily__c>  BHATActivityDailylist  = [SELECT Work_Hour_End_Time__c, Work_Hour_Start_Time__c,OPEIU_Graveyard_Swing__c,
                                                             MinutesWorked__c,HoursWorked__c FROM BHAT_Activity_Daily__c
                                                             WHERE ownerId=: UserInfo.getUserId() AND
                                                             Activity_Date__c =: Date.valueOf(ActivityDeserialized.ActivityDate)
                                                             LIMIT 1  ];

     if (BHATActivityDailylist.size() > 0)
     {
         BHAT_Activity_Daily__c BHATActivityDaily   = BHATActivityDailylist.get(0);

       if ( BHATActivityDaily.Work_Hour_Start_Time__c != ActivityDeserialized.WorkHourStartTime ||
            BHATActivityDaily.Work_Hour_End_Time__c != ActivityDeserialized.WorkHourEndTime ||
            BHATActivityDaily.HoursWorked__c != ActivityDeserialized.HoursWorked ||
            BHATActivityDaily.MinutesWorked__c !=  ActivityDeserialized.MinutesWorked ||
            BHATActivityDaily.OPEIU_Graveyard_Swing__c != ActivityDeserialized.IsOPEIUGraveYard  )
       {
         BHATActivityDaily.Work_Hour_Start_Time__c = ActivityDeserialized.WorkHourStartTime;
         BHATActivityDaily.Work_Hour_End_Time__c = ActivityDeserialized.WorkHourEndTime;
         BHATActivityDaily.HoursWorked__c = ActivityDeserialized.HoursWorked;
         BHATActivityDaily.MinutesWorked__c =  ActivityDeserialized.MinutesWorked;
         BHATActivityDaily.OPEIU_Graveyard_Swing__c = ActivityDeserialized.IsOPEIUGraveYard;

         update BHATActivityDaily;
       }
     }
    }
    else{
        Result = 'Record on this date has been closed out. Please Contact HR if you have questions.';
    }

   return Result;
}
/********************ENDING of Update/Delete/Insert Bhat Activity Based on some condition************************/


   @RemoteAction
   global static string GetBHATActivityLookupData()
   {
        //BhatActivityLookupDataDto bhatActivityLookupDataDto = new BhatActivityLookupDataDto();
        List<BHATActivityCodeDto> bhatActivityCodeList =  new List<BHATActivityCodeDto>();

        List<BHAT_Activity_Code__c> activitydcode= [select id,name, Short_Description__c,
                Activity_Code_Category__c from BHAT_Activity_Code__c where id!=null order by name ];

         Date today;
         today = date.today();
            
         for(integer i=0;i<activitydcode.size();i++)
         {
                 BHATActivityCodeDto  bhatActivityCodeDto = new BHATActivityCodeDto();
                 bhatActivityCodeDto.id = activitydcode[i].id;
                 bhatActivityCodeDto.name = activitydcode[i].name;
                 //bhatActivityCodeDto.BHAT_Activity_Code =
                 bhatActivityCodeDto.Activity_Code_Category = activitydcode[i].Activity_Code_Category__c;
                 bhatActivityCodeDto.Short_Description = activitydcode[i].Short_Description__c;

                 List<BHAT_Activity_Note__c> bhatActivityNotesList = new List<BHAT_Activity_Note__c>();

                 bhatActivityNotesList =[select id,name,Activity_Note_Description__c,BHAT_Activity_Code__c from BHAT_Activity_Note__c where BHAT_Activity_Code__c = :activitydcode[i].id And Valid_From_Date__c <= :today And Valid_Until_Date__c >= :today];

                bhatActivityCodeDto.BHATActivityNotesList = bhatActivityNotesList;
                bhatActivityCodeList.add(bhatActivityCodeDto);
          }
      return  JSON.serialize(bhatActivityCodeList );
     }


   public class BhatActivityLookupDataDto
   {
        public List<BHATActivityCodeDto> BHATActivityCodeList;
   }



   public class BhatActivityDailyDataDto
   {
        public List<ActivityDto> ActivityDtoList;
        public Date ActivityDate;
        public String WorkHourStartTime;
        public String WorkHourEndTime;
        public Decimal DailyTotalHours;
        public Boolean IsHourlyEmployee;
        public Boolean IsNonExemptEmployee;
        public Boolean IsOPEIUGraveYard;
        public Boolean IsCopyPrevious;
        public Integer HoursWorked;
        public Integer MinutesWorked;
        public Boolean WeeklyReviewStatus;
   }

     public class BHATActivityCodeDto {

        public string Id;
        public string name;
        public string BHAT_Activity_Code;
        public string Activity_Code_Category;
        public string Short_Description;
        public Integer SortSequence ;
        public List<BHAT_Activity_Note__c> BHATActivityNotesList;
    }

     public class BhatItem
     {
           public String ItemValue { get; private set; }
     }

    //Subclass : Wrapper Class
   public class ActivityDto{
      //Static Variables
           public string ActivityID;
           public String ActivityCode;
           public String ActivityCodeID;
           public String ShortDescription;
           public String LongDescription;
           public string SubCategory;
           public string SubCategoryID;
           public string Description;
           public Boolean IsNonHourlyEmployeeAndDefaultACode;
           public Decimal Hours;
           public Boolean IsDelete;
           public Integer SortSequence;
           public Boolean DescriptionLengthExceeded;
           public Integer UniqueId;
           public Boolean IsNoteDescriptionRequired;
           public Boolean WeeklyReviewStatus;
          public List<BHAT_Activity_Note__c> BHATActivityNotesList;

        //Wrapper  Class Controller
        public ActivityDto()
        {
             SubCategoryID ='';
             DescriptionLengthExceeded = false; IsNoteDescriptionRequired = false;
        }
    }


    public static date getStartWeekData(date thisdate )
    {
            date startDate = thisdate.toStartofWeek();
            startDate = startDate+ 1;
            return startDate;
    }


      //Subclass : Wrapper Class
    public class ActivityWeeklyDto {
        //Static Variables
        public String WeekName;
        public Date WeekStartDate;
        public Date WeekEndDate;
        public Decimal WeeklyTotalHours;
        public Decimal WeeklyHoursTotal;
        public String Status;

        //New fields to retreive from user object
        public String EmpNo;
        public String FirstName;
        public String LastName;
        public String Division;
        public String Manager;
        public String ReviewStatus;  //Weekly object

        //Wrapper  Class Controller
        public ActivityWeeklyDto () {
            Status ='No Entry';
        }

    }

      //Subclass : Wrapper Class
    public class Activitywrap {
        //Static Variables
        public Date ActivityDate;
        public Date ActivityDay;
        public Decimal DailyHoursSpent;
        public Decimal DailyHoursTotal;
        public String Status;
        public String ActivityDayText;

        //Wrapper  Class Controller
        public Activitywrap () {
            Status ='No Entry';
        }

    }

    //Subclass : Wrapper Class
    public class ActivityDailyHours {
        //Static Variables
        public Decimal TotalHoursReported;
        public Decimal TotalHoursExpected;
        public List<Activitywrap> ActivitiyDaily;
        public Date WeekStartDay;
        public String UserFullName;
    }

    public class BHATActivityNoteDto
        {

            public string Id;
            public string name;
            public string BHAT_Activity_Code;
            public string Activity_Note_Description;
            public Decimal SortOrder;
        }


      //Subclass : Wrapper Class
    public class BhatGlobalData {

        //Static Variables
        public Date ThisWeekStartDate;
        public Date TodayDate;
        public String UserFullName;
        public List<BHATActivityCodeDto> BHATActivityCodeList;
        public  List<BHATActivityNoteDto> BHATActivityNotesList;

        //Wrapper  Class Controller
        public BhatGlobalData () {
            ThisWeekStartDate = date.parse('10/21/2013');
            TodayDate = System.today();
            UserFullName = UserInfo.getName();
            BHATActivityCodeList = new List<BHATActivityCodeDto>();

            List<BHATActivityNoteDto> bhatActivityNoteDtoList = new List<BHATActivityNoteDto>();

            // Fill None item first.
                List<BHAT_Activity_Code__c> activitydcodeList = [select Id from BHAT_Activity_Code__c where id!=null order by name ];

            Date today;
            today = date.today();

            for(Bhat_Activity_code__c ac: activitydcodeList ) {
                     BHATActivityNoteDto BHATActivityNoteDtoNone= new BHATActivityNoteDto();
                     BHATActivityNoteDtoNone.Id= BhatSubCategoryNoneID;
                     BHATActivityNoteDtoNone.name ='0';
                     BHATActivityNoteDtoNone.Activity_Note_Description ='None';
                     BHATActivityNoteDtoNone.BHAT_Activity_Code = ac.Id;
                     BHATActivityNoteDtoNone.SortOrder = 0;
                     bhatActivityNoteDtoList.add(BHATActivityNoteDtoNone);
                 }

                 List<BHAT_Activity_Note__c > bhatctivityNotesList =  [select id, name,Activity_Note_Description__c,
                                        BHAT_Activity_Code__c,SortOrder__c
                                        from BHAT_Activity_Note__c 
                                        where BHAT_Activity_Code__c != null And Valid_From_Date__c <= :today And Valid_Until_Date__c >= :today
                                        ORDER BY SortOrder__c,name ASC];
                                        

                for(BHAT_Activity_Note__c anote: bhatctivityNotesList)
                {
                        BHATActivityNoteDto bhatActivityNoteDto = new BHATActivityNoteDto();
                        bhatActivityNoteDto.Id = anote.id;
                        bhatActivityNoteDto.name = anote.name;
                        bhatActivityNoteDto.BHAT_Activity_Code = anote.BHAT_Activity_Code__c;
                        bhatActivityNoteDto.Activity_Note_Description = anote.Activity_Note_Description__c;
                        bhatActivityNoteDto.SortOrder = anote.SortOrder__c;

                        bhatActivityNoteDtoList.add(bhatActivityNoteDto );
                }
                this.BHATActivityNotesList = bhatActivityNoteDtoList;
        }
    }
}