global class BatchActivityGrouping implements Database.Batchable<AggregateResult> , Database.AllowsCallouts {

    public String query;  
    global BatchActivityGrouping (String query){
      System.debug('constructor of BatchActivityGrouping');
      System.debug('query: ' + query);
      this.query = query;
    }

    global Iterable<AggregateResult> start(Database.BatchableContext info){
      System.debug('start() of BatchActivityGrouping');
      System.debug('this.query: ' + this.query);
      System.debug('query: '      + query);
      return new AggregateResultIterable(query);
    }

    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
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