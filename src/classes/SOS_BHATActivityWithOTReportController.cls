public class SOS_BHATActivityWithOTReportController{
    // Properties.
    // UI TODO.
    
    public BHAT_Activity_Daily__c startDateDummyObj{get; set;}
    public BHAT_Activity_Daily__c endDateDummyObj{get; set;}
    
    public String showBy{get; set;}
    public String range{get; set;}
    public Boolean dateEnabled{get; set;}
    //public BHAT_Activity__c[] activities{get; set;}
    public String outputTable{get; set;}
    
    public SOS_BHATActivityWithOTReportController() {  
        
        startDateDummyObj = new BHAT_Activity_Daily__c();
        endDateDummyObj = new BHAT_Activity_Daily__c();
        range = '1';
        showBy = '1';
        setDates();
        
    }
    
    public void setDates() {
        Date fixedMonday = Date.newInstance(2014, 6, 16); // 16 june 2014 is monday
        Date todaysDate = Date.today();
        Date mondayOfThisWeek = todaysDate;
        while (Math.mod(fixedMonday.daysBetween(mondayOfThisWeek), 7) != 0) {
            mondayOfThisWeek = mondayOfThisWeek.addDays(-1);
        }
        dateEnabled = false;
        if (range == '2') {
            startDateDummyObj.Activity_Date__c = mondayOfThisWeek;
            endDateDummyObj.Activity_Date__c = mondayOfThisWeek.addDays(6);
        }
        else if (range == '1') {
            startDateDummyObj.Activity_Date__c = mondayOfThisWeek.addDays(-7);
            endDateDummyObj.Activity_Date__c = mondayOfThisWeek.addDays(-1);
        }
        else {
            dateEnabled = true;
        }
    }
    
    public String getStartDateString() {
        return '' + startDateDummyObj.Activity_Date__c.month() + '/' + startDateDummyObj.Activity_Date__c.day() + '/' + startDateDummyObj.Activity_Date__c.year();
    }
    
    public String getEndDateString() {
        return '' + endDateDummyObj.Activity_Date__c.month() + '/' + endDateDummyObj.Activity_Date__c.day() + '/' + endDateDummyObj.Activity_Date__c.year();
    }
    
    public List<SelectOption> getItemsForShowBy() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','My bhat activities'));
        options.add(new SelectOption('2','My teams bhat activities'));
        return options;
    }
    
    public List<SelectOption> getItemsForRange() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Last Week'));
        options.add(new SelectOption('2','This Week'));
        options.add(new SelectOption('3','Custom'));
        return options;
    }
    
    public PageReference search() {
    
        if (startDateDummyObj.Activity_Date__c == null) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Start Date is required');
            ApexPages.addMessage(message);
            return null;
        }
        if (endDateDummyObj.Activity_Date__c == null) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'End Date is required');
            ApexPages.addMessage(message);
            return null;
        }
        if (startDateDummyObj.Activity_Date__c > endDateDummyObj.Activity_Date__c) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Start Date should be less than or equal to End Date');
            ApexPages.addMessage(message);
            return null;
        }
        Id userId = UserInfo.getUserId();
        BHAT_Activity__c[] activities;
        if (showBy == '1') {
            activities = [SELECT Id, OwnerId, Owner.Name, Activity_Date__c, BHAT_Code_and_Short_Desc__c, Details__c, IsUnpaidLunch__c, Hours_Spent__c, BHAT_Activity_Daily__r.OPEIU_Graveyard_Swing__c, BHAT_Activity_Daily__r.Work_Hour_Start_Time__c, BHAT_Activity_Daily__r.Work_Hour_End_Time__c FROM BHAT_Activity__c WHERE Activity_Date__c >= :startDateDummyObj.Activity_Date__c AND Activity_Date__c <= :endDateDummyObj.Activity_Date__c AND OwnerId = :userId ORDER BY Owner.Name, OwnerId, Activity_Date__c];
        }
        else {
            activities = [SELECT Id, OwnerId, Owner.Name, Activity_Date__c, BHAT_Code_and_Short_Desc__c, Details__c, IsUnpaidLunch__c, Hours_Spent__c, BHAT_Activity_Daily__r.OPEIU_Graveyard_Swing__c, BHAT_Activity_Daily__r.Work_Hour_Start_Time__c, BHAT_Activity_Daily__r.Work_Hour_End_Time__c FROM BHAT_Activity__c WHERE Activity_Date__c >= :startDateDummyObj.Activity_Date__c AND Activity_Date__c <= :endDateDummyObj.Activity_Date__c ORDER BY Owner.Name, OwnerId, Activity_Date__c];
        }
        outputTable = createTable(activities);
       
        /*
        reminderLog = [SELECT User__r.Name, User__r.Email, Email_For_30_Day_Sent_On__c, 
            Email_For_60_Day_Sent_On__c, Email_For_90_Day_Sent_On__c FROM BHAT_Activity_Reminder_Log__c
            WHERE 
            (Email_For_30_Day_Sent_On__c != null AND Email_For_30_Day_Sent_On__c >= :startDateDummyObj.Activity_Date__c AND Email_For_30_Day_Sent_On__c <= :endDateDummyObj.Activity_Date__c) OR
            (Email_For_60_Day_Sent_On__c!= null AND Email_For_60_Day_Sent_On__c >= :startDateDummyObj.Activity_Date__c AND Email_For_60_Day_Sent_On__c<= :endDateDummyObj.Activity_Date__c) OR
            (Email_For_90_Day_Sent_On__c != null AND Email_For_90_Day_Sent_On__c >= :startDateDummyObj.Activity_Date__c AND Email_For_90_Day_Sent_On__c <= :endDateDummyObj.Activity_Date__c)
            ORDER BY Email_For_90_Day_Sent_On__c DESC,  Email_For_60_Day_Sent_On__c DESC, Email_For_30_Day_Sent_On__c DESC
        ];
        */
        
        return null;
    }
    
    private String createTable(BHAT_Activity__c[] activities) {
        Id currentUser = null;
        Date currentDate = null;
        List<TableRow> trows = new List<TableRow>();
        Integer regularRow = -1;
        Integer overTimeRow  = -1;
        Integer currentUserTotalRow = -1;
        Integer currentDailyTotalRow = -1;
        Double userTotal = 0.00;
        Double dailyTotal = 0.00;
        Double userPaidTotal = 0.00;
        Double dailyPaidTotal = 0.00;
        Double regularTotal = 0.00;
        Double regularPaidTotal = 0.00;
        Double overtimeTotal = 0.00;
        
        TableRow tr;
        for (BHAT_Activity__c a: activities) {
            if (currentUser != a.OwnerId) {
                if (currentUser != null && userTotal > 0.00) {
                    tr = trows.get(currentUserTotalRow);
                    tr.UserTotal  = String.valueOf(userTotal);
                    tr.UserPaidTotal  = String.valueOf(userPaidTotal);
                }
                if (currentDate != null && dailyTotal > 0.00) {
                    tr = trows.get(currentDailyTotalRow);
                    tr.DailyTotal  = String.valueOf(dailyTotal);
                    tr.DailyPaidTotal  = String.valueOf(dailyPaidTotal);
                }
                userTotal = 0.00;
                dailyTotal = 0.00;
                userPaidTotal = 0.00;
                dailyPaidTotal = 0.00;
                currentUser = a.OwnerId;
                currentDate = null;
                tr = new TableRow();
                tr.UserName =  a.Owner.Name;
                trows.add(tr);
                tr = new TableRow();
                trows.add(tr);
                currentUserTotalRow = trows.size() - 1;
            }
            if (currentDate != a.Activity_Date__c) {
                if (currentDate != null && dailyTotal > 0.00) {
                    tr = trows.get(currentDailyTotalRow);
                    tr.DailyTotal  = String.valueOf(dailyTotal);
                    tr.DailyPaidTotal  = String.valueOf(dailyPaidTotal);
                }
                dailyTotal = 0.00;
                dailyPaidTotal = 0.00;
                currentDate = a.Activity_Date__c;
                tr = new TableRow();
                tr.ActivityDate = String.valueOf(a.Activity_Date__c);
                trows.add(tr);
                tr = new TableRow();
                trows.add(tr);
                currentDailyTotalRow = trows.size() - 1;
                regularRow = overTimeRow = currentDailyTotalRow;
            }
            Boolean isOvertime = false;
            if (a.BHAT_Code_and_Short_Desc__c == 'O-OverTime/Differentials') {
                isOvertime = true;
            }
            tr = null;
            if (regularRow == overTimeRow ||(regularRow > overTimeRow && !isOvertime) ||(regularRow < overTimeRow && isOvertime)) {
                tr = new TableRow();
                trows.add(tr);
                if (isOvertime) {
                    overTimeRow++;
                }
                else  {
                    regularRow++;
                }
            }
            else if (regularRow > overTimeRow && isOvertime) {
                overTimeRow++;
                tr = trows.get(overTimeRow);
            }
            else if (regularRow < overTimeRow && !isOvertime) {
                regularRow++;
                tr = trows.get(regularRow);
            }
            /*
            String sep = '';
            if (a.BHAT_Activity_Note__r.Name != null && a.BHAT_Activity_Note__r.Name.length() > 0 &&
                a.BHAT_Activity_Note_Other__c != null && a.BHAT_Activity_Note_Other__c.length() > 0) {
                sep = '/';
            }
            String subcat = '';
            if (a.BHAT_Activity_Note__r.Name != null && a.BHAT_Activity_Note__r.Name.length() > 0) {
                subcat = a.BHAT_Activity_Note__r.Name;
            }
            String subcatother = '';
            if (a.BHAT_Activity_Note_Other__c != null && a.BHAT_Activity_Note_Other__c.length() > 0) {
                subcatother  = a.BHAT_Activity_Note_Other__c ;
            }
            */
            if (isOvertime) {
                tr.OvertimeBhatCode = a.BHAT_Code_and_Short_Desc__c;
                //tr.OvertimeBhatSubCategory = subcat + sep + subcatother;
                tr.OvertimeBhatSubCategory = a.Details__c;
                tr.OvertimeOpeiu = a.BHAT_Activity_Daily__r.OPEIU_Graveyard_Swing__c;
                tr.OvertimeHours = String.valueOf(a.Hours_Spent__c);
                tr.OvertimePaidHours = (a.IsUnpaidLunch__c)?'':tr.OvertimeHours;
                if (a.BHAT_Activity_Daily__r.Work_Hour_Start_Time__c != null || a.BHAT_Activity_Daily__r.Work_Hour_End_Time__c != null) {
                    tr.OvertimeStartEndTime = a.BHAT_Activity_Daily__r.Work_Hour_Start_Time__c + ' - ' + a.BHAT_Activity_Daily__r.Work_Hour_End_Time__c;
                }
                overtimeTotal += a.Hours_Spent__c;          
            }
            else {
                tr.RegularBhatCode= a.BHAT_Code_and_Short_Desc__c;
                //tr.RegularBhatSubCategory = subcat + sep + subcatother;
                tr.RegularBhatSubCategory = a.Details__c;
                tr.RegularHours = String.valueOf(a.Hours_Spent__c);
                tr.RegularPaidHours = (a.IsUnpaidLunch__c)?'':tr.RegularHours;
                if (a.BHAT_Activity_Daily__r.Work_Hour_Start_Time__c != null || a.BHAT_Activity_Daily__r.Work_Hour_End_Time__c != null) {
                    tr.RegularStartEndTime = a.BHAT_Activity_Daily__r.Work_Hour_Start_Time__c + ' - ' + a.BHAT_Activity_Daily__r.Work_Hour_End_Time__c;
                }
                
                userTotal += a.Hours_Spent__c;
                userPaidTotal += (a.IsUnpaidLunch__c)?0.00:a.Hours_Spent__c;
                dailyTotal += a.Hours_Spent__c;
                dailyPaidTotal += (a.IsUnpaidLunch__c)?0.00:a.Hours_Spent__c;
                regularTotal += a.Hours_Spent__c;  
                regularPaidTotal += (a.IsUnpaidLunch__c)?0.00:a.Hours_Spent__c;
            }            
        }
        if (currentUser != null && userTotal > 0.00) {
            tr = trows.get(currentUserTotalRow);
            tr.UserTotal  = String.valueOf(userTotal);
            tr.UserPaidTotal  = String.valueOf(userPaidTotal);
        }
        if (currentDate != null && dailyTotal > 0.00) {
            tr = trows.get(currentDailyTotalRow);
            tr.DailyTotal  = String.valueOf(dailyTotal);
            tr.DailyPaidTotal  = String.valueOf(dailyPaidTotal);
        }
        String tblHtml = '<table class="reportTbl" width="100%" cellspacing="0" cellpadding="0">';
        //tblHtml += '<tr><th class="reportTblTopHeader" colspan="4">Regular Hours</th><th style="width:15px;"></th><th class="reportTblTopHeader" colspan="5">Overtime/Differential Hours</th></tr>';
        tblHtml += '<tr><th class="reportTblSecondHeader">Date/Time</th><th class="reportTblSecondHeader">Regular Hours</th><th style="text-align:right;">Total Paid Hours</th><th style="text-align:right;">&nbsp;&nbsp;Total Hours</th><th>&nbsp;&nbsp;</th><th class="reportTblSecondHeader">Overtime/Differential Hours</th><th class="reportTblSecondHeader">&nbsp;&nbsp;Details</th><th class="reportTblSecondHeader">&nbsp;&nbsp;Date/Time</th><th>&nbsp;&nbsp;OPEIU Graveyard/Swing</th><th style="text-align:right;">&nbsp;&nbsp;Total Paid Hours</th><th style="text-align:right;">&nbsp;&nbsp;Total Hours</th></tr>';
        for (TableRow t:trows) {
            if  (t.UserName != null) {
                tblHtml += '<tr style="background-color:#c0d4f1;"><td class="reportTblUserHeader" colspan="11" >' + t.UserName + '</td></tr>';
            }
            else if (t.ActivityDate != null)  {
                tblHtml += '<tr style="background-color:#e0e8fb;"><td class="reportTblDateHeader" colspan="1">' + t.ActivityDate + '</td><td class="reportTblDateHeader" colspan="6">' + '' + '</td><td class="reportTblDateHeader" colspan="4">' + '' + '</td></tr>';
            }
            else if (t.UserTotal != null)  {
                tblHtml += '<tr style="background-color:#c0d4f1;"><td></td><td></td><td class="reportTblUTotalHeader" style="text-align:right;">' + t.UserPaidTotal + '</td><td class="reportTblUTotalHeader" style="text-align:right;">' + t.UserTotal + '</td><td colspan="7"></td></tr>';
            }
            else if (t.DailyTotal != null)  {
                tblHtml += '<tr style="background-color:#e0e8fb;"><td></td><td></td><td class="reportTblDTotalHeader" style="text-align:right;">' + t.DailyPaidTotal+ '</td><td class="reportTblDTotalHeader" style="text-align:right;">' + t.DailyTotal+ '</td><td colspan="7"></td></tr>';
            }
            else {
                tblHtml += '<tr><td>' + (t.RegularStartEndTime == null?'':t.RegularStartEndTime) + '</td><td>' + 
                (t.RegularBhatCode == null?'':t.RegularBhatCode) + '</td><td style="text-align:right;">' + 
                (t.RegularPaidHours == null?'':t.RegularPaidHours) + '</td><td style="text-align:right;">' + 
                (t.RegularHours == null?'':t.RegularHours) + '</td><td></td><td>' + 
                (t.OvertimeBhatCode == null?'':t.OvertimeBhatCode) + '</td><td>' +  
                (t.OvertimeBhatSubCategory == null?'':t.OvertimeBhatSubCategory) + '</td><td>' + 
                (t.OvertimeStartEndTime == null?'':t.OvertimeStartEndTime) + '</td><td>' + 
                (t.OvertimeOpeiu == null?'':('<input type="checkbox" disabled="disabled" ' + (t.OvertimeOpeiu?'checked':'') + ' />')) + '</td><td style="text-align:right;">' + 
                (t.OvertimePaidHours == null?'':t.OvertimePaidHours) + '</td><td style="text-align:right;">' + 
                (t.OvertimeHours == null?'':t.OvertimeHours) + '</td></tr>';
                
            }
        }
        tblHtml += '<tr><td><b>Grand Total</b></td><td></td><td class="reportTblUTotalHeader" style="text-align:right;">' + regularPaidTotal + '</td><td class="reportTblUTotalHeader" style="text-align:right;">' + regularTotal + '</td><td colspan="5"></td><td style="text-align:right;">' + overtimeTotal + '</td></tr>';
        tblHtml += '<tr><td><b>' + (regularTotal + overtimeTotal) + '</b></td><td></td><td class="reportTblUTotalHeader" style="text-align:right;"></td><td colspan="5"></td><td style="text-align:right;"></td></tr>';
        tblHtml += '</table>';
        return tblHtml;
    }
    
    public class TableRow {
        public String UserName {get;set;}
        public String ActivityDate {get;set;}
        public String UserTotal {get;set;}
        public String DailyTotal {get;set;}
        public String UserPaidTotal {get;set;}
        public String DailyPaidTotal {get;set;}
        public String RegularBhatCode {get;set;}
        public String RegularBhatSubCategory {get;set;}
        public String RegularPaidHours {get;set;}
        public String RegularHours {get;set;}
        public String RegularStartEndTime {get;set;}
        public String OvertimeBhatCode {get;set;}
        public String OvertimeBhatSubCategory {get;set;}
        public Boolean OvertimeOpeiu {get;set;}
        public String OvertimePaidHours {get;set;}
        public String OvertimeHours {get;set;}
        public String OvertimeStartEndTime {get;set;}
    }
    
    
}