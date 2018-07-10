public class PledgeUpHelper {

  public class token {
    public string token;
  }

  public class data {
    Integer count,page,num_pages;
    String Next,Previous,Url,Pk,ContributionsUrl,MembershipUrl,PaymentUrl,TransactionsUrl,Profile,Employer,MemberId,MemberUid,MemberEmail,MemberName,MemberFirstName,MemberLastName,MemberMiddleName;
    String Street1,Street2,City,State,Zip;
  }
      
  public static String getToken() {
    String endpoint  = 'https://pledgeup.com/api/v1/accounts/auth-token/';
    String payload   = '{\"email\": \"mmoreno@seiu-uhw.org\", \"password\": \"sAs3*z2p!\"}';
    HttpRequest req  = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setHeader('Accept','application/json');
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('POST');
    req.setBody(payload);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    return res.getBody();
  }

  @future(callout=true)
  public static void getAllMembers() {
    String jwt,tokenStr,testJsonData;
    token urlToken;
    Integer batchCount = 1;
    List<data> dataList = new List<data>();
    List<Lead> leadList;

    tokenStr = getToken();
    urlToken = (token) JSON.deserialize(tokenStr,token.class);
  
    if(!String.isBlank(urlToken.token)) {
      jwt = 'JWT ' + urlToken.token;
      System.debug('Got a token! [' + urlToken.token + ']');

      String endpoint = 'https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200';

      Boolean moreToGet = true;
      while(moreToGet) {
        leadList = new List<Lead>();

        HttpRequest mbrReq  = new HttpRequest();
        mbrReq.setEndpoint(endpoint);
        mbrReq.setHeader('Accept','application/json');
        mbrReq.setHeader('Content-Type', 'application/json');
        mbrReq.setHeader('Authorization', jwt);
        mbrReq.setMethod('GET');
     
        Http http = new Http();
        System.debug('About to make call....');
        HTTPResponse mbrRes = http.send(mbrReq);
        System.debug('Results from call....');
        System.debug(mbrRes);
        String bodyStr = mbrRes.getBody();
        System.debug(' bodyStr -> ');
        System.debug(bodyStr);


        String   fieldName, fieldValueString;
        Integer  fieldValueInteger;
        Date     fieldValueDate;
        Datetime fieldValueDatetime;
        Boolean  fieldValueBoolean;

        Integer i = 0, count = 0, page = 0, numPages = 0;
        String next,previous,url,pk,contributions_url,membership_url,payment_url,transactions_url,profile,employer,memberId,member_uid,memberEmail,memberName,memberFirstName,memberLastName,memberMiddleName;
        String street1,street2,city,state,zip;

//      JSONParser parser = JSON.createParser(testJsonData);
        JSONParser parser = JSON.createParser(bodyStr);       
        System.JSONToken currentToken;

        Boolean debug, noError = true;

        while(parser.nextToken() != null) {
          state = 'CA';  // Lead needs this.
          memberId = member_uid = memberEmail = memberName = memberFirstName = memberLastName = memberMiddleName = 'Missing';
          i++;
          debug = false;
          currentToken = parser.getCurrentToken();

//        System.debug( '[' + i  + '] current_token: ' + currentToken); 

          if(currentToken === System.JSONToken.FIELD_NAME) {
            fieldName  = parser.getCurrentName();        // Get the field name for the current value.
            parser.nextValue();                          // Advance to the next value.

            switch on fieldName {

              when 'count' {
                fieldValueInteger = parser.getIntegerValue();
                count = fieldValueInteger;
                fieldValueString = String.valueOf(fieldValueInteger);
                debug = true;
              }

              when 'page' {
                fieldValueInteger = parser.getIntegerValue();
                page = fieldValueInteger;
                fieldValueString = String.valueOf(fieldValueInteger);
                debug = true;
              }

              when 'num_pages' {
                fieldValueInteger = parser.getIntegerValue();
                numPages = fieldValueInteger;
                fieldValueString = String.valueOf(fieldValueInteger);
                debug = true;
              }

              when 'next' {
                fieldValueString = parser.getText();
                next = fieldValueString;
                if(next != null) {
                  System.debug('Next: ' + next);
                } else {
                  System.debug('Next is null');
                }   
                debug = true;
              }

              when 'prev' {
                fieldValueString = parser.getText();
                next = fieldValueString;
                debug = true;
              }

              when 'url' {
                fieldValueString = parser.getText();
                url = fieldValueString;
                debug = true;
              }

              when 'pk' {
                fieldValueString = parser.getText();
                pk = fieldValueString;
                debug = true;
              }

              when 'contributions_url' {
                fieldValueString = parser.getText();
                contributions_url = fieldValueString;
                debug = true;
              }

              when 'membership_url' {
                fieldValueString = parser.getText();
                membership_url = fieldValueString;
                debug = true;
              }

              when 'payment_url' {
                fieldValueString = parser.getText();
                payment_url = fieldValueString;
                debug = true;
              }

              when 'transactions_url' {
                fieldValueString = parser.getText();
                transactions_url = fieldValueString;
                debug = true;
              }

              when 'profile' {
                fieldValueString = parser.getText();
                profile = fieldValueString;
                debug = true;
              }

              when 'employer' {
                fieldValueString = parser.getText();
                employer = fieldValueString;
                debug = true;
              }

              when 'id' {
                fieldValueString  = parser.getText();
//                fieldValueInteger = parser.getIntegerValue();
//                memberId = fieldValueInteger;
                memberId = fieldValueString;
                debug = true;
              }

              when 'uid' {
              fieldValueString = parser.getText();
              member_uid = fieldValueString;
              debug = true;
              }

              when 'email' {
              fieldValueString = parser.getText();
              memberEmail = fieldValueString;
              debug = true;
              }

              when 'name' {
              fieldValueString = parser.getText();
              memberName = fieldValueString; 
              debug = true;
              }

              when 'first name' {
              fieldValueString = parser.getText();
              memberFirstName = fieldValueString;
              debug = true;
              }

              when 'middle name' {
              fieldValueString = parser.getText();
              memberMiddleName = fieldValueString;
              debug = true;
              }

              when 'last name' {
                fieldValueString = parser.getText();
                if(!String.isBlank(fieldValueString)) {
                  memberLastName = fieldValueString;
                  debug = true;
                }
              }

              when 'street1' {
                fieldValueString = parser.getText();
                street1 = fieldValueString;
                debug = true;
              }

              when 'street2' {
              fieldValueString = parser.getText();
              street2 = fieldValueString;
              debug = true;
              }

              when 'city' {
              fieldValueString = parser.getText();
              city = fieldValueString;
              debug = true;
              }

              // when 'state' {
              //   fieldValueString = parser.getText();
              //   state = fieldValueString;
              //   debug = true;
              // }

              when 'zipcode' {
                fieldValueString = parser.getText();
                zip = fieldValueString;
                debug = true;
              }

            }

            if(debug) {
              Lead l = new Lead();
              l.FirstName   = memberFirstName;
              l.MiddleName  = memberMiddleName;
              l.LastName    = memberLastName;
              // l.Street      = street1;
              // l.City        = city;
              // l.State       = 'CA';
              // l.Postalcode  = zip;
              // l.Country     = 'United States';
              l.Company     = 'PledgeUp';
              l.Lead_FID__c = 'TmpFID_' + String.valueOf(i);
//              l.Phone     = ??
//              l.Email     = memberEmail;
              l.LeadSource = 'PledgeUp';
              leadList.add(l);

/*            data d = new data();
              d.Next             = next;
              d.Previous         = previous;
              d.Url              = url;
              d.Pk               = pk;
              d.ContributionsUrl = contributions_url;
              d.MembershipUrl    = membership_url;
              d.PaymentUrl       = payment_url;
              d.TransactionsUrl  = transactions_url;
              d.Profile          = profile;
              d.Employer         = employer;
              d.MemberId         = memberId;
              d.MemberUid        = member_uid;
              d.MemberEmail      = memberEmail;
              d.MemberName       = memberName;
              d.MemberFirstName  = memberFirstName;
              d.MemberLastName   = memberLastName;
              d.MemberMiddleName = memberMiddleName;
              dataList.add(d); */

//              System.debug('[' + i  + ']  ' + currentToken + ' | ' + fieldName + ' | ' + fieldValueString);          
            }
          }
        }

        Database.SaveResult[] srList = Database.insert(leadList, false);
        for (Database.SaveResult sr : srList) {
          if(!sr.isSuccess()) {
            noError = false;
            for(Database.Error err : sr.getErrors()) {
              System.debug(err.getStatusCode() + ': ' + err.getMessage());
            }
          }
        } 

        // try {
        //   Insert leadList;
        //   System.debug('Lead records inserted. ');
        // } catch(Exception e) {
        //   System.debug('Error inserting Lead records. ' + e.getMessage());
        //   noError = false;
        // }

        if(noError) {
          if(String.isBlank(next)) {
            moreToGet = false;
            System.debug('Total Batch Count: ' + String.valueOf(moreToGet));
          } else {
            endpoint = next;
            batchCount++;
          }
        }
      }  // moreToGet
    } else {
      System.debug('Error: Don\'t have a token!');
    }

  }

}