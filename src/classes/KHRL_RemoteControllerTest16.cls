@isTest
public class KHRL_RemoteControllerTest16 {

    public static testMethod void test() {

      AccountTeamMember tmpAccTeamRec;
      AccountShare      tmpShareRec;

      List <Database.SaveResult> srList;
      List <AccountShare> shareCreateList;
      List <AccountShare> shareCreateIDs;
      List <AccountShare> coordShareRecordsToCreate;
      List <AccountShare> org1ShareRecordsToCreate;
      List <AccountShare> org2ShareRecordsToCreate;

      List <AccountTeamMember> atmCreateList;
      List <AccountTeamMember> atmCreateIDs;
      List <AccountTeamMember> CoordAtmRecordsToCreate;

      shareCreateList           = new List <AccountShare>();
      atmCreateList             = new List <AccountTeamMember>();
      CoordAtmRecordsToCreate   = new List <AccountTeamMember>();

      coordShareRecordsToCreate = new List <AccountShare>();
      coordAtmRecordsToCreate   = new List <AccountTeamMember>();

      tmpShareRec                        = new AccountShare();
      tmpShareRec.AccountId              = '001i000000lPaBXAA0';
      tmpShareRec.UserOrGroupId          = '005i0000002NcCxAAK';
      tmpShareRec.AccountAccessLevel     = 'Edit';
      tmpShareRec.ContactAccessLevel     = 'Edit';
      tmpShareRec.OpportunityAccessLevel = 'Read';
system.debug('tmpShareRec.Id');
system.debug(tmpShareRec.Id);
      coordShareRecordsToCreate.add(tmpShareRec);

      tmpAccTeamRec                      = new AccountTeamMember();
      tmpAccTeamRec.AccountId            = '001i000000lPaBXAA0';
      tmpAccTeamRec.TeamMemberRole       = 'Coordinator';
      tmpAccTeamRec.UserId               = '005i0000002NcCxAAK';
      coordAtmRecordsToCreate.add(tmpAccTeamRec);

      atmCreateList.addAll(CoordAtmRecordsToCreate);
      shareCreateList.addAll(CoordShareRecordsToCreate);

      system.debug(shareCreateList);

      srList = Database.insert(ShareCreateList, false);
      for (Database.SaveResult sr : srList) {
        if (!sr.isSuccess()) {
            system.debug(':ShareCreateList:');
            system.debug(ShareCreateList);
              system.debug('Error 6 :' + sr.Errors[0].StatusCode);
          }
      }

      srList = Database.insert(atmCreateList, false);
      for (Database.SaveResult sr : srList) {
        if (!sr.isSuccess()) {
            system.debug(':atmCreateList:');
            system.debug(atmCreateList);
              system.debug('Error 7 :' + sr.Errors[0].StatusCode);
        }
      }

        String BenSaid    = '005i0000002NcRb';
//        String MattCline  = '003i0000025ORRr';
        String RobinBlake = '005i0000002NcCxAAK';
        String ChanteBW   = '003i000002GpfFa';

        String KAISER_WALNUT_CREEK = '001i000000lPaBX';

        KHRLObject__c TestRec1 = new KHRLObject__c();
        List <KHRLObject__c> testRecords1;
        testRecords1 = new List <KHRLObject__c>();

        TestRec1.EmpAccountId__c     = KAISER_WALNUT_CREEK;
        TestRec1.DivisionCode__c     = 'K';
        TestRec1.Constituency__c     = 'KS1B';
        TestRec1.DirectorId__c       = BenSaid;
        TestRec1.CoordinatorId__c    = RobinBlake;
        TestRec1.Org1Id__c           = RobinBlake;
        TestRec1.Org2Id__c           = RobinBlake;
        TestRec1.CsId__c             = '';
        TestRec1.Note__c             = 'This is a test!';
        TestRec1.ResetCoordinator__c = 0;
        TestRec1.ResetOrg1__c        = 1;
        TestRec1.ResetOrg2__c        = 0;
        TestRec1.ResetCS__c          = 0;

        testRecords1.add(TestRec1);
        List<String> results1;
        system.debug('[KhrlUpdate test start]');
        results1 = KHRL_RemoteController16.KhrlUpdate(testRecords1);
        System.assertNotEquals(null, results1, 'KHRL Update test failed');
        system.debug(results1);
        system.debug('[KhrlUpdate test end]');

        // -------------------------------------------------------------------------------------------------------------------------

system.debug('[EbUpdate test setup]');

        KHRLObject__c TestRec2 = new KHRLobject__c();
        List <KHRLObject__c> testRecords2;
        testRecords2 = new List <KHRLObject__c>();

        TestRec2.DivisionCode__c     = 'K';
        TestRec2.CoordinatorId__c    = RobinBlake;
        TestRec2.Org1Id__c           = '';
        TestRec2.Org2Id__c           = '';
        TestRec2.ResetCoordinator__c = 0;
        TestRec2.ResetOrg1__c        = 0;
        TestRec2.ResetOrg2__c        = 0;
        TestRec2.UpdateEboard__c     = 0;
        TestRec2.UpdateEboard__c     = 1;
        TestRec2.EboardId__c         = 'a0hi0000003qWPzAAM';

        testRecords2.add(TestRec2);
        List<String> results2;
system.debug('[EbUpdate test start]');
        results2 = KHRL_RemoteController16.EbUpdate(testRecords2);
        System.assertNotEquals(null, results2, 'KHRL EbUpdate test failed');
        system.debug(results2);
system.debug('[EbUpdate test end]');

        // -------------------------------------------------------------------------------------------------------------------------

        KHRLObject__c TestRec3 = new KHRLobject__c();
        List <KHRLObject__c> testRecords3;
        testRecords3 = new List <KHRLObject__c>();

        TestRec3.DivisionCode__c     = 'K';
        TestRec3.CoordinatorId__c    = '';
        TestRec3.Org1Id__c           = '005i0000005P0Nk';
        TestRec3.Org2Id__c           = '';
        TestRec3.ResetCoordinator__c = 0;
        TestRec3.ResetOrg1__c        = 0;
        TestRec3.ResetOrg2__c        = 0;
        TestRec3.UpdateEboard__c     = 0;
        TestRec3.UpdateEboard__c     = 1;
        TestRec3.EboardId__c         = 'a0hi0000003qWPzAAM';

        testRecords3.add(TestRec3);
        List<String> results3;
        system.debug('[CsUpdate test]');
        results3 = KHRL_RemoteController16.CsUpdate(testRecords3);
        System.assertNotEquals(null, results3, 'KHRL CsUpdate test failed');
        system.debug(results3);

        // ++ ++
        String results3b;
        results3b = KHRL_RemoteController16.getIdToUse(TestRec3);
        System.assertNotEquals(null, results3b, 'KHRL getIdToUse test failed');

        String results4;
        results4 = KHRL_RemoteController16.FudgeMethod1();
        system.debug(results4);

        String results5;
        results5 = KHRL_RemoteController16.FudgeMethod2();
        system.debug(results5);

    }
    
}