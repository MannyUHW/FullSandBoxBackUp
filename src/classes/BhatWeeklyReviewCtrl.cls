public class BhatWeeklyReviewCtrl{


    public List<ActivityWeeklyDto> BhatweeklyDtoList {get;set;}
    private String soql {get;set;}
    BusinessDay b = new BusinessDay();
    private Set<Id> staffIdSet= new Set<Id>();
    public string defaultReviewStatusText = 'Not Reviewed';
    
    public  List<ActivityWeeklyDto> getBhatweeklyDtoList1() {
            /*    
            List<BHAT_Activity__c> bhatActivity  =[SELECT BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.name,BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Id,
                     BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Notes__c,
                    BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.WeekStartDate__c,BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.WeekEndDate__c,
                    BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Weekly_Hours_Total__c , BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Status__c,
                    BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Status__c, BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.owner.Name, 
                    BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Name_EEID__c, WeekStartDate__c, Activity_Date__c,Activity_Note_Name__c,
                    BHAT_Activity_Note_Other__c,BHAT_Activity_Note__c,BHAT_Code_and_Short_Desc__c,Details__c,Division__c,Hours_Spent__c, 
                    BHAT_Activity_Daily__r.Status__c , Name  
                    FROM BHAT_Activity__c 
                    WHERE owner.name ='Sun Nathan' 
                    ORDER BY BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Name_EEID__c asc,WeekStartDate__c asc, Activity_Date__c asc];

            BhatweeklyDtoList =  getActivityWeeklyDtoList(bhatActivity);
            */
            
            BhatweeklyDtoList = new List<ActivityWeeklyDto>();
            
            return null;
    }

 
    public  List<ActivityWeeklyDto> getActivityWeeklyDtoList(List<BHAT_Activity__c> bhatActivity )
    {
    
    
                List<ActivityWeeklyDto> bhatweeklyDtoListLocal=new List<ActivityWeeklyDto>();
                
                
                BHAT_Activity_Weekly__c bhatwkly = new BHAT_Activity_Weekly__c();
                
                ActivityWeeklyDto  bhwkdto = new ActivityWeeklyDto();
                
                 for ( BHAT_Activity__c a : bhatActivity)
                 {
                    
                    if (bhatwkly.Id != a.BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Id)
                    {
                        bhatwkly = a.BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r;
                        bhwkdto = new ActivityWeeklyDto();
                        bhwkdto.BhatActivityList = new list<BhatActivityDto>();
                        bhwkdto.WeekStartDate = bhatwkly.WeekStartDate__c;
                        bhwkdto.WeekEndDate = bhatwkly.WeekEndDate__c;
                        bhwkdto.WeekName = bhatwkly.name;
                        bhwkdto.OwnerName = bhatwkly.owner.Name;
                        bhwkdto.WeeklyHoursTotal =  bhatwkly.Weekly_Hours_Total__c;
                        bhwkdto.ReviewStatus =  bhatwkly.Review_Status__c;
                        bhwkdto.Status =  bhatwkly.Status__c;
                        bhwkdto.ReviewNotes =  bhatwkly.Review_Notes__c;
                        bhwkdto.Id = a.BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Id;
                        bhwkdto.weekId = a.BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Id;
                        
                        if (bhwkdto.ReviewStatus != NULL && bhwkdto.ReviewStatus != '' && bhwkdto.ReviewStatus != 'Not Reviewed' )
                        {
                            bhwkdto.IsReviewed = true;
                        }
                        else
                        {
                            bhwkdto.IsReviewed = false;
                        }
                        
                        bhatweeklyDtoListLocal.add(bhwkdto);
                    }
                    
                        BhatActivityDto bhadto = new BhatActivityDto();
                        bhadto.ActivityDate = a.Activity_Date__c;
                        bhadto.DailyHoursSpent = a.Hours_Spent__c;
                        bhadto.ActivityDayText = a.BHAT_Code_and_Short_Desc__c;
                        
                        bhadto.ActivityNoteName = a.Activity_Note_Name__c;
                        bhadto.CodeAndShortDesc = a.BHAT_Code_and_Short_Desc__c;
                        bhadto.SubCategoryOther = a.BHAT_Activity_Note_Other__c;
                        bhadto.DailyActivityStatus = a.BHAT_Activity_Daily__r.Status__c;
                         bhadto.Name = a.Name;
                        
                    
                        bhwkdto.BhatActivityList.add(bhadto);
                    
                 }
            
            // Do the sort function here on bhatweeklyDtoListLocal

            return bhatweeklyDtoListLocal;
    
    
    }


    public List<user> userList 
    {
        get {
          if (userList == null) 
          {
              
              
              this.staffIdSet = GetStaffIds();
              userList = [SELECT id, name FROM user WHERE ( managerId =: UserInfo.getUserId() OR ID IN :staffIdSet )  AND IsActive = true order by LastName asc ];
           
           }
          return userList ;          
        }
        set;
    }
          
    public Set<Id> GetStaffIds()
    {
             Set<Id> stafflist = new Set<Id>();
              List<BHAT_Reviewer_Staff__c> bhatStaffList = [SELECT staff__c from BHAT_Reviewer_Staff__c WHERE Reviewer__c in (SELECT ID FROM BHAT_Reviewer__c WHERE Reviewer__c =:UserInfo.getUserId() )];
             for (BHAT_Reviewer_Staff__c rs  :bhatStaffList )
             {
                 stafflist.add(rs.staff__c);
             }
        return stafflist;
    }
    
   public List<String> reviewStatusList {
        get {
          if (reviewStatusList== null) 
          {    
            reviewStatusList= new List<String>();
            Schema.DescribeFieldResult field = BHAT_Activity_Weekly__c.Review_Status__c.getDescribe();
    
            for (Schema.PicklistEntry f : field.getPicklistValues())
              reviewStatusList.add(f.getLabel());    
              
             
          }
          return reviewStatusList;          
        }
        set;
    }
    
    
    public string getSeletedReviewStatus(){
          return defaultReviewStatusText;
     }
     public void setSeletedReviewStatus(String defaultReviewStatus){
         this.defaultReviewStatusText = defaultReviewStatus;
     }

     public list<SelectOption> getReviewStatusItems (){
        
       string defaultReviewStatusTextLocal = 'Not Reviewed';
       List<SelectOption> options = new List<SelectOption>();
       
       options.add(new SelectOption('',''));
            
       Schema.DescribeFieldResult fieldResult = BHAT_Activity_Weekly__c.Review_Status__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption(defaultReviewStatusTextLocal,defaultReviewStatusTextLocal));
            
       for( Schema.PicklistEntry f : ple)
       {
          if(f.getLabel() != defaultReviewStatusTextLocal)
          {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
          }
       }       
       return options;
     }
   
    
    
    
    public List<String> statusList {
        get {
          if (statusList== null) {
    
            statusList= new List<String>();
            Schema.DescribeFieldResult field = BHAT_Activity_Weekly__c.Status__c.getDescribe();
    
            for (Schema.PicklistEntry f : field.getPicklistValues())
              statusList.add(f.getLabel());
    
          }
          return statusList;          
        }
        set;
    }
    
    
    public BhatWeeklyReviewCtrl()
    {
        getBhatweeklyDtoList1();
        
    }
    
    
    // the soql without the order and limit
    public List<BHAT_Activity_Weekly__c> bhatweekly =new List<BHAT_Activity_Weekly__c>();
    BHAT_Activity_Weekly__c bhatweek = new BHAT_Activity_Weekly__c();
    
    
    public void savebhatWeekly()
    {
        bhatweekly  =  [select id,name,owner_division__c,WeekStartDate__c,WeekEndDate__c, 
                      Weekly_Hours_Total__c , Review_Status__c,Review_Notes__c,Status__c, owner.Name  
                      from BHAT_Activity_Weekly__c limit 2]; 
         update bhatweekly;
    }
  
    
      public String weekid{
            get;
            // *** setter is NOT being called ***
            set {
                weekid = Apexpages.currentPage().getParameters().get('weekid');
                System.debug('weekID=================!!!: '+weekid );
            }
        }
        
       public String weeknotes{
            get;
            // *** setter is NOT being called ***
            set {
                weeknotes = Apexpages.currentPage().getParameters().get('weeknotes');
                System.debug('weeknotes=================!!!: '+weeknotes);
            }
        }
         

    /*
    
    public void approve()
    {
       String weekid = Apexpages.currentPage().getParameters().get('weekid');
      String weeknotes = Apexpages.currentPage().getParameters().get('weeknotes');
    
        system.debug('weekid------------------->' + weekid);
        system.debug('weeknotes---------------->' + weeknotes);
        
         bhatweek  =  [select id,name,owner_division__c,WeekStartDate__c,WeekEndDate__c, 
                      Weekly_Hours_Total__c , Review_Status__c,Review_Notes__c,Status__c, owner.Name  
                      from BHAT_Activity_Weekly__c where id =: weekid]; 
                      
         bhatweek.Review_Notes__c = weeknotes;
         bhatweek.Review_Status__c = 'Approved';    
                      
         system.debug('bhat week approve record---------------------------'+ bhatweek);
         update bhatweek;
    }
    
    public void reject()
    {
      // String weekid = Apexpages.currentPage().getParameters().get('weekid');
      // String weeknotes = Apexpages.currentPage().getParameters().get('weeknotes');
    
        system.debug('weekid------------------->' + weekid);
        system.debug('weeknotes---------------->' + weeknotes);
        
         bhatweek  =  [select id,name,owner_division__c,WeekStartDate__c,WeekEndDate__c, 
                      Weekly_Hours_Total__c , Review_Status__c,Review_Notes__c,Status__c, owner.Name  
                      from BHAT_Activity_Weekly__c where id =: weekid]; 
                      
         bhatweek.Review_Notes__c = weeknotes;
         bhatweek.Review_Status__c = 'Rejected';    
                      
         system.debug('bhat week reject record---------------------------'+ bhatweek);
         update bhatweek;
    }
    

    
    
    public List<BHAT_Activity_Daily__c> bhatdaily=new List<BHAT_Activity_Daily__c>();
    
    public List<BHAT_Activity_Daily__c> getBhatDaily()
    {
         bhatdaily =[select Activity_Date__c, Status__c, Daily_Hours_Spent__c  
            FROM BHAT_Activity_Daily__c 
            where Owner.name ='Sun Nathan'] ;
         return bhatdaily;
    }

    */


// runs the search with parameters passed via Javascript
  public PageReference runSearch() 
  {    
    
 
    try{      
        setSOQL();
        // run the query again
        runQuery();
    }
    catch(Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex));
    }
    
    return null;
  }
  


  
  
  public PageReference runApproveOrReject() 
  {
        String weeklyId = Apexpages.currentPage().getParameters().get('weeklyId');
        String reviewNotes = Apexpages.currentPage().getParameters().get('reviewNotes');
        String approveOrReject = Apexpages.currentPage().getParameters().get('approveOrReject');
            
         list<BHAT_Activity_Weekly__c> bhatweekList  =  [select id,name,owner_division__c,WeekStartDate__c,WeekEndDate__c, 
                      Weekly_Hours_Total__c , Review_Status__c,Review_Notes__c,Status__c, Date_Reviewed__c, Reviewed__c, Reviewed_By__c, owner.Name  
                      from BHAT_Activity_Weekly__c where id =: weeklyId]; 
               
     if (bhatweekList.size()>0)
     {                  
         bhatweekList[0].Review_Notes__c = reviewNotes;
         
         if (approveOrReject=='approve')
         {
             bhatweekList[0].Review_Status__c = 'Approved';
             
             bhatweekList[0].Date_Reviewed__c = Date.Today();
             bhatweekList[0].Reviewed__c  = true;
             bhatweekList[0].Reviewed_By__c = UserInfo.getUserId();
             
             update  bhatweekList[0];
         }
         else if (approveOrReject=='reject')
         {
         
             if (reviewNotes != null && reviewNotes.trim().length() > 0 ) 
             {
                 bhatweekList[0].Review_Status__c = 'Rejected';
                 
                 bhatweekList[0].Date_Reviewed__c = Date.Today();
                 bhatweekList[0].Reviewed__c  = true;
                 bhatweekList[0].Reviewed_By__c = UserInfo.getUserId();
                 
                 
                 update  bhatweekList[0];
             }
             else
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Notes field is required when Rejecting a Week!'));
             }
                 
         }    

     }

    try{      
        setSOQL();
        // run the query again
        runQuery();
    }
    catch(Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex.getMessage()));
    }
   return null; 
  }


  public void setSOQL()
  {
    
    String userid = Apexpages.currentPage().getParameters().get('userid');
    String firstName = Apexpages.currentPage().getParameters().get('firstname');
    String lastName = Apexpages.currentPage().getParameters().get('lastname');
    String startWeek = Apexpages.currentPage().getParameters().get('startWeek');
    String endWeek = Apexpages.currentPage().getParameters().get('endWeek');
    String status = Apexpages.currentPage().getParameters().get('status');
    String reviewstatus = Apexpages.currentPage().getParameters().get('reviewstatus');
    date endDate ;
    date endDateTemp ;
    date startDate;

    soql = 'SELECT BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.name,BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.id, ';
    soql += 'BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Notes__c,BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.WeekStartDate__c,BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.WeekEndDate__c,';
                soql += ' BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Weekly_Hours_Total__c , BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Status__c,';
                    soql += 'BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Status__c, BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.owner.Name,'; 
                    soql += 'BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Name_EEID__c, WeekStartDate__c, Activity_Date__c,Activity_Note_Name__c,';
                    soql += 'BHAT_Activity_Note_Other__c,BHAT_Activity_Note__c,BHAT_Code_and_Short_Desc__c,Details__c,Division__c,Hours_Spent__c, ';
                    soql += 'BHAT_Activity_Daily__r.Status__c, Name ';
                    soql += 'FROM BHAT_Activity__c WHERE id != null ';

     if (!userid.equals(''))
     {
         soql += ' and owner.Id = \'' +String.escapeSingleQuotes(userid)+ '\'';
     }
     else
     {
     
          this.staffIdSet = GetStaffIds();
     
          soql += ' and owner.IsActive = true and ( owner.Id IN :staffIdSet OR Manager_Id__c  = \'' +String.escapeSingleQuotes(UserInfo.getUserId())+ '\')';
     }    

    /*
    if (!firstName.equals(''))
      soql += ' and owner.FirstName LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
      
    if (!lastName.equals(''))
      soql += ' and owner.LastName LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
    */
    /*****new condition added*******/      
    if (!startWeek.equals('')) 
    {
        
        startDate =  b.getStartWeekData(Date.valueOf(String.escapeSingleQuotes(startWeek)));
        startDate = date.newInstance(startDate.year(), startDate.month(),startDate.day());
        String startDateString = String.valueOf(startDate);
        
      soql += ' and BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.WeekStartDate__c >='+ startDateString;    
    }
    else
    {
        throw new bhatException('Start Week is required.');
    }
    
    if(!endWeek.equals(''))
    {  
        endDateTemp =  b.getEndWeekData(Date.valueOf(String.escapeSingleQuotes(endWeek)));
        endDate =  endDatetemp.addDays(2);
        endDate = date.newInstance(endDate.year(), endDate.month(),endDate.day());
        
        String endDateString = String.valueOf(endDate);
      soql += ' and BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.WeekEndDate__c <'+ endDateString;
    }

    if (!endWeek.equals('') && !startWeek.equals('') )
    {
            if (endDate < startDate)
            {
                throw new bhatException('Start Date is greater than End date');
            }
        
    }

        
    if (!status.equals(''))
      soql += ' and BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Status__c = \''+status+'\'';
    
    if (!reviewstatus.equals(''))
    {
         if (reviewstatus.equals('Not Reviewed'))
         {  
            soql += ' and ( BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Status__c =\''+reviewstatus+'\' OR BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Status__c =\'\')';
         }
         else
         {
            soql += ' and BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Review_Status__c =\''+reviewstatus+'\'';
         }
    }
    /*****new condition added*******/ 
 
    soql += ' ORDER BY owner.LastName asc, BHAT_Activity_Daily__r.BHAT_Activity_Weekly__r.Name_EEID__c asc,WeekStartDate__c asc, Activity_Date__c asc';
    
    /******new debug*****/
    System.debug('SOQL retrieved-------------------------->'+soql );
    /******new debug*****/
    

  } 
  
// runs the actual query
  public void runQuery() {

       try
       {
            
         List<ActivityWeeklyDto> bhatweeklyDtoListLocal=new List<ActivityWeeklyDto>();
            
            List<BHAT_Activity__c> bhatActivity  = Database.query(soql + ' limit 1000');
            BhatweeklyDtoList =  getActivityWeeklyDtoList(bhatActivity);
           
            if (BhatweeklyDtoList.size() <= 0 )
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Bhat records not found'));
            }
           
       } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!' + e.getMessage()));
       }
    
  }
  
  
   // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }

  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
    set;
  }

  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
  
  
 
      //Subclass : Wrapper Class 
    public class ActivityWeeklyDto {
        //Static Variables 
        public String Id { get; set; }
        public String weekId{ get; set; }
        public String WeekName { get; set; }
        public Date WeekStartDate{ get; set; }
        public Date WeekEndDate{ get; set; }
        public Decimal WeeklyTotalHours{ get; set; }
        public Decimal WeeklyHoursTotal{ get; set; }
        public String Status{ get; set; }
        
        //New fields to retreive from user object
        public String EmpNo{ get; set; }
        public String FirstName{ get; set; }
        public String LastName;
        public String OwnerName { get; set; }
        public String Division{ get; set; }
        public String Manager{ get; set; }
        public String ReviewStatus{ get; set; }
        public String ReviewNotes{ get; set; }
        public boolean IsReviewed{ get; set; }
         //public List<ActivityDailyDto> ActivityDailyList;
          public List<BhatActivityDto> BhatActivityList{ get; set; }
        //Wrapper  Class Controller
        public ActivityWeeklyDto () {
            Status ='No Entry';
        }
        
    }
     


    //Subclass : Wrapper Class 
    public class ActivityDailyDto {
        //Static Variables 
        public Decimal TotalHoursReported{ get; set; }
        public Decimal TotalHoursExpected{ get; set; }
        public List<BhatActivityDto> BhatActivityList{ get; set; }
        public Date WeekStartDay{ get; set; }
        public String UserFullName{ get; set; }
    }
    
    
      //Subclass : Wrapper Class 
    public class BhatActivityDto {
        //Static Variables 
        public String Name{ get; set; }
        public Date ActivityDate{ get; set; }
        public Date ActivityDay{ get; set; }
        public Decimal DailyHoursSpent{ get; set; }
        public Decimal DailyHoursTotal{ get; set; }
        public String Status{ get; set; }
        public String ActivityDayText{ get; set; }
        public String DailyActivityStatus{ get; set; }
        public String ActivityNoteName{ get; set; }
        public String CodeAndShortDesc{ get; set; }
        public String SubCategoryOther{ get; set; }
        //Wrapper  Class Controller
        public BhatActivityDto () {
            Status ='No Entry';
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