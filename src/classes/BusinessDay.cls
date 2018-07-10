Public class BusinessDay{


    public date getStartWeekData(date thisdate ){
        Datetime dt = DateTime.newInstance(thisdate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
        date startDate;
        
         if(dayOfWeek  != 'Sunday'){
                startDate = thisdate.toStartofWeek();
                startDate = startDate+ 1;
           }
           else{
               thisdate = thisdate - 1;
               startDate = thisdate.toStartofWeek();
               startDate = startDate + 1;
           }
            return startDate;
    }
    
    public date getEndWeekData(date thisdate ){
        Datetime dt = DateTime.newInstance(thisdate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
         date startDate;
     
           if(dayOfWeek != 'Sunday'){
                startDate = thisdate.tostartofWeek();
                startDate = startDate+7;
           }
           else{
               thisdate = thisdate - 1;
               startDate = thisdate.tostartofWeek();
               startDate = startDate+7;
           }
            return startDate;
    }
    public string getMonthStart(date thisdate ){ 
       String month;      
            Integer dt =  thisdate.day();
            Integer dtMonth = thisdate.month();            
            if(dtMonth == 1){
              month = 'Jan'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 2){
              month = 'Feb'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 3){
              month = 'Mar'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 4){
              month = 'Apr'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 5){
              month = 'May'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 6){
              month = 'Jun'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 7){
              month = 'Jul'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 8){
              month = 'Aug'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 9){
              month = 'Sep'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 10){
              month = 'Oct'+' '+ string.ValueOf(dt);
            }            
            if(dtMonth == 11){
              month = 'Nov'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 12){
              month = 'Dec'+' '+ string.ValueOf(dt);
            }
        return month;
    }
   
     public string getMonthEnd(date thisdate ){
       String month;
            Integer dt =  thisdate.day();
            Integer dtMonth = thisdate.month();
                        
            if(dtMonth == 1){
              month = 'Jan'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 2){
              month = 'Feb'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 3){
              month = 'Mar'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 4){
              month = 'Apr'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 5){
              month = 'May'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 6){
              month = 'Jun'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 7){
              month = 'Jul'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 8){
              month = 'Aug'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 9){
              month = 'Sep'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 10){
              month = 'Oct'+' '+ string.ValueOf(dt);
            }            
            if(dtMonth == 11){
              month = 'Nov'+' '+ string.ValueOf(dt);
            }
            if(dtMonth == 12){
              month = 'Dec'+' '+ string.ValueOf(dt);
            }
        return month;
    }
   
}