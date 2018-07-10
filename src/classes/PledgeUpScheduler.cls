global class PledgeUpScheduler implements Schedulable {

  // This class is scheduled to run once a day. It seeds PledgeUpSchedule__c with initial values.
  // It in turn schedules PledgeUpScheduleAt to run once every hour.
  // That class checks the data from PledgeUpSchedule__c and if PledgeUpSchedule__c.NextUrl != null and no errors, there are more callouts to make, 
  // so it creates a queueable job and submits it. That job calls a class that does the callout, parses the Json, saves the data as Leads and updates the data 
  // in PledgeUpSchedule__c.  It then does the same check on PledgeUpSchedule__c data and if there is more data to get, it enqueues a new instance of itself.

  global void execute(SchedulableContext SC) {
    System.debug('execute() of PledgeUpScheduler.');

    PledgeUpSchedule__c pls = [SELECT Id,NextUrl__c,CalloutCount__c FROM PledgeUpSchedule__c];
    System.debug('Seed PledgeUpSchedule__c with initial values for the day.');
    pls.CalloutCount__c = 0;
    pls.NextUrl__c      = 'https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200https://pledgeup.com/api/v1/local/organization/seiu-uhw/member/?page_size=200';
    try {
      Update pls;
      System.debug('PledgeUpSchedule__c record updated. ');

      PledgeUpScheduleAt plsa = new PledgeUpScheduleAt();
      String sch = '0 0 * * * ?';
      String jobID = system.schedule('PledgeUpScheduleAt to run every hour', sch, plsa);

    } catch(Exception e) {
      System.debug('Error seeding PledgeUpSchedule__c record. Call DataTeam' + e.getMessage());
    }    

  }
   
}