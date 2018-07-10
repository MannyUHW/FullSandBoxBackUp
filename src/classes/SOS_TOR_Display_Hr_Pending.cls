public class SOS_TOR_Display_Hr_Pending {
    public List<SOS_Time_Off_Request__c> hrPendingLst {get;set;}
    public String recId {get;set;}
    Set<Id> hrGroupSet=new Set<Id>();
    public Boolean isDisplay{set;get;}
    public Boolean isExempt {get;set;}
    public SOS_TOR_Display_Hr_Pending(ApexPages.standardController controller) {
        User usr = [Select Id,Non_Exempt_Employee__c from user where id =: userinfo.getUserId() limit 1];
        if(usr.Non_Exempt_Employee__c)
            isExempt = false;
        else
            isExempt = true;
        // Loop through all group members in a group
        for (GroupMember m : [Select Id,UserOrGroupId From GroupMember Where GroupId =: System.Label.HR_Group_Id]){
                hrGroupSet.add(m.UserOrGroupId);
        }
        if(hrGroupSet.contains(userinfo.getuserid()))
            isDisplay = true;
        else
            isDisplay = False;
        hrPendingLst = [Select Id, name, Status__c, Type__c,Employee_Name__c, Employee_Number__c,
         Manager_Name__c, Total_Hours_Requested__c, Start_Date__c, End_Date__c, Total_Hours_Requested_Hour_Day__c, Time_Off_Remaining_by_type__c, CreatedDate, 
         Comments__c from SOS_Time_Off_Request__c where Status__c='HR Pending'];
    }
    public pageReference navRecord() {
        pageReference recDetail = new pageReference('/apex/SOS_HR_Approval?id='+recId);
        return recDetail;
    }
}