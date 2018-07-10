public class PledgeUpCalloutHelper {

  public class token {
    public string token;
  }

  // public class data {
  //   Integer count,page,num_pages;
  //   String Next,Previous,Url,Pk,ContributionsUrl,MembershipUrl,PaymentUrl,TransactionsUrl,Profile,Employer,MemberId,MemberUid,MemberEmail,MemberName,MemberFirstName,MemberLastName,MemberMiddleName;
  //   String Street1,Street2,City,State,Zip;
  // }

  public static String reset() {
    PledgeUpSchedule__c pls = [SELECT Id,NextUrl__c,CalloutCount__c FROM PledgeUpSchedule__c];
    String retVal = 'OK';
    pls.CalloutCount__c = 0;
    pls.NextUrl__c      = 'https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200';
    try {
      Update pls;
      System.debug('PledgeUpSchedule__c record updated. ');
    } catch(Exception e) {
      System.debug('Error seeding PledgeUpSchedule__c record. Call DataTeam' + e.getMessage());
      retVal = 'Error ' + e.getMessage();
    }  
    return retVal;
  }
      
//public static String getToken() {
  public static HTTPResponse getToken(String testParam1, String testParam2) {
    System.debug('  ----------- PledgeUpCalloutHelper:getToken ---------------------------------  ');
    System.debug('TestParam1: ' + testParam1 + ' TestParam2: ' + testParam2);
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
    System.debug('  ----------- PledgeUpCalloutHelper:getToken ---------------------------------  ');
//  return res.getBody();
    return res;
  }

//public static String getAllMembers(String tokenStr, String nextUrl) {
public static HTTPResponse getAllMembers(String tokenStr, String nextUrl) {  
    @TestVisible String jwt,testJsonData;
    @TestVisible token urlToken;

   System.debug('  ----------- PledgeUpCalloutHelper:getAllMembers ---------------------------------  ');
   System.debug(tokenStr);
   System.debug(nextUrl);
   System.debug('  ----------- PledgeUpCalloutHelper:getAllMembers ---------------------------------  ');

    urlToken = (token) JSON.deserialize(tokenStr,token.class);
    if(!String.isBlank(urlToken.token)) {
      jwt = 'JWT ' + urlToken.token;
      System.debug('Got a token! [' + urlToken.token + ']');

      if(String.isBlank(nextUrl)) {
//        return '';
          return null;
      } else {
        if(nextUrl != 'null') {

          HttpRequest mbrReq  = new HttpRequest();
          mbrReq.setEndpoint(nextUrl);
          mbrReq.setHeader('Accept','application/json');
          mbrReq.setHeader('Content-Type', 'application/json');
          mbrReq.setHeader('Authorization', jwt);
          mbrReq.setMethod('GET');

          Http http = new Http();
          System.debug('About to make call....');
          HTTPResponse mbrRes = http.send(mbrReq);
          System.debug('HTTPResponse Results from call....');
          System.debug(mbrRes);
//          String bodyStr = mbrRes.getBody();
//          return bodyStr;
            return mbrRes;
        } else {
            return null;
        }
      }

    } else {
      System.debug('Error: Don\'t have a token!');
//      return 'Error';
      return null;
    }

  }

    public static Boolean saveLeads(List<Lead> leadsToSave) {
      Boolean retVal = true;
      Database.SaveResult[] srList = Database.insert(leadsToSave, false);
      for (Database.SaveResult sr : srList) {
        if(!sr.isSuccess()) {
          retVal = false;
          for(Database.Error err : sr.getErrors()) {
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
          }
        }
      } 
      return retVal;
    }

    public static PledgeUpData parseData(JSONParser parser) {
    System.JSONToken currentToken;
    String   fieldName, fieldValueString;
    Integer  fieldValueInteger;
    Date     fieldValueDate;
    Datetime fieldValueDatetime;
    Boolean  fieldValueBoolean;

    Integer i = 0, count = 0, page = 0, numPages = 0;
    String next,previous,url,pk,contributions,contributions_url,membership_url,payment_url,transactions_url,profile,employer,memberId,member_uid,memberEmail,memberName,memberFirstName,memberLastName,memberMiddleName;
    String street1,street2,city,state,zip;
    Boolean addToList, lastRecordField, noError = true;
    List<Lead> leadList;

    addToList       = false;
    lastRecordField = false;
    leadList = new List<Lead>();
    memberId = member_uid = memberEmail = memberName = memberFirstName = memberLastName = memberMiddleName = '';
    while(parser.nextToken() != null) {
      state = 'CA';  // Lead needs this.
      i++;
      currentToken = parser.getCurrentToken();
      fieldValueString = fieldName = '';
      if(currentToken === System.JSONToken.FIELD_NAME) {
        fieldName = parser.getCurrentName();      // Get the field name for the current value.
        parser.nextValue();                       // Advance to the next value.
        switch on fieldName {

          when null {
            System.debug('<<' + i + '>>  fieldname is null'  );
          }

          when 'count' {
            fieldValueInteger = parser.getIntegerValue();
            count = fieldValueInteger;
            fieldValueString = String.valueOf(fieldValueInteger);
          }

          when 'page' {
            fieldValueInteger = parser.getIntegerValue();
            page = fieldValueInteger;
            fieldValueString = String.valueOf(fieldValueInteger);
          }

          when 'num_pages' {
            fieldValueInteger = parser.getIntegerValue();
            numPages = fieldValueInteger;
            fieldValueString = String.valueOf(fieldValueInteger);
          }

          when 'next' {
            fieldValueString = parser.getText();
            next = fieldValueString;
          }

          when 'prev' {
            fieldValueString = parser.getText();
            previous  = fieldValueString;
          }

          when 'url' {
            fieldValueString = parser.getText();
            url = fieldValueString;
          }

          when 'pk' {
            fieldValueString = parser.getText();
            pk = fieldValueString;
          }

          when 'contributions_url' {
            fieldValueString = parser.getText();
            contributions_url = fieldValueString;
          }

          when 'membership_url' {
            fieldValueString = parser.getText();
            membership_url = fieldValueString;
          }

          when 'payment_url' {
            fieldValueString = parser.getText();
            payment_url = fieldValueString;
          }

          when 'transactions_url' {
            fieldValueString = parser.getText();
            transactions_url = fieldValueString;
          }

          when 'profile' {
            fieldValueString = parser.getText();
            profile = fieldValueString;
          }

          when 'employer' {
            fieldValueString = parser.getText();
            employer = fieldValueString;
          }

          when 'id' {
            fieldValueString  = parser.getText();
            memberId = fieldValueString;
          }

          when 'uid' {
            fieldValueString = parser.getText();
            member_uid = fieldValueString;
            }

            when 'email' {
            fieldValueString = parser.getText();
            memberEmail = fieldValueString;
            }

            when 'name' {
            fieldValueString = parser.getText();
            memberName = fieldValueString; 
            }

          when 'first name' {
            fieldValueString = parser.getText();
            memberFirstName = fieldValueString;
          }

          when 'middle name' {
            fieldValueString = parser.getText();
            memberMiddleName = fieldValueString;
          }

          when 'last name' {
            fieldValueString = parser.getText();
            if(!String.isBlank(fieldValueString)) {
              memberLastName = fieldValueString;
            }
          }

          when 'street1' {
            fieldValueString = parser.getText();
            street1 = fieldValueString;
          }

          when 'street2' {
            fieldValueString = parser.getText();
            street2 = fieldValueString;
          }

          when 'city' {
            fieldValueString = parser.getText();
            city = fieldValueString;
          }

          // when 'state' {
          //   fieldValueString = parser.getText();
          //   state = fieldValueString;
          //   addToList = true;
          // }

          when 'zipcode' {
            fieldValueString = parser.getText();
            zip = fieldValueString;
          }

          when 'contributions' {
            fieldValueString = parser.getText();
            contributions = fieldValueString;

            if(memberFirstName != 'null' && !String.isBlank(memberFirstName) && !String.isBlank(memberLastName)) {
              addToList = true;
            } 
            lastRecordField = true;
          }

          // when else {
          //   System.debug('<<' + i + '>>  fieldName is not trapped:  '  + fieldName );
          // }

        }

        if(lastRecordField) {
          
          if(addToList) {
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
//        l.Phone     = ??
//        l.Email     = memberEmail;
            l.LeadSource = 'PledgeUp';
            leadList.add(l);
          }

          addToList = false;
          lastRecordField = false;
          memberId = member_uid = memberEmail = memberName = memberFirstName = memberLastName = memberMiddleName = '';

/*        data d = new data();
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
        }
      }
/*       if(fieldName == 'first name' || fieldName == 'last name') {
        System.debug('[[[' + i  + ']]]  ' + currentToken + ' | ' + fieldName + ' | ' + fieldValueString);
      } */
    }
    PledgeUpData pud = new PledgeUpData();
    pud.Count = count;
    pud.Next  = next;
    // pud.LeadList = new List<Lead>();
    // pud.LeadList.addAll(leadList);
    System.debug('  ____ PUD ____ ');
    System.debug(pud.Count);
    System.debug(pud.Next);
    // System.debug(pud);
    System.debug('  ____ PUD ____ ');

    // System.debug(leadList);
    // System.debug('^^^ parseData-leadList ^^^');

    if(saveLeads(leadList)) {
      System.debug('Leads saved.');
    } else {
      System.debug('Error saving Leads.');
//      pud.Next = 'Error';
    }

    return pud;
  }
}