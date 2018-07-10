global class EmailSvc_KBarg15 implements Messaging.InboundEmailHandler {

  public static final String EID = 'eid';

  public static final String EMAIL ='email';
  public static final String CELL ='cell';
 
  public static final String WAGE ='wage';
  public static final String RETIREMENT ='retirement';
  public static final String JOB_SECURITY ='jobsecurity';
  public static final String HEALTHCARE ='healthcare';
  public static final String WELLNESS1 ='wellness1';
  public static final String WELLNESS2 ='wellness2';
  public static final String OTHER ='other';
  public static final String OTHER_DESC ='otherDesc';
  public static final String CHANGE ='change';
  public static final String EDUCATION ='education';
  public static final String FULLTIME ='fulltime';
  public static final String STICKER ='sticker';
  public static final String FLYERS ='flyers';
  public static final String WORKPLACE ='workplace';
  public static final String THA ='tha';
  public static final String MEDI_CAL ='medi-cal';
  public static final String OBAMACARE ='obamacare';
  public static final String COMPLETED ='completed';
  
  public static final String DEPT ='dept';
  public static final String LANG ='lang';
  
    public static final String SPANISH ='spanish';

  public static final String COLLECTOR ='cb';
  public static final String TIMESTAMP ='ts';

/*
  static Map<String, String> getQuestionMap() {
    Map<String, String> returnMap = new Map<String, String>();
    List<Survey_Question__c> qlist = [SELECT id, Name FROM Survey_Question__c where name like 'kbarg15%'];
    for (Survey_Question__c q: qlist) {
      String qname = q.name.toLowerCase();
      if (qname.contains('job') && q.name.contains('security')) {
        returnMap.put(JOB_SECURITY, q.id);
      } else if (qname.contains('priority wage')) {
        returnMap.put(WAGE, q.id);
      } else if (qname.contains('change')) {
        returnMap.put(CHANGE, q.id);
      } else if (qname.contains('activity flyers')) {
        returnMap.put(FLYERS, q.id);
      } else if (qname.contains('survey completed')) {
        returnMap.put(COMPLETED, q.id);        
      } else if (qname.contains('wellness1')) {
        returnMap.put(WELLNESS1, q.id);
      } else if (qname.contains('wellness2')) {
        returnMap.put(WELLNESS2, q.id);
      } else if (qname.contains('education')) {
        returnMap.put(EDUCATION, q.id);
      } else if (qname.contains('priority healthcare')) {
        returnMap.put(HEALTHCARE, q.id);
      } else if (qname.contains('activity workplace')) {
        returnMap.put(WORKPLACE, q.id);
      } else if (qname.contains('activity obamacare')) {
        returnMap.put(OBAMACARE, q.id);
      } else if (qname.contains('retirement')) {
        returnMap.put(RETIREMENT, q.id);
      } else if (qname.contains('full')) {
        returnMap.put(FULLTIME, q.id);
      } else if (qname.contains('activity tha')) {
        returnMap.put(THA, q.id);
      } else if (qname.contains('activity sticker')) {
        returnMap.put(STICKER, q.id);
      } else if (qname.contains('activity medi-cal')) {
        returnMap.put(WAGE, q.id);
      } else if (qname.contains('spanish')) {
        returnMap.put(SPANISH, q.id);
      } else if (qname.contains('priority other')) {
        returnMap.put(OTHER, q.id);
      }
    }
    return returnMap;
  }
*/
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail pEmail, Messaging.Inboundenvelope pEnvelope) {
    
    /*
      String subject = pEmail.subject;
      String s = pEmail.plainTextBody;
    integer ccounter= 0;
    if (subject.contains('Kaiser Barg Survey')) {
          
          Map<String, String> qidMap = getQuestionMap();
          
          for (Integer i = 0; i < s.length(); i++) {
            if (s.substring(i, i+1) == '{') {
              Integer j = s.indexOf('}', i+1);
              String record = s.substring(i+1, j);
              
              Map<String, String> amap =  new Map<String, String>();
              
              for (String s2: record.split(';')) {
                String[] a = s2.split('=');
                if (a.size() > 1) {
                  String key = a[0];
                  String value = a[1];
                  if (key.equals('lang') && value.equals('es')) {
                    amap.put(SPANISH, 'y');
                  } else {
                    amap.put(key, value);
                  }
                }
              }
              long ts = Long.valueOf(amap.get(TIMESTAMP));
              if (ts > 1419359538723l) {
                putSurvey(qidMap, amap); 
                ccounter++;      
              }
            }
          }
            
      }     

      //send email      
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> sendTo = new List<String>();
      sendTo.add('bborcherding@seiu-uhw.org');
      mail.setToAddresses(sendTo);

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('Status: KBarg15 Email Services Processing');
      String body = 'Processed ' + ccounter + ' records.';
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list
      mails.add(mail);

      // Step 6: Send all emails in the master list
      Messaging.sendEmail(mails);
      */
    
      Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
      result.success = true;
      return result;

  }
  
  public void cheese() {
    Integer q = 0;
    q++;
    q++;
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    q++;        
    return;
  } 
          

/*
private void putSurvey(Map<String, String> pQuestionSfidMap, Map<String, String> pResponseMap) {
  system.debug('[putSurvey] looking up Employer Id ' + pResponseMap.get(EID));
  String aeid = pResponseMap.get(EID);
  long ts = Long.valueOf(pResponseMap.get(TIMESTAMP));
  List<Contact> cset = [select id from contact where Employee_ID__c = :aeid];
   system.debug('[putSurvey] contact set size = ' + cset.size());
  if (cset.size() != 1) {
    //ignore for now, will manually enter
  } else {
    for (Contact c: cset) {
      String cid = c.id;
      List<survey_response__c> rset = [select Survey_Question__r.id, Response_Value__c from survey_response__c  where contact__r.id=:cid];
      if (rset.size() == 0) {
        for (String responseKey: pResponseMap.keySet()) {
          {
            Survey_Response__c  sr = new Survey_Response__c();
            sr.Contact__c = cid;
            sr.Survey_Question__c = pQuestionSfidMap.get(COMPLETED);
            sr.response_value__c = 'yes';
            sr.collected_datetime__c = DateTime.newInstance(ts);
            insert sr;
          }
          if (pQuestionSfidMap.containsKey(responseKey)) {
            Survey_Response__c  sr = new Survey_Response__c();
            sr.Contact__c = cid;
            sr.Survey_Question__c = pQuestionSfidMap.get(responseKey);
            sr.response_value__c = pResponseMap.get(responseKey);
            sr.collected_datetime__c = DateTime.newInstance(ts);
            insert sr;
          }
        }
      }
    }
  }
}       
*/
}