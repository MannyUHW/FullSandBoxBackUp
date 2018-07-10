public class RecruitDataController {

  class myClass {
    String Code;
    String Loc;
    String Ecom;
    Decimal Cnt;
  }

  @RemoteAction
  public static List <sObject> getData() {

    Integer i,l;
    Decimal cnt;
    String name,loc,ecom;
    List<ID> idArray = new List<Id>();
    Id idToAdd;
    List <sObject> returnData = new List <sObject>();

    for (list <EBoardSeats__c> dataList : [
      SELECT SeatHolder__c
      FROM EBoardSeats__c 
      WHERE E_Board_Year__c = '2017' AND Title__c = 'Executive Committee' And SeatHolder__c != null ORDER BY Constituency_forAPI__c ASC NULLS FIRST]) {
      l = dataList.size();
      for(i=0;i<l;i++) {
        idToAdd = dataList[i].SeatHolder__c;
        idArray.add(idToAdd);
      }
    }

    AggregateResult[] ecommCounts;
    AggregateResult[] regularCounts;

    ecommCounts = [
      SELECT  Recruit__r.Name EcommName, Recruit__r.Account.Constituency__r.Name , Location__c, Sum(Total_Shift__c) Cnt
      FROM Recruit__c 
      WHERE Recruit__c In :idArray AND Volunteer_Date__c >= 2018-05-01 
      GROUP BY Recruit__r.Name, Recruit__r.Account.Constituency__r.Name, Location__c];

    for(AggregateResult ecommCount : ecommCounts) {
        name = (String)  ecommCount.get('Name');
        loc  = (String)  ecommCount.get('Location__c');
        cnt  = (Decimal) ecommCount.get('Cnt');
        ecom = (String)  ecommCount.get('EcommName');
        System.debug('Name: ' + name);
        System.debug('Loc:  ' + loc);
        System.debug('Cnt:  ' + cnt);
        System.debug('Ecom: ' + ecom);
    }


      List <sObject> RegularShifts = [
      SELECT Recruit__r.Account.Constituency__r.Name , Location__c, Sum(Total_Shift__c)
      FROM Recruit__c 
      WHERE Recruit__c NOT In :idArray AND Volunteer_Date__c >= 2018-05-01 
      GROUP BY Recruit__r.Account.Constituency__r.Name, Location__c];

      System.debug(RegularShifts);  
  
    return RegularShifts;
  
  }

  @RemoteAction
  public static List <sObject> getTestData()  {

// Too deep (5 is limit)
// Recruit__r.Account.Constituency__r.Executive_Committee_Seat__r.SeatHolder__r.FirstName, 

    sObject[] testData = [
      SELECT Recruit__r.Id, Recruit__r.FirstName,Recruit__r.LastName,Volunteer_Date__c,Total_Shift__c ,
        Recruit__r.Account.Name,
        Recruit__r.Account.Constituency__r.ConstituencyName__c,
        Recruit__r.Account.Constituency__r.Executive_Committee_Seat__r.SeatHolder__c 
      FROM Recruit__c 
      WHERE Volunteer_Date__c >= 2018-01-01 AND Recruit__c != null AND Total_Shift__c > 0];

    return testData;

  }

  @RemoteAction
  public static List <myClass> getEcommData()  {
    Integer i,l;
    Decimal cnt;
    String code,loc,ecom;
    List<ID> idArray = new List<Id>();
    Id idToAdd;
    List <sObject> returnData = new List <sObject>();

    for (list <EBoardSeats__c> dataList : [
      SELECT SeatHolder__c,
        SeatHolder__r.FirstName,
        SeatHolder__r.LastName,
        ConstituencyName__c,
        Constituency_forAPI__c
      FROM EBoardSeats__c 
      WHERE E_Board_Year__c = '2017' AND Title__c = 'Executive Committee' And SeatHolder__c != null ORDER BY Constituency_forAPI__c ASC NULLS FIRST]) {
      l = dataList.size();
      for(i=0;i<l;i++) {
        myClass rec = new myClass();
        
        rec.Code = code;
        rec.Loc  = loc;
        rec.Ecom = ecom;
        rec.Cnt  = cnt;        
        
        idToAdd = dataList[i].SeatHolder__c;
        idArray.add(idToAdd);
      }
    }

    AggregateResult[] ecommCounts;
    AggregateResult[] regularCounts;

    ecommCounts = [
      SELECT  Recruit__r.Name EcName, Recruit__r.Account.Constituency__r.Name Code, Location__c, Sum(Total_Shift__c) Cnt
      FROM Recruit__c 
      WHERE Recruit__c In :idArray AND Volunteer_Date__c >= 2018-05-01 
      GROUP BY Recruit__r.Name, Recruit__r.Account.Constituency__r.Name, Location__c
    ];
                    
    List <myClass> myClassList = new List <myClass>();

    for(AggregateResult ecommCount : ecommCounts) {
        myClass rec = new myClass();

        code = (String)  ecommCount.get('Code');
        loc  = (String)  ecommCount.get('Location__c');
        cnt  = (Decimal) ecommCount.get('Cnt');
        ecom = (String)  ecommCount.get('EcName');
        System.debug('Name: ' + code);
        System.debug('Loc:  ' + loc);
        System.debug('Ecom: ' + ecom);
        System.debug('Cnt:  ' + cnt);        
        rec.Code = code;
        rec.Loc  = loc;
        rec.Ecom = ecom;
        rec.Cnt  = cnt;        
        myClassList.add(rec);
    }
    System.debug(myClassList);

    return myClassList;

  }

}