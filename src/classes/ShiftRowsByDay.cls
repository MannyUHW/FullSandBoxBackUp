public with sharing class ShiftRowsByDay {
  public   list <ShiftRow> shiftRowsByDate  {get; set;}
  public   Datetime dateMapper                {get; set;}
  /******************************/
  public ShiftRowsByDay(list<StartTimeEndTime> startEndList, Date d, list <Staffing_Assignment__c> staffingAssignmentList){
  	dateMapper = datetime.newInstance(d.year(), d.month(), d.day());
  	shiftRowsByDate = new List <ShiftRow>();
    ShiftRow addingSR;
    for(StartTimeEndTime stet:startEndList){
     if(d == stet.startDT.date()){
      addingSR = new ShiftRow(stet, d, staffingAssignmentList);
      addInOrderShiftRowByDate(addingSR);
     }
    }
  }
  /******************************/
   private void addInOrderShiftRowByDate(ShiftRow sr){
      boolean srAdded = false;
      List <ShiftRow> newList = new List<ShiftRow>();
      for(ShiftRow oldSR : shiftRowsByDate){
        if(sr.startDTime <= oldSR.startDTime && !srAdded){
          newList.add(sr);
          newList.add(oldSR);
          srAdded = true;
        }
        else{
          newList.add(oldSR);
        }
      }
      
      if(!srAdded)
        newList.add(sr);
      
      shiftRowsByDate.clear();
      for(ShiftRow newSR:newList){
        shiftRowsByDate.add(newSR);
      }
   }
  /******************************/
}