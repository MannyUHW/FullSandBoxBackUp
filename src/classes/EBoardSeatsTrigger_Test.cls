@isTest(SeeAllData =true)
  public class EBoardSeatsTrigger_Test{
  
    public static testMethod void testEBSUpdate(){
    
          Test.startTest();
          EBoardSeats__c eb = [select SeatHolder__c from EBoardSeats__c where SeatHolder__c != null LIMIT 1];
          Id formerId = eb.SeatHolder__c;
          
          eb.SeatHolder__c = null;   //set to null to test that Contact is correctly having its Executive Title cleared.
          Update eb;
          Test.stopTest();
     
          Contact c = [select Executive_Body_Title__c from Contact where Id = :formerId];
          if (c.Executive_Body_Title__c == null)
          {
             System.assert(true);
          }
          else
             System.assert(false);
    }
      
    public static testMethod void testEBSUnseatAll(){
          Test.startTest();
          List<EBoardSeats__c> ebsSeated = [select SeatHolder__c from EBoardSeats__c where SeatHolder__c != null];
           
          for (EBoardSeats__c ebs : ebsSeated)
          {  
                ebs.SeatHolder__c = null;
          }
          update ebsSeated;
          Test.stopTest();
    }      
 }