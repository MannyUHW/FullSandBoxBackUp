// https://salesforce.stackexchange.com/questions/123618/batch-job-with-custom-iterable-throwing-error-first-error-invalid-conversion-frhttps://salesforce.stackexchange.com/questions/123618/batch-job-with-custom-iterable-throwing-error-first-error-invalid-conversion-fr
//
// class CustomIteratable implements Iterable<SObject>, Iterator<SObject>
// {
//     public Iterator<SObject> iterator() { return this; }
//     public Boolean hasNext() { /*implementation*/ }
//     public SObject next() { /*implementation*/ }
// }
global class CustomIterable implements Iterable<String>, Iterator<String> { 
  
  List<String> data;
  Integer i, dataLength;

  public Iterator<String> iterator() { return this; }

  public CustomIterable(){ 
    data = new List<String>();
    data.add('This is a test');
    data.add('So is a this');
    dataLength = 2;
    i = 0;
  }   

  global boolean hasNext(){ 
    if(i >= data.size()) {
      return false; 
    } else {
      return true; 
    }
  }    

  global String next(){ 
    if(i == dataLength){return null;} 
      i++; 
      return data[i-1]; 
  } 
}