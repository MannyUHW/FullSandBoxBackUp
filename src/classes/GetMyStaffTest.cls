@isTest
public class GetMyStaffTest {

static testMethod void testGetMyStaff() 
{

//Set up user1
        User u1 = [SELECT Id FROM User WHERE FirstName='Fola'];

//Run As U1
System.RunAs(u1){

GetMyStaff s = new GetMyStaff();
List<User> s1lst = s.usrs;

}//end RunAs(u1)

}
}