@isTest
public class COPEController3v4Test {

    public static testMethod void test() {

        PageReference tpageRef = Page.Cope_Report_3v4;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('arg', '2');
    
        COPE_data__c copedata = new COPE_data__c();
    
        copedata.Division__c= '';
        copedata.CoordinatorLastName__c= 'Wood';
        copedata.CoordinatorFirstName__c= 'John';
        copedata.FieldRepLastName__c= 'Longwell';
        copedata.NewCOPETotal__c = 2;
        copedata.NewCOPECount__c = 2;
        copedata.COPEIncreaseTotalPerSeat__c = 2;
        copedata.COPEIncreaseCountPerSeat__c = 2;
        copedata.COPETotalPerSeat__c = 2;
        copedata.COPECountPerSeat__c = 2;
        copedata.COPECountTenPlusPerSeat__c = 2;
        copedata.EmpCountPerSeat__c = 2;
        copedata.COPETotalPerSeat_3__c = 2;
        copedata.COPECountPerSeat_3__c = 2;
        copedata.COPECountTenPlusPerSeat_3__c = 2;
        copedata.EmpCountPerSeat_3__c = 2;
        copedata.COPETotalPerSeat_6__c = 2;
        copedata.COPECountPerSeat_6__c = 2;
        copedata.COPECountTenPlusPerSeat_6__c = 2;
        copedata.EmpCountPerSeat_6__c = 2;
        copedata.COPETotalPerSeat_9__c = 2;
        copedata.COPECountPerSeat_9__c = 2;
        copedata.COPECountTenPlusPerSeat_9__c = 2;
        copedata.EmpCountPerSeat_9__c = 2;
        copedata.COPETotalPerSeat_12__c = 2;
        copedata.COPECountPerSeat_12__c = 2;
        copedata.COPECountTenPlusPerSeat_12__c = 2;
        copedata.EmpCountPerSeat_12__c = 2;
        
        insert copedata;
        
        copedata = new COPE_data__c();
    
        copedata.Division__c= '';
        copedata.CoordinatorLastName__c= 'Wood2';
        copedata.CoordinatorFirstName__c= 'John2';
        copedata.FieldRepLastName__c= 'Longwell2';
        copedata.NewCOPETotal__c = 2;
        copedata.NewCOPECount__c = 2;
        copedata.COPEIncreaseTotalPerSeat__c = 2;
        copedata.COPEIncreaseCountPerSeat__c = 2;
        copedata.COPETotalPerSeat__c = 2;
        copedata.COPECountPerSeat__c = 2;
        copedata.COPECountTenPlusPerSeat__c = 2;
        copedata.EmpCountPerSeat__c = 2;
        copedata.COPETotalPerSeat_3__c = 2;
        copedata.COPECountPerSeat_3__c = 2;
        copedata.COPECountTenPlusPerSeat_3__c = 2;
        copedata.EmpCountPerSeat_3__c = 2;
        copedata.COPETotalPerSeat_6__c = 2;
        copedata.COPECountPerSeat_6__c = 2;
        copedata.COPECountTenPlusPerSeat_6__c = 2;
        copedata.EmpCountPerSeat_6__c = 2;
        copedata.COPETotalPerSeat_9__c = 2;
        copedata.COPECountPerSeat_9__c = 2;
        copedata.COPECountTenPlusPerSeat_9__c = 2;
        copedata.EmpCountPerSeat_9__c = 2;
        copedata.COPETotalPerSeat_12__c = 2;
        copedata.COPECountPerSeat_12__c = 2;
        copedata.COPECountTenPlusPerSeat_12__c = 2;
        copedata.EmpCountPerSeat_12__c = 2;

        insert copedata;

        COPEController3v4 ctrlr = new COPEController3v4();
        System.AssertNotEquals(null,ctrlr);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('arg', '11');
        
        List<COPE_data__c> output = ctrlr.getbyDivOrgRep();
        System.assertNotEquals(null,output);

    }
}