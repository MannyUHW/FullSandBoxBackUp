public class PledgeUpBatch implements Database.batchable<String>, Database.AllowsCallouts {

//  global static string next;
   
  public Iterable<String> start(Database.Batchablecontext BC){
    System.debug('start() of PledgeUpBatch.');
    return new PledgeUpIterable();
  }

  public void execute(Database.BatchableContext BC, List<String> scope){       
    System.debug('execute() of PledgeUpBatch.');
    System.debug(' --- scope: ---');
    System.debug(scope);
    System.debug(' --- scope: ---');
  }

  public void finish(Database.BatchableContext info){
    System.debug('finish() of PledgeUpBatch.');        
    System.debug(' --- info: ---');
    System.debug(info);
    System.debug(' --- info: ---');    
  }

}