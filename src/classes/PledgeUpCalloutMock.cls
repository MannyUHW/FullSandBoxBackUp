@isTest
global class PledgeUpCalloutMock implements HttpCalloutMock {

    // public String tokenStr { get; set; }
    // public String nextUrl  { get; set; }
 
    // public PledgeUpCalloutMock(String pTokenStr, String pNextUrl) {
    //   this.tokenStr = pTokenStr;
    //   this.nextUrl  = pNextUrl;
    //   System.debug(' -- pledgeupcalloutmock params --');
    //   System.debug(this.tokenStr);
    //   System.debug(this.nextUrl);
    //   System.debug(' -- pledgeupcalloutmock params --');
    // }

  global HTTPResponse respond(HTTPRequest req) {

    String testJsonData = '{'+
      '  \"count\": 3692,'+
      '  \"page\": 1,'+
      '  \"num_pages\": 37,'+
      '  \"next\": null,'+
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

      System.debug(' PledgeUpCalloutMock start');

      // String testJsonData = '{'+
      //   '  \"count\": 3692,'+
      //   '  \"page\": 1,'+
      //   '  \"num_pages\": 37,'+
      //   '  \"next\": null,' +
      //   '  \"previous\": null'+
      //   '}';

      System.debug(' PledgeUpCalloutMock test data:');
      System.debug(testJsonData);

      HttpResponse res = new HttpResponse(); // Create a fake response
      res.setHeader('Content-Type', 'application/json');
//      res.setBody(testJsonData);
      res.setStatusCode(200);
      System.debug('Response:');
      System.debug(res);
      System.debug(' PledgeUpCalloutMock end');

      return res;
  }  
}