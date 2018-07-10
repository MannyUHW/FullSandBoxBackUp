public with sharing class generateIcalendarAttachment {
  public String attachmentString {get; set;}
  private String CRLF = '\r\n';
  /**********************************/
  public generateIcalendarAttachment(Datetime startTime, Datetime endTime, String uId, String boothLocation, String boothName){
    
    String dtstamp = 'DTSTAMP:' + Datetime.Now().formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'') + CRLF;
    String result = 'BEGIN:VCALENDAR' + CRLF + 'VERSION:2.0' + CRLF+ 'PRODID:-//Microsoft Corporation//Entourage Mac 11.0 MIMEDIR//EN' + CRLF;
    result += 'METHOD:PUBLISH' + CRLF;
    result += 'UI:'+uId+CRLF;
    result += 'BEGIN:VEVENT' + CRLF;
    result += dtstamp;
    result += 'DTSTART:' + startTime.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'') + CRLF;
    result += 'DTEND:' + endTime.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'') + CRLF;
    result += SetField('SUMMARY:', boothName+': Booth Shifts');
    result += SetField('DESCRIPTION:', boothName+': Booth Shifts');
    result += SetField('LOCATION:', boothLocation);
    result += 'END:VEVENT' + CRLF;
    result += 'END:VCALENDAR' + CRLF;
    attachmentString=result;
  }
  /**********************************/
  private String SetField(String fieldName, String fieldValue) {
    if (fieldValue != null && fieldValue != '') {
      return fieldName + Escape(fieldValue) + CRLF;
    }
    return '';
  }
  /**********************************/
  private String Escape(String original) {
    return original.replace('\n','\\n').replace('\r','');
  }
  /**********************************/
  
}