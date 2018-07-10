@isTest(SeeAllData = true)
public class Report_Custom_Utils_TEST {
    
    
        public static testMethod void testClass(){
          Report_Custom_Utils.toProperCase('salesforce SALESFORCE SEIU-UHW');
          Report_Custom_Utils.formatPhone('3235551234');
          Report_Custom_Utils.calculateDistance(34.010223, -118.156906, 37.809834, -122.271048);
        }
        
}