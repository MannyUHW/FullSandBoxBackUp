public class SOS_Time_off_Request_History {
    public List<SOS_Time_Off_Request__History> torHisLst;
    public List<SOS_Time_Off_Request__c> torLst;
    public SOS_Time_off_Request_History() {
        /*torHisLst = [Select s.ParentId, s.OldValue, s.NewValue, s.IsDeleted, s.Id, s.Field, s.CreatedDate, s.CreatedById From SOS_Time_Off_Request__History s];
        torLst = [Select s.Type__c, s.Total_Hours_Requested_hr_day__c, s.Total_Hours_Requested__c, s.Total_Hours_Requested_Hour_Day__c, s.Time_Off_Balance__c, 
        s.SystemModstamp, s.Status__c, s.Start_Date__c, s.Name, s.Manager_Pending_Date__c, s.Manager_Name__c, s.LastModifiedDate, s.LastModifiedById, 
        s.LastActivityDate, s.Is_Non_Exempt__c, s.IsDeleted, s.Id, s.Full_Day__c, s.End_Date__c, s.Employee_Type__c, s.Employee_Number__c, s.Employee_Name__c, 
        s.CreatedDate, s.CreatedById, s.Comments__c, s.Approved_Rejectd_by__c, s.Approve_Reject_Date__c From SOS_Time_Off_Request__c s];*/
    }
    
    public class HistoryTorWrap {
        
    }   

}