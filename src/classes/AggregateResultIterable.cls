global class AggregateResultIterable implements Iterable<AggregateResult> {

    public String query;  

    global AggregateResultIterable (String query){
      System.System.debug('AggregateResultIterable query: ' + query);
      this.query = query;
    }

    global Iterator<AggregateResult> Iterator(){
        return new AggregateResultIterator(query);
    }             

}