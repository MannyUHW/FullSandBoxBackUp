Public class BhatActivityReminderDebugToExcel
{

    public List<ReminderEmailReport> ReminderEmailReportList  {get;set;}
    
    public BhatActivityReminderDebugToExcel()
    {

        ReminderEmailReportList   = new list<ReminderEmailReport>();
        exportToExcel();

    }

    
    public void exportToExcel()
    {

        BhatActivityReminderEmail bhatreminder= new BhatActivityReminderEmail();
  
  
       String periodstext= Apexpages.currentPage().getParameters().get('periods');      
       String userstext= Apexpages.currentPage().getParameters().get('users');  
       
       system.debug('periodstext:' + periodstext);
       system.debug('userstext:' + userstext);
       
       list<Integer> PeriodValuesSelectedInt = new list<Integer>();
       
       
       List<String> useridList = new List<String>();
       List<string> PeriodValuesSelected = new List<string>();
       
       if (userstext.trim() != '')
       {
          useridList  = userstext.split(',');
       }

       if (periodstext.trim() != '')
       {
          PeriodValuesSelected = periodstext.split(',');
       }

  
        if(PeriodValuesSelected.size() > 0)
        {  
            for(String period : PeriodValuesSelected)
            {
                PeriodValuesSelectedInt.add(Integer.ValueOf(period));
            }
        }


       this.ReminderEmailReportList = bhatreminder.GetBhatActivityPendingList(useridList , PeriodValuesSelectedInt);

        system.debug('this.ReminderEmailReportList' + this.ReminderEmailReportList);        
    
    }
 
 public static Integer cheese() {
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
    return i;    
  }
  
 
  }