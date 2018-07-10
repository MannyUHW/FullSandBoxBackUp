@isTest(SeeAllData = true)
public class bhatindexcontrollerTest
{
    public static testMethod void myunitTest()
    {
        datetime  dtNow = datetime.now();
        string rightNow = '[' + dtNow.format('yyyy-MM-ddHH:mm:ss.SSSZ','America/New_York') + ']';
        String name;
        name = 'new ' + rightNow;

        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = name);
        insert bcode;
        System.assertEquals(bcode.name,name);

        date d1,d2;
        d1 = date.newinstance(2016, 6,  1);
        d2 = date.newinstance(2016, 6, 30);

//        id noteId;
//        noteId = [SELECT Id FROM BHAT_Activity_Code__c Where Name = 'G'];

        List<BHAT_Activity_Code__c> subCats;
        BHAT_Activity_Code__c subCat;

        subCats = [SELECT Id FROM BHAT_Activity_Code__c Where Name = 'G'];
        subCat  = subCats[0];

        String sId = String.valueOf(subCats[0]);

        BHAT_Activity_Note__c  bnote = new BHAT_Activity_Note__c(name = name, Activity_Note_Description__c = 'Test Descritpion',BHAT_Activity_Code__c = subCat.Id, Valid_From_Date__c = d1, Valid_Until_Date__c = d2);
        insert bnote;
        System.assertEquals(bnote.Name,name);

        User u = [select id,name from user where id=: userInfo.getUserID() limit 1];

        BHAT_Activity_Weekly__c bweeks =  new BHAT_Activity_Weekly__c( Name = 'Test' ,
        ownerId = u.id,
        Status__c = 'Complete',
        WeekStartDate__c = Date.Today(),
        WeekEndDate__c = Date.Today()+7,
        WeeklyTotalHours__c = 2.0,
        WeeklyPaidBreakHours__c = 2.0,
        WeeklyUnpaidLunchHours__c = 1.0 );
        insert bweeks;

        System.assertEquals(bweeks.ownerId,u.id);

        BHAT_Activity_Daily__c dac = new BHAT_Activity_Daily__c(Activity_Date__c = date.today()+1,
        ownerId = bweeks.OwnerId,
        Time_Off_Total__c = 3.0,
        Status__c = 'Complete',
        Work_Hour_End_Time__c = '09:00 AM',
        Work_Hour_Start_Time__c = '05:00 PM',
        BHAT_Activity_Weekly__c = bweeks.id,
        Daily_Hours_Spent__c = bweeks.WeeklyTotalHours__c ,
        Paid_Break_Total__c = bweeks.WeeklyPaidBreakHours__c,
        Unpaid_Lunch_Total__c  = bweeks.WeeklyUnpaidLunchHours__c,
        EndDateMonth__c = 'test',
        EndDateWeek__c = Date.Today()+7,
        ReturnedDate__c = Date.Today(),
        StartDateMonth__c = 'test');
        insert dac;

        System.assertEquals(dac.Activity_Date__c,date.today()+1);

        BHAT_Activity__c ac = new BHAT_Activity__c(Activity_Date__c = dac.Activity_Date__c,
        BHAT_Activity_Code__c = bcode.id,
        BHAT_Activity_Daily__c = dac.id,
        Hours_Spent__c = dac.Daily_Hours_Spent__c,
        ownerId = dac.ownerid);
        insert ac;

        System.assertEquals(ac.Activity_Date__c,dac.Activity_Date__c);

        bhatindexcontroller bhatIndex = new bhatindexcontroller();

        date startDate=system.today();
        String stdate = '11/14/2014';
        String actName='test';
        String deleteJason='[{"ItemValue":"+ac.id+"}]';
        String  activitiesJSON='[{"SubCategoryID":null,"SubCategory":null,"SubCategoryID": null , "WorkHourStartTime": null, "WorkHourEndTime": null,"IsHourlyEmployee" : "false","IsNonExemptEmployee" :"true", "ShortDescription":null,"LongDescription":null,"Hours":0,"Description":null, "BHATActivityNotesList":[],"ActivityID":null,"ActivityCodeID":null,"ActivityCode":"u","BHAT_Activity_Code__c":null}]';
        String inputVal = 'Friday';
        bhatindexcontroller.valueDoubler(inputVal);

        bhatindexcontroller.GetBHATPreviousActivityByDate(stdate);
        bhatindexcontroller.getActivityList(startDate);
        bhatindexcontroller.GetActivitySummary(StartDate);
        bhatindexcontroller.DeleteSelectedActivities_OLD(deleteJason);

        bhatindexcontroller.GetAllActivityCodeListForUI();
        u.Hourly_Employee__c = false;
        u.Non_Exempt_Employee__c = false;
        u.Work_End_Time__c = null;
        u.Work_Start_Time__c = null;
        update u;
        bhatindexcontroller.GetBHATActivityByDate(stdate);
        bhatindexcontroller.getAccountCity(actName);

        try
        {
            bhatindexcontroller.GetAllActivityCodeList_NEW();
        }
        catch(Exception e)
        {

        }

        bhatindexcontroller.isNotEditable(Date.Today());


        try
        {
            bhatindexcontroller.GetBhatGlobalData();
        }
        catch(Exception e)
        {
        }

        bhatindexcontroller.GetBHATActivityLookupData();
        bhatindexcontroller.BHATActivityCodeDto bdto = new  bhatindexcontroller.BHATActivityCodeDto();
        bhatindexcontroller.BhatActivityLookupDataDto lookupDto = new bhatindexcontroller.BhatActivityLookupDataDto();

        try {delete bnote;} catch(Exception e) {system.debug(e);}
        try {delete bcode;} catch(Exception e) {system.debug(e);}
    }

    public static testMethod void myunitTest31()
    {
        try
        {
            bhatindexcontroller.bhatActivityDailyDataDto bhatDto = new bhatindexcontroller.bhatActivityDailyDataDto();

            //String  activitiesJSON1='{"WorkHourStartTime":"09:00 AM","WorkHourEndTime":"5:30 pm","MinutesWorked":50,"IsOPEIUGraveYard":null,"IsNonExemptEmployee":null,"IsHourlyEmployee":true,"IsCopyPrevious":null,"HoursWorked":"8","DailyTotalHours":null,"ActivityDtoList":[{"UniqueId":0,"SubCategoryID":"a0Ai0000003Zd5gEAC","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Representation","LongDescription":"Worker Representation","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2o8AAC","ActivityCode":"A","$$hashKey":"005"},{"UniqueId":1,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"External Organizing","LongDescription":"External Organizing","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTllAAG","ActivityCode":"B","$$hashKey":"007"},{"UniqueId":2,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Politics","LongDescription":"Worker/Work Related Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2ocAAC","ActivityCode":"C","$$hashKey":"009"},{"UniqueId":3,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"GO","LongDescription":"General Overhead","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlqAAG","ActivityCode":"D","$$hashKey":"00B"},{"UniqueId":4,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Contributions/Gifts/Grants","LongDescription":"Contributions/Gifts/Grants","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5BAAU","ActivityCode":"E","$$hashKey":"00D"},{"UniqueId":5,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Union Admin","LongDescription":"Union Administration","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlvAAG","ActivityCode":"F","$$hashKey":"00F"},{"UniqueId":6,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"NonMem Politics","LongDescription":"Non-member/Candidate Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTm0AAG","ActivityCode":"G","$$hashKey":"00H"},{"UniqueId":7,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Idealogical/Charitable Activities (Non Political)","LongDescription":"Idealogical/Charitable Activities (Non Political)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5QAAU","ActivityCode":"H","$$hashKey":"00J"},{"UniqueId":8,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Leave","LongDescription":"Paid Leave: (Vacation,Holiday,Sick, Jury,Bereavement)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTmFAAW","ActivityCode":"I","$$hashKey":"00L"},{"UniqueId":9,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Kaiser LMP","LongDescription":"Kaiser LMP","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004Ya0QAAS","ActivityCode":"J","$$hashKey":"00N"},{"UniqueId":10,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Break Time","LongDescription":"Paid Break Time","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066qFaAAI","ActivityCode":"K","$$hashKey":"00P"},{"UniqueId":11,"SubCategoryID":"a0Ai000000CQj9lEAD","SubCategory":null,"SortSequence":1,"ShortDescription":"OverTime","LongDescription":"OverTime","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000009okb6AAA","ActivityCode":"O","$$hashKey":"00R"},{"UniqueId":12,"SubCategoryID":"a0Ai000000CPmZ5EAL","SubCategory":null,"SortSequence":1,"ShortDescription":"Unpaid Leave","LongDescription":"Unpaid Leave","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066LSFAA2","ActivityCode":"U","$$hashKey":"00T"}],"ActivityDate":"2014-07-14"}';
            String activitiesJSON1='{"WorkHourStartTime":"09:00 AM","WorkHourEndTime":"5:30 pm","MinutesWorked":50,"IsOPEIUGraveYard":true,"IsNonExemptEmployee":null,"IsHourlyEmployee":true,"IsCopyPrevious":true,"HoursWorked":"8","DailyTotalHours":null,"ActivityDtoList":[{"UniqueId":0,"SubCategoryID":"a0Ai0000003Zd5gEAC","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Representation","LongDescription":"Worker Representation","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2o8AAC","ActivityCode":"A","$$hashKey":"005"},{"UniqueId":1,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"External Organizing","LongDescription":"External Organizing","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTllAAG","ActivityCode":"B","$$hashKey":"007"},{"UniqueId":2,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Politics","LongDescription":"Worker/Work Related Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2ocAAC","ActivityCode":"C","$$hashKey":"009"},{"UniqueId":3,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"GO","LongDescription":"General Overhead","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlqAAG","ActivityCode":"D","$$hashKey":"00B"},{"UniqueId":4,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Contributions/Gifts/Grants","LongDescription":"Contributions/Gifts/Grants","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5BAAU","ActivityCode":"E","$$hashKey":"00D"},{"UniqueId":5,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Union Admin","LongDescription":"Union Administration","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlvAAG","ActivityCode":"F","$$hashKey":"00F"},{"UniqueId":6,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"NonMem Politics","LongDescription":"Non-member/Candidate Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTm0AAG","ActivityCode":"G","$$hashKey":"00H"},{"UniqueId":7,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Idealogical/Charitable Activities (Non Political)","LongDescription":"Idealogical/Charitable Activities (Non Political)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5QAAU","ActivityCode":"H","$$hashKey":"00J"},{"UniqueId":8,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Leave","LongDescription":"Paid Leave: (Vacation,Holiday,Sick, Jury,Bereavement)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTmFAAW","ActivityCode":"I","$$hashKey":"00L"},{"UniqueId":9,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Kaiser LMP","LongDescription":"Kaiser LMP","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004Ya0QAAS","ActivityCode":"J","$$hashKey":"00N"},{"UniqueId":10,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Break Time","LongDescription":"Paid Break Time","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066qFaAAI","ActivityCode":"K","$$hashKey":"00P"},{"UniqueId":11,"SubCategoryID":"a0Ai000000CQj9lEAD","SubCategory":null,"SortSequence":1,"ShortDescription":"OverTime","LongDescription":"OverTime","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000009okb6AAA","ActivityCode":"O","$$hashKey":"00R"},{"UniqueId":12,"SubCategoryID":"a0Ai000000CPmZ5EAL","SubCategory":null,"SortSequence":1,"ShortDescription":"Unpaid Leave","LongDescription":"Unpaid Leave","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066LSFAA2","ActivityCode":"U","$$hashKey":"00T"}],"ActivityDate":"2014-07-14"}';
            //String  activitiesJSON='[{"SubCategoryID":null,"SubCategory":null,"SubCategoryID": null , "WorkHourStartTime": null, "WorkHourEndTime": null,"IsHourlyEmployee" : "false","IsNonExemptEmployee" :"true", "ShortDescription":null,"LongDescription":null,"Hours":0,"Description":null, "BHATActivityNotesList":[],"ActivityID":null,"ActivityCodeID":null,"ActivityCode":"u","BHAT_Activity_Code__c":null}]';

            //bhatDto

            //bhatindexcontroller.UpdateBhatActivity(JSON.serialize(bhatDto));
            bhatindexcontroller.UpdateBhatActivity(activitiesJSON1);

            //activitiesJSON1='{"WorkHourStartTime":"09:00 AM","WorkHourEndTime":"5:30 pm","MinutesWorked":50,"IsOPEIUGraveYard":true,"IsNonExemptEmployee":null,"IsHourlyEmployee":true,"IsCopyPrevious":true,"HoursWorked":"8","DailyTotalHours":null,"ActivityDtoList":[{"UniqueId":0,"SubCategoryID":"a0Ai0000003Zd5gEAC","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Representation","LongDescription":"Worker Representation","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2o8AAC","ActivityCode":"A","$$hashKey":"005"},{"UniqueId":1,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"External Organizing","LongDescription":"External Organizing","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTllAAG","ActivityCode":"B","$$hashKey":"007"},{"UniqueId":2,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Politics","LongDescription":"Worker/Work Related Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2ocAAC","ActivityCode":"C","$$hashKey":"009"},{"UniqueId":3,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"GO","LongDescription":"General Overhead","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlqAAG","ActivityCode":"D","$$hashKey":"00B"},{"UniqueId":4,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Contributions/Gifts/Grants","LongDescription":"Contributions/Gifts/Grants","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5BAAU","ActivityCode":"E","$$hashKey":"00D"},{"UniqueId":5,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Union Admin","LongDescription":"Union Administration","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlvAAG","ActivityCode":"F","$$hashKey":"00F"},{"UniqueId":6,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"NonMem Politics","LongDescription":"Non-member/Candidate Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTm0AAG","ActivityCode":"G","$$hashKey":"00H"},{"UniqueId":7,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Idealogical/Charitable Activities (Non Political)","LongDescription":"Idealogical/Charitable Activities (Non Political)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5QAAU","ActivityCode":"H","$$hashKey":"00J"},{"UniqueId":8,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Leave","LongDescription":"Paid Leave: (Vacation,Holiday,Sick, Jury,Bereavement)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTmFAAW","ActivityCode":"I","$$hashKey":"00L"},{"UniqueId":9,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Kaiser LMP","LongDescription":"Kaiser LMP","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004Ya0QAAS","ActivityCode":"J","$$hashKey":"00N"},{"UniqueId":10,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Break Time","LongDescription":"Paid Break Time","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066qFaAAI","ActivityCode":"K","$$hashKey":"00P"},{"UniqueId":11,"SubCategoryID":"a0Ai000000CQj9lEAD","SubCategory":null,"SortSequence":1,"ShortDescription":"OverTime","LongDescription":"OverTime","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000009okb6AAA","ActivityCode":"O","$$hashKey":"00R"},{"UniqueId":12,"SubCategoryID":"a0Ai000000CPmZ5EAL","SubCategory":null,"SortSequence":1,"ShortDescription":"Unpaid Leave","LongDescription":"Unpaid Leave","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066LSFAA2","ActivityCode":"U","$$hashKey":"00T"}],"ActivityDate":"2014-07-14"}';

            //bhatindexcontroller.UpdateBhatActivity(activitiesJSON1);


        }
        catch(Exception e)
        {

        }
    }


    public static testMethod void myunitTest32()
    {
        try
        {
            bhatindexcontroller.bhatActivityDailyDataDto bhatDto = new bhatindexcontroller.bhatActivityDailyDataDto();

            String  activitiesJSON1='{"WorkHourStartTime":"09:00 AM","WorkHourEndTime":"5:30 pm","MinutesWorked":50,"IsOPEIUGraveYard":null,"IsNonExemptEmployee":null,"IsHourlyEmployee":true,"IsCopyPrevious":null,"HoursWorked":"8","DailyTotalHours":null,"ActivityDtoList":[{"UniqueId":0,"SubCategoryID":"a0Ai0000003Zd5gEAC","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Representation","LongDescription":"Worker Representation","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2o8AAC","ActivityCode":"A","$$hashKey":"005"},{"UniqueId":1,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"External Organizing","LongDescription":"External Organizing","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTllAAG","ActivityCode":"B","$$hashKey":"007"},{"UniqueId":2,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Worker Politics","LongDescription":"Worker/Work Related Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004X2ocAAC","ActivityCode":"C","$$hashKey":"009"},{"UniqueId":3,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"GO","LongDescription":"General Overhead","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlqAAG","ActivityCode":"D","$$hashKey":"00B"},{"UniqueId":4,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Contributions/Gifts/Grants","LongDescription":"Contributions/Gifts/Grants","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5BAAU","ActivityCode":"E","$$hashKey":"00D"},{"UniqueId":5,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Union Admin","LongDescription":"Union Administration","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTlvAAG","ActivityCode":"F","$$hashKey":"00F"},{"UniqueId":6,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"NonMem Politics","LongDescription":"Non-member/Candidate Political Activities","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTm0AAG","ActivityCode":"G","$$hashKey":"00H"},{"UniqueId":7,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Idealogical/Charitable Activities (Non Political)","LongDescription":"Idealogical/Charitable Activities (Non Political)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066M5QAAU","ActivityCode":"H","$$hashKey":"00J"},{"UniqueId":8,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Leave","LongDescription":"Paid Leave: (Vacation,Holiday,Sick, Jury,Bereavement)","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004XTmFAAW","ActivityCode":"I","$$hashKey":"00L"},{"UniqueId":9,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Kaiser LMP","LongDescription":"Kaiser LMP","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000004Ya0QAAS","ActivityCode":"J","$$hashKey":"00N"},{"UniqueId":10,"SubCategoryID":"","SubCategory":null,"SortSequence":1,"ShortDescription":"Paid Break Time","LongDescription":"Paid Break Time","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066qFaAAI","ActivityCode":"K","$$hashKey":"00P"},{"UniqueId":11,"SubCategoryID":"a0Ai000000CQj9lEAD","SubCategory":null,"SortSequence":1,"ShortDescription":"OverTime","LongDescription":"OverTime","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":2,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i0000009okb6AAA","ActivityCode":"O","$$hashKey":"00R"},{"UniqueId":12,"SubCategoryID":"a0Ai000000CPmZ5EAL","SubCategory":null,"SortSequence":1,"ShortDescription":"Unpaid Leave","LongDescription":"Unpaid Leave","IsNoteDescriptionRequired":false,"IsNonHourlyEmployeeAndDefaultACode":false,"IsDelete":false,"Hours":0.5,"DescriptionLengthExceeded":false,"Description":null,"BHATActivityNotesList":null,"ActivityID":null,"ActivityCodeID":"a07i00000066LSFAA2","ActivityCode":"U","$$hashKey":"00T"}],"ActivityDate":"2014-07-14"}';

            bhatindexcontroller.UpdateBhatActivity(activitiesJSON1);

        }
        catch(Exception e)
        {

        }
    }



    public static testMethod void myunitTest2()
    {
        bhatindexcontroller bhatIndex = new bhatindexcontroller();
        string inputVal = '123';
        bhatindexcontroller.valueDoubler(inputVal);

        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = 'u');
        insert bcode;

        System.assertEquals(bcode.name,'u');

        BHAT_Activity__c newact = new BHAT_Activity__c(ownerid = userInfo.getUserID(),BHAT_Activity_Code__c = bcode.id,
        Activity_Date__c = Date.today() );
        insert newact;

        System.assertEquals(newact.BHAT_Activity_Code__c,bcode.id);
        bhatindexcontroller.GetBHATActivityDtoByDate(newact.Activity_Date__c);
        try{
            inputVal = 'exception';
            bhatindexcontroller.valueDoubler(inputVal);
        }
        catch(Exception e){}
        date startDate1=system.today();
        bhatindexcontroller.getActivityList(startDate1+90);

    }
}