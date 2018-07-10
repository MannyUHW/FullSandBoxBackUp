global class AggregateResultIterable2 implements Iterable<Contact> {

    public String query;  

    global AggregateResultIterable2 (String query){
      System.System.debug('AggregateResultIterable query: ' + query);
      this.query = query;
    }

    global Iterator<Contact> Iterator(){
        return new AggregateResultIterator2(query);
    }             

}