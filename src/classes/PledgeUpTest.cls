@isTest
private class PledgeUpTest {

  public class token {
    public string token;
  }

  @isTest static void testGetToken() {
    String testJsonData = '\"{eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmlnX2lhdCI6MTUzMDU0NzE1NSwidXNlcm5hbWUiOiJtbW9yZW5vQHNlaXUtdWh3Lm9yZyIsImVtYWlsIjoibW1vcmVub0BzZWl1LXVody5vcmciLCJleHAiOjE1MzA1NDgwNTUsInVzZXJfaWQiOjE0NTF9.bpPBWpAKdzfDnFvZAGLninrmkH9wi2898EeVyBcHgr8}\"';
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new PledgeUpGetTokenMock());
      
    // Call method to test. This causes a fake response to be sent from the class that implements HttpCalloutMock. 
    HttpResponse res = PledgeUpCalloutHelper.getToken('Wuggle','Smudge');
     
    // Verify response received contains fake values
    String contentType = res.getHeader('Content-Type');
    System.assert(contentType == 'application/json');
    String actualValue = res.getBody();
    System.assertEquals(actualValue, testJsonData);
    System.assertEquals(200, res.getStatusCode());
  }

  @isTest static void testCallout() {

    String testJsonData = '{\"count\": 3692,\"page\": 1,\"num_pages\": 37,\"next\": null,\"previous\":null}';

/*   String testJsonData = '{'+
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
    '}'; */

    String testKey = '{\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmlnX2lhdCI6MTUzMDU0NzE1NSwidXNlcm5hbWUiOiJtbW9yZW5vQHNlaXUtdWh3Lm9yZyIsImVtYWlsIjoibW1vcmVub0BzZWl1LXVody5vcmciLCJleHAiOjE1MzA1NDgwNTUsInVzZXJfaWQiOjE0NTF9.bpPBWpAKdzfDnFvZAGLninrmkH9wi2898EeVyBcHgr8\"}';
    String testUrl = 'https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200';

    System.debug('  ------------------------ PledgeUpTest - getAllMembers ---------------------------------  ');
    System.debug(testKey);
    System.debug(testUrl);
    System.debug('  ------------------------ PledgeUpTest - getAllMembers ---------------------------------  ');
    
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new PledgeUpCalloutMock());

    Test.startTest();
    // Call method to test. This causes a fake response to be sent from the class that implements HttpCalloutMock. 
    HttpResponse res = PledgeUpCalloutHelper.getAllMembers(testKey,testUrl);
//    HttpResponse res = PledgeUpCalloutHelper.getAllMembers();
    Test.stopTest(); 
    System.debug('  ------------------------ PledgeUpTest - response ---------------------------------  ');
    System.debug(res);
    System.debug('  ------------------------ PledgeUpTest - response ---------------------------------  ');

    // Verify response received contains fake values
    String contentType = res.getHeader('Content-Type');
    System.assert(contentType == 'application/json');
    String actualValue = res.getBody();
    System.assertEquals(actualValue, testJsonData);
    System.assertEquals(200, res.getStatusCode());
  }
}