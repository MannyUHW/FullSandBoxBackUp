public class UserTriggerHandler {

    static Map<Id,User> usersmap = new Map<Id,User>([Select Id,Name,ManagerId,SOS_Manager_Name__c from User where isActive=True]);

    Public static void onBeforeInsert(List<User> TriggerNew) {
        for(User usr:TriggerNew) {
            //usr.Time_Off_Recent_Load_Date__c = system.today();
            if(usr.ManagerId != null && usersmap.containsKey(usr.ManagerId)){
                usr.SOS_Manager_Name__c = usersmap.get(usr.ManagerId).Name;
            }
            else if(usr.ManagerId == null || !usersmap.containsKey(usr.ManagerId) ) {
                usr.SOS_Manager_Name__c = '';
            }
        }
    }

/*
    This was never called from UseTrigger class, even though 'before update' was included in the event list.

    Public static void onBeforeUpdate(Map<Id,User> TriggerOldMap, Map<Id,User> TriggerNewMap) {

        for(User usr:TriggerNewMap.values()) {
            if(usr.ManagerId != TriggerOldMap.get(usr.id).ManagerId && usr.ManagerId != null && usersmap.containsKey(usr.ManagerId)){
                usr.SOS_Manager_Name__c = usersmap.get(usr.ManagerId).Name;
            }
            else if((usr.ManagerId != TriggerOldMap.get(usr.id).ManagerId && usr.ManagerId == null) || !usersmap.containsKey(usr.ManagerId)){
                usr.SOS_Manager_Name__c = '';
            }
        }
    }
*/
    public static void onBeforeUpdate(List <User> TriggerOldList, List <User> TriggerNewList) {
    /* I'm adding this (even though the function name already existed, it was never called by the original SOS trigger)  */

      String userId;
      userId = (String) TriggerOldList[0].Id; // There is only ever 1 Id.
      Boolean isActiveOld;
      Boolean isActiveNew;
      String msg;
      Decimal rlCount;
      isActiveOld = TriggerOldList[0].isActive;
      isActiveNew = TriggerNewList[0].isActive;
      if(isActiveOld == true && isActiveNew == false) {
        rlCount = TriggerNewList[0].Route_List_Instance_Count__c;
        if(rlCount > 0) {
          if(rlCount > 1)
            msg = 'Cannot make inactive as User has ' + String.valueOf(rlCount) + ' Route List accounts';
          else
            msg = 'Cannot make inactive as User has 1 Route List account';

          TriggerNewList[0].isActive.addError(msg);
        }
      }
    }

    public static void onAfterUpdate(List<User> TriggerNew) {
        List<String> userIds = new  List<String>();
        for(User usr:TriggerNew) {
            userIds.add(usr.Id);
        }

        if (userIds.size() > 0) {
            UpdateTimeOfBalance(userIds);
        }
    }

    private class AtmRec {
      private string AccountId;
      private string UserId;
      private string Role;
    }

    public static void checkATM(List<String> userIds) {
      system.debug('++ function checkATM( start ) ++ ');
      system.debug(userIds);

      List <AccountTeamMember>  atmRoles;
      List <AtmRec> tempArray;

      AtmRec atmRec;
      tempArray = new List<AtmRec>();

      atmRoles = [
        SELECT AccountId,UserId,TeamMemberRole
        FROM AccountTeamMember
        WHERE TeamMemberRole In ('Coordinator','Organizer1','Organizer2')  And UserId IN :userIds
        ORDER BY User.LastName, User.FirstName, Account.Name, TeamMemberRole
      ];

      integer cnt = 0;
      for(AccountTeamMember atm :atmRoles) {
        cnt++;
        system.debug(cnt);
        atmRec            = new AtmRec();
        atmRec.AccountId  = atm.AccountId;
        atmRec.UserId     = atm.UserId;
        atmRec.Role       = atm.TeamMemberRole;
        tempArray.add(atmRec);
      }

      if(tempArray.size() > 0 ) {
        system.debug(tempArray);
        system.debug('++ function checkATM( end ) ++ ');
      }

    }

    public static void onAfterInsert(List<User> TriggerNew) {
        Set<Id> userIds = new Set<Id>();
        for(User usr:TriggerNew) {
            userIds.add(usr.Id);
        }

        if (userIds.size() > 0) {
            CreateTimeOfBalance(userIds);
        }
   }

   @future
   public static void CreateTimeOfBalance(Set<Id> userIds) {
       List<SOS_Time_Off_Balance__c> listTOBs = new List<SOS_Time_Off_Balance__c>();
        for(Id usrId: userIds) {
            SOS_Time_Off_Balance__c tob = new SOS_Time_Off_Balance__c();
            tob.Employee_Name__c = usrId;
            tob.OwnerId = usrId;
            tob.Bereavement_Time_Rem__c=0;
            tob.Bereavement_Time_Pending__c =0;
            tob.Bereavement_Time_Approved__c =0;
            tob.Birthday_Time_Rem__c =0;
            tob.Birthday_Time_Pending__c  =0;
            tob.Birthday_Time_Approved__c =0;
            tob.Float_Time_Rem__c =0;
            tob.Float_Time_Pending__c  =0;
            tob.Float_Time_Approved__c =0;
            tob.Holiday_work_days_Time_Rem__c =0;
            tob.Holiday_work_days_Time_Pending__c  =0;
            tob.Holiday_work_days_Time_Approved__c =0;
            tob.Jury_Duty_Time_Rem__c=0;
            tob.Jury_Duty_Time_Pending__c  =0;
            tob.Jury_Duty_Time_Approved__c =0;
            tob.Relieve_Time_Rem__c =0;
            tob.Relieve_Time_Pending__c  =0;
            tob.Relieve_Time_Approved__c =0;
            tob.Religious_OPEIU_Only_Time_Rem__c =0;
            tob.Religious_OPEIU_Only_Time_Pending__c  =0;
            tob.Religious_OPEIU_Only_Time_Approved__c =0;
            tob.Sick_Time_Rem__c=0;
            tob.Sick_Time_Pending__c  =0;
            tob.Sick_Time_Approved__c =0;
            tob.Unpaid_Time_Rem__c =0;
            tob.Unpaid_Time_Pending__c  =0;
            tob.Unpaid_Time_Approved__c =0;
            tob.Vacation_Time_Rem__c =0;
            tob.Vacation_Time_Pending__c  =0;
            tob.Vacation_Time_Approved__c =0;
            listTOBs.add(tob);
        }

        if (listTOBs.size() > 0) {
            insert listTOBs;
        }
   }

   @future
   public static void UpdateTimeOfBalance( List<String> userIds) {
       List<SOS_Time_Off_Balance__c> listTOBs = new List<SOS_Time_Off_Balance__c>();

       system.debug('userIds:' + userIds);

       listTOBs = [SELECT id FROM SOS_Time_Off_Balance__c WHERE Employee_Name__c IN : userIds];

       if (listTOBs.size() > 0) {
          update listTOBs;
       }
   }

}