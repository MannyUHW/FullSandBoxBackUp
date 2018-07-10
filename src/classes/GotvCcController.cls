public class GotvCcController {

  public class LicCountClass {
    String Ltype;
    Integer Lcnt;
  }

  @ReadOnly    
  @RemoteAction
  public static List <LicCountClass> getLicensureCounts() {
    
    LicCountClass licCountRec;
    List<LicCountClass> licCntList = new List<LicCountClass>();
    
    String ltype;
    Integer cnt;

    AggregateResult[] licCounts = [Select License_Type__c, Count(Id) Cnt From Licensure__c Group By License_Type__c];

    for(AggregateResult licCount : licCounts) {
      ltype = (String)  licCount.get('License_Type__c');
      cnt   = (Integer) licCount.get('Cnt');
    
      licCountRec = new LicCountClass();
      licCountRec.Ltype = ltype;
      licCountRec.Lcnt  = cnt;
      licCntList.add(licCountRec);
    }
    System.debug(licCntList.size());
    System.debug(licCntList);
    return licCntList;
  }

  @ReadOnly
  @RemoteAction
  public static List <XMatch__c> getXMatchDetail() {
    List <XMatch__c> data = new List <XMatch__c>();
    for (list <XMatch__c> dataList : [SELECT AccountId__c,MatchTarget__c,JobStatus__c FROM XMatch__c ORDER BY AccountId__c,MatchTarget__c,JobStatus__c]) {
      data.addAll(dataList);
    }
    return data;
  }

  @RemoteAction
  public static String getUrl() {
    // Found at https://salesforce.stackexchange.com/questions/27751/get-the-salesforce-internal-non-site-url-from-a-site/41689
    // Note String baseURL = URL.getSalesforceBaseUrl().toExternalForm() isn't reliable.  Changes, depending on current url.

    String orgId     = UserInfo.getOrganizationId();
    String userId    = UserInfo.getUserId();
    String sessionId = UserInfo.getSessionId();
    PageReference pr = new PageReference('/id/' + orgId + '/' + userId);
    pr.getParameters().put('oauth_token', sessionId);
    pr.getParameters().put('format', 'json');

    if(Test.isRunningTest() ) {
      return 'ok';
    } else {
      System.debug('Test is NOT running');
      System.debug( Url.getSalesforceBaseUrl().toExternalForm() );
      System.debug( pr.getContent().toString() );
      //within test context use url class, else derive from identity api
      String data = Test.isRunningTest() ? '{"urls": {"rest": "' + Url.getSalesforceBaseUrl().toExternalForm() + '"}}' : pr.getContent().toString();
      Map<String,Object> result = (Map<String,Object>)Json.deserializeUntyped(data);
      Map<String,Object> urls = (Map<String,Object>)result.get('urls');
      String baseURL = (String) urls.get('custom_domain');
      System.debug('**** baseURL:' + baseURL);
    return baseURL;
    }
  }

  @ReadOnly
  @RemoteAction
  public static List <GOTV_Views__c> getViews() {
    list <GOTV_Views__c> data;
    data = new List <GOTV_Views__c>();
    integer i,l;
    GOTV_Views__c tmpRec;
    for (list <GOTV_Views__c> dataList : [SELECT Id,Type__c,ViewClass__c,User__c,Name,Description__c,ColumnState__c,SortModel__c,OwnerId FROM GOTV_Views__c ORDER BY Name]) {
      l = dataList.size();
      for(i=0;i<l;i++) {
        tmpRec = dataList[i];
        data.add(tmpRec);
      }
    }
    return data;
  }

  @ReadOnly    
  @RemoteAction
  public static List <Account> getAccountData() {
    integer recLimit;
    AggregateResult[] buCounts;
    AggregateResult[] asCounts;
    List<Id> nonNoIdList = new List<Id>();

    Id accountId;
    Integer cnt;
    Map<Id,Integer> buMap = new Map<Id,Integer>();
 
    // Include non New Organizing accounts that have Assessments
    asCounts = [Select AccountId, Count(Id) Cnt
                From Contact
                Where Account.Account_Group__c != 'New Organizing' And GOTV_Assessment__c != null And Account.Type = 'Employer' And Account.Active__c = 'yes'
                Group By AccountId];
    for(AggregateResult asCount : asCounts) {
        accountId = (Id) asCount.get('AccountId');
        nonNoIdList.add(accountId);
    }

    // Count contacts, as BU_Count is null for New Organizing (and unreliable for recent conversions)
    buCounts = [Select AccountId,Count(Id) Cnt
                From Contact
                Where In_Current_BU__c = true AND ( 
                  (Account.Account_Group__c = 'New Organizing' And Account.Type = 'Employer' And Account.Active__c = 'YES') Or 
                   AccountId In :nonNoIdList
                  )
                Group By AccountId];

    for(AggregateResult buCount : buCounts) {
      accountId = (Id) buCount.get('AccountId');
      cnt       = (Integer) buCount.get('Cnt');
      buMap.put(accountId,cnt);
    }

    list <Account> data;
    Account rec;
    if(data == null) {
      data = new List <Account>();
      integer i,l;

      // Account List: Any Non New Organizing that have Assessments, plus New Organizing acccounts that have a BU count:
      for (list <Account> dataList : [
        SELECT Id,Name, Account_Group__c,Region__c,Hospital_System__c,BU_Count__c,Coordinator__r.Id, Coordinator__r.Lastname,Coordinator__r.FirstName, Organizer_1__r.Id, Organizer_1__r.Lastname,Organizer_1__r.FirstName,
          (SELECT Id,Account__c,Type__c,Name,Description__c,FilterSoql__c,SavedFilter__c FROM Gotv_Universes__r),
          (SELECT Allowed_Responses__c,Description__c,Name FROM Survey_Questions__r WHERE Is_Vote_Block__c = true)
        FROM Account 
        Where (Account_Group__c = 'New Organizing' And Type = 'Employer' And Active__c = 'YES') Or Id In :nonNoIdList
        ORDER BY Account_Group__c Desc, Name Asc]) {
        l = dataList.size();
        for(i=0;i<l;i++) {
          rec = dataList[i];
          if(buMap.containsKey(rec.Id)) {
            dataList[i].BU_Count__c = buMap.get(rec.Id);
            rec.BU_Count__c = buMap.get(rec.Id);
            data.add(rec);
          }
        }
      }
    }
    return data;
  }

  @ReadOnly
  @RemoteAction
  public static List <Contact> getGotvContactData(Id accountId, List<Integer> dtArray, String userLevel, Id userId) {
    integer recLimit, utcD,utcM,utcY,utcH,utcZ,utcS;
    list <Contact> data;
    data = new List <Contact>();
    integer i,l;

    System.debug('[getGotvContactData] UserLevel: ' + userLevel + ' - UserId: ' + userId);

    if(dtArray != null) {
      utcD = dtArray[0];
      utcM = dtArray[1];
      utcY = dtArray[2];
      utcH = dtArray[3];
      utcZ = dtArray[4];
      utcS = dtArray[5];
      DateTime cutoffDT = DateTime.newInstance(utcY, utcM, utcD, utcH, utcZ, utcS);
      System.debug('------------------------------------------------');
      System.debug(cutoffDT);

      for (list <Contact> dataList : [
        SELECT AccountId,AssistantName,Department,FirstName,LastName,MiddleName,MailingCity,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Notes_Consolidated__c,Title,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
          GOTV_Assessment__c,GOTV_Board_Challenge__c,GOTV_Challenge_Reason__c,GOTV_Challenge__c,Inoculated__c ,
          GOTV_Card_Signed_Date__c,GOTV_Exact_Vote_Time__c,GOTV_Gettable__c,GOTV_Hard_Pull__c,GOTV_Hard_Pull_Reason__c,GOTV_Inside_Plan_Notes__c,GOTV_Off_Both_Days__c,GOTV_Outside_Plan__c,
          GOTV_Plan_Type__c,GOTV_Shift_Scheduler__c,GOTV_Slip__c,GOTV_Special_Plan__c,GOTV_Special_Plan_Notes__c,GOTV_Took_Photo__c,GOTV_UHW_Challenge__c,GOTV_Vote_Block_Time__c,GOTV_Vote_Yes_Petition__c,GOTV_Where_After_Voting__c, 
          GOTV_Where_Before_Voting__c,GOTV_Works_Eday_1__c,Id,New_Org_Card_Signed_By__c,New_Org_Card_Signed_By__r.Name, Purple_UP__c,Reconfirmed_GOTV__c,Shift__c,
          Staffing_17__c,Sticker_Up_Actions__c,Three_Touch__c,Three_Touch_ST__c,Three_Touch_VC__c,Vote_Captain__c,Work_Days_at_Primary_Worksite__c,Works_Night_Before_Eday2__c,
          LastModifiedDate, Owner.Name,BU__c , Card_Assess__c, GOTV_Assess__c,Assigned_to_VC__c,Assigned_to_VC_Name__c,AssignedLeader__r.Name,
          (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'), 
          (SELECT Response_Value__c 
           FROM Survey_Responses__r 
           WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true
          )
        FROM Contact
        WHERE AccountId = :accountId AND In_Current_BU__c = true And LastModifiedDate >= :cutoffDT And FirstName != 'Dummy'
        ORDER BY LastName,FirstName]) {
        l = dataList.size();
        System.debug('recent changes size: ' + l );
        for(i=0;i<l;i++) {
          data.add(dataList[i]);
        }
      }
    } else {
      for (list <Contact> dataList : [
        SELECT AccountId,AssistantName,Department,FirstName,LastName,MiddleName,MailingCity,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Notes_Consolidated__c,Title,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
          GOTV_Assessment__c,GOTV_Board_Challenge__c,GOTV_Challenge_Reason__c,GOTV_Challenge__c,Inoculated__c ,
          GOTV_Card_Signed_Date__c,GOTV_Exact_Vote_Time__c,GOTV_Gettable__c,GOTV_Hard_Pull__c,GOTV_Hard_Pull_Reason__c,GOTV_Inside_Plan_Notes__c,GOTV_Off_Both_Days__c,GOTV_Outside_Plan__c,
          GOTV_Plan_Type__c,GOTV_Shift_Scheduler__c,GOTV_Slip__c,GOTV_Special_Plan__c,GOTV_Special_Plan_Notes__c,GOTV_Took_Photo__c,GOTV_UHW_Challenge__c,GOTV_Vote_Block_Time__c,GOTV_Vote_Yes_Petition__c,GOTV_Where_After_Voting__c, 
          GOTV_Where_Before_Voting__c,GOTV_Works_Eday_1__c,Id,New_Org_Card_Signed_By__c,New_Org_Card_Signed_By__r.Name, Purple_UP__c,Reconfirmed_GOTV__c,Shift__c,
          Staffing_17__c,Sticker_Up_Actions__c,Three_Touch__c,Three_Touch_ST__c,Three_Touch_VC__c,Vote_Captain__c,Work_Days_at_Primary_Worksite__c,Works_Night_Before_Eday2__c,
          LastModifiedDate, Owner.Name,BU__c , Card_Assess__c, GOTV_Assess__c,Assigned_to_VC__c,Assigned_to_VC_Name__c,AssignedLeader__r.Name,
          (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'),        
          (SELECT Response_Value__c 
           FROM Survey_Responses__r 
           WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true 
          )
        FROM Contact
        WHERE AccountId = :accountId AND In_Current_BU__c = true And FirstName != 'Dummy'
        ORDER BY LastName,FirstName]) {
        l = dataList.size();
        for(i=0;i<l;i++) {
          data.add(dataList[i]);
        }
      }
    }

    return data;
  }

  @ReadOnly
  @RemoteAction
  public static List <Contact> getDataEntryContactData(Id accountId, List<Integer> dtArray, String userLevel, Id userId) {
    integer recLimit, utcD,utcM,utcY,utcH,utcZ,utcS;
    list <Contact> data;
    data = new List <Contact>();
    integer i,l;

    System.debug('[getDataEntryContactData] AccountId: ' + accountId + ' UserLevel: ' + userLevel + ' - UserId: ' + userId);

    if(dtArray != null) {
      utcD = dtArray[0];
      utcM = dtArray[1];
      utcY = dtArray[2];
      utcH = dtArray[3];
      utcZ = dtArray[4];
      utcS = dtArray[5];
      DateTime cutoffDT = DateTime.newInstance(utcY, utcM, utcD, utcH, utcZ, utcS);
      System.debug('------------------------------------------------');
      System.debug(cutoffDT);

      if(userLevel == 'Regular') {
        for (list <Contact> dataList : [ 
          SELECT Id,AccountId,Department,In_Current_BU__c,FirstName,LastName,MiddleName,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
                 Activist__c , BU__c ,Captain__c ,Captain_s_OC__c ,Cross_Match_UHW__c ,CrossMatchFacility__c ,
                 Dialysis_Build_OC__c ,Dialysis_Employer__c ,Dialysis_Phases__c ,Dignity_Region__c ,Dignity_Sub_Region__c ,Div_Sub_Region__c ,HomePhone ,
                 ID_Leaders__c ,Lic_List_Phone__c ,Mailing_BA__c ,MailingCity ,MailingPostalCode ,MailingState ,MailingStreet ,MobilePhone ,
                 OC_Member__c ,OtherPhone ,Phone ,Photo_Release_Signed__c,Title,Work_Status__c,Worksite__c, 
                 X1_1_complete__c,LOA__c,Worksite_Add_Info__c,
                 Schedule_In_Hand__c, Staffing_17__c, Staffing_17_Collected_By__c,Staffing_17_Collected_By__r.Name,
                 LastModifiedDate, Owner.Name, Ics__c, GOTV_Special_Plan_Notes__c,GOTV_Inside_Plan_Notes__c,GOTV_Outside_Plan__c,Notes_Consolidated__c,
          (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'), 
          (SELECT Response_Value__c 
            FROM Survey_Responses__r 
            WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true
          )
          FROM Contact
          WHERE AccountId = :accountId AND OwnerId = :userId AND In_Current_BU__c = true And LastModifiedDate >= :cutoffDT And FirstName != 'Dummy'
          ORDER BY LastName,FirstName]) {
          l = dataList.size();
          System.debug('recent changes size: ' + l );
          for(i=0;i<l;i++) {
            data.add(dataList[i]);
          }
        }
      } else {
        for (list <Contact> dataList : [ 
          SELECT Id,AccountId,Department,In_Current_BU__c,FirstName,LastName,MiddleName,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
            Activist__c , BU__c ,Captain__c ,Captain_s_OC__c ,Cross_Match_UHW__c ,CrossMatchFacility__c ,
            Dialysis_Build_OC__c ,Dialysis_Employer__c ,Dialysis_Phases__c ,Dignity_Region__c ,Dignity_Sub_Region__c ,Div_Sub_Region__c ,HomePhone ,
            ID_Leaders__c ,Lic_List_Phone__c ,Mailing_BA__c ,MailingCity ,MailingPostalCode ,MailingState ,MailingStreet ,MobilePhone ,
            OC_Member__c ,OtherPhone ,Phone ,Photo_Release_Signed__c,Title,Work_Status__c,Worksite__c, 
            X1_1_complete__c,LOA__c,Worksite_Add_Info__c,
            Schedule_In_Hand__c, Staffing_17__c, Staffing_17_Collected_By__c,Staffing_17_Collected_By__r.Name,
            LastModifiedDate, Owner.Name, Ics__c, GOTV_Special_Plan_Notes__c,GOTV_Inside_Plan_Notes__c,GOTV_Outside_Plan__c,Notes_Consolidated__c,
          (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'), 
          (SELECT Response_Value__c 
            FROM Survey_Responses__r 
            WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true
          )
        FROM Contact
        WHERE AccountId = :accountId AND In_Current_BU__c = true And LastModifiedDate >= :cutoffDT And FirstName != 'Dummy'
        ORDER BY LastName,FirstName]) {
        l = dataList.size();
        System.debug('recent changes size: ' + l );
        for(i=0;i<l;i++) {
          data.add(dataList[i]);
          }
        }
      }
    } else {
      if(userLevel == 'Regular') {
        for (list <Contact> dataList : [
          SELECT Id,AccountId,Department,In_Current_BU__c,FirstName,LastName,MiddleName,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
                 Activist__c, BU__c ,Captain__c ,Captain_s_OC__c ,Cross_Match_UHW__c ,CrossMatchFacility__c ,
                 Dialysis_Build_OC__c ,Dialysis_Employer__c ,Dialysis_Phases__c ,Dignity_Region__c ,Dignity_Sub_Region__c ,Div_Sub_Region__c ,HomePhone ,
                 ID_Leaders__c ,Lic_List_Phone__c ,Mailing_BA__c ,MailingCity ,MailingPostalCode ,MailingState ,MailingStreet ,MobilePhone ,
                 OC_Member__c ,OtherPhone ,Phone ,Photo_Release_Signed__c,Title,Work_Status__c,Worksite__c, 
                 X1_1_complete__c,LOA__c,Worksite_Add_Info__c,
                 Schedule_In_Hand__c, Staffing_17__c, Staffing_17_Collected_By__c,Staffing_17_Collected_By__r.Name,               
                 LastModifiedDate, Owner.Name, Ics__c,GOTV_Special_Plan_Notes__c,GOTV_Inside_Plan_Notes__c,GOTV_Outside_Plan__c,Notes_Consolidated__c,
            (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'), 
            (SELECT Response_Value__c 
             FROM Survey_Responses__r 
             WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true
            )
          FROM Contact
          WHERE AccountId = :accountId AND OwnerId = :userId AND In_Current_BU__c = true And FirstName != 'Dummy'
          ORDER BY LastName,FirstName]) {
          l = dataList.size();
          for(i=0;i<l;i++) {
            data.add(dataList[i]);
          }
        }

      }
      else {
        for (list <Contact> dataList : [
          SELECT Id,AccountId,Department,In_Current_BU__c,FirstName,LastName,MiddleName,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
                 Activist__c, BU__c ,Captain__c ,Captain_s_OC__c ,Cross_Match_UHW__c ,CrossMatchFacility__c ,
                 Dialysis_Build_OC__c ,Dialysis_Employer__c ,Dialysis_Phases__c ,Dignity_Region__c ,Dignity_Sub_Region__c ,Div_Sub_Region__c ,HomePhone ,
                 ID_Leaders__c ,Lic_List_Phone__c ,Mailing_BA__c ,MailingCity ,MailingPostalCode ,MailingState ,MailingStreet ,MobilePhone ,
                 OC_Member__c ,OtherPhone ,Phone ,Photo_Release_Signed__c,Title,Work_Status__c,Worksite__c, 
                 X1_1_complete__c,LOA__c,Worksite_Add_Info__c,
                 Schedule_In_Hand__c, Staffing_17__c, Staffing_17_Collected_By__c,Staffing_17_Collected_By__r.Name,               
                 LastModifiedDate, Owner.Name, Ics__c,GOTV_Special_Plan_Notes__c,GOTV_Inside_Plan_Notes__c,GOTV_Outside_Plan__c,Notes_Consolidated__c,
            (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'), 
            (SELECT Response_Value__c 
             FROM Survey_Responses__r 
             WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true
            )
          FROM Contact
          WHERE AccountId = :accountId AND In_Current_BU__c = true And FirstName != 'Dummy'
          ORDER BY LastName,FirstName]) {
          l = dataList.size();
          for(i=0;i<l;i++) {
            data.add(dataList[i]);
          }
        }
      }
    }
    return data;
  }

  @RemoteAction 
  public static String initialize(ID accountId) {
    System.debug('initialize: accountId: ');
    Integer i,l,cnt=0;
    String retVal;
    List <Contact> contactData = new List<Contact>();
    Contact tmpContact;
    for (list <Survey_Response__c> dataList : [
        SELECT Contact__r.Id, Response_Value__c 
        FROM Survey_Response__c
        WHERE Contact__r.Account.Id = :accountId And Survey_Question__r.Is_Vote_Block__c = true
      ]) {
      l = dataList.size();
      for(i=0;i<l;i++) {
        cnt++;
        tmpContact = new Contact();
        tmpContact.Id = dataList[i].Contact__r.Id;
        tmpContact.GOTV_Vote_Block_Time__c = dataList[i].Response_Value__c;
        contactData.add(tmpContact);
      }
    }

    // ------------------------------------------------------------------------------------------- //
    // Update Contacts
    // ------------------------------------------------------------------------------------------- //
    try {
      update contactData;
      System.debug(cnt + ' Contact Records updated');
      retVal = 'OK';
    } catch(Exception e) {
      System.debug('Error updating Contact records. ' + e.getMessage());
      retVal = 'Error: ' + e.getMessage();
    }
    return retVal;
  }

  @ReadOnly
  @RemoteAction
  public static List <Contact> getContactMatches(String pAccountId) {
    List <String>  contactIdsArray = new List <String>();
    List <Contact> contactsArray   = new List <Contact>();
    Integer i,j,k,l;
    
    for (List <XMatched__c> contactList : [SELECT ContactId__c FROM XMatched__c WHERE MatchingAccountId__c = :pAccountId]) {
      j = contactList.Size();
      for(i=0;i<j;i++) {
        contactIdsArray.add(contactList[i].ContactId__c);
      }
    }

    for (List <Contact> matches : 
      [SELECT Id,LastName,FirstName,MiddleName,Division__c,Account.Id,Account.Name,In_Current_BU__c,Email,HomePhone,Department,Title,MailingCity,MailingPostalCode,MailingState,MailingStreet,Member_Status__c,MobilePhone,Phone 
       From Contact Where Id IN :contactIdsArray]) {
      l = matches.Size();
      for(k=0;k<l;k++) {
        contactsArray.add(matches[k]);
      }
    }
    return contactsArray;
  }

  @ReadOnly
  @RemoteAction
  public static List <Licensure__c> getLicensureData() {
    List <Licensure__c> licensureArray = new List <Licensure__c>();
    // CertifiedHemotech
    for (List <Licensure__c> data : 
      [SELECT Id,Last_Name__c,First_Name__c,Middle_Name__c,License_Addr_City__c,License_Addr_State__c,License_Addr_Street__c,License_Addr_Zip__c,
        License_Agency__c, License_Expiration_Date__c,License_Status__c,License_Type__c,Email__c,Phone_1__c,Phone_2__c,Phone_3__c
        From Licensure__c Where License_Type__c = 'Certified Phlebotomy Technician']) 
      {
      licensureArray.addAll(data);
    }
    return licensureArray;
  }

  @ReadOnly
  @RemoteAction
  public static List <Licensure__c> getLicensureMatches(String pAccountId) {
    List <String>       licensureIdsArray = new List <String>();
    List <Licensure__c> licensureArray    = new List <Licensure__c>();
    Integer i,j,k,l;
    
    for (List <XMatched__c> licensureList : [SELECT LicensureId__c FROM XMatched__c WHERE MatchingAccountId__c = :pAccountId]) {
      j = licensureList.Size();
      for(i=0;i<j;i++) {
        licensureIdsArray.add(licensureList[i].LicensureId__c);
      }
    }

    for (List <Licensure__c> matches : 
      [SELECT Id,Last_Name__c,First_Name__c,Middle_Name__c,License_Addr_City__c,License_Addr_State__c,License_Addr_Street__c,License_Addr_Zip__c,
        License_Agency__c, License_Expiration_Date__c,License_Status__c,License_Type__c,
        Email__c,Phone_1__c,Phone_2__c,Phone_3__c
        From Licensure__c Where Id IN :licensureIdsArray]) {
      l = matches.Size();
      for(k=0;k<l;k++) {
        licensureArray.add(matches[k]);
      }
    }
    return licensureArray;
  }

  @RemoteAction     
  public static void startXMatchBatchTruncate(String pAccountId,String pMatchTarget) {
    Database.executeBatch(new XMatchBatchTruncate(pAccountId,pMatchTarget), 2000);   
  }

  @RemoteAction     
  public static void startXMatchedBatchTruncate(String pAccountId,String pMatchCode) {
    Database.executeBatch(new XMatchedBatchTruncate(pAccountId,pMatchCode), 2000);   
  }

  @RemoteAction
    public static List<XMatch__c> queueMatchData(Integer batchSize, Id accountId, string whereOption, string matchTarget) {       
    List <Contact> data;
    List <Contact> batchedData;
    List <Gotv_Universe__c> uData;
    List <String> queryArray = new List<String>();
    Integer i,j,k,l,cnt,batchCnt = 0;
    String filterSoql,baseSoql,queryWhere,querySoql,lastName,firstName;
    Boolean noErrors = true;

    if(matchTarget == 'Contact') {
      baseSoql   = 'SELECT Id FROM Contact WHERE ';      
    } else {
      baseSoql   = 'SELECT Id,First_Name__c,Last_Name__c FROM Licensure__c WHERE ';
    }
    queryWhere = '';
    for (list <Contact> dataList : [
      // Note: In this first iteration, there isn't any logic (simple or fuzzy) yet.  All it does at the moment is find named dups.
      //       This will be enhanced over time to add more intelliigent matching algorithms.
      //       When that logic is used, I'll pull more fields to match on, but for now just using firstname & lastname to find dups.  
      //       SELECT Department,Division__c,Email,FirstName,HomePhone,Id,In_Current_BU__c,LastName,MailingCity,MailingPostalCode,MailingState,MailingStreet,Member_Status__c,MiddleName,MobilePhone,Phone,Title 

      // Batch up names to look for:
      SELECT Id,FirstName,LastName
      FROM Contact WHERE In_Current_BU__c = true AND AccountId = :accountId
      ORDER BY LastName Asc,Firstname ASC]) {
      l = dataList.size();
      for(i=0;i<l;i++) {
        lastName  = dataList[i].LastName.escapeEcmaScript();  // Handles names like O'connor
        firstName = dataList[i].FirstName.escapeEcmaScript();
        if(batchCnt > 0) {
          queryWhere += ' OR ';
        }
        if(matchTarget == 'Contact') {
          queryWhere += ' (LastName Like \'' + lastName + '%\' AND FirstName Like \'' + firstName + '%\') ';
        } else {
          queryWhere += ' (Last_Name__c Like \'' + lastName + '%\' AND First_Name__c Like \'' + firstName + '%\') ';
        }
        if(batchCnt == batchSize || i == l-1) {
          system.debug('************************');
          system.debug(batchCnt);
          system.debug('************************');
          if(whereOption.length() > 0) {
            querySoql = baseSoql + ' ( ' + whereOption + ') AND (' + queryWhere + ')';
          }
          else {
            querySoql = baseSoql + queryWhere;
          }
          system.debug(querySoql);
          queryArray.add(querySoql);
          queryWhere = '';
          batchCnt   = 0;
        } else {
          batchCnt++;
        }
      }
    }
    
    // ------------------------------------------------------------------------------------------- //
    // Save XMatch__c records
    // ------------------------------------------------------------------------------------------- //
    ID retVal = null;
    XMatch__c tmpXmatchRec;
    XMatch__c[] xArray = new List<XMatch__c>();
    for(i=0;i<queryArray.size();i++) {
      tmpXmatchRec = new XMatch__c();
      tmpXmatchRec.AccountId__c   = accountId;
      tmpXmatchRec.JobId__c       = '';
      tmpXmatchRec.JobStatus__c   = 'Queued'; 
      tmpXmatchRec.JobQuery__c    = queryArray[i];
      tmpXmatchRec.MatchTarget__c = matchTarget;
      xArray.add(tmpXmatchRec);
    }

    Database.SaveResult[] srList = Database.insert(xArray, false);
    for (Database.SaveResult sr : srList) {
      if(sr.isSuccess()) {
        retVal = sr.getId();
        System.debug('Successfully inserted record. ID: ' + retVal);
      }
      else {
        noErrors = false;
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return xArray;
  }

  public static String truncateXMatched(String pAccountId, String pMatchTarget) {
    Integer i,l;
    String retVal;
    List<XMatched__c> XMatchedArray = new List<XMatched__c>();
    retVal = 'ok'; 
    for (list <XMatched__c> dataList : [SELECT Id FROM XMatched__c WHERE MatchingAccountId__c = :pAccountId AND MatchCode__c = :pMatchTarget]) {
      XMatchedArray.addAll(dataList);
      // ------------------------------------------------------------------------------------------- //
      // Delete all XMatched__c records
      // ------------------------------------------------------------------------------------------- //
      Database.DeleteResult[] drList = Database.delete(XMatchedArray, false);
      for (Database.DeleteResult dr : drList) {
        if(!dr.isSuccess()) {
          retVal = 'error';
          for(Database.Error err : dr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
          }
        }
      }
      XMatchedArray.clear();
    }
    return retVal;
  }

  public static String truncateXMatches(String pAccountId, String pMatchTarget) {
    String retVal;
    List<XMatch__c > XMatchArray = new List<XMatch__c>();
    retVal = 'ok'; 
    for (list <XMatch__c> dataList : [SELECT Id FROM XMatch__c WHERE AccountId__c = :pAccountId AND MatchTarget__c = :pMatchTarget]) {
      XMatchArray.addAll(dataList);
      // ------------------------------------------------------------------------------------------- //
      // Delete all XMatched__c records
      // ------------------------------------------------------------------------------------------- //
      Database.DeleteResult[] drList = Database.delete(XMatchArray, false);
      for (Database.DeleteResult dr : drList) {
        if(!dr.isSuccess()) {
          retVal = 'error';
          for(Database.Error err : dr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
          }
        }
      }
      XMatchArray.clear();
    }
    return retVal;
  }

  @RemoteAction     
  public static String startXMatchBatch(String pAccountId,String pMatchTarget) {
    String xmatchId,accountId,jobId,matchTarget,jobQuery,truncateResult;
    List <XMatch__c> jobItems = [SELECT Id,AccountId__c,JobStatus__c,JobId__c,JobQuery__c,MatchTarget__c FROM XMatch__c WHERE AccountId__c = :pAccountId AND MatchTarget__c = :pMatchTarget AND JobStatus__c = 'Queued' LIMIT 1];
    if(jobItems.size() == 0) {
      System.debug('All queries run');
    } else {
      xmatchId    = jobItems[0].Id;
      jobQuery    = jobItems[0].JobQuery__c;
      matchTarget = jobItems[0].MatchTarget__c;
      System.debug('startXMatchBatch()..');
      System.debug(' GotvCcController.XMatchBatchQuery : starting Job with ' + xmatchId + ' record from XMatch__c');
      Database.executeBatch(new XMatchBatchQuery(xmatchId,pAccountId,jobQuery,matchTarget), 2000);   
    }
    System.debug(' GotvCcController.XMatchBatchQuery : startJob Finished');
    return 'ok';
  }

  @RemoteAction
  public static ID saveUniverse(ID accountId, String type, String name, String description, String filterSoql, String filterSettings) {
    System.debug('Save Univers: accountId: ' + accountId + ' description: ' + description );
    System.debug(filterSoql);
    Gotv_Universe__c universe = new Gotv_Universe__c();
    universe.Account__c     = accountId;
    universe.Type__c        = type;
    universe.Name           = name;
    universe.Description__c = description;
    universe.FilterSoql__c  = filterSoql;
    universe.SavedFilter__c = filterSettings;
    ID retVal = null;
    
    // ------------------------------------------------------------------------------------------- //
    // Save Gotv_Universe__c record
    // ------------------------------------------------------------------------------------------- //
    Gotv_Universe__c[] uArray = new List<Gotv_Universe__c>();
    uArray.add(universe);
    Database.SaveResult[] srList = Database.insert(uArray, false);
    for (Database.SaveResult sr : srList) {
      if(sr.isSuccess()) {
        retVal = sr.getId();
        System.debug('Successfully inserted record. ID: ' + retVal);
      }
      else {
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return retVal;
  }

  @RemoteAction
    public static ID updateUniverse(ID universeId, String name, String description, String filterSoql, String filterSettings) {
    Gotv_Universe__c universe = new Gotv_Universe__c();
    universe.Id             = universeId;
    universe.Name           = name;
    universe.Description__c = description;
    universe.FilterSoql__c  = filterSoql;
    universe.SavedFilter__c = filterSettings;
    ID retVal = null;
    
    // ------------------------------------------------------------------------------------------- //
    // Update Gotv_Universe__c record
    // ------------------------------------------------------------------------------------------- //
    Gotv_Universe__c[] uArray = new List<Gotv_Universe__c>();
    uArray.add(universe);
    Database.SaveResult[] srList = Database.update(uArray, false);
    for (Database.SaveResult sr : srList) {
      if(sr.isSuccess()) {
        retVal = sr.getId();
        System.debug('Successfully updated record. ID: ' + retVal);
      }
      else {
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return retVal;
  }

  @RemoteAction
  public static ID deleteUniverse(ID universeId) {
    Gotv_Universe__c universe = new Gotv_Universe__c();
    universe.Id = universeId;
    ID retVal = null;
        
    // ------------------------------------------------------------------------------------------- //
    // Delete Gotv_Universe__c record
    // ------------------------------------------------------------------------------------------- //
    Gotv_Universe__c[] uArray = new List<Gotv_Universe__c>();
    uArray.add(universe);
    Database.DeleteResult[] drList = Database.delete(uArray, false);
    for (Database.DeleteResult dr : drList) {
      if(dr.isSuccess()) {
        retVal = dr.getId();
        System.debug('Successfully deleted record. ID: ' + retVal);
      }
      else {
        for(Database.Error err : dr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return retVal;
  }

  @RemoteAction
  public static ID saveView(String name, String description,  String viewClass, String type, String columnModel, String sortModel) {
    System.debug('Save View: Name: ' + name + ' description: ' + description );
    Gotv_Views__c view   = new Gotv_Views__c();
    view.Name           = name;
    view.Description__c = description;
    view.ViewClass__c   = viewClass;
    view.Type__c        = type;
    view.ColumnState__c = columnModel;
    view.SortModel__c   = sortModel;
    ID retVal = null;
        
    // ------------------------------------------------------------------------------------------- //
    // Save Gotv_Views__c record
    // ------------------------------------------------------------------------------------------- //
    Gotv_views__c[] vArray = new List<Gotv_views__c>();
    vArray.add(view);
    Database.SaveResult[] srList = Database.insert(vArray, false);
    for (Database.SaveResult sr : srList) {
      if(sr.isSuccess()) {
        retVal = sr.getId();
        System.debug('Successfully inserted record. ID: ' + retVal);
      }
      else {
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return retVal;
  }

  @RemoteAction 
  public static ID updateView(ID viewId, String name, String description, String type, String columnModel, String sortModel) {
    GOTV_Views__c view = new GOTV_Views__c();
    view.Id             = viewId;
    view.Name           = name;
    view.Description__c = description;
    view.Type__c        = type;
    view.ColumnState__c = columnModel;
    view.SortModel__c   = sortModel;
    ID retVal = null;
     
    // ------------------------------------------------------------------------------------------- //
    // Update GOTV_Views__c record
    // ------------------------------------------------------------------------------------------- //
    GOTV_Views__c[] vArray = new List<GOTV_Views__c>();
    vArray.add(view);
    Database.SaveResult[] srList = Database.update(vArray, false);
    for (Database.SaveResult sr : srList) {
      if(sr.isSuccess()) {
        retVal = sr.getId();
        System.debug('Successfully updated record. ID: ' + retVal);
      }
      else {
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return retVal;
  }

  @RemoteAction
  public static ID deleteView(ID viewId) {
    GOTV_Views__c view = new GOTV_Views__c();
    view.Id = viewId;
    ID retVal = null;
      
    // ------------------------------------------------------------------------------------------- //
    // Delete GOTV_Views__c record
    // ------------------------------------------------------------------------------------------- //
    GOTV_Views__c[] vArray = new List<GOTV_Views__c>();
    vArray.add(view);
    Database.DeleteResult[] drList = Database.delete(vArray, false);
    for (Database.DeleteResult dr : drList) {
      if(dr.isSuccess()) {
        retVal = dr.getId();
        System.debug('Successfully deleted record. ID: ' + retVal);
      }
      else {
        for(Database.Error err : dr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
    return retVal;
  }

  @RemoteAction
  public static String assignVoteBlock(String voteBlock, String[] Ids) {
    Integer i=0,l=0;
    String retVal;
    List <Contact> contactData = new List<Contact>();
    Contact tmpContact;

    for (list <Contact> dataList : [
      SELECT  Id, GOTV_Vote_Block_Time__c
      FROM Contact
      WHERE Id IN :Ids]) {
      l = dataList.size();
      for(i=0;i<l;i++) {
        tmpContact = new Contact();
        tmpContact.Id = dataList[i].Id;
        if (!String.IsEmpty(voteBlock)) {
          tmpContact.GOTV_Vote_Block_Time__c = voteBlock;
        }
        else {
          tmpContact.GOTV_Vote_Block_Time__c = null;
        }
        contactData.add(tmpContact);
      }            
    }
    // ------------------------------------------------------------------------------------------- //
    // Update Contacts
    // ------------------------------------------------------------------------------------------- //
    try {
      update contactData;
      retVal = 'OK';
    } catch(Exception e) {
      System.debug('Error updating Contact records. ' + e.getMessage());
      retVal = 'Error: ' + e.getMessage();
    }
    return retVal;
  }

  @RemoteAction
  public static String updateTaskNote(Task taskObj) {
    Id accountId,id,whoId;
    String description,subject,type;
    String retVal = 'OK';
    System.debug(' -----------updateTaskNote2------------- ');
    System.debug(taskObj);

    id          = taskObj.Id;
    accountId   = taskObj.AccountId;
    whoId       = taskObj.WhoId; 
    type        = 'GotvNote';
    description = taskObj.Description;
    subject     = taskObj.Subject;
    System.debug(id);    
    System.debug(accountId);
    System.debug(whoId);
    System.debug(type);
    System.debug(description);
    System.debug(subject);

    Task[] tArray = new List<Task>();
    Task tempTask = new Task();
//  tempTask.AccountId   = accountId; // Compile Error: Field is not writeable: Task.AccountId 
    tempTask.WhoId       = whoId;
    tempTask.Type        = type;
    tempTask.Description = description;
    tempTask.Subject     = subject;
    tempTask.Status      = 'Closed';

    if(id != null) {
      tempTask.Id = id;
      // ------------------------------------------------------------------------------------------- //
      // Update Task record
      // ------------------------------------------------------------------------------------------- //
      tArray.add(tempTask);
      Database.SaveResult[] srList = Database.update(tArray, false);
      for (Database.SaveResult sr : srList) {
        if(sr.isSuccess()) {
          retVal = sr.getId();
          System.debug('Successfully updated record. ID: ' + retVal);
        }
        else {
          for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
          }
        }
      }
    } else {
      // ------------------------------------------------------------------------------------------- //
      // Save Task record
      // ------------------------------------------------------------------------------------------- //
      tArray.add(tempTask);
      Database.SaveResult[] srList = Database.insert(tArray, false);
      for (Database.SaveResult sr : srList) {
        if(sr.isSuccess()) {
          retVal = sr.getId();
          System.debug('Successfully inserted record. ID: ' + retVal);
        }
        else {
          for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
          }
        }
      }      
    }
    return retVal;
  }

  @RemoteAction
  public static String updateContact(ID contactId, String fieldName, String setTo) {

    String contactName;
    String gotvPlanType = 'null';
    String gotvInsidePlanNotes = '';
    Boolean sendNotesEmail = false;
    Boolean sendTypeEmail  = false;
    Boolean emailAddrSet   = false;
    Contact tmpContact = new Contact();
    Contact currentRec;
    tmpContact.Id = contactId;

    Organization orgData = [SELECT ID,INSTANCENAME,ISSANDBOX FROM Organization];

    List<Contact> currentContData = [
        SELECT AccountId,Department,FirstName,LastName,Mailing_BA__c,MailingCity,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Notes_Consolidated__c,Title,Assigned_to_VC__c,Build_OC_Support__c,Card_Assessment__c,Division__c,DoNotCall,
          GOTV_Assessment__c,GOTV_Board_Challenge__c,GOTV_Challenge_Reason__c,GOTV_Challenge__c,
          GOTV_Card_Signed_Date__c,GOTV_Exact_Vote_Time__c,GOTV_Gettable__c,GOTV_Hard_Pull__c,GOTV_Hard_Pull_Reason__c,GOTV_Inside_Plan_Notes__c,GOTV_Off_Both_Days__c,GOTV_Outside_Plan__c,
          GOTV_Plan_Type__c,GOTV_Shift_Scheduler__c,GOTV_Slip__c,GOTV_Special_Plan__c,GOTV_Special_Plan_Notes__c,GOTV_Took_Photo__c,GOTV_UHW_Challenge__c,GOTV_Vote_Block_Time__c,GOTV_Vote_Yes_Petition__c,GOTV_Where_After_Voting__c, 
          GOTV_Where_Before_Voting__c,GOTV_Works_Eday_1__c,Id,New_Org_Card_Signed_By__c,New_Org_Card_Signed_By__r.Name, Purple_UP__c,Reconfirmed_GOTV__c,Shift__c,
          Staffing_17__c,Sticker_Up_Actions__c,Three_Touch__c,Three_Touch_ST__c,Three_Touch_VC__c,Vote_Captain__c,Work_Days_at_Primary_Worksite__c,Works_Night_Before_Eday2__c,
          LastModifiedDate,
          (SELECT Id, AccountId, WhoId, ActivityDate, Description, Subject, Type, LastModifiedBy.Name, LastModifiedDate, Owner.Name FROM Tasks WHERE Type = 'GotvNote'), 
          (SELECT Response_Value__c 
           FROM Survey_Responses__r 
           WHERE Contact__r.Id = :contactId And Survey_Question__r.Is_Vote_Block__c = true
          )
        FROM Contact
      WHERE Id = :contactId AND In_Current_BU__c = true];
    if(currentContData.size() > 0) {
      currentRec   = currentContData[0];
      contactName  = currentRec.FirstName + ' ' + currentRec.LastName;
      if(!String.isBlank(currentRec.GOTV_Plan_Type__c)) {
        gotvPlanType = currentRec.GOTV_Plan_Type__c;
      }
      if(!String.isBlank(currentRec.GOTV_Inside_Plan_Notes__c)) {
        gotvInsidePlanNotes = currentRec.GOTV_Inside_Plan_Notes__c;
      }
    }

    if(fieldName == '[AC]') {
      if(setTo == 'true') {
        tmpContact.Activist__c = true;
      } else {
        tmpContact.Activist__c = false;
      }
    } 

    if(fieldName == '[BA]') {
      if(setTo == 'true') {
        tmpContact.Mailing_BA__c = true;
      } else {
        tmpContact.Mailing_BA__c = false;
      }
    } 

    if(fieldName == '[BC]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Board_Challenge__c = true;
      } else {
        tmpContact.GOTV_Board_Challenge__c = false;
      }
    } 

    if(fieldName == '[BO]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Off_Both_Days__c = true;
      } else {
        tmpContact.GOTV_Off_Both_Days__c = false;
      }
    } 

    if(fieldName == '[CA]') {
      if(setTo == 'true') {
        tmpContact.Captain__c = true;
      } else {
        tmpContact.Captain__c = false;
      }
    } 

    if(fieldName == '[CU]') {
      if(setTo == 'true') {
        tmpContact.Cross_Match_UHW__c = true;
      } else {
        tmpContact.Cross_Match_UHW__c = false;
      }
    }

    if(fieldName == '[CV]') {
      if(setTo == 'true') {
        tmpContact.Vote_Captain__c = true;
      } else {
        tmpContact.Vote_Captain__c = false;
      }
    } 

    if(fieldName == '[DC]') {
      if(setTo == 'true') {
        tmpContact.DoNotCall = true;
      } else {
        tmpContact.DoNotCall = false;
      }
    } 

    if(fieldName == '[GT]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Gettable__c = true;
      } else {
        tmpContact.GOTV_Gettable__c = false;
      }
    } 

    if(fieldName == '[HP]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Hard_Pull__c = true;
      } else {
        tmpContact.GOTV_Hard_Pull__c = false;
      }
    } 

    if(fieldName == '[IB]') {
      if(setTo == 'true') {
        tmpContact.In_Current_BU__c = true;
      } else {
        tmpContact.In_Current_BU__c = false;
      }
    } 

    if(fieldName == '[IC]') {
      if(setTo == 'true') {
        tmpContact.Ics__c = true;
      } else {
        tmpContact.Ics__c = false;
      }
    } 

    if(fieldName == '[IL]') {
      if(setTo == 'true') {
        tmpContact.ID_Leaders__c = true;
      } else {
        tmpContact.ID_Leaders__c = false;
      }
    } 

    if(fieldName == '[IN]') {
      if(setTo == 'true') {
        tmpContact.Inoculated__c = true;
      } else {
        tmpContact.Inoculated__c = false;
      }
    } 

    if(fieldName == '[LO]') {
      if(setTo == 'true') {
        tmpContact.LOA__c = true;
      } else {
        tmpContact.LOA__c = false;
      }
    } 

    if(fieldName == '[N1]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Works_Night_Before_Eday1__c = true;
      } else {
        tmpContact.GOTV_Works_Night_Before_Eday1__c = false;
      }
    } 

    if(fieldName == '[N2]') {
      if(setTo == 'true') {
        tmpContact.Works_Night_Before_Eday2__c = true;
      } else {
        tmpContact.Works_Night_Before_Eday2__c = false;
      }
    } 

    if(fieldName == '[OB]') {
      if(setTo == 'true') {
        tmpContact.Three_Touch__c = true;
      } else {
        tmpContact.Three_Touch__c = false;
      }
    } 

    if(fieldName == '[OC]') {
      if(setTo == 'true') {
        tmpContact.OC_Member__c = true;
      } else {
        tmpContact.OC_Member__c = false;
      }
    } 

    if(fieldName == '[PR]') {
      if(setTo == 'true') {
        tmpContact.Photo_Release_Signed__c = true;
      } else {
        tmpContact.Photo_Release_Signed__c = false;
      }
    } 

    if(fieldName == '[RC]') {
      if(setTo == 'true') {
        tmpContact.Reconfirmed_GOTV__c = true;
      } else {
        tmpContact.Reconfirmed_GOTV__c = false;
      }
    }       

    if(fieldName == '[SC]') {
      if(setTo == 'true') {
        tmpContact.Schedule_In_Hand__c = true;
      } else {
        tmpContact.Schedule_In_Hand__c = false;
      }
    } 
    
    if(fieldName == '[SL]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Slip__c = true;
      } else {
        tmpContact.GOTV_Slip__c = false;
      }
    } 

    if(fieldName == '[SP]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Special_Plan__c = true;
      } else {
        tmpContact.GOTV_Special_Plan__c = false;
      }
    } 

    if(fieldName == '[ST]') {
      if(setTo == 'true') {
        tmpContact.Three_Touch_ST__c = true;
      }
      else {
        tmpContact.Three_Touch_ST__c = false;
      }
    } 

    if(fieldName == '[TP]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Took_Photo__c = true;
      } else {
        tmpContact.GOTV_Took_Photo__c = false;
      }
    } 

    if(fieldName == '[UC]') {
      if(setTo == 'true') {
        tmpContact.GOTV_UHW_Challenge__c = true;
      } else {
        tmpContact.GOTV_UHW_Challenge__c = false;
      }
    } 

    if(fieldName == '[VC]') {
      if(setTo == 'true') {
        tmpContact.Three_Touch_VC__c = true;
      } else {
        tmpContact.Three_Touch_VC__c = false;
      }
    } 

    if(fieldName == '[W1]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Works_Eday_1__c = true;
      } else {
        tmpContact.GOTV_Works_Eday_1__c = false;
      }
    } 

    if(fieldName == '[W2]') {
      if(setTo == 'true') {
        tmpContact.GOTV_Works_Eday2__c = true;
      } else {
        tmpContact.GOTV_Works_Eday2__c = false;
      }
    } 

    if(fieldName == '[X1]') {
      if(setTo == 'true') {
        tmpContact.X1_1_complete__c = true;
      } else {
        tmpContact.X1_1_complete__c = false;
      }
    } 

    // ---------------------------------------------------------------
    if(fieldName == 'AssignedLeader') {
      tmpContact.AssignedLeader__c = setTo;
    } 

     if(fieldName == 'AssignedToVc') {
      tmpContact.Assigned_to_VC__c = setTo;
     } 

    // Compile Error: Field is not writeable: Contact.Assigned_to_VC_Name__c

    if(fieldName == 'AssistantName') {
      tmpContact.AssistantName = setTo;
    } 

    if(fieldName == 'BU') {
      tmpContact.BU__c = setTo;
    } 

    if(fieldName == 'BuildOcSupport') {
      tmpContact.Build_OC_Support__c = setTo;
    } 

    // Note: ignoring CardAssess, as it's a formula field.

    if(fieldName == 'CaptainsOc') {
      tmpContact.Captain_s_OC__c  = setTo;
    } 

    if(fieldName == 'CardAssessment') {
      tmpContact.Card_Assessment__c  = setTo;
    } 

    if(fieldName == 'CellPhone') {
      tmpContact.MobilePhone = setTo;
    } 

    if(fieldName == 'CrossMatchFacility') {
      tmpContact.CrossMatchFacility__c = setTo;
    }     

    if(fieldName == 'Department') {
      tmpContact.Department = setTo;
    }     

    if(fieldName == 'DialysisBuildOc') {
      tmpContact.Dialysis_Build_OC__c = setTo;
    } 

    if(fieldName == 'DialysisEmployer') {
      tmpContact.Dialysis_Employer__c = setTo;
      system.debug('******** changed Dialysis_Employer__c to ' + setTo );
    } 

    if(fieldName == 'DialysisPhases') {
      tmpContact.Dialysis_Phases__c = setTo;
    } 

    if(fieldName == 'DignityRegion') {
      tmpContact.Dignity_Region__c = setTo;
    }     

    if(fieldName == 'DignitySubRegion') {
      tmpContact.Dignity_Sub_Region__c = setTo;
    } 

    if(fieldName == 'Divisin') {
      tmpContact.Division__c = setTo;
    } 

    if(fieldName == 'DivSubRegion') {
      tmpContact.Div_Sub_Region__c = setTo;
    } 
    
    if(fieldName == 'FirstName') {
      tmpContact.FirstName = setTo;
    } 
     
    if(fieldName == 'LastName') {
      tmpContact.LastName = setTo;
    } 

    // note: ignoring GotvAssess (GOTV_Assess__c), as it's a formula field.

    if(fieldName == 'GotvAssessment') {
      tmpContact.GOTV_Assessment__c = setTo;
    } 

    if(fieldName == 'GotvChallenge') {
      tmpContact.GOTV_Challenge__c = setTo;
    }

    if(fieldName == 'GotvCardSignedDate') {
      tmpContact.GOTV_Card_Signed_Date__c = Date.parse(setTo); // Does this need conversion?
    } 

    if(fieldName == 'GotvExactVoteTime') {
      tmpContact.GOTV_Exact_Vote_Time__c = Date.parse(setTo); // Does this need conversion?
    } 

    if(fieldName == 'GotvHardPullReason') {
      tmpContact.GOTV_Hard_Pull_Reason__c = setTo;
    }

    if(fieldName == 'GotvInsidePlanNotes') {
      tmpContact.GOTV_Inside_Plan_Notes__c = setTo;
      sendNotesEmail = true;
    }

    if(fieldName == 'GotvOutsidePlanNotes') {
      tmpContact.GOTV_Outside_Plan__c = setTo;
      sendNotesEmail = true;
    }

    if(fieldName == 'GotvPlanType') {
      tmpContact.GOTV_Plan_Type__c = setTo;
      sendTypeEmail = true;
    } 

    if(fieldName == 'GotvShiftScheduler') {
      tmpContact.GOTV_Shift_Scheduler__c = setTo;
    } 

    if(fieldName == 'GotvSpecialPlanNotes') {
      tmpContact.GOTV_Special_Plan_Notes__c = setTo;
    }

    if(fieldName == 'GotvVoteYesPetition') {
      tmpContact.GOTV_Vote_Yes_Petition__c = setTo;
    } 

    // note: ignoring VoteBlock as it's a Survey Response and is only used to populate GOTV_Vote_Block_Time__c

    if(fieldName == 'GotvVoteBlockTime') {
      tmpContact.GOTV_Vote_Block_Time__c = setTo;
    } 

    if(fieldName == 'GotvWhereBeforeVoting') {
      tmpContact.GOTV_Where_Before_Voting__c = setTo;
    } 
      
    if(fieldName == 'GotvWhereAfterVoting') {
      tmpContact.GOTV_Where_After_Voting__c = setTo;
    }

    if(fieldName == 'HomePhone') {
      tmpContact.HomePhone = setTo;
    } 

    if(fieldName == 'LicListPhone') {
      tmpContact.Lic_List_Phone__c = setTo;
    }

    if(fieldName == 'NewOrgCardSignedBy') {
      tmpContact.New_Org_Card_Signed_By__c = setTo;
    }

    // Compile Error: Field is not writeable: Contact.Owner_Name__c
    //  if(fieldName == 'OwnerName') {
    //    tmpContact.Owner_Name__c = setTo; // OwnerId needs changing
    //  } 

    if(fieldName == 'MailingStreet') {
      tmpContact.MailingStreet = setTo;
    } 

    if(fieldName == 'MailingCity') {
      tmpContact.MailingCity = setTo;
    } 

    if(fieldName == 'MailingState') {
      tmpContact.MailingState = setTo;
    } 

    if(fieldName == 'MailingZip') {
      tmpContact.MailingPostalCode = setTo;
    } 

    if(fieldName == 'NotesConsolidated') {
      tmpContact.Notes_Consolidated__c = setTo;
    }

    if(fieldName == 'OtherPhone') {
      tmpContact.OtherPhone = setTo;
    } 

    if(fieldName == 'Phone') {
      tmpContact.Phone = setTo;
    } 

    if(fieldName == 'PurpleUp') {
      tmpContact.Purple_UP__c = setTo;
    } 

    if(fieldName == 'StickerUpActions') {
      tmpContact.Sticker_Up_Actions__c = setTo;
    } 

    if(fieldName == 'Shift') {
      tmpContact.Shift__c = setTo;
    } 

    if(fieldName == 'Staffing17') {
      tmpContact.Staffing_17__c = setTo;
    } 

    if(fieldName == 'Staffing17CollectedBy') {
      tmpContact.Staffing_17_Collected_By__c = setTo;
    } 

    if(fieldName == 'Title') {
      tmpContact.Title = setTo;
    }

    // if(fieldName == 'SignedMembershipCardDate') {
    //   tmpContact.Signed_Membership_Card_Date__c = setTo;  // Need conversion?
    // } 

    if(fieldName == 'WorkDaysAtPrimaryWorksite') {
      tmpContact.Work_Days_at_Primary_Worksite__c = setTo;
    }

    if(fieldName == 'Worksite') {
      tmpContact.Worksite__c = setTo;
    }

    if(fieldName == 'WorksiteAddInfo') {
      tmpContact.Worksite_Add_Info__c = setTo;
    }

    if(fieldName == 'WorkStatus') {
      tmpContact.Work_Status__c = setTo;
    }

    if(fieldName == 'VerbalAssessment') {
      tmpContact.Verbal_Assessment__c  = setTo;
    }  


// ***********************************************************

    List <Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
    List <String> insideAddressArray   = new List <String>();
    List <String> outsideAddressArray  = new List <String>();

    List <String> defaultAddressArray  = new List <String>();
    List <String> ccAddressArray = new List <String>();
    String currentUser           = UserInfo.getName();
    String currentUserEmail      = UserInfo.getUserEmail();
    String emailMsg;
    Messaging.SingleEmailMessage singleEmail;

    //  Plan Type Email Routing:
    Integer i, listSize;
    String plan, planType, emailAddr;
    Boolean defaultAddr;

    List<GOTV_Email_Recipients__c> whoToEmail = [SELECT PlanType__c,Default__c,User__r.Email FROM GOTV_Email_Recipients__c];
    listSize = whoToEmail.size();

    for(i=0;i<listSize;i++) {
      planType    = whoToEmail[i].PlanType__c;
      emailAddr   = whoToEmail[i].User__r.Email;
      defaultAddr = whoToEmail[i].Default__c;
      if(planType == 'I') {
        plan = 'Inside';
        insideAddressArray.add(emailAddr);
      }

      if(planType == 'O') {
        plan = 'Outside';
        outsideAddressArray.add(emailAddr);
      }

      if(planType == 'B') {
        plan = 'Inside and Outside';
        insideAddressArray.add(emailAddr);
        outsideAddressArray.add(emailAddr);
      }

      if(defaultAddr) {
        defaultAddressArray.add(emailAddr);
      }

      System.debug( plan + ' email send to ' + emailAddr );
}

    if(sendTypeEmail || Test.isRunningTest()) {
      singleEmail = new Messaging.SingleEmailMessage();
      singleEmail.setReplyTo('noreply@seiu-uhw.org');            
      emailMsg = '<p>This is to inform you that the GOTV Plan Type for ' + contactName + ' was switched from ' + gotvPlanType + ' to ' + setTo + '</p>';
      emailMsg += '<p>Current GOTV Inside Plan Note: ' + gotvInsidePlanNotes + '</p>';
      if(setTo == 'Inside') {
        singleEmail.setSubject('GOTV Plan Type Changed to Inside for ' + contactName);
        singleEmail.setToAddresses(insideAddressArray); 
        singleEmail.setCcAddresses(outsideAddressArray); 
        emailAddrSet = true;
      }
      if(setTo == 'Outside') {
        singleEmail.setSubject('GOTV Plan Type Changed to Outside for ' + contactName);
        singleEmail.setToAddresses(outsideAddressArray); 
        singleEmail.setCcAddresses(insideAddressArray); 
        emailAddrSet = true;
      }
      if(setTo == 'Both') {
        singleEmail.setSubject('GOTV Plan Type Changed to Both for ' + contactName);
        singleEmail.setToAddresses(outsideAddressArray); 
        singleEmail.setCcAddresses(insideAddressArray); 
        emailAddrSet = true;
      }
      if(!emailAddrSet) {
        singleEmail.setSubject('GOTV Plan Type reset for ' + contactName);
        singleEmail.setToAddresses(defaultAddressArray); 
      }
      singleEmail.setHtmlBody(emailMsg);
      emailList.add(singleEmail);
      if(!orgData.ISSANDBOX && !Test.isRunningTest()) { // Only checking done here so above code isn't ignored for test (code coverage)
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
      }
    }

    if(sendNotesEmail || Test.isRunningTest()) {
      singleEmail = new Messaging.SingleEmailMessage();
      singleEmail.setReplyTo('noreply@seiu-uhw.org');            
      singleEmail.setSubject('GOTV Inside Plan Notes Changed for ' + contactName);
      emailMsg = '<p>This is to inform you that the GOTV Inside Plan Notes for ' + contactName + ' were changed by ' + currentUser + '</p>';
      emailMsg += '<p>New Note: ' + setTo + '</p>';
      if(gotvPlanType == 'Inside') {
        singleEmail.setToAddresses(insideAddressArray); 
        singleEmail.setCcAddresses(outsideAddressArray); 
        emailAddrSet = true;
      }
      if(gotvPlanType == 'Outside') {
        singleEmail.setToAddresses(outsideAddressArray); 
        singleEmail.setCcAddresses(insideAddressArray); 
        emailAddrSet = true;
      }
      if(!emailAddrSet && defaultAddressArray.size() > 0) {
        singleEmail.setSubject('GOTV Plan Type reset for ' + contactName);
        singleEmail.setToAddresses(defaultAddressArray); 
      }
      singleEmail.setHtmlBody(emailMsg);
      emailList.add(singleEmail);
      if(!orgData.ISSANDBOX && !Test.isRunningTest()) { // Only checking done here so above code isn't ignored for test (code coverage)
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
      }
    } 
       
    // ------------------------------------------------------------------------------------------- //
    // Update Contact
    // ------------------------------------------------------------------------------------------- //
    try {
      Update tmpContact;
      System.debug('Contact record updated. ');
      return 'OK';
    } catch(Exception e) {
      System.debug('Error updating Contact record. ' + e.getMessage());
      return 'Error';
    }
  }
}