global class AggregateResultIterator2 implements Iterator<Contact> {

  Contact [] results {get;set;}
  Integer index {get; set;} 
  String tokenStr;
  String jsonData;
  string nextUrl;

  global AggregateResultIterator2(String query) {
    System.debug('AggregateResultIterator2 constructor');

    index   = 0;
    nextUrl = 'https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200';
    String myQuery = 'SELECT Name FROM Contact WHERE Name != null LIMIT 20';
    results = Database.query(myQuery);            

    tokenStr = PledgeUpCalloutHelper.getToken();
    System.debug('Got token: ' + tokenStr);

  } 

  global boolean hasNext(){ 
    PledgeUpData pledgeUpData;

  //  System.debug('hasNext:index');
  //  System.debug(index);

  //  System.debug('Still Got token: ' + tokenStr);
    jsonData = PledgeUpCalloutHelper.getAllMembers(tokenStr,nextUrl);
  //  System.debug('jsonData');
  //  System.debug(jsonData);

    pledgeUpData = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData));
    System.debug('pledgeUpData.size()');
    System.debug(pledgeUpData.LeadList.size());
    nextUrl = pledgeUpData.Next;


 //   if(index < results.size()) {
 //     System.debug(results[index]);
 //   }
    if(String.IsBlank(nextUrl)) {
      System.debug('NextUrl is null, so must have all the data.');
      return false;
    }
    else {
      if(nextUrl != 'Error') {
        System.debug('More to get:  ' + nextUrl);
        return results != null && !results.isEmpty() && index < results.size(); 
      }
      else return false;
    }
  }    

  global Contact next(){ 
//    System.debug('next: ');
    return results[index++];            
  }       

}