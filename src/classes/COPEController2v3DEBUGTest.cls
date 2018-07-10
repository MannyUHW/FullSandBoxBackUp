@isTest(SeeAllData=true)
public class COPEController2v3DEBUGTest {

    public static testMethod void test() {

        COPE_data__c copedata = new COPE_data__c();

        copedata.Cell1Class__c            = '1';
        copedata.CommitteeMbrFirstName__c = 'CommFirstName';
        copedata.CommitteeMbrLastName__c  = 'CommLatName';
        copedata.CommitteeMbrName__c      = 'CommitteeMbrName';
        copedata.CoordinatorFirstName__c  = 'CoordinatorFirstName';
        copedata.CoordinatorLastName__c   = 'CoordinatorLastName';
        copedata.COPECountPerSeat__c      = 1;
        copedata.COPECountPerSeat_1__c    = 2;
        copedata.COPECountPerSeat_12__c   = 3;
        copedata.COPECountPerSeat_2__c    = 4;
        copedata.COPECountPerSeat_3__c    = 4;
        copedata.COPECountPerSeat_4__c    = 4;
        copedata.COPECountPerSeat_5__c    = 4;
        copedata.COPECountPerSeat_6__c    = 4;
        copedata.COPECountPerSeat_9__c          = 4;
        copedata.COPECountTenPlusPerSeat__c     = 4;
        copedata.COPECountTenPlusPerSeat_1__c   = 4;
        copedata.COPECountTenPlusPerSeat_12__c  = 4;
        copedata.COPECountTenPlusPerSeat_2__c   = 4;
        copedata.COPECountTenPlusPerSeat_3__c   = 4;
        copedata.COPECountTenPlusPerSeat_4__c   = 4;
        copedata.COPECountTenPlusPerSeat_5__c   = 4;
        copedata.COPECountTenPlusPerSeat_9__c   = 4;
        copedata.COPECountTenPlusPerSeat_6__c   = 4;
        copedata.COPEIncreaseCountPerSeat__c    = 4;
        copedata.COPEIncreaseTotalPerSeat__c    = 4;
        copedata.COPEPercent__c           = 4;
        copedata.COPEPercent_1__c         = 4;
        copedata.COPEPercent_12__c        = 4;
        copedata.COPEPercent_2__c         = 4;
        copedata.COPEPercent_3__c         = 4;
        copedata.COPEPercent_4__c         = 4;
        copedata.COPEPercent_5__c         = 4;
        copedata.COPEPercent_6__c         = 4;
        copedata.COPEPercent_9__c         = 4;
        copedata.COPEPercentTen__c        = 4;
        copedata.COPEPercentTen_1__c      = 4;
        copedata.COPEPercentTen_12__c     = 4;
        copedata.COPEPercentTen_2__c      = 4;
        copedata.COPEPercentTen_3__c      = 4;
        copedata.COPEPercentTen_4__c      = 4;
        copedata.COPEPercentTen_5__c      = 4;
        copedata.COPEPercentTen_6__c      = 4;
        copedata.COPEPercentTen_9__c      = 4;
        copedata.COPETotalPerSeat__c      = 4;
        copedata.COPETotalPerSeat_1__c    = 4;
        copedata.COPETotalPerSeat_12__c   = 4;
        copedata.COPETotalPerSeat_2__c    = 4;
        copedata.COPETotalPerSeat_3__c    = 4;
        copedata.COPETotalPerSeat_4__c    = 4;
        copedata.COPETotalPerSeat_5__c    = 4;
        copedata.COPETotalPerSeat_6__c    = 4;
        copedata.COPETotalPerSeat_9__c    = 4;
        copedata.Current_Month__c         = 'Test';
        copedata.District__c              = '7';
        copedata.Division__c              = 'Kaiser';
        copedata.eBoardFirstName__c       = 'Vacant';
        copedata.eBoardLastName__c        = 'Vacant';
        copedata.EboardNames__c           = 'Vacant';
        copedata.EmpCountPerSeat__c       = 4; 
        copedata.EmpCountPerSeat_1__c     = 4;
        copedata.EmpCountPerSeat_12__c    = 4;
        copedata.EmpCountPerSeat_2__c     = 4;
        copedata.EmpCountPerSeat_3__c     = 4;
        copedata.EmpCountPerSeat_4__c     = 4;
        copedata.EmpCountPerSeat_5__c     = 4;
        copedata.EmpCountPerSeat_6__c     = 4;
        copedata.EmpCountPerSeat_9__c     = 4;
        copedata.Employer__c              = 'Test';
        copedata.EmployerId__c            = 1; 
        copedata.FieldRepFirstName__c     = 'Test'; 
        copedata.FieldRepLastName__c      = 'Test'; 
        copedata.NewCOPECount__c          = 5;
        copedata.NewCOPETotal__c          = 10;
        copedata.OutputColumn1__c         = '';
        copedata.SeatID__c                = 'KSAA'; 
        copedata.SeatName__c              = 'Seat Test';
        copedata.UWG__c                   = 1;

        insert copedata;

        COPEController2v3DEBUG ctrlr = new COPEController2v3DEBUG();
        System.AssertNotEquals(null,ctrlr);

        String cm = ctrlr.getCurrentMonth();
        System.AssertNotEquals(null,cm);

        List<COPE_data__c> output = ctrlr.getbyDivPodEboard();
        System.assertNotEquals(null,output);

        Integer i = ctrlr.fudgeit();
        
    }
}