@isTest(SeeAllData = true)
public class BhatActivityReminderDebugTEST{

    public static testMethod void ShowReminderReportTest()
    {

        User  u = InsertData();

        PageReference tpageRef = Page.BhatActivityReminderDebug;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('arg', '2');

        list<string> employeeIds = new list<string>();

        employeeIds.add(u.id);

        BhatActivityReminderDebugCtrl BhatACtrl = new  BhatActivityReminderDebugCtrl();
        BhatACtrl.EmployeeFilterList = employeeIds ;
        BhatACtrl.ShowReminderReport();
        BhatACtrl.cheese();
        BhatActivityReminderDebugToExcel.cheese();
    }


    public static testMethod void SendEmailToSelectedUserTest()
    {

        User  u = InsertData();
        BhatActivityReminderDebugCtrl.SendEmailToSelectedUser(u.id);

    }

    public static testMethod void sendReminderTest()
    {

        User  u = InsertData();

        PageReference tpageRef = Page.BhatActivityReminderDebug;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('userList', u.id);

        list<string> employeeIds = new list<string>();
        employeeIds.add(u.id);

        list<integer> periods = new list<integer>();
        periods.add(90);

        BhatActivityReminderEmail ba = new BhatActivityReminderEmail();
        ba.GetBhatActivityPendingList(employeeIds,new list<Integer>());
        //ba.SendEmailReminder(employeeIds);



    }


    public static testMethod void others()
    {

        User  u = InsertData();

        PageReference tpageRef = Page.BhatActivityReminderDebug;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('userList', u.id);

        list<string> employeeIds = new list<string>();
        employeeIds.add(u.id);

        list<integer> periods = new list<integer>();
        periods.add(90);

        BhatActivityReminderEmail ba = new BhatActivityReminderEmail();
        ba.getChiefOfStaff();
        ba.getDirectors();



    }




    public static testMethod void getListTest()
    {
        BhatActivityReminderDebugCtrl BhatACtrl = new  BhatActivityReminderDebugCtrl();
        BhatACtrl.getList();


    }




    public static user InsertData()
    {

        Profile p=[SELECT Id FROM profile WHERE name='System Administrator' limit 1];

        User u=new User(alias = generateRandomString(4)+'user',
        email='user122@mail.com',emailencodingkey='UTF-8', lastname='newton',
        languagelocalekey='en_US',localesidkey='en_US',
        profileid = p.Id,timezonesidkey='America/Los_Angeles',username=generateRandomString(4)+'user775sos1@mail.com',CommunityNickname=generateRandomString(4)+'usr1');
        insert u;



        BHAT_Activity_Code__c bcode = new BHAT_Activity_Code__c(Name = 'u', Short_Description__c = 'tt' );
        insert bcode;

        System.assertEquals(bcode.name,'u');

        date d1,d2;
        d1 = date.newinstance(2016, 6,  1);
        d2 = date.newinstance(2016, 6, 30);

        BHAT_Activity_Note__c  bnote=new BHAT_Activity_Note__c(name='bnotename',Activity_Note_Description__c='Test Descritpion',BHAT_Activity_Code__c=bcode.id, Valid_From_Date__c = d1, Valid_Until_Date__c = d2);
        insert bnote;

        BHAT_Activity_Weekly__c bweeks =  new BHAT_Activity_Weekly__c( Name = 'Test' ,
        ownerId = u.id,
        Status__c = 'Complete',
        WeekStartDate__c = Date.Today(),
        WeekEndDate__c = Date.Today()+7,
        WeeklyTotalHours__c = 2.0,
        Total_Time_Off_Hours__c= 8.0,
        WeeklyPaidBreakHours__c = 2.0,
        WeeklyUnpaidLunchHours__c = 1.0,
        Review_Notes__c = '',
        Review_Status__c = 'Not Reviewed');
        insert bweeks;

        BHAT_Activity_Weekly__c bweeks1 =  new BHAT_Activity_Weekly__c( Name = 'Test1' ,
        ownerId = u.id,
        Status__c = 'Complete1',
        WeekStartDate__c = Date.Today()+1,
        WeekEndDate__c = Date.Today()+8,
        WeeklyTotalHours__c = 2.0,
        WeeklyPaidBreakHours__c = 2.0,
        WeeklyUnpaidLunchHours__c = 1.0,
        Review_Notes__c = '',
        Review_Status__c = 'Not Reviewed');
        insert bweeks1;

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
        BHAT_Activity_Note__c = bnote.id,
        BHAT_Activity_Note_Other__c = 'test note other',
        ownerId = dac.ownerid);
        insert ac;

        list<bhat_activity__c> bacList = new list<bhat_activity__c>();
        bacList.add(ac);

        return u;

    }


    public static String generateRandomString(Integer len) {
    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    String randStr = '';
    while (randStr.length() < len) {
    Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
    randStr += chars.substring(idx, idx+1);
}
return randStr;
}



}