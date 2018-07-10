public class KHRL_RemoteController {

    /* Version 1.6 */

    public KHRL_RemoteController() {
      System.debug('KHRL_RemoteController Version 1.6');
    }

    private static String getIdToUse(KHRLObject__c r){
        List <AccountTeamMember> currentCoordinator;
        String retIdToUse;
        if (!String.IsEmpty(r.Org1Id__c)) {
            retIdToUse = r.Org1Id__c;
        }
        Else   {
            if (!String.IsEmpty(r.CoordinatorId__c))
            {
                retIdToUse = r.CoordinatorId__c;
            }
        else
            {
                currentCoordinator = [SELECT UserId From AccountTeamMember Where TeamMemberRole = 'Coordinator' AND AccountId = :r.EmpAccountId__c ] ;
                if (!currentCoordinator.isEmpty())
                    retIdToUse = currentCoordinator[0].UserId;
                else
                    retIdToUse = r.DirectorId__c;
            }
        }
        return retIdToUse;
    }

    @RemoteAction
    public static List<String> KhrlUpdate(List <KHRLObject__c> updates) {

        // Note: Can't just update the userid of an existing ATM rec - get an error:
        //           Visualforce Remoting Exception: Field is not writeable: AccountTeamMember.UserId
        //       So I delete existing ones and then add new ones.

        // Note: Can't have a ATM of 'Contract Specialist' as ATM records want a UserId and Contract Specialists only have a ContactId.  Get an error if try to store ContactId as UserId.

        system.debug('Update start');

        List <String> teamRoles;
        List <String> accountIdArray;
        List <String> errorList;
        List <String> notesDeleteIds;
        List <String> resultList;

        List <AccountTeamMember> atmDeleteIds;
        List <Account>           accountUpdateList;

        List <AccountTeamMember> atmCreateList;
        List <AccountTeamMember> atmCreateIDs;
        List <AccountTeamMember> coordAtmRecordsToCreate;
        List <AccountTeamMember> org1AtmRecordsToCreate;
        List <AccountTeamMember> org2AtmRecordsToCreate;
        List <AccountTeamMember> currentCoordinator;

        List <AccountShare> shareCreateList;
        List <AccountShare> shareCreateIDs;
        List <AccountShare> coordShareRecordsToCreate;
        List <AccountShare> org1ShareRecordsToCreate;
        List <AccountShare> org2ShareRecordsToCreate;

        List <KHRLnotes__c> notesDeleteList;
        List <KHRLnotes__c> notesRecordsToCreate;

        List < EBoardSeats__c > eboardRecordsToUpdate;

        List <Database.DeleteResult> drList;
        List <Database.SaveResult>   srList;

        teamRoles                 = new List <String>();
        errorList                 = new List <String>();
        accountIdArray            = new List <String>();

        shareCreateList           = new List <AccountShare>();
        coordShareRecordsToCreate = new List <AccountShare>();
        org1ShareRecordsToCreate  = new List <AccountShare>();
        org2ShareRecordsToCreate  = new List <AccountShare>();

        notesDeleteIds            = new List <String>();
        notesDeleteList           = new List <KHRLnotes__c>();
        notesRecordsToCreate      = new List <KHRLnotes__c>();

        atmCreateList             = new List <AccountTeamMember>();
        atmDeleteIds              = new List <AccountTeamMember>();
        coordAtmRecordsToCreate   = new List <AccountTeamMember>();
        org1AtmRecordsToCreate    = new List <AccountTeamMember>();
        org2AtmRecordsToCreate    = new List <AccountTeamMember>();
        currentCoordinator        = new List <AccountTeamMember>();

        Boolean noError           = True;
        Boolean org1Update        = false;
        Boolean resetCoordFlag    = false;
        Boolean resetOrg1Flag     = false;
        Boolean resetOrg2Flag     = false;
        Boolean updateEboard      = false;
        String eboardRouteListAccountId;

        AccountTeamMember tmpAccTeamRec;
        AccountShare      tmpShareRec;
        Account           tmpAccountRec;
        KHRLnotes__c      tmpNotesRec;
        String            idToUse;
        String            eboardConstituency;
        String            eboardCoord;
        String            eboardOrg1;
        String            eboardOrg2;

        idToUse                  = '';
        eboardRouteListAccountId = '';
        eboardConstituency       = '';
        eboardCoord              = '';
        eboardOrg1               = '';
        eboardOrg2               = '';
        accountUpdateList        = new List <Account>();

        for (KHRLObject__c KhrlRec : updates) {

System.debug('Test rec:');
System.debug(KhrlRec);

            if ((!String.IsEmpty(KhrlRec.CoordinatorId__c) || KhrlRec.ResetCoordinator__c == 1) ||
                (!String.IsEmpty(KhrlRec.Org1Id__c)        || KhrlRec.ResetOrg1__c        == 1) ||
                (!String.IsEmpty(KhrlRec.Org2Id__c)        || KhrlRec.ResetOrg2__c        == 1) ||
                (!String.IsEmpty(KhrlRec.CsId__c)          || KhrlRec.ResetCS__c          == 1) ||
                (!String.IsEmpty(KhrlRec.RegionalDirectorId__c)) ) {
                tmpAccountRec = new Account();               // Need to update Accounts unless only a note was passed in.
                tmpAccountRec.Id = KhrlRec.EmpAccountId__c;
            }

            if (idToUse == '')
                idToUse = getIdToUse(KhrlRec);

            if (KhrlRec.UpdateEboard__c == 1) {
                updateEboard = True;
                eboardRouteListAccountId = KhrlRec.EmpAccountId__c;
            }

            if (!String.IsEmpty(KhrlRec.Constituency__c))  // Only 1 Constituency code is passed.  Save it for later.
            eboardConstituency = KhrlRec.Constituency__c;

            accountIdArray.add(KhrlRec.EmpAccountId__c);

            if ((!String.IsEmpty(KhrlRec.CoordinatorId__c)) || KhrlRec.ResetCoordinator__c == 1 ) {
                teamRoles.add('Coordinator');
            }

            if ((!String.IsEmpty(KhrlRec.Org1Id__c)) || KhrlRec.ResetOrg1__c == 1)
            {
                teamRoles.add('Organizer1');
                org1Update = True;
                // If Org1 is reset or changed, need to change ownership of contacts to:
                //   1. new Org1Id if passed.
                //   2. new coordinatorId if passed.
                //   3. Existing coordinatorId if no new one passed.
                //   4. Passed directorId, if not 1 or 2 or 3.
                if (KhrlRec.UpdateEboard__c == 1)
                    eboardOrg1 = idToUse;
            }

            if ((!String.IsEmpty(KhrlRec.Org2Id__c)) || KhrlRec.ResetOrg2__c == 1)
            teamRoles.add('Organizer2');

            if (!String.IsEmpty(KhrlRec.Note__c) )
            notesDeleteIds.add(KhrlRec.EmpAccountId__c);

            if (!String.IsEmpty(KhrlRec.Note__c))  {
                tmpNotesRec                 = new KHRLnotes__c();
                tmpNotesRec.DivisionCode__c = KhrlRec.DivisionCode__c;
                tmpNotesRec.EmpAccountId__c = KhrlRec.EmpAccountId__c;
                tmpNotesRec.Note__c         = KhrlRec.Note__c;
                notesRecordsToCreate.add(tmpNotesRec);
            }

            if (!String.IsEmpty(KhrlRec.RegionalDirectorId__c))
                tmpAccountRec.RegionalDirectorId__c = KhrlRec.RegionalDirectorId__c;

            if (!String.IsEmpty(KhrlRec.CoordinatorId__c)) {
                if (KhrlRec.UpdateEboard__c == 1)
                    eboardCoord                    = KhrlRec.CoordinatorId__c;

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
                coordAtmRecordsToCreate.add(tmpAccTeamRec);
            }
            if (KhrlRec.ResetCoordinator__c == 1) {
                if (KhrlRec.UpdateEboard__c == 1)
                    eboardCoord = '';

                resetCoordFlag = True;
                tmpAccountRec.Coordinator__c = null;
            }

            if (!String.IsEmpty(KhrlRec.Org1Id__c)) {
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
                org1AtmRecordsToCreate.add(tmpAccTeamRec);
            }
            if (KhrlRec.ResetOrg1__c == 1) {
                tmpAccountRec.Organizer_1__c = Id.valueOf(idToUse);
                resetOrg1Flag = True;
            }

            if ((!String.IsEmpty(KhrlRec.Org2Id__c))) {
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
                org2AtmRecordsToCreate.add(tmpAccTeamRec);
            }
            if (KhrlRec.ResetOrg2__c == 1) {
                tmpAccountRec.Organizer_2__c = null;
                resetOrg2Flag = True;
                eboardOrg2    = '';
            }

            if (KhrlRec.ResetCS__c == 1)
                tmpAccountRec.Contract_Specialist__c = '';

            if (!String.IsEmpty(KhrlRec.CsId__c))
                tmpAccountRec.Contract_Specialist__c = KhrlRec.CsId__c;

            if ((!String.IsEmpty(KhrlRec.CoordinatorId__c) || KhrlRec.ResetCoordinator__c == 1) ||
                (!String.IsEmpty(KhrlRec.Org1Id__c)        || KhrlRec.ResetOrg1__c        == 1) ||
                (!String.IsEmpty(KhrlRec.Org2Id__c)        || KhrlRec.ResetOrg2__c        == 1) ||
                (!String.IsEmpty(KhrlRec.CsId__c)          || KhrlRec.ResetCS__c          == 1) ||
                (!String.IsEmpty(KhrlRec.RegionalDirectorId__c))
               )
                accountUpdateList.add(tmpAccountRec);
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
                    resultList.add('Error 4:' + dr.Errors[0].StatusCode);
                    noError = false;
                    break;
                }
            }
            }
            catch (DmlException e){resultList.add('Error 5');}
        }

        // ------------------------------------------------------------------------------------------- //
        // Create AccountShares
        // ------------------------------------------------------------------------------------------- //
        if (!CoordAtmRecordsToCreate.isEmpty()) {
            atmCreateList.addAll(CoordAtmRecordsToCreate);
            shareCreateList.addAll(CoordShareRecordsToCreate);
        }

        if (!Org1AtmRecordsToCreate.isEmpty()) {
            atmCreateList.addAll(Org1AtmRecordsToCreate);
            shareCreateList.addAll(Org1ShareRecordsToCreate);
        }

        if (!Org2AtmRecordsToCreate.isEmpty()) {
            atmCreateList.addAll(Org2AtmRecordsToCreate);
            shareCreateList.addAll(Org2ShareRecordsToCreate);
        }

        if (noError && !ShareCreateList.isEmpty()) {
            try {
                srList = Database.insert(ShareCreateList, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        errorList.add('Error 6 :' + sr.Errors[0].StatusCode);
                        noError = false;
                        break;
                    }
                }
            }
            catch (DmlException e) {errorList.add('Error 7 ');noError = false;}
        }

        // ------------------------------------------------------------------------------------------- //
        // Create AccountTeamMembers
        // ------------------------------------------------------------------------------------------- //
        if (noError && !atmCreateList.isEmpty()) {
            try {
                srList = Database.insert(atmCreateList, false);
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
        // Create Notes__c
        // ------------------------------------------------------------------------------------------- //
        if (noError && !notesRecordsToCreate.isEmpty()) {
            try {
                srList = Database.insert(notesRecordsToCreate, false);
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
        // Update Account fields
        // ------------------------------------------------------------------------------------------- //
        if (noError && !accountUpdateList.isEmpty()) {
            try {
                srList = Database.update(accountUpdateList, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        errorList.add('Error 14:' + sr.Errors[0].StatusCode);
                        noError = false;
                    }
                }
            }
            catch (DmlException e) {errorList.add('Error 15');noError = false;}
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
                        errorList.add('Error 16');
                        noError = false;
                    }
                }
            }
            catch (DmlException e){errorList.add('Error 17');}
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
        System.debug('Update end');

        return errorList;
    }
}