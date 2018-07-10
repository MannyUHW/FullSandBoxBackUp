// https://salesforce.stackexchange.com/questions/123618/batch-job-with-custom-iterable-throwing-error-first-error-invalid-conversion-fr
//
// class CustomIteratable implements Iterable<SObject>, Iterator<SObject>
// {
//     public Iterator<SObject> iterator() { return this; }
//     public Boolean hasNext() { /*implementation*/ }
//     public SObject next() { /*implementation*/ }
// }
global class PledgeUpIterable implements Iterable<String>, Iterator<String> { 
  
  String jsonData;
  String nextUrl;
  List<String> data;
  JSONParser parser;
  Integer i, dataLength;
  List<Lead> leadData;

  PledgeUpData pud;

  public Iterator<String> iterator() { return this; }

  public PledgeUpIterable(){ 
//    data = new List<String>();
    System.debug('[[PledgeUpIterable() constructor]');
    System.JSONToken currentToken;
    
    pud = new PledgeUpData();
//    pud.LeadList = new List<Lead>();

    i = 0;
    dataLength = 2;
    jsonData = PledgeUpCalloutHelper.getAllMembers('');
//    leadData = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData));

      String testJsonData = '{'+
      '  \"count\": 3692,'+
      '  \"page\": 1,'+
      '  \"num_pages\": 37,'+
      '  \"next\": \"https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page=2&sorts=-member.record+created+at\",'+
      '  \"previous\": null,'+
      '  \"results\": ['+
      '    {'+
      '      \"url\": \"https://pledgeup.com/api/v1/local/member/318481/\",'+
      '      \"pk\": 318481,'+
      '      \"contributions_url\": \"https://pledgeup.com/api/v1/local/member/318481/contributionpledge/\",'+
      '      \"membership_url\": \"https://pledgeup.com/api/v1/local/member/318481/status/\",'+
      '      \"payment_url\": \"https://pledgeup.com/api/v1/local/member/318481/payment/\",'+
      '      \"transactions_url\": \"https://pledgeup.com/api/v1/local/member/318481/transaction/\",'+
      '      \"profile\": \"https://pledgeup.com/local/seiu-uhw/member/318481/\",'+
      '      \"data\": {'+
      '        \"worksite\": {'+
      '          \"shift\": {'+
      '            \"hours\": null,'+
      '            \"days\": null'+
      '          },'+
      '          \"name\": null,'+
      '          \"address\": {'+
      '            \"street2\": null,'+
      '            \"longitude\": null,'+
      '            \"city\": \"Somewhere\",'+
      '            \"state\": \"CA\",'+
      '            \"latitude\": null,'+
      '            \"street1\": \"101 Main St\",'+
      '            \"zipcode\": \"94123\"'+
      '          },'+
      '          \"workarea\": {'+
      '            \"location\": null,'+
      '            \"hours\": null,'+
      '            \"name\": null'+
      '          },'+
      '          \"employer\": null'+
      '        },'+
      '        \"member\": {'+
      '          \"middle name\": null,'+
      '          \"cell phone\": \"3235078921\",'+
      '          \"last name\": \"Hernandez\",'+
      '          \"work email\": null,'+
      '          \"gender\": \"f\",'+
      '          \"date of birth\": null,'+
      '          \"profession\": null,'+
      '          \"is leader\": null,'+
      '          \"work phone\": null,'+
      '          \"id\": 318481,'+
      '          \"salutation\": null,'+
      '          \"name\": \"Nicolasa Hernandez\",'+
      '          \"home email\": null,'+
      '          \"title\": null,'+
      '          \"record created at\": \"2018-06-20T17:58:29.056161+00:00\",'+
      '          \"email\": \"Nicolasa.Hernandez@SomeEmployer.com\",'+
      '          \"notes\": null,'+
      '          \"uid\": \"mem-xr4e6y9g4p6FUcSctH7uXd\",'+
      '          \"first name\": \"Nicolasa\",'+
      '          \"last invite sent at\": null,'+
      '          \"prefix\": null,'+
      '          \"text auth\": null,'+
      '          \"suffix\": null,'+
      '          \"home phone\": null,'+
      '          \"assessment\": null'+
      '        },'+
      '        \"home_address\": null,'+
      '        \"stats\": {'+
      '          \"email\": {'+
      '            \"bounces\": 0,'+
      '            \"confirmations\": 0,'+
      '            \"last bounce time\": null,'+
      '            \"last confirmation time\": null,'+
      '            \"complaints\": 0,'+
      '            \"last complaint time\": null'+
      '          }'+
      '        },'+
      '        \"campaign names\": ['+
      '          \"AV/SLA Area\"'+
      '        ],'+
      '        \"campaigns\": {'+
      '          \"av-sla-area\": {'+
      '            \"turfs\": null,'+
      '            \"name\": \"AV/SLA Area\",'+
      '            \"questions\": null,'+
      '            \"slug\": \"av-sla-area\"'+
      '          }'+
      '        },'+
      '        \"membership\": null,'+
      '        \"user\": null,'+
      '        \"work_address\": null,'+
      '        \"payment\": null,'+
      '        \"contributions\": null'+
      '      }'+
        '    }'+
      '  ]'+
      '}';

//      System.debug(testJsonData);
      leadData = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData));
//      pud = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData), pud);

      System.debug('********** PledgeUp Data (pud) ***********');
//System.debug(pud);
System.debug(leadData);
      System.debug('********** PledgeUp Data (pud) ***********');
      
//      System.debug('********** Lead data size ***********');
//      System.debug(leadData.size());
        // System.debug(pud.LeadList.size());
//      System.debug('********** Lead data 0 ***********');

//    System.debug(leadData[0]);
//    System.debug('********** Lead data 1 ***********');
//    System.debug(leadData[1]);    

  }   

  global boolean hasNext(){ 
    System.debug('[[ PledgeUpIterable hasNext() ]');
//    return false; 
    if(i >= dataLength) {
      return false; 
    } else {
      return true; 
    }
  }    

  global String next(){ 
    System.debug('[[ PledgeUpIterable next() ]');
 //   return 'dummy next value';
    if(i == dataLength){
      return null;
    } 
    i++; 
    return 'dummy next value ' + i; // return data[i-1]; 
  } 

}