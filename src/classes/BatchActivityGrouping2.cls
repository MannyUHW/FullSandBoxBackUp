global class BatchActivityGrouping2 implements Database.Batchable<Contact> , Database.AllowsCallouts {

    public String query;  
    global BatchActivityGrouping2 (String query){
      System.debug('constructor of BatchActivityGrouping2');
      System.debug('query: ' + query);
      this.query = query;
    }

    global Iterable<Contact> start(Database.BatchableContext info){
      System.debug('start() of BatchActivityGrouping');
      System.debug('this.query: ' + this.query);
      System.debug('query: '      + query);
      return new AggregateResultIterable2(query);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
      System.debug('scope is...');
      System.debug(scope);

 //    List<Activity_Grouping__c> lstMoRecordsToProcess = new List<Activity_Grouping__c>();  
     
 //    for (Sobject so : scope)  {       
 //          //iterate through list 
//      }        

   }

    global void finish(Database.BatchableContext BC) {
    //send completion email
    }

}