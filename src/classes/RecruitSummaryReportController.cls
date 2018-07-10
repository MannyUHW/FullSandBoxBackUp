public class RecruitSummaryReportController {

public class ReportClass {
    String Fid;
    String Name;
    String FirstName;
    String LastName;
    Decimal Total;
    String AccountName;   
    String Division;
    String Region;   
    String ConsName;
    String ConsCode;
    String SeatHolderName;
    String SeatHolderId;
}

  @RemoteAction
  public static Map<String,ReportClass> getReportData()  {

    Map<String,ReportClass> reportMap = new Map<String,ReportClass>();
    ReportClass currentRec;
    for(Recruit__c rec : [SELECT Recruit__r.FID__c, Recruit__r.FirstName,Recruit__r.LastName,Total_Shift__c,Recruit__r.Account.Name,Recruit__r.Account.Account_Group__c,Recruit__r.Account.Region__c, Recruit__r.Account.Constituency__r.ConstituencyName__c, Recruit__r.Account.Constituency__r.Constituency_Name__c, Recruit__r.Account.District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Name, Recruit__r.Account.District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Id 
      FROM Recruit__c 
      WHERE Volunteer_Date__c >= 2018-05-01 AND Recruit__c != null AND Total_Shift__c > 0]) {
      if(reportMap.containsKey(rec.Recruit__r.FID__c)) {
        currentRec = reportMap.get(rec.Recruit__r.FID__c);
        currentRec.Total += rec.Total_Shift__c;
        reportMap.put(rec.Recruit__r.FID__c,currentRec);
      } else {
        ReportClass reportRec    = new ReportClass();
        reportRec.Fid            = rec.Recruit__r.FID__c;
        reportRec.FirstName      = rec.Recruit__r.FirstName;
        reportRec.LastName       = rec.Recruit__r.LastName;
        reportRec.Total          = rec.Total_Shift__c;
        reportRec.AccountName    = rec.Recruit__r.Account.Name;
        reportRec.Division       = rec.Recruit__r.Account.Account_Group__c;
        reportRec.Region         = rec.Recruit__r.Account.Region__c;
        reportRec.ConsName       = rec.Recruit__r.Account.Constituency__r.ConstituencyName__c;
        reportRec.ConsCode       = rec.Recruit__r.Account.Constituency__r.Constituency_Name__c;
        reportRec.SeatHolderName = rec.Recruit__r.Account.District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Name; 
        reportRec.SeatHolderId   = rec.Recruit__r.Account.District_2017__r.Executive_Committee_Seat__r.SeatHolder__r.Id;
        reportMap.put(reportRec.Fid,reportRec);
      }
    }
    return reportMap;
  }

}