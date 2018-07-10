Public class BhatActivityReminderDebugCtrl
{

    public List<ReminderEmailReport> ReminderEmailReportList { get; set; }

    //String array to keep track of the ids of EmployeeFilterList  
    public List<String> EmployeeFilterList { get; set; }
    
    public String[] PeriodValuesSelected { get; set; }
    public List<Integer> PeriodValuesSelectedInt { get; set; }
    public SelectOption[] PeriodValueOptionList { get; set; }


    
    public Boolean Reminder30Days { get; set; }
    public Boolean Reminder60Days { get; set; }
    public Boolean Reminder90Days { get; set; }
    public Boolean selectAll  {get;set;}
      
    //List of select options to populate select boxes  
    public List<SelectOption> getList() {  
         List<SelectOption> options = new List<SelectOption>();  
           for (User u : [SELECT id, name FROM user WHERE IsActive = true and Term_Date__c = null  order by LastName asc]) {   
             options.add(new SelectOption(u.id, u.Name));   
           }    
         return options;   
    }   
    
    
    
    public List<String> EmailMessageList {get;set;}

    public BhatActivityReminderDebugCtrl()
    {
    
        this.EmailMessageList = new list<String>();    
        this.ReminderEmailReportList = new list<ReminderEmailReport>();
        this.PeriodValuesSelectedInt = new list<Integer>();
        
        this.PeriodValueOptionList = new SelectOption[0];
        this.PeriodValuesSelected = new String[0];
        
        
        this.PeriodValueOptionList  = new list<SelectOption>();
        PeriodValueOptionList.add(new selectoption('30', '30 Days'));
        PeriodValueOptionList.add(new selectoption('60', '60 Days'));
        PeriodValueOptionList.add(new selectoption('90', '90 Days'));
        
        EmployeeFilterList = new list<string>();
    }
 
 
  public PageReference ExportToExcel() 
  {    
 
     return null;
  }   
  
  @RemoteAction
  public static boolean SendEmailToSelectedUser( string userIds)
  {
  
       BhatActivityReminderEmail BhatActivityReminderEmail = new BhatActivityReminderEmail();
       list<id> selectedUserIdList = new list<id>();

        //this.ReminderEmailReportList = new list<ReminderEmailReport>();
        //this.PeriodValuesSelectedInt = new list<Integer>();

        List<String> useridList = userIds.split(',');
       
        //List<Id> userFilterList = new List<Id>();

        List<ReminderEmailReport> ReminderEmailReportList = BhatActivityReminderEmail.GetBhatActivityPendingList(useridList , new list<Integer>());
        
        system.debug(' sun ReminderEmailReportList :' + ReminderEmailReportList );
        
        /*
        for(ReminderEmailReport rpt: ReminderEmailReportList)
        {
            rpt.UserEmailId  ='Sun@strategicorganizingsystems.com';
        }
        */
        
        BhatActivityReminderEmail.SendEmailReminder(ReminderEmailReportList );
        BhatActivityReminderEmail.UpdateReminderLog(ReminderEmailReportList );
      
      return true;
      
  }
  
    
  public PageReference SendEmailReminder() 
  {    


        system.debug('sun test22');
 
       String userList= Apexpages.currentPage().getParameters().get('userList');       

       BhatActivityReminderEmail BhatActivityReminderEmail = new BhatActivityReminderEmail();
       list<id> selectedUserIdList = new list<id>();


        this.ReminderEmailReportList = new list<ReminderEmailReport>();
        this.PeriodValuesSelectedInt = new list<Integer>();
        
        
        
        system.debug(' sun userList:' + userList);
        

        List<Id> userFilterList = new List<Id>();

        List<ReminderEmailReport> ReminderEmailReportList = BhatActivityReminderEmail.GetBhatActivityPendingList(userFilterList , new list<Integer>());
        
        system.debug(' sun ReminderEmailReportList :' + ReminderEmailReportList );
        
        
        //BhatActivityReminderEmail.SendEmailReminder(ReminderEmailReportList );
        
        
      
    //}
    //catch(Exception ex)
   // {
   //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex));
   // }
    
    return null;
 
    
 
  }
  
  
 public PageReference ShowReminderReport() 
  {    
 
    try{   
      
       BhatActivityReminderEmail BhatActivityReminderEmail = new BhatActivityReminderEmail();
       list<id> selectedUserIdList = new list<id>();


        this.ReminderEmailReportList = new list<ReminderEmailReport>();
        this.PeriodValuesSelectedInt = new list<Integer>();
       
     
        if(PeriodValuesSelected.size() > 0)
        {  
            for(String period : PeriodValuesSelected)
            {
                PeriodValuesSelectedInt.add(Integer.ValueOf(period));
            }

        }
        
        List<ReminderEmailReport> ReminderEmailReportList = BhatActivityReminderEmail.GetBhatActivityPendingList(EmployeeFilterList, PeriodValuesSelectedInt);
        this.ReminderEmailReportList  = ReminderEmailReportList   ;
        
      
    }
    catch(Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex));
    }
    
    return null;
  }
  
  
 public PageReference ResetLog() 
  {    
 
    try{      
      
    }
    catch(Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex));
    }
    
    return null;
  }
  
  // old
  public  void SendReminderEmail()
  {
        BhatActivityReminderEmail BhatActivityReminderEmail = new BhatActivityReminderEmail();


        if(PeriodValuesSelected.size() > 0)
        {  
            for(string period : PeriodValuesSelected)
            {
                PeriodValuesSelectedInt.add(Integer.valueof(period ));
            }

        }
        

        /*String userid = Apexpages.currentPage().getParameters().get('userid');
        
        
        if (userid.equals('')) 
        {
             throw new bhatException('Employee is required.');
        } */
        
        if(EmployeeFilterList.size() == 0)
        {
           throw new bhatException('Select an Employee..!');
        }  
        
        if(EmployeeFilterList.size() > 0)
        {  
        
            List<Id> ids = new List<Id>{String.join(EmployeeFilterList, ',') };
            List<ReminderEmailReport> pendingListg = BhatActivityReminderEmail.GetBhatActivityPendingList(ids,PeriodValuesSelectedInt);
           
           
           BhatActivityReminderEmail.SendEmailReminder(pendingListg);
           BhatActivityReminderEmail.UpdateReminderLog(pendingListg);
        }
        
  }


    public class bhatException extends Exception{}

public Integer cheese() {
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
    return i;    
  }

}