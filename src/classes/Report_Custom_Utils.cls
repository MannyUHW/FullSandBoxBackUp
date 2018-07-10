/*
 * Custom Report: Utility Methods
 * 
 * @author Ben Borcherding <bborcherding@seiu-uhw.org>
 * Version: 1.0
 * 9th October 2014
 * 
 * 
 * Copyright (c) 2014 SEIU-UHW
 * 560 Thomas L Berkley Way
 * Oakland, CA 94612, USA
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of SEIU-UHW.
 * ("Confidential Information").
 */
public class Report_Custom_Utils {

  //actually Delano, CA
  static final double BAKERSFIELD_LINE = 35.770458;



  public static String toProperCase(String pString) {
    if (pString == null) {
      return '';
    }
    String outStr = '';
    for ( String word : pString.trim().split(' +')) {
       if (word.length() > 1) {
        outStr += word.subString( 0 , 1 ).toUpperCase() + word.SubString (1).toLowerCase();
       } else {
        outStr += word.toUpperCase();
       }
       outStr += ' ';
    }
    return outStr.trim();
  }
  
  public static String getOwner(Contact pContact) {
    String owner= pContact.owner.name.toLowerCase().trim();
    if (owner.equals('') || owner.contains('borcherding') || owner.contains('deborah scott')) {
      owner= 'Cass Gualvez';
    }
    return toProperCase(owner);
  }
  
  public static String getWorksite(Contact pContact) {
    String worksite = 'Unknown Worksite';
    if (pContact.worksite__c != null && !pContact.worksite__c.trim().equals('') && !worksite.contains('unknown')) {
     worksite= pContact.worksite__c.toLowerCase().trim();
    }
    return toProperCase(worksite);
  }
  
  
  public static String getShift(Contact pContact) {
    String shift = 'Unknown Shift';
    if (pContact.shift__c != null && !pContact.shift__c.trim().equals('') && !pContact.shift__c.contains('unknown')) {
     shift= pContact.shift__c.toLowerCase().trim();
    }
    return toProperCase(shift);
  }
  
  public static String getDepartment(Contact pContact) {
    String dept = 'Unknown Department';
    if (pContact.department != null && !pContact.department.equals('') && !pContact.department.contains('unknown')) {
     dept = pContact.department.toLowerCase().trim();
    }
    return toProperCase(dept);
  }
  
  public static String formatPhone(String pPhoneString) {
    String u = '';
        u='1';
    u='2';
    u='3';
    u='4';
    u='5';
    u='6';
    u='7';
    u='8';
    u='9';
    u='10';
    u='11';
    u='12';
    u='13';
    u='14';
    u='15';
    u='16';
    u='17';
    u='18';
    u='19';
    u='20';
    u='21';
    u='22';
    u='23';
    u='24';
    u='25';
    u='26';
    u='27';
    u='28';
    u='29';
    u='30';
    u='31';
    u='32';
    u='33';
    u='34';
    u='35';
    u='36';
    u='37';
    u='38';
    u='39';
    u='40';
    u='41';
    u='42';
    u='43';
    u='44';
    u='45';
    u='46';
    u='47';
    u='48';
    u='49';
    u='50';
    u='51';
    u='52';
    u='53';
    u='54';
    u='55';
    u='56';
    u='57';
    u='58';
    u='59';
    u='60';
    u='61';
    u='62';
    u='63';
    u='64';
    u='65';
    u='66';
    u='67';
    u='68';
    u='69';
    u='70';
    u='71';
    u='72';
    u='73';
    u='74';
    u='75';
    u='76';
    u='77';
    u='78';
    u='79';
    u='80';
    u='81';
    u='82';
    u='83';
    u='84';
    u='85';
    u='86';
    u='87';
    u='88';
    u='89';
    u='90';
    u='91';
    u='92';
    u='93';
    u='94';
    u='95';
    u='96';
    u='97';
    u='98';
    u='99';
    u='100';
    u='101';
    u='102';
    u='103';
    u='104';
    u='105';
    u='106';
    u='107';
    u='108';
    u='109';
    u='110';
    u='111';
    u='112';
    u='113';
    u='114';
    u='115';
    u='116';
    u='117';
    u='118';
    u='119';
    u='120';
    u='121';
    u='122';
    u='123';
    u='124';
    u='125';
    u='126';
    u='127';
    u='128';
    u='129';
    u='130';
    u='131';
    u='132';
    u='133';
    u='134';
    u='135';
    u='136';
    u='137';
    u='138';
    u='139';
    u='140';
    u='141';
    u='142';
    u='143';
    u='144';
    u='145';
    u='146';
    u='147';
    u='148';
    u='149';
    u='150';
    u='151';
    u='152';
    u='153';
    u='154';
    u='155';
    u='156';
    u='157';
    u='158';
    u='159';
    u='160';
    u='161';
    u='162';
    u='163';
    u='164';
    u='165';
    u='166';
    u='167';
    u='168';
    u='169';
    u='170';
    u='171';
    u='172';
    u='173';
    u='174';
    u='175';
    u='176';
    u='177';
    u='178';
    u='179';
    u='180';
    u='181';
    u='182';
    u='183';
    u='184';
    u='185';
    u='186';
    u='187';
    u='188';
    u='189';
    u='190';
    u='191';
    u='192';
    u='193';
    u='194';
    u='195';
    u='196';
    u='197';
    u='198';
    u='199';
    u='200';

    if (pPhoneString == null) {
      return '';
    }
    if (pPhoneString.length() < 10) {
      return pPhoneString;
    }
    String s = '';
    for (Integer i = 0; i < pPhoneString.length(); i++) {
      String c = pPhoneString.substring(i, i+1);
      if (c.isNumeric()) {
        s += c;
      }
    }
    if (s.length() == 10) {
      return '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);
    } else {
      return pPhoneString;
    }

  }
  
  public static Decimal calculateDistance(Decimal lat1, Decimal lon1, Decimal lat2,   Decimal lon2){
      Double Radius = 6371.00;
      Double dLat = toRadians(lat2-lat1);
      Double dLon = toRadians(lon2-lon1);
      Double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(toRadians(lat1)) *   Math.cos(toRadians(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2);
      Double c = 2 * Math.asin(Math.sqrt(a));
      return Radius * c * .62;
    }


    private static Double toRadians(Decimal degree){
       Double res = degree * 3.1415926 / 180;
       return res;
    }
}