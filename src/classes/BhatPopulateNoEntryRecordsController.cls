public class BhatPopulateNoEntryRecordsController{

    // This Class being used Populate missing date with 'No Entry Status'
    
    public String BHAT_Update_Start_Date  {get;set;}
    public String BHAT_Update_End_Date  {get;set;}
    
    
    public BhatPopulateNoEntryRecordsController()
    {
        Common_Settings__c uhwCommentSettings = Common_Settings__c.getValues('UHWCommonSettings');  
        if (uhwCommentSettings!= NULL)
        {
            
            DateTime dtConverted_startDate = Datetime.newInstance(uhwCommentSettings.BHAT_Update_Start_Date__c.year(), uhwCommentSettings.BHAT_Update_Start_Date__c.month(),uhwCommentSettings.BHAT_Update_Start_Date__c.day(),0,0,0);
            BHAT_Update_Start_Date  =  dtConverted_startDate.format('MMM d,  yyyy');
            
            DateTime dtConverted_endDate = Datetime.newInstance(uhwCommentSettings.BHAT_Update_End_Date__c.year(), uhwCommentSettings.BHAT_Update_End_Date__c.month(),uhwCommentSettings.BHAT_Update_End_Date__c.day(),0,0,0);
            BHAT_Update_End_Date  =  dtConverted_endDate.format('MMM d,  yyyy');
        }
        else
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Bhat Update Date Range found in the custom setting: Common_Settings'));
            
        }
    }

    
    
    
     public void DeleteNoEntryRecords()
     {
     
        try
        {

            List<String> inactiveUsers = BhatPopulateNoEntryRecordsLib.DeleteNoEntryRecords();
            
            if (inactiveUsers.size() > 0 )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'The following inactive users records are not deleted:<br/>'  + String.join(inactiveUsers, '<br/>') ));
            }
            
            
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, '\'No Entry\' Records have been Deleted'));
        }
        catch( Exception ex)
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex));
        }
      }
    
     public void Populate()
     {
     
             try
             {
                
//              List<String> inactiveUsers =  BhatPopulateNoEntryRecordsLib.Populate(true);
                List<String> inactiveUsers =  BhatPopulateNoEntryRecordsLib.Populate(false); // Changed by GS 6/23/16                
            
                if (inactiveUsers.size() > 0 )
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'The following inactive users records are not updated:<br/>'  + String.join(inactiveUsers, '<br/>') ));
                }
            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, '\'No Entry\' Records have been populated'));
         
            }
            catch( Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:' + ex));
            
            }
         
     }
}