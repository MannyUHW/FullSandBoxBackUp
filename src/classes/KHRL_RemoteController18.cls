public class KHRL_RemoteController18 {

    public static String getIdToUse(KHRLObject__c r) {

      List <AccountTeamMember> currentCoordinator;
      String retIdToUse;
      if (!String.IsEmpty(r.Org1Id__c)) {
        retIdToUse = r.Org1Id__c;
      }
      else {
        if (!String.IsEmpty(r.CoordinatorId__c)) {
          retIdToUse = r.CoordinatorId__c;
        }
        else {
          currentCoordinator = [SELECT UserId From AccountTeamMember Where TeamMemberRole = 'Coordinator' AND AccountId = :r.EmpAccountId__c ] ;
          if (!currentCoordinator.isEmpty())
              retIdToUse = currentCoordinator[0].UserId;
          else
              retIdToUse = r.Regional_Director__c;
        }
      }
      return retIdToUse;
    }

    @RemoteAction
    public static List <String> EbUpdate(List <KHRLObject__c> updates) {

    List <EBoardSeats__c> eboardUpdateList;
    List <String> errorList;
    List <Database.SaveResult> srList;

    KHRLObject__c KhrlRec;
    EBoardSeats__c tmpEboardRec;

    eboardUpdateList = new List <EBoardSeats__c>();
    errorList        = new List <String>();
    KhrlRec          = updates[0];

    System.debug('Passed Data:');
    System.debug(KhrlRec.EboardId__c);
    System.debug(KhrlRec.CoordinatorId__c);
    System.debug(KhrlRec.Org1Id__c);
    System.debug(KhrlRec.Org2Id__c);
    System.debug(KhrlRec.CoordFlag__c);
    System.debug(KhrlRec.Org1Flag__c);
    System.debug(KhrlRec.Org2Flag__c);

    tmpEboardRec = new EBoardSeats__c();
    tmpEboardRec.Id             = KhrlRec.EboardId__c;

    if(KhrlRec.CoordFlag__c == 'R') {
        tmpEboardRec.Coordinator__c = null;
    }

    if(KhrlRec.Org1Flag__c == 'R') {
        tmpEboardRec.Organizer__c = null;
    }

    if(KhrlRec.Org2Flag__c == 'R') {
        tmpEboardRec.Organizer2__c = null;
    }

    if(KhrlRec.CoordFlag__c == 'C') {
        tmpEboardRec.Coordinator__c = KhrlRec.CoordinatorId__c;
    }

    if(KhrlRec.Org1Flag__c == 'C') {
        tmpEboardRec.Organizer__c   = KhrlRec.Org1Id__c;
        tmpEboardRec.OwnerId        = Id.valueOf(KhrlRec.Org1Id__c);
    }

    if(KhrlRec.Org2Flag__c == 'C') {
        tmpEboardRec.Organizer2__c  = KhrlRec.Org2Id__c;
    }

    eboardUpdateList.add(tmpEboardRec);

    // ------------------------------------------------------------------------------------------- //
    // Update Eboard
    // ------------------------------------------------------------------------------------------- //
    try {
        srList = Database.update(eboardUpdateList, false);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                errorList.add('Error Eb 1:' + sr.Errors[0].StatusCode);
            } else {
              System.debug('Saved Id: ' + sr.getId());
            }
        }
      }
      catch (DmlException e) {errorList.add('Error Eb 2');}

      System.debug(errorList);
      return errorList;
    }

    @RemoteAction
    public static List<String> CsUpdate(List <KHRLObject__c> updates)  {

    List <String> csDeleteIds;
    List <String> errorList;
    List <ContractSpecialists__c> csDeleteList;
    List <ContractSpecialists__c> csRecordsToCreate;
    List <ContractSpecialists__c> csRecordsToChange;
    List <Contact>                contactRecordsToUpdate;
    List <Database.DeleteResult> drList;
    List <Database.SaveResult>   srList;

    ContractSpecialists__c tmpCsRec;
    Contact                tmpContactRec;

    csRecordsToCreate = new List <ContractSpecialists__c>();
    csRecordsToChange = new List <ContractSpecialists__c>();
    contactRecordsToUpdate = new List <Contact>();
    csDeleteIds       = new List <String>();
    errorList         = new List <String>();
    Boolean noError   = true;

    for (KHRLObject__c KhrlRec : updates) {

        System.debug('** KhrlRec CsUpdate **');
        System.debug(KhrlRec.CsRecId__c);
        System.debug(KhrlRec.CsEmail__c);
        System.debug(KhrlRec.CsPhone__c);
        System.debug(KhrlRec.CsOp__c);

        if(KhrlRec.CsOp__c == 'Del') {
            csDeleteIds.add(KhrlRec.CsRecId__c);

            tmpContactRec = new Contact();
            tmpContactRec.Id = KhrlRec.CsId__c;
            tmpContactRec.Contract_Specialist__c = false;
            contactRecordsToUpdate.add(tmpContactRec);
        }

        if(KhrlRec.CsOp__c == 'Add') {
            tmpCsRec = new ContractSpecialists__c();
            tmpCsRec.Contact__c      = KhrlRec.CsId__c;

            if(KhrlRec.DivisionCode__c == 'K')
                tmpCsRec.Division__c     = 'Kaiser';
            else
                tmpCsRec.Division__c     = 'Hospital';

            tmpCsRec.Email__c        = KhrlRec.CsEmail__c;
            tmpCsRec.CellPhone__c    = KhrlRec.CsPhone__c;
            csRecordsToCreate.add(tmpCsRec);

            tmpContactRec = new Contact();
            tmpContactRec.Id = KhrlRec.CsId__c;
            tmpContactRec.Contract_Specialist__c = true;
            contactRecordsToUpdate.add(tmpContactRec);
        }

        if(KhrlRec.CsOp__c == 'Chg') {
            tmpCsRec = new ContractSpecialists__c();
            tmpCsRec.Id             = KhrlRec.CsRecId__c;

            if(!String.IsEmpty(KhrlRec.CsEmail__c))
                tmpCsRec.Email__c     = KhrlRec.CsEmail__c;

            if(!String.IsEmpty(KhrlRec.CsPhone__c))
                tmpCsRec.CellPhone__c = KhrlRec.CsPhone__c;

            csRecordsToChange.add(tmpCsRec);
        }
    }

    // ------------------------------------------------------------------------------------------- //
    // Delete Existing Contract_Specialist__c records
    // ------------------------------------------------------------------------------------------- //
    if (!csDeleteIds.isEmpty()) {
        csDeleteList = [SELECT Id From ContractSpecialists__c Where Id in :csDeleteIds];
        try {
            drList = Database.delete(csDeleteList, false);
            for(Database.DeleteResult dr : drList) {
                if (!dr.isSuccess()) {
                    errorList.add('Error CS 1:' + dr.Errors[0].StatusCode);
                    noError = false;
                    break;
                }
            }
        }
        catch (DmlException e){errorList.add('Error CS 2');}
    }

    // ------------------------------------------------------------------------------------------- //
    // Create  Contract_Specialist__c
    // ------------------------------------------------------------------------------------------- //
    if (noError && !csRecordsToCreate.isEmpty()) {
        try {
            srList = Database.insert(csRecordsToCreate, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error CS 3:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error CS 4');noError = false;}
    }


    // ------------------------------------------------------------------------------------------- //
    // Update Contract_Specialist__c
    // ------------------------------------------------------------------------------------------- //
    if (noError && !csRecordsToChange.isEmpty()) {
        try {
            srList = Database.update(csRecordsToChange, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error CS 5:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error CS 6');}
    }

    // ------------------------------------------------------------------------------------------- //
    // Update Contact's Contract_Specialist__c flag
    // ------------------------------------------------------------------------------------------- //
    if (noError && !contactRecordsToUpdate.isEmpty()) {
        try {
            srList = Database.update(contactRecordsToUpdate, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error CS 7:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error CS 8');}
    }

    System.debug(errorList);

    return errorList;
}

@RemoteAction
public static List<String> KhrlUpdate(List <KHRLObject__c> updates) {

    // Note: Can't just update the userid of an existing ATM rec - get an error:
    //           Visualforce Remoting Exception: Field is not writeable: AccountTeamMember.UserId
    //       So I delete existing ones and then add new ones.

    // Note: Can't have a ATM of 'Contract Specialist' as ATM records want a UserId and Contract Specialists only have a ContactId.  Get an error if try to store ContactId as UserId.

    // Note: Can't send emails from test.

    system.debug('Update start');

    Set <String> userIdsToCount;
    List <String> teamRoles;
    List <String> accountIdArray;
    List <String> errorList;
    List <String> notesDeleteIds;

    List <User> hrEmailList;

    List <AccountTeamMember> atmDeleteIds;
    List <Account>           accountUpdateList;

    List <AccountTeamMember> atmCreateList;
    List <AccountTeamMember> atmCreateIDs;
    List <AccountTeamMember> coordAtmRecordsToCreate;
    List <AccountTeamMember> org1AtmRecordsToCreate;
    List <AccountTeamMember> org2AtmRecordsToCreate;
    List <AccountTeamMember> repExAtmRecordsToCreate;
    List <AccountTeamMember> currentCoordinator;

    List <AccountShare> shareCreateList;
    List <AccountShare> shareCreateIDs;
    List <AccountShare> coordShareRecordsToCreate;
    List <AccountShare> org1ShareRecordsToCreate;
    List <AccountShare> org2ShareRecordsToCreate;
    List <AccountShare> repExShareRecordsToCreate;

    List <KHRLnotes__c> notesDeleteList;
    List <KHRLnotes__c> notesRecordsToCreate;

    List < EBoardSeats__c > eboardRecordsToUpdate;

    List <User>             userUpdateList;

    List <Database.DeleteResult> drList;
    List <Database.SaveResult>   srList;

    userIdsToCount            = new Set<String>();

    teamRoles                 = new List <String>();
    errorList                 = new List <String>();
    accountIdArray            = new List <String>();

    shareCreateList           = new List <AccountShare>();
    coordShareRecordsToCreate = new List <AccountShare>();
    org1ShareRecordsToCreate  = new List <AccountShare>();
    org2ShareRecordsToCreate  = new List <AccountShare>();
    repExShareRecordsToCreate = new List <AccountShare>();

    notesDeleteIds            = new List <String>();
    notesDeleteList           = new List <KHRLnotes__c>();
    notesRecordsToCreate      = new List <KHRLnotes__c>();

    atmCreateList             = new List <AccountTeamMember>();
    atmDeleteIds              = new List <AccountTeamMember>();
    coordAtmRecordsToCreate   = new List <AccountTeamMember>();
    org1AtmRecordsToCreate    = new List <AccountTeamMember>();
    org2AtmRecordsToCreate    = new List <AccountTeamMember>();
    repExAtmRecordsToCreate   = new List <AccountTeamMember>();
    currentCoordinator        = new List <AccountTeamMember>();

    Boolean noError           = true;
    Boolean org1Update        = false;
    Boolean resetCoordFlag    = false;
    Boolean resetOrg1Flag     = false;
    Boolean resetOrg2Flag     = false;
    Boolean updateEboard      = false;
    String eboardRouteListAccountId;

    List <User> managerEmailData, coordEmailData, org1EmailData, org2EmailData;
    String managerName, managerEmail, coordName, coordEmail, org1Name, org1Email, org2Name, org2Email, emailMsg, currentUser;

    AccountTeamMember tmpAccTeamRec;
    AccountShare      tmpShareRec;
    Account           tmpAccountRec;
    User              tmpUserRec;
    KHRLnotes__c      tmpNotesRec;
    String            idToUse;
    String            managerId;
    String            eboardConstituency;
    String            eboardCoord;
    String            eboardOrg1;
    String            eboardOrg2;
    Integer           i;

    idToUse                  = '';
    eboardRouteListAccountId = '';
    eboardConstituency       = '';
    eboardCoord              = '';
    eboardOrg1               = '';
    eboardOrg2               = '';
    accountUpdateList        = new List <Account>();
    userUpdateList           = new List <User>();

    KHRLObject__c tmpRec;
    tmpRec = updates[0];     // Must do outside update loop, as Coord or Dir change is for whole batch.
    System.debug(' Director flag: ' +  tmpRec.DirectorFlag__c);         
    System.debug('    Coord flag: ' +  tmpRec.CoordFlag__c);
    System.debug('    Org1  flag: ' +  tmpRec.Org1Flag__c);
    System.debug('    Org2  flag: ' +  tmpRec.Org2Flag__c);

    List <String> toAddresses = new List <String>();

    Organization orgData = [SELECT ID,INSTANCENAME,ISSANDBOX FROM Organization];
System.debug(orgData.INSTANCENAME);
System.debug(orgData.ISSANDBOX);

    currentUser = UserInfo.getName();
    hrEmailList = [SELECT Id,FirstName,LastName,Username FROM User WHERE IsActive = true AND Title = 'HR SPECIALIST'];

// --------------------------------------------------------------------------------------
   
    List <Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
    List <String> addressArray = new List <String>();

// ----------------------------------------------------------------------

    // If Coordinator is changed, make that Manager of Org1 & 2.
    // If Coordinator is reset, make that Regional Dir Manager of Org1 & 2.
    if(!String.IsEmpty(tmpRec.CoordFlag__c)) {
        teamRoles.add('Coordinator');
        if (tmpRec.CoordFlag__c == 'C') {
           managerId   = tmpRec.CoordinatorId__c;
           managerName = tmpRec.CoordName__c;
        }
        else {
           managerId   = tmpRec.Regional_Director__c;
           managerName = tmpRec.Regional_Director_Name__c;
        }
        
        if(!String.IsEmpty(tmpRec.Org1Id__c)) {
            if(tmpRec.Org1Id__c != 'Vacant') {
                org1Name             = tmpRec.Org1Name__c;
                tmpUserRec           = new User();
                tmpUserRec.Id        = tmpRec.Org1Id__c;
                tmpUserRec.ManagerId = managerId;
                userUpdateList.add(tmpUserRec);
                if(!orgData.ISSANDBOX) {
                    emailMsg = 'Manager for ' + org1Name + ' changed to ' + managerName + ' by ' + currentUser;
                    for(i=0;i<hrEmailList.size();i++) {
                        addressArray.add(hrEmailList[i].Username);
                    }
                    Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
                    singleEmail.setToAddresses(addressArray); 
                    singleEmail.setReplyTo('noreply@seiu-uhw.org');
                    singleEmail.setSubject('Automated Route List Manager Change');
                    singleEmail.setPlainTextBody(emailMsg);
                    emailList.add(singleEmail);
                }
            }
        }

        if(!String.IsEmpty(tmpRec.Org2Id__c)) {
            if(tmpRec.Org2Id__c != 'Vacant') {
                org2Name             = tmpRec.Org2Name__c;
                tmpUserRec           = new User();
                tmpUserRec.Id        = tmpRec.Org2Id__c;
                tmpUserRec.ManagerId = managerId;
                userUpdateList.add(tmpUserRec);
                if(!orgData.ISSANDBOX) {
                    emailMsg = 'Manager for ' + org2Name + ' changed to ' + managerName + ' by ' + currentUser;
                    for(i=0;i<hrEmailList.size();i++) {
                        addressArray.add(hrEmailList[i].Username);
                    }
                    Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
                    singleEmail.setToAddresses(addressArray); 
                    singleEmail.setReplyTo('noreply@seiu-uhw.org');
                    singleEmail.setSubject('Automated Route List Manager Change');
                    singleEmail.setPlainTextBody(emailMsg);
                    emailList.add(singleEmail);
                }
            }
        }
    }
    
    // If Regional Dir is changed, make that Manager of Coordinator
    if(tmpRec.DirectorFlag__c == 'C') {
        managerId   = tmpRec.Regional_Director__c;
        managerName = tmpRec.Regional_Director_Name__c;
        if(!String.IsEmpty(tmpRec.CoordinatorId__c)) {
            if(tmpRec.CoordinatorId__c != 'Vacant') {
                coordName               = tmpRec.CoordName__c;
                tmpUserRec              = new User();
                tmpUserRec.Id           = tmpRec.CoordinatorId__c;
                tmpUserRec.ManagerId    = tmpRec.Regional_Director__c;
                userUpdateList.add(tmpUserRec);
                if(!orgData.ISSANDBOX) {
                   emailMsg = 'Manager for ' + coordName + ' changed to ' +   managerName + ' by ' + currentUser;
                    for(i=0;i<hrEmailList.size();i++) {
                        addressArray.add(hrEmailList[i].Username);
                    }
                    Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
                    singleEmail.setToAddresses(addressArray); 
                    singleEmail.setReplyTo('noreply@seiu-uhw.org');
                    singleEmail.setSubject('Automated Route List Manager Change');
                    singleEmail.setPlainTextBody(emailMsg);
                    emailList.add(singleEmail);               
                }
            }
        }
    }

// --------------------------------------------------------------------------------------

if(!orgData.ISSANDBOX) {
    system.debug('pre send email --------------------------------');
    system.debug('hrEmailList.size...');
    system.debug(hrEmailList.size());
    system.debug('emailList.size...');
    system.debug(emailList.size());
    Messaging.sendEmail(emailList);
    system.debug('post send email --------------------------------');
}

// --------------------------------------------------------------------------------------

    for (KHRLObject__c KhrlRec : updates) {

        System.debug(' Test rec: ');
        System.debug(KhrlRec);

        if (!String.IsEmpty(KhrlRec.CoordFlag__c) ||
            !String.IsEmpty(KhrlRec.Org1Flag__c)  ||
            !String.IsEmpty(KhrlRec.Org2Flag__c)  ||
            !String.IsEmpty(KhrlRec.CsId__c)      || 
            !String.IsEmpty(KhrlRec.Regional_Director__c) || KhrlRec.ResetCS__c == 1) {
            tmpAccountRec    = new Account();               // Need to update Accounts unless only a note was passed in.
            tmpAccountRec.Id = KhrlRec.EmpAccountId__c;
        }

        accountIdArray.add(KhrlRec.EmpAccountId__c);

        if (idToUse == '')
            idToUse = getIdToUse(KhrlRec);

        if (KhrlRec.UpdateEboard__c == 1) {
            updateEboard = true;
            eboardRouteListAccountId = KhrlRec.EmpAccountId__c;
        }

        if (!String.IsEmpty(KhrlRec.Constituency__c))  {
            eboardConstituency = KhrlRec.Constituency__c;
        }


//      if ((!String.IsEmpty(KhrlRec.Org1Id__c)) || KhrlRec.ResetOrg1__c == 1)
        if (!String.IsEmpty(KhrlRec.Org1Flag__c)) {
            teamRoles.add('Organizer1');
            org1Update = true;
            // If Org1 is reset or changed, need to change ownership of contacts to:
            //   1. new Org1Id if passed.
            //   2. new coordinatorId if passed.
            //   3. Existing coordinatorId if no new one passed.
            //   4. Passed directorId, if not 1 or 2 or 3.
            if (KhrlRec.UpdateEboard__c == 1) {
                eboardOrg1 = idToUse;
            }
        }

        //if ((!String.IsEmpty(KhrlRec.Org2Id__c)) || KhrlRec.ResetOrg2__c == 1)
        if (!String.IsEmpty(KhrlRec.Org2Flag__c)) {
            teamRoles.add('Organizer2');
        }

        if (!String.IsEmpty(KhrlRec.RepExFlag__c)) {
            teamRoles.add('Rep Excellence');
        }

        if (!String.IsEmpty(KhrlRec.Note__c) ) {
            notesDeleteIds.add(KhrlRec.EmpAccountId__c);
        }

        if (!String.IsEmpty(KhrlRec.Note__c))  {
            tmpNotesRec                 = new KHRLnotes__c();
            tmpNotesRec.DivisionCode__c = KhrlRec.DivisionCode__c;
            tmpNotesRec.EmpAccountId__c = KhrlRec.EmpAccountId__c;
            tmpNotesRec.Note__c         = KhrlRec.Note__c;
            notesRecordsToCreate.add(tmpNotesRec);
        }

//        if (!String.IsEmpty(KhrlRec.Regional_Director__c)) {
          if (!String.IsEmpty(KhrlRec.DirectorFlag__c)) {
            tmpAccountRec.Regional_Director__c = KhrlRec.Regional_Director__c;
        }

        if (!String.IsEmpty(KhrlRec.CoordinatorId__c)) {
            userIdsToCount.add(KhrlRec.CoordinatorId__c);
            if (KhrlRec.UpdateEboard__c == 1) {
                eboardCoord                    = KhrlRec.CoordinatorId__c;
            }
            resetCoordFlag                     = false;
            tmpAccountRec.Coordinator__c       = KhrlRec.CoordinatorId__c;

            tmpShareRec                        = new AccountShare();
            tmpShareRec.AccountId              = KhrlRec.EmpAccountId__c;
            tmpShareRec.UserOrGroupId          = KhrlRec.CoordinatorId__c;
            tmpShareRec.AccountAccessLevel     = 'Edit';
            tmpShareRec.ContactAccessLevel     = 'Edit';
            tmpShareRec.OpportunityAccessLevel = 'Read';
            coordShareRecordsToCreate.add(tmpShareRec);

            tmpAccTeamRec                      = new AccountTeamMember();
            tmpAccTeamRec.AccountId            = KhrlRec.EmpAccountId__c;
            tmpAccTeamRec.TeamMemberRole       = 'Coordinator';
            tmpAccTeamRec.UserId               = KhrlRec.CoordinatorId__c;
            tmpAccTeamRec.ContactAccessLevel   = 'Edit';
            coordAtmRecordsToCreate.add(tmpAccTeamRec);
        }

        if (KhrlRec.CoordFlag__c == 'R') {
            userIdsToCount.add(KhrlRec.CoordinatorId__c);
            if (KhrlRec.UpdateEboard__c == 1) {
                eboardCoord = null;
            }
            resetCoordFlag = true;
            tmpAccountRec.Coordinator__c = null;
        }

        if (KhrlRec.Org1Flag__c == 'C') {    
            userIdsToCount.add(KhrlRec.Org1Id__c);
            resetOrg1Flag                      = false;
            tmpAccountRec.Organizer_1__c       = KhrlRec.Org1Id__c;

            tmpShareRec                        = new AccountShare();
            tmpShareRec.AccountId              = KhrlRec.EmpAccountId__c;
            tmpShareRec.UserOrGroupId          = KhrlRec.Org1Id__c;
            tmpShareRec.AccountAccessLevel     = 'Edit';
            tmpShareRec.ContactAccessLevel     = 'Edit';
            tmpShareRec.OpportunityAccessLevel = 'Read';
            org1ShareRecordsToCreate.add(tmpShareRec);

            tmpAccTeamRec                      = new AccountTeamMember();
            tmpAccTeamRec.AccountId            = KhrlRec.EmpAccountId__c;
            tmpAccTeamRec.TeamMemberRole       = 'Organizer1';
            tmpAccTeamRec.UserId               = KhrlRec.Org1Id__c;
            tmpAccTeamRec.ContactAccessLevel   = 'Edit';            
            org1AtmRecordsToCreate.add(tmpAccTeamRec);
        }
        if (KhrlRec.Org1Flag__c == 'R') {
            userIdsToCount.add(KhrlRec.Org1Id__c);
            tmpAccountRec.Organizer_1__c = Id.valueOf(idToUse);
            resetOrg1Flag = true;
        }

        if (KhrlRec.Org2Flag__c == 'C') {    
            userIdsToCount.add(KhrlRec.Org2Id__c);
            resetOrg2Flag                      = false;
            eboardOrg2                         = KhrlRec.Org2Id__c;
            tmpAccountRec.Organizer_2__c       = KhrlRec.Org2Id__c;

            tmpShareRec                        = new AccountShare();
            tmpShareRec.AccountId              = KhrlRec.EmpAccountId__c;
            tmpShareRec.UserOrGroupId          = KhrlRec.Org2Id__c;
            tmpShareRec.AccountAccessLevel     = 'Edit';
            tmpShareRec.ContactAccessLevel     = 'Edit';
            tmpShareRec.OpportunityAccessLevel = 'Read';
            org2ShareRecordsToCreate.add(tmpShareRec);

            tmpAccTeamRec                      = new AccountTeamMember();
            tmpAccTeamRec.AccountId            = KhrlRec.EmpAccountId__c;
            tmpAccTeamRec.TeamMemberRole       = 'Organizer2';
            tmpAccTeamRec.UserId               = KhrlRec.Org2Id__c;
            tmpAccTeamRec.ContactAccessLevel   = 'Edit';
            org2AtmRecordsToCreate.add(tmpAccTeamRec);
        }
        if (KhrlRec.Org2Flag__c == 'R') {
            userIdsToCount.add(KhrlRec.Org2Id__c);
            tmpAccountRec.Organizer_2__c = null;
            resetOrg2Flag = true;
        }

        if (KhrlRec.RepExFlag__c == 'C') {    
            userIdsToCount.add(KhrlRec.RepExId__c);

            tmpShareRec                        = new AccountShare();
            tmpShareRec.AccountId              = KhrlRec.EmpAccountId__c;
            tmpShareRec.UserOrGroupId          = KhrlRec.RepExId__c;
            tmpShareRec.AccountAccessLevel     = 'Edit';
            tmpShareRec.ContactAccessLevel     = 'Edit';
            tmpShareRec.OpportunityAccessLevel = 'Read';
            repExShareRecordsToCreate.add(tmpShareRec);

            tmpAccTeamRec                      = new AccountTeamMember();
            tmpAccTeamRec.AccountId            = KhrlRec.EmpAccountId__c;
            tmpAccTeamRec.TeamMemberRole       = 'Rep Excellence';
            tmpAccTeamRec.UserId               = KhrlRec.RepExId__c;
            tmpAccTeamRec.ContactAccessLevel   = 'Edit';
            repExAtmRecordsToCreate.add(tmpAccTeamRec);
        }
        if (KhrlRec.RepExFlag__c == 'R') {
            userIdsToCount.add(KhrlRec.RepExId__c);
        }

        if (KhrlRec.ResetCS__c == 1) {
            tmpAccountRec.Contract_Specialist__c = null;
        } else {
            if (!String.IsEmpty(KhrlRec.CsId__c)) {
                tmpAccountRec.Contract_Specialist__c = KhrlRec.CsId__c;
            }
        }

        if (!String.IsEmpty(KhrlRec.DirectorFlag__c) ||
            !String.IsEmpty(KhrlRec.CoordFlag__c)    ||
            !String.IsEmpty(KhrlRec.Org1Flag__c)     ||
            !String.IsEmpty(KhrlRec.Org2Flag__c)     ||
            !String.IsEmpty(KhrlRec.CsId__c)         || 
            !String.IsEmpty(KhrlRec.Regional_Director__c) || KhrlRec.ResetCS__c == 1
        ) {
            accountUpdateList.add(tmpAccountRec);
        }
            
    }

    // ------------------------------------------------------------------------------------------- //
    // Delete Existing ATM records (Which also deletes AccountShare records automatically)
    // ------------------------------------------------------------------------------------------- //
    if (!teamRoles.isEmpty()) {
        atmDeleteIds = [SELECT Id From AccountTeamMember Where Account.Type = 'Employer' AND TeamMemberRole IN :teamRoles AND AccountId IN :accountIdArray];
        try {
            drList = Database.delete(atmDeleteIds, false);
            for (Database.DeleteResult dr:drList) {
                if (!dr.isSuccess()) {
                    errorList.add('Error 0:' + dr.Errors[0].StatusCode);
                    noError = false;
                    break;
                }
            }
        }
        catch(DmlException e) {errorList.add('Error 1 ');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Delete Existing Notes records
    // ------------------------------------------------------------------------------------------- //
    if (!notesDeleteIds.isEmpty()) {
        notesDeleteList = [SELECT Id From KHRLnotes__c Where EmpAccountId__c in :notesDeleteIds];
        try
        {
            drList = Database.delete(notesDeleteList, false);
            for(Database.DeleteResult dr : drList) {
            if (!dr.isSuccess()) {
                errorList.add('Error 2:' + dr.Errors[0].StatusCode);
                noError = false;
                break;
            }
        }
        }
        catch (DmlException e){errorList.add('Error 3');}
    }

    // ------------------------------------------------------------------------------------------- //
    // Create AccountShares
    // ------------------------------------------------------------------------------------------- //
    if (!coordAtmRecordsToCreate.isEmpty()) {
        atmCreateList.addAll(coordAtmRecordsToCreate);
        shareCreateList.addAll(coordShareRecordsToCreate);
    }

    if (!org1AtmRecordsToCreate.isEmpty()) {
        atmCreateList.addAll(org1AtmRecordsToCreate);
        shareCreateList.addAll(org1ShareRecordsToCreate);
    }

    if (!org2AtmRecordsToCreate.isEmpty()) {
        atmCreateList.addAll(org2AtmRecordsToCreate);
        shareCreateList.addAll(org2ShareRecordsToCreate);
    }

    if (!repExAtmRecordsToCreate.isEmpty()) {
        atmCreateList.addAll(repExAtmRecordsToCreate);
        shareCreateList.addAll(repExShareRecordsToCreate);
    }

    if (noError && !shareCreateList.isEmpty()) {
        try {
            srList = Database.insert(ShareCreateList, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 4 :' + sr.Errors[0].StatusCode);
                    noError = false;
                    break;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error 5 ');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Create AccountTeamMembers
    // ------------------------------------------------------------------------------------------- //
    if (noError && !atmCreateList.isEmpty()) {
        try {
            srList = Database.insert(atmCreateList, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 6:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error 7');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Create Notes__c
    // ------------------------------------------------------------------------------------------- //
    if (noError && !notesRecordsToCreate.isEmpty()) {
        try {
            srList = Database.insert(notesRecordsToCreate, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 8:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error 9');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Update Account fields
    // ------------------------------------------------------------------------------------------- //
    if (noError && !accountUpdateList.isEmpty()) {
        try {
            srList = Database.update(accountUpdateList, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 10:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error 11');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Update User ManagerId fields
    // ------------------------------------------------------------------------------------------- //
    if (noError && !userUpdateList.isEmpty()) {
        try {
            srList = Database.update(userUpdateList, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 12:' + sr.Errors[0].StatusCode);
                    noError = false;
                }
            }
        }
        catch (DmlException e) {errorList.add('Error 13');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Update EbaordSeats__c
    // ------------------------------------------------------------------------------------------- //
    if (noError && updateEboard) {
        eboardRecordsToUpdate = [Select Id, RouteListAccountId__c, Name,Coordinator__c, Organizer__c, Organizer2__c, OwnerId From EBoardSeats__c Where Constituency__r.Name = :eboardConstituency];

        for (EBoardSeats__c Seat : eboardRecordsToUpdate) {
            if (!String.IsEmpty(eboardCoord))
                Seat.Coordinator__c = Id.valueOf(eboardCoord);
            else {
                if (resetCoordFlag)
                    Seat.Coordinator__c = null;
            }

            if (!String.IsEmpty(eboardOrg1)) {
                Seat.Organizer__c = Id.valueOf(eboardOrg1);
                Seat.OwnerId      = Id.valueOf(eboardOrg1);
            }

            if (!String.IsEmpty(eboardOrg2))
                Seat.Organizer2__c = Id.valueOf(eboardOrg2);
            else {
                if (resetOrg2Flag)
                    Seat.Organizer2__c = null;
            }

            if (!String.IsEmpty(eboardRouteListAccountId))
                Seat.RouteListAccountId__c = eboardRouteListAccountId;
        }
        try {
            srList = Database.update(eboardRecordsToUpdate);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    errorList.add('Error 14');
                    noError = false;
                }
            }
        }
        catch (DmlException e){errorList.add('Error 15');}
    }

    // ------------------------------------------------------------------------------------------- //
    // Count User totals for those changed in Route List
    // ------------------------------------------------------------------------------------------- //
    AggregateResult[] UserCounts;
    List <User> userCountList;
    userCountList = new List<User>();
    User tempUser;
    Id userId;
    Integer cnt;

    UserCounts = [SELECT UserId , Count(Id) Cnt From AccountTeamMember Where TeamMemberRole IN ('Coordinator','Organizer1','Organizer2') AND UserId In :userIdsToCount Group By UserId];
    for(AggregateResult userCount : UserCounts) {
        userId      = (Id) userCount.get('UserId');
        cnt         = (Integer) userCount.get('Cnt');
        tempUser    = new User();
        tempUser.Id = userId;
        tempUser.Route_List_Instance_Count__c = cnt;
        userCountList.add(tempUser);
    }

    // ------------------------------------------------------------------------------------------- //
    // Update User Count fields
    // ------------------------------------------------------------------------------------------- //
    if (noError && !userCountList.isEmpty()) {
      try {
        srList = Database.update(userCountList, false);
        for (Database.SaveResult sr : srList) {
          if (!sr.isSuccess()) {
            errorList.add('Error 16:' + sr.Errors[0].StatusCode);
            noError = false;
          }
        }
      }
      catch (DmlException e) {errorList.add('Error 17');noError = false;}
    }

    // ------------------------------------------------------------------------------------------- //
    // Change Contact record ownership
    // ------------------------------------------------------------------------------------------- //
    if (noError && org1Update) {
        KHRL_ChangeContactOwner changeOwner = new KHRL_ChangeContactOwner();
        changeOwner.userId = Id.valueOf(idToUse);
        for (String accountId : AccountIdArray) {
            changeOwner.AccountIdArray.add(accountId);
        }
        ID batchprocessid = Database.executeBatch(changeOwner);
        // Note: Batch job could be monitored with:
        //       SELECT ApexClassId,CompletedDate,JobItemsProcessed,JobType,NumberOfErrors,Status,TotalJobItems FROM AsyncApexJob WHERE Id = batchprocessid
        //       but in reality it seemed too complicated to monitor Status with a timer event on the page, providing real-time updates.
        //       So, if no errors at this point, user just has to assume contact owner change will run OK and finish at some point in the near future.
    }

    return errorList;
}

}