public class SOS_TOR_New_buttonController {
    Public Map<Id,SOS_Time_Off_Balance__c> tobusermap = new Map<Id,SOS_Time_Off_Balance__c>();
    Public SOS_Time_Off_Request__c tor {get;set;}
    public String homeredirecturl {get;set;}
    public String tobid{get;set;}
    public Boolean isEnable {get;set;}
    public Boolean isDisplayStatus {get;set;}
    public Boolean isExempt {get;set;}
    private ApexPages.StandardController controller;
    User usr = [Select Id,name,SOS_Manager_Name__c,EmployeeNumber,Non_Exempt_Employee__c,Show_Balance_In_Days__c,Employee_Type_Value__c from user where id=:userinfo.getuserid()];
    public SOS_TOR_New_buttonController(ApexPages.StandardController controller) {        
        //Non_Exempt_Employee__c to be changed to Show_Balance_In_Days__c
        tor = (SOS_Time_Off_Request__c)controller.getRecord();
        tor.Manager_Name__c = usr.SOS_Manager_Name__c;
        tor.Employee_Name__c = usr.name;
        tor.Employee_Number__c = usr.EmployeeNumber;  
        tor.Status__c = 'New';
        isenable = false;
        for(SOS_Time_Off_Balance__c tob: [Select id,Employee_Name__c from SOS_Time_Off_Balance__c where Employee_Name__c=:userinfo.getuserid()]){
            tobusermap.put(tob.Employee_Name__c,tob);
        }
        if(tobusermap.containsKey(userinfo.getuserid()))
            tobid = tobusermap.get(userinfo.getuserid()).id;
        else
            tobid = '';  
            
        if(usr.Show_Balance_In_Days__c) {
            isExempt = false;
            tor.Employee_Type__c = 'Non Exempt';
        }
        else {
            isExempt = true;
            tor.Employee_Type__c = 'Exempt';
        }    
        tor.Employee_Type__c = usr.Employee_Type_Value__c; 
            
        homeredirecturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + tobid;
    }
    
    public pageReference saveAndReturn() {
        List<ApexPages.Message> msglst = new List<ApexPages.Message>();
        If((tobid != null || tobid != '')&&!Test.isRunningTest())
            tor.Time_Off_Balance__c = tobid;
        try {
            insert tor;
        }
        Catch(Exception excp) {
            if(!excp.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, excp.getMessage() );
                msglst.add(msg);
                ApexPages.addMessage(msg);
            }              
        }
        if(msglst.size()== 0 && !ApexPages.hasMessages()) {
            isenable = true;
            return new pageReference('/apex/RedirectHome');
        }
        else
            return null;        
        
    }
    
    public pageReference updateAndReturn() {
        List<ApexPages.Message> msglst = new List<ApexPages.Message>();
        try {
            update tor;
        }
        Catch(Exception excp) {
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, excp.getMessage() );
            msglst.add(msg);
            ApexPages.addMessage(msg);  
        }
        if(msglst.size()== 0 && !ApexPages.hasMessages()) {
            isenable = true;
            return new pageReference('/apex/RedirectHome');
        }
        else
            return null;        
        
    }
    
    public pageReference timeOfEntryHome() {        
        if(tobid != null && tobid != '') {
            pageReference toehome = new pageReference('/'+tobid);
            toehome.setRedirect(True);
            return toehome;
        }
        else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Time Off Balace is not available');
            ApexPages.addmessage(myMsg);            
            return null;
        }
    }
    
    public void populateTOR() {
        List<Holiday> holidaylst = [Select h.ActivityDate, h.Name, h.IsRecurrence From Holiday h];
        Integer totalholidays = 0;
        for(Holiday h : holidaylst) {
            if(h.ActivityDate >= tor.Start_Date__c && h.ActivityDate <= tor.End_Date__c ) {
                totalholidays += 1;
            }
        }
        Integer i = 0;   
        Datetime sdate = Datetime.newInstance(tor.Start_Date__c, Time.newInstance(12, 0, 0, 0)); 
        Datetime edate = Datetime.newInstance(tor.end_Date__c, Time.newInstance(12, 0, 0, 0));  
        Integer totalnumberDays = tor.Start_Date__c.daysBetween(tor.end_Date__c) + 1;
        while (sdate <= edate) {
            if (sdate.format('E') == 'Sat' | sdate.format('E') == 'Sun'){
                i = i + 1;
            }
            sdate = sdate.addDays(1);
        }    
        if(totalholidays != null)
            i += totalholidays;
        Integer workingdays = (totalnumberDays - i);
        if(!usr.Show_Balance_In_Days__c)
            tor.Total_Hours_Requested__c = workingdays;
        else
            tor.Total_Hours_Requested__c = (workingdays * 8);
    } 
}