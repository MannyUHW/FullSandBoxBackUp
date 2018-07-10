@isTest
global class PledgeUpGetTokenMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest req) {
//  String testJsonData = '{\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmlnX2lhdCI6MTUzMDU0NzE1NSwidXNlcm5hbWUiOiJtbW9yZW5vQHNlaXUtdWh3Lm9yZyIsImVtYWlsIjoibW1vcmVub0BzZWl1LXVody5vcmciLCJleHAiOjE1MzA1NDgwNTUsInVzZXJfaWQiOjE0NTF9.bpPBWpAKdzfDnFvZAGLninrmkH9wi2898EeVyBcHgr8\"}';
    String testJsonData = '\"{eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmlnX2lhdCI6MTUzMDU0NzE1NSwidXNlcm5hbWUiOiJtbW9yZW5vQHNlaXUtdWh3Lm9yZyIsImVtYWlsIjoibW1vcmVub0BzZWl1LXVody5vcmciLCJleHAiOjE1MzA1NDgwNTUsInVzZXJfaWQiOjE0NTF9.bpPBWpAKdzfDnFvZAGLninrmkH9wi2898EeVyBcHgr8}\"';
    System.debug(' PledgeUpGetTokenMock start');
    System.debug(' PledgeUpGetTokenMock test data:');
    System.debug(testJsonData);
    HttpResponse res = new HttpResponse(); // Create a fake response
    res.setHeader('Content-Type', 'application/json');
    res.setBody(testJsonData);
    res.setStatusCode(200);
    System.debug('Response:');
    System.debug(res);
    System.debug(' PledgeUpGetTokenMock end');
    return res;
  }  
}