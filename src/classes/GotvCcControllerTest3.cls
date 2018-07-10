@isTest (seeAllData=true) private class GotvCcControllerTest3 {

  @isTest static void test3_1() {
    System.debug('test3_1() start');

    String usrDebug,department,title; 
    String adminName,dirName,coordName;
    Id adminId,dirId,coordId;
    User usr;

    Map<Id, User> userList = new Map<ID, User>([
      SELECT Id,Department,Division,FirstName,LastName,License_Name__c,Profile.Name,Title FROM 
      User WHERE IsActive = true AND (Department = 'OPS/FIN-DATA' Or (Title Like 'Database%' Or (Division = 'Kaiser' AND (Title Like 'Director%' OR Title Like 'Coordinator%' ) ) ) )
    ]);

    for (ID idKey : userList.keyset()) {
        usr = userList.get(idKey);
        usrDebug = usr.FirstName + ' ' + usr.LastName + ' | ' + usr.Title;

        department = usr.Department;
        title      = usr.Title;

        if(department.contains('OPS/FIN-DATA')) {
          adminName = usr.FirstName + ' ' + usr.LastName;
          adminId   = usr.Id;
        }

        if(department == 'KAISER' && title.contains('DIRECTOR')) {
          dirName   = usr.FirstName + ' ' + usr.LastName;
          dirId     = usr.Id;
        }

        if(title.contains('COORDINATOR')) {
          coordName = usr.FirstName + ' ' + usr.LastName;
          coordId   = usr.Id;
        }
    }

    System.debug(adminName + ' - ' + adminId);
    System.debug(dirName   + ' - ' + dirId);
    System.debug(coordName + ' - ' + coordId);

    List<Account> getOneList = [SELECT Id FROM Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' And Active__c = 'YES' LIMIT 1];
    System.debug('Account is:');

    Account getOne = getOneList[0];
    integer l;
    System.debug(getOne.Id);

    List <Contact> adminTestData = GotvCcController.getGotvContactData(getOne.Id, null, 'Admin', adminId );
    l = adminTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> dirTestData = GotvCcController.getGotvContactData(getOne.Id, null, 'Super', dirId );
    l = dirTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> coordTestData = GotvCcController.getGotvContactData(getOne.Id, null, 'Regular', coordId );
    l = coordTestData.size();
    system.assertNotEquals(l,0);

    System.debug('test3_1() end');
  }

  @isTest static void test3_2() {
    System.debug('test3_2() start');

    List<Account> getOneList = [SELECT Id FROM Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' And Active__c = 'YES' LIMIT 1];
    System.debug('Account is:');

    Account getOne = getOneList[0];
    System.debug(getOne.Id);

    String usrDebug,department,title; 
    String adminName,dirName,coordName;
    Id adminId,dirId,coordId;
    User usr;

    Map<Id, User> userList = new Map<ID, User>([
      SELECT Id,Department,Division,FirstName,LastName,License_Name__c,Profile.Name,Title FROM 
      User WHERE IsActive = true AND (Department = 'OPS/FIN-DATA' Or (Title Like 'Database%' Or (Division = 'Kaiser' AND (Title Like 'Director%' OR Title Like 'Coordinator%' ) ) ) )
    ]);

    for (ID idKey : userList.keyset()) {
        usr = userList.get(idKey);
        usrDebug = usr.FirstName + ' ' + usr.LastName + ' | ' + usr.Title;

        department = usr.Department;
        title      = usr.Title;

        if(department.contains('OPS/FIN-DATA')) {
          adminName = usr.FirstName + ' ' + usr.LastName;
          adminId   = usr.Id;
        }

        if(department == 'KAISER' && title.contains('DIRECTOR')) {
          dirName   = usr.FirstName + ' ' + usr.LastName;
          dirId     = usr.Id;
        }

        if(title.contains('COORDINATOR')) {
          coordName = usr.FirstName + ' ' + usr.LastName;
          coordId   = usr.Id;
        }
    }

    System.debug(adminName + ' - ' + adminId);
    System.debug(dirName   + ' - ' + dirId);
    System.debug(coordName + ' - ' + coordId);    

    integer l,utcD,utcM,utcY,utcH,utcZ,utcS;

    List <Contact> adminTestData = GotvCcController.getGotvContactData(getOne.Id, null, 'Admin', adminId );
    l = adminTestData.size();
    system.assertNotEquals(l,0);

    DateTime dt = adminTestData[0].LastModifiedDate;

    List<Integer> dtArray = new List<Integer>();
    utcD = dt.day();
    utcM = dt.month();
    utcY = dt.year();
    utcH = dt.hour();
    utcZ = dt.minute();
    utcS = dt.second();
    dtArray.add(utcD);
    dtArray.add(utcM);
    dtArray.add(utcY);
    dtArray.add(utcH);
    dtArray.add(utcZ);
    dtArray.add(utcS);
    Datetime myDateTime = Datetime.newInstance(utcY, utcM, utcD, utcH-12, utcZ, utcS-5);
    System.debug(myDateTime);

    adminTestData = GotvCcController.getGotvContactData(getOne.Id, dtArray, 'Admin', adminId );
    l = adminTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> dirTestData = GotvCcController.getGotvContactData(getOne.Id, dtArray, 'Super', dirId );
    l = dirTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> coordTestData = GotvCcController.getGotvContactData(getOne.Id, dtArray, 'Regular', coordId );
    l = coordTestData.size();
    system.assertNotEquals(l,0);
    
    System.debug('test3_2() end');
  }

  @isTest static void test3_3() {
    System.debug('test3_3() start');

    String usrDebug,department,title; 
    String adminName,dirName,coordName,teamRole;
    Id ownerId, accountId, userId, adminId, dirId, orgId;
    User usr;

    User[] adminList = [
      SELECT Id
      FROM User
      WHERE IsActive = true AND Profile.Name = 'System Administrator' And Employee_ID__c != null ORDER BY LastName Desc Limit 1];
    
    adminId   = adminList[0].Id;

    AccountTeamMember[] teamMembers = [
      SELECT AccountId, TeamMemberRole, UserId
      From AccountTeamMember 
      Where Account.Name = 'KAISER-ANTIOCH' AND TeamMemberRole IN ('Regional Director','Organizer1') 
      Order By AccountId, TeamMemberRole];

    for(AccountTeamMember tm : teamMembers) {
      accountId = tm.AccountId;
      teamRole  = tm.TeamMemberRole;
      userId    = tm.UserId;
      if(teamRole.toLowerCase() == 'regional director' )  {
        dirId   = userId;
      }
      if(teamRole.toLowerCase() == 'organizer1' )  {
        orgId   = userId;
      }
    }

    System.debug(adminId);
    System.debug(dirId);
    System.debug(orgId);

    integer l;
    List <Contact> adminTestData = GotvCcController.getDataEntryContactData(accountId, null, 'Admin', adminId );
    l = adminTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> dirTestData = GotvCcController.getDataEntryContactData(accountId, null, 'Super', dirId );
    l = dirTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> coordTestData = GotvCcController.getDataEntryContactData(accountId, null, 'Regular', orgId );
    l = coordTestData.size();
    system.assertNotEquals(l,0);

    System.debug('test3_3() end');
  }

  @isTest static void test3_4() {
    System.debug('test3_3() start');

    String usrDebug,department,title; 
    String adminName,dirName,coordName,teamRole;
    Id ownerId, accountId, userId, adminId, dirId, orgId;
    User usr;

    User[] adminList = [
      SELECT Id
      FROM User
      WHERE IsActive = true AND Profile.Name = 'System Administrator' And Employee_ID__c != null ORDER BY LastName Desc Limit 1];
    
    adminId   = adminList[0].Id;

    AccountTeamMember[] teamMembers = [
      SELECT AccountId, TeamMemberRole, UserId
      From AccountTeamMember 
      Where Account.Name = 'KAISER-ANTIOCH' AND TeamMemberRole IN ('Regional Director','Organizer1') 
      Order By AccountId, TeamMemberRole];

    for(AccountTeamMember tm : teamMembers) {
      accountId = tm.AccountId;
      teamRole  = tm.TeamMemberRole;
      userId    = tm.UserId;
      if(teamRole.toLowerCase() == 'regional director' )  {
        dirId   = userId;
      }
      if(teamRole.toLowerCase() == 'organizer1' )  {
        orgId   = userId;
      }
    }

    System.debug(adminId);
    System.debug(dirId);
    System.debug(orgId);

    integer l,utcD,utcM,utcY,utcH,utcZ,utcS;
    List<Integer> dtArray = new List<Integer>();

    AggregateResult[] maxDates;
    maxDates = [
      SELECT AccountId, Max(LastModifiedDate) MaxChangeDate
      FROM Contact
      WHERE Account.Name = 'KAISER-ANTIOCH'
      GROUP BY AccountId
    ];
    
    System.debug(maxDates[0]);
    
    Datetime maxChangeDate;
    for(AggregateResult maxDateRec : maxDates) {
      accountId     = (Id)       maxDateRec.get('AccountId');
      maxChangeDate = (Datetime) maxDateRec.get('MaxChangeDate');
    }
    System.debug(accountId);
    System.debug(maxChangeDate);

    List <Contact> adminTestData = GotvCcController.getGotvContactData(accountId, null, 'Admin', adminId );
    l = adminTestData.size();
    system.assertNotEquals(l,0);

    utcD = maxChangeDate.day();
    utcM = maxChangeDate.month();
    utcY = maxChangeDate.year();
    utcH = maxChangeDate.hour();
    utcZ = maxChangeDate.minute();
    utcS = 0;
    if(utcZ > 10) {
      utcZ = utcZ -10;
    }
    dtArray.add(utcD);
    dtArray.add(utcM);
    dtArray.add(utcY);
    dtArray.add(utcH);
    dtArray.add(utcZ);
    dtArray.add(utcS);

    adminTestData = GotvCcController.getDataEntryContactData(accountId, dtArray, 'Admin', adminId );
    l = adminTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> dirTestData = GotvCcController.getDataEntryContactData(accountId, dtArray, 'Super', dirId );
    l = dirTestData.size();
    system.assertNotEquals(l,0);

    List <Contact> coordTestData = GotvCcController.getDataEntryContactData(accountId, dtArray, 'Regular', orgId );
    l = coordTestData.size();
    system.assertNotEquals(l,0);

    System.debug('test3_4() end');
  }

  @isTest static void test3_5() {
    System.debug('test3_5() start');

    List<Contact> getOneList = [SELECT Id,AccountId  FROM Contact WHERE Account.Account_Group__c = 'Kaiser' AND In_Current_BU__c = true LIMIT 1];
    Contact getOne = getOneList[0];
    System.debug('Account is:');
    System.debug(getOne.AccountId);
    System.debug('Contact is:');
    System.debug(getOne.Id);

    List <XMatch__c> res = GotvCcController.getXMatchDetail();
    Integer l = res.size();
    system.assertNotEquals(l,0);

    System.debug('test3_5() end');
  }  

}