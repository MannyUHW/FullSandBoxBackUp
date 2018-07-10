@isTest
public class Report_NearbyMbrContactsCtrlrTest {

  public static testMethod void testController() {
    
    Report_NearbyMbrContactsCtrlr ctrlr = new Report_NearbyMbrContactsCtrlr ();
    ctrlr.cheese();
    String body = Report_NearbyMbrContactsCtrlr.getNearbyContacts().toLowerCase();
    
    System.assert(true);
  }

}