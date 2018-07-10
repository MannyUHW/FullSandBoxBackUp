public class MbrActivityReportController {

  public class ReportClass {
    Id     Id;
    String FirstName;
    String LastName;
    String LeaderTier;
    Boolean X80Leader;
    Decimal PhoneBankTotal;
    Decimal LastCopeAmt;
    Decimal SignatureCnt;
    Date LastCopeDate;
    String Source;

    Id AccountId;
    String AccountName;
    Decimal BuCount;          
    String Region;           
    String AccountGroup;     
    String ConstituencyCode; 
    String ConstituencyName; 
    String SubSeat;          
    String DistrictName;
    String EcommName;
    Id EcommId;

  }

  class AccountClass {
    Id AccountId;
    String AccountName;
    Decimal BuCount;          
    String Region;           
    String AccountGroup;     
    String ConstituencyCode; 
    String ConstituencyName; 
    String SubSeat;          
    String DistrictName;
    String EcommName;
    Id EcommId;
  }

  class SignatureClass {
    Id Id;
    Id AccountId;    
    String FirstName;
    String LastName;
    Decimal Total;
  }

  class PhoneBankClass {
    Id AccountId;
    Id ContactId;
    String FirstName;
    String LastName;
    Decimal Total;
  }

  @RemoteAction
  public static Map<Id,ReportClass> getReportData()  {

    Id id,accountId,ecommId;    
    Integer i;
    String accountName,firstName,lastName,leaderTier;
    String region,accountGroup,constituencyCode,constituencyName,subSeat,districtName,ecommName;
    Decimal total,validCnt,currentVal,buCount;

    Integer debugCnt_A = 0, debugCnt_B = 0, debugCnt_C = 0, debugCnt_D = 0;
    Integer debugCnt_Cope = 0, debugCnt_Acct_OK = 0, debugCnt_Acct_Missing = 0;

    Map<Id,SignatureClass> signatureMap = new Map<Id,SignatureClass>();
    Map<Id,AccountClass>   accountMap   = new Map<Id,AccountClass>();
    Map<Id,ReportClass>    reportMap    = new Map<Id,ReportClass>();
    Map<Id,PhoneBankClass> phoneBankMap = new Map<Id,PhoneBankClass>();

    Set<Id> contactSet = new Set<Id>();
    SignatureClass signatureRec;
    ReportClass rec,tmpRptObj;
    PhoneBankClass phoneBankRec;
    AccountClass accountRec;

    // ***************************************
    // 80 % Leaders
    // ***************************************
    for (Contact epCont : [SELECT Id,FirstName,LastName,X80_Leader__c,AccountId FROM Contact WHERE X80_Leader__c  != null AND In_Current_BU__c = true] )  {
        rec = new ReportClass();
        rec.Id        = epCont.Id;
        rec.AccountId = epCont.AccountId;
        rec.FirstName = epCont.FirstName;
        rec.LastName  = epCont.LastName;
        rec.X80Leader = epCont.X80_Leader__c;
        rec.Source    = 'A';
        reportMap.put(rec.Id,rec);
        contactSet.add(rec.Id);
        debugCnt_A++;
//        System.debug( '0. ' + epCont.FirstName + ' ' + epCont.LastName);
    }

    // ***************************************
    // COOL Assessment
    // ***************************************
    for (Survey_Response__c coolSr : [SELECT Contact__r.Id,Contact__r.FirstName,Contact__r.LastName,Contact__r.AccountId,Response_Value__c 
      FROM Survey_Response__c WHERE Survey_Code__c = 'CL6' AND Contact__r.In_Current_BU__c = true
      ORDER BY Contact__r.LastName,Contact__r.FirstName])  
      {
        id         = coolSr.Contact__r.Id;
        accountId  = coolSr.Contact__r.AccountId;
        firstName  = coolSr.Contact__r.Firstname;
        lastName   = coolSr.Contact__r.Lastname;
        leaderTier = coolSr.Response_Value__c;
        if(reportMap.containsKey(id)) {
          tmpRptObj = reportMap.get(id);
          tmpRptObj.LeaderTier = leaderTier;
          reportMap.put(id,tmpRptObj);
        } else {
          rec = new ReportClass();
          rec.Id             = id;
          rec.AccountId      = accountId;
          rec.FirstName      = firstname;
          rec.LastName       = lastname;
          rec.LeaderTier     = leaderTier;
          rec.X80Leader      = false;
          rec.PhoneBankTotal = 0;
          rec.Source         = 'B';
          reportMap.put(id,rec);
          contactSet.add(id);
          debugCnt_B++;
        }    
    }

    // ***************************************
    // Phone Banking (get counts)
    // ***************************************
    for (Recruit__c recruit : [
      SELECT Recruit__r.AccountId, Recruit__r.Id, Recruit__r.FirstName,Recruit__r.LastName, Total_Shift__c
      FROM Recruit__c 
      WHERE Volunteer_Date__c >= 2017-01-01 AND Recruit__c != null AND Total_Shift__c > 0
      ORDER BY Recruit__r.AccountId, Recruit__r.Id])
    {
      id         = recruit.recruit__r.Id;
      accountId  = recruit.recruit__r.AccountId;
      firstName  = recruit.Recruit__r.FirstName;
      lastName   = recruit.Recruit__r.LastName;
      total      = recruit.Total_Shift__c;

      if(phoneBankMap.containsKey(id)) {
        phoneBankRec = phoneBankMap.get(id);
        currentVal   = phoneBankRec.Total;
        phoneBankRec.Total = currentVal + total;
        phoneBankMap.put(id,phoneBankRec);
      } else {
        phoneBankRec = new PhoneBankClass();        
        phoneBankRec.ContactId = id;
        phoneBankRec.AccountId = accountId;
        phoneBankRec.FirstName = firstName;
        phoneBankRec.LastName  = lastName;
        phoneBankRec.Total     = total;
        phoneBankMap.put(id,phoneBankRec);
      }
    }

    // Apply counts
    for (Id phoneBankMapId : phoneBankMap.keySet()) {
      phoneBankRec = phoneBankMap.get(phoneBankMapId);
      if(reportMap.containsKey(phoneBankMapId)) {
        tmpRptObj = reportMap.get(phoneBankMapId);
        tmpRptObj.PhoneBankTotal = phoneBankRec.Total;
        reportMap.put(id,tmpRptObj);
      } else {
        rec = new ReportClass();
        rec.Id             = phoneBankMapId;
        rec.AccountId      = phoneBankRec.AccountId;
        rec.FirstName      = phoneBankRec.Firstname;
        rec.LastName       = phoneBankRec.Lastname;
        rec.X80Leader      = false;
        rec.PhoneBankTotal = phoneBankRec.Total;
        rec.Source         = 'C';
        reportMap.put(phoneBankMapId,rec);
        contactSet.add(phoneBankMapId);        
        debugCnt_C++;
      }
    }

    // *****************************************
    // Dialysis Petition Signatures (get counts)
    // *****************************************
    for(Petition_Ledger__c pl  : [
      SELECT Transferred_From__r.Id,Transferred_From__r.FirstName,Transferred_From__r.LastName,Transferred_From__r.AccountId,Valid_Signatures__c FROM Petition_Ledger__c 
      WHERE Transferred_From__c != null AND Valid_Signatures__c != null ORDER BY Transferred_From__c]) 
    {
      id        = pl.Transferred_From__r.Id;  
      accountId = pl.Transferred_From__r.AccountId;
      firstName = pl.Transferred_From__r.FirstName;
      lastName  = pl.Transferred_From__r.LastName;
      validCnt  = pl.Valid_Signatures__c;
      if(signatureMap.containsKey(id)) {
        signatureRec = signatureMap.get(id);
        currentVal = signatureRec.Total;
        signatureRec.Total = currentVal + validCnt;
        signatureMap.put(id,signatureRec);
      } else {
        signatureRec = new SignatureClass();
        signatureRec.Id = id;
        signatureRec.AccountId = accountId;
        signatureRec.FirstName = firstName;
        signatureRec.LastName  = lastName;
        signatureRec.Total     = validCnt;
        signatureMap.put(id,signatureRec);
      }
    }

    // Apply counts
    for (Id signatureMapId : signatureMap.keySet()) {
      signatureRec = signatureMap.get(signatureMapId);
      currentVal   = signatureRec.Total;
      if(reportMap.containsKey(signatureMapId)) {
        tmpRptObj = reportMap.get(signatureMapId);
        tmpRptObj.SignatureCnt = currentVal;
        reportMap.put(id,tmpRptObj);
      } else {
        accountId = signatureRec.AccountId;
        firstname = signatureRec.FirstName;
        lastname  = signatureRec.LastName;
        rec = new ReportClass();
        rec.Id             = signatureMapId;
        rec.AccountId      = accountId;
        rec.FirstName      = firstname;
        rec.LastName       = lastname;
        rec.X80Leader      = false;
        rec.PhoneBankTotal = 0;
        rec.SignatureCnt   = currentVal;
        rec.Source         = 'D';
        reportMap.put(signatureMapId,rec);
        debugCnt_D++;
      }
    }

    // ***************************************
    // COPE for above
    // ***************************************
    Decimal lastCopeAmt;
    Date lastCopeDate;
    for (Contact copeCont : [SELECT Id,Cope_Amount__c,Cope_Payment_Date__c,AccountId FROM Contact WHERE Cope_Payment_Date__c >= 2017-01-01 AND In_Current_BU__c = true AND id IN :contactSet]) {
      id           = copeCont.Id;
      lastCopeAmt  = copeCont.Cope_Amount__c;
      lastCopeDate = copeCont.Cope_Payment_Date__c;
      if(reportMap.containsKey(id)) {
        tmpRptObj = reportMap.get(id);
        tmpRptObj.LastCopeAmt  = lastCopeAmt;
        tmpRptObj.LastCopeDate = lastCopeDate;
        reportMap.put(id,tmpRptObj);
        debugCnt_Cope++; 
      }
    }

    // ***************************************
    // Account data
    // ***************************************
    // AND Constituency__c != null
    for (Account act : [
      SELECT Id,Name,Region__c,Account_Group__c,BU_Count__c,
      Constituency__r.Name,
      Constituency__r.ConstituencyName__c,
      subseat__c,
      District_Name__c,
      District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Name , 
      District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Id
      FROM Account 
      WHERE Active__c = 'Yes' 
      ORDER BY Account_Group__c,Name])
    { 
      accountId        = act.Id;
      accountName      = act.Name;
      buCount          = act.BU_Count__c;
      region           = act.Region__c;
      accountGroup     = act.Account_Group__c;
      constituencyCode = act.Constituency__r.Name;
      constituencyName = act.Constituency__r.ConstituencyName__c;
      subSeat          = act.subseat__c; 
      districtName     = act.District_Name__c; 
      ecommName        = act.District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Name;
      ecommId          = act.District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Id;

      accountRec = new AccountClass();
      accountRec.AccountId        = accountId;
      accountRec.AccountName      = accountName;
      accountRec.BuCount          = buCount;
      accountRec.Region           = region;
      accountRec.AccountGroup     = accountGroup;
      accountRec.ConstituencyCode = constituencyCode;
      accountRec.ConstituencyName = constituencyName;
      accountRec.SubSeat          = subSeat;
      accountRec.DistrictName     = districtName;
      accountRec.EcommName        = ecommName;
      accountRec.EcommId          = ecommId;
      accountMap.put(accountId,accountRec);
    }

    // Apply Account data
    for (Id reportMapId : reportMap.keySet()) {
      tmpRptObj = reportMap.get(reportMapId);
      if(accountMap.containsKey(tmpRptObj.AccountId)) {
        accountRec = accountMap.get(tmpRptObj.AccountId);
        tmpRptObj.AccountName      = accountRec.AccountName;
        tmpRptObj.BuCount          = accountRec.BuCount;          
        tmpRptObj.Region           = accountRec.Region;           
        tmpRptObj.AccountGroup     = accountRec.AccountGroup;      
        tmpRptObj.ConstituencyCode = accountRec.ConstituencyCode; 
        tmpRptObj.ConstituencyName = accountRec.ConstituencyName; 
        tmpRptObj.SubSeat          = accountRec.SubSeat;          
        tmpRptObj.DistrictName     = accountRec.DistrictName;
        tmpRptObj.EcommName        = accountRec.EcommName;
        tmpRptObj.EcommId          = accountRec.EcommId;
        debugCnt_Acct_OK++; 
      } else {
        tmpRptObj.AccountName      = 'Account not found';
        debugCnt_Acct_Missing++;
      }
      reportMap.put(reportMapId,tmpRptObj);
    }

    System.debug('debug A: '   + debugCnt_A);
    System.debug('debug B: '   + debugCnt_B);
    System.debug('debug C: '   + debugCnt_C);
    System.debug('debug D: '   + debugCnt_D);
    System.debug('debug Cope ' + debugCnt_Cope);
    System.debug('debug Acct OK: '      + debugCnt_Acct_OK);
    System.debug('debug Acct Missing: ' + debugCnt_Acct_Missing);

    return reportMap;

  }

}