@isTest (seeAllData=true) private class LeaderOutreachTxTest {
  
  @isTest static void test1() {

    System.debug('test1() start');
    
        string LeaderFirstName;
        string LeaderLastName;
        string MemberFirstName;
        string MemberLastName;
        string EmpId;
        string Answer1;
        string Answer2;
        string Answer3;
        string Answer4;
        string MemberEmail;
        string MemberDepartment;
        string MemberCellPhone;
        string MemberEmpId;
        LeaderOutreachTx tmpLeaderOutreachTx,tmpLeaderOutreachTxFromJSON;
        string tmpLeaderOutreachTxStr;

        LeaderFirstName  = 'Graham';
        LeaderLastName   = 'Smith';
        MemberFirstName  = 'Jake';
        MemberLastName   = 'Decker';
        EmpId            = '123';
        Answer1          = 'A1';
        Answer2          = 'A2';
        Answer3          = 'A3';
        Answer4          = 'A4';
        MemberEmail      = 'T@Test.com';
        MemberDepartment = 'Test';
        MemberCellPhone  = '123 456 7890';
        MemberEmpId      = '666';

        tmpLeaderOutreachTx = new LeaderOutreachTx();
        tmpLeaderOutreachTx.LeaderFirstName  = LeaderFirstName;
        tmpLeaderOutreachTx.LeaderLastName   = LeaderLastName;
        tmpLeaderOutreachTx.MemberFirstName  = MemberFirstName;
        tmpLeaderOutreachTx.MemberLastName   = MemberLastName;
        tmpLeaderOutreachTx.Answer1          = Answer1;
        tmpLeaderOutreachTx.Answer2          = Answer2;
        tmpLeaderOutreachTx.Answer3          = Answer3;
        tmpLeaderOutreachTx.Answer4          = Answer4;
        tmpLeaderOutreachTx.MemberEmail      = MemberEmail;
        tmpLeaderOutreachTx.MemberDepartment = MemberDepartment;
        tmpLeaderOutreachTx.MemberCellPhone  = MemberCellPhone;
        tmpLeaderOutreachTx.MemberEmpId      = MemberEmpId;

        System.assertEquals(tmpLeaderOutreachTx.LeaderFirstName,  LeaderFirstName);
        System.assertEquals(tmpLeaderOutreachTx.LeaderLastName,   LeaderLastName);
        System.assertEquals(tmpLeaderOutreachTx.MemberFirstName,  MemberFirstName);
        System.assertEquals(tmpLeaderOutreachTx.MemberLastName,   MemberLastName);
        System.assertEquals(tmpLeaderOutreachTx.Answer1,          Answer1);
        System.assertEquals(tmpLeaderOutreachTx.Answer2,          Answer2);
        System.assertEquals(tmpLeaderOutreachTx.Answer3,          Answer3);
        System.assertEquals(tmpLeaderOutreachTx.Answer4,          Answer4);
        System.assertEquals(tmpLeaderOutreachTx.MemberEmail,      MemberEmail);
        System.assertEquals(tmpLeaderOutreachTx.MemberDepartment, MemberDepartment);
        System.assertEquals(tmpLeaderOutreachTx.MemberCellPhone,  MemberCellPhone);
        System.assertEquals(tmpLeaderOutreachTx.MemberEmpId,      MemberEmpId);

        tmpLeaderOutreachTxStr       = JSON.serialize(tmpLeaderOutreachTx);
        tmpLeaderOutreachTxFromJSON  = LeaderOutreachTx.parse(tmpLeaderOutreachTxStr);

        System.assertEquals(tmpLeaderOutreachTx.LeaderFirstName,  tmpLeaderOutreachTxFromJSON.LeaderFirstName);
        System.assertEquals(tmpLeaderOutreachTx.LeaderLastName,   tmpLeaderOutreachTxFromJSON.LeaderLastName);
        System.assertEquals(tmpLeaderOutreachTx.MemberFirstName,  tmpLeaderOutreachTxFromJSON.MemberFirstName);
        System.assertEquals(tmpLeaderOutreachTx.MemberLastName,   tmpLeaderOutreachTxFromJSON.MemberLastName);
        System.assertEquals(tmpLeaderOutreachTx.Answer1,          tmpLeaderOutreachTxFromJSON.Answer1);
        System.assertEquals(tmpLeaderOutreachTx.Answer2,          tmpLeaderOutreachTxFromJSON.Answer2);
        System.assertEquals(tmpLeaderOutreachTx.Answer3,          tmpLeaderOutreachTxFromJSON.Answer3);
        System.assertEquals(tmpLeaderOutreachTx.Answer4,          tmpLeaderOutreachTxFromJSON.Answer4);
        System.assertEquals(tmpLeaderOutreachTx.MemberEmail,      tmpLeaderOutreachTxFromJSON.MemberEmail);
        System.assertEquals(tmpLeaderOutreachTx.MemberDepartment, tmpLeaderOutreachTxFromJSON.MemberDepartment);
        System.assertEquals(tmpLeaderOutreachTx.MemberCellPhone,  tmpLeaderOutreachTxFromJSON.MemberCellPhone);
        System.assertEquals(tmpLeaderOutreachTx.MemberEmpId,      tmpLeaderOutreachTxFromJSON.MemberEmpId);

        System.debug('test1() end');
  }
}