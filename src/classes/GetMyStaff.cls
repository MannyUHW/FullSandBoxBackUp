public class GetMyStaff 
{ 
    public String obj;
    public List<User> usrs{get;set;}
    
    public GetMyStaff() 
    {    
        usrs = [SELECT Id, Name, Department,FirstName,LastName,User.Manager.Name,Manager_First_Name__c,Manager_Last_Name__c,Staff_Contact_Id__c,Title FROM User WHERE Manager_First_Name__c = :UserInfo.getFirstName() AND Manager_Last_Name__c= :UserInfo.getLastName() AND IsActive = True order by Name];
    }       
}