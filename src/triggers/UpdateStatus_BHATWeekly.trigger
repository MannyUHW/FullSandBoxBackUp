trigger UpdateStatus_BHATWeekly on BHAT_Activity_Weekly__c (before insert, before update) {
  
    Decimal minWorkDays = 0.0;
    Integer minWorkDaysInt = 0;

    Decimal minHourPerDay = 0.0;
    Integer minHourPerDayInt = 0;
                    

   BHAT_Activity_Weekly__c  newobj= Trigger.new[0];

   List<Bhat_Activity_Daily__c> dailyActivities = new List<Bhat_Activity_Daily__c>();
   decimal bhatHourlyExemptMinHours = 0;
    
   // for(Account BHAT_Activity_Weekly__c : Trigger.new){
    
    
   // }
    
    
    List<BHAT_Activity_Weekly__c > weekList = [SELECT id,Weekly_Hours_Total__c, 
                                              (SELECT id,Status__c,BHAT_Activity_Weekly__c, Daily_Hours_Total__c FROM Bhat_Activity_Daily__r)
                                               FROM BHAT_Activity_Weekly__c where id =: newobj.id];
                                               
    User user = [SELECT BHAT_Hourly_Exempt_Min_Hours__c FROM User WHERE Id =:userinfo.getUserID() LIMIT 1];
    
    if (user != null)
    {
        bhatHourlyExemptMinHours = user.BHAT_Hourly_Exempt_Min_Hours__c;
    }
    
        integer count_Complete = 0;
        integer count_NoEntry = 0;
        integer count_Incomplete = 0; 
        integer count_Overtime = 0;
        
        BHAT_Activity_Weekly__c wk = Trigger.new[0];
        
            for (BHAT_Activity_Weekly__c wks : weekList)
            {
                 if(wks.id == wk.id)
                 {
                      for(BHAT_Activity_Daily__c daily : wks.Bhat_Activity_Daily__r)
                      {
                      
                            if (bhatHourlyExemptMinHours > 0 )
                            {
                            
                                if (bhatHourlyExemptMinHours == 35)
                                {
                                    minWorkDaysInt=5;
                                }    
                                else
                                {

                                    minWorkDays = (bhatHourlyExemptMinHours/8);
                                    minWorkDaysInt  = minWorkDays.intValue();
                                }
                                
                                
                                
                            
                                
                                system.debug('(bhatHourlyExemptMinHours/minWorkDaysInt):' + bhatHourlyExemptMinHours + ' / ' + minWorkDaysInt );
                            
                                minHourPerDay = (bhatHourlyExemptMinHours/minWorkDaysInt);
                                minHourPerDayInt = minHourPerDay.intValue();
                    
                                system.debug('minHourPerDay: '  + minHourPerDay );
                                system.debug('minHourPerDayInt: '  + minHourPerDayInt );
                                system.debug('daily.Daily_Hours_Total__c: '  + daily.Daily_Hours_Total__c);
                                system.debug('daily.Daily_Hours_Total__c == minHourPerDayInt: '  + (daily.Daily_Hours_Total__c == minHourPerDayInt));
                                system.debug('daily.Status__c: '  + daily.Status__c);
                                
                                

                                if( daily.Status__c == 'Complete' && daily.Daily_Hours_Total__c == minHourPerDayInt  ){
                                   count_Complete++;
                                }
                                else if( daily.Status__c == 'Complete' && daily.Daily_Hours_Total__c > minHourPerDayInt  ){
                                   count_Overtime++;
                                }
                                else if( daily.Status__c == 'Overtime'){
                                    count_Overtime++;
                                }
                                else if( daily.Status__c == 'No Entry'){
                                   count_NoEntry++;
                                }
                                else {
                                    count_Incomplete++;
                                } 

                             }
                             else
                             {
                             
                                if( daily.Status__c == 'InComplete'){
                                    count_Incomplete++;
                                } 
                                if( daily.Status__c == 'Complete'){
                                   count_Complete++;
                                }
                                if( daily.Status__c == 'No Entry'){
                                   count_NoEntry++;
                                }
                                if( daily.Status__c == 'Overtime'){
                                    count_Overtime++;
                                }
                                                             
                             }   
                            
                            
                      }
                  } 
            }
       
           System.Debug('**********FINAL COUNT VALUES***********-------------'+'INC'+ count_Incomplete +'-------'+'NoEnt'+count_NoEntry+'----'+'Complete'+count_Complete+'Ovtime'+count_Overtime);
           
           //Test begins....
           
       
       
            if (bhatHourlyExemptMinHours > 0 )
            {

                    //Decimal minHourPerDay = (bhatHourlyExemptMinHours/minWorkDaysInt);
                    //Integer minHourPerDayInt = minHourPerDay.intValue();
                    
                    System.Debug('**********wk.Weekly_Hours_Total__c***********-------------'+'wk.Weekly_Hours_Total__c:'+ wk.Weekly_Hours_Total__c +'-------'+'bhatHourlyExemptMinHours:'+bhatHourlyExemptMinHours);
                    System.Debug('**********(minWorkDaysInt * minHourPerDay ) ' + (minWorkDaysInt * minHourPerDay ) );
                    
       
                   if(count_Complete ==0 && count_Overtime ==0 && count_Incomplete == 0 && count_NoEntry >0)
                   {
                        wk.Status__c  = 'No Entry';
                   }
                   else if (wk.Weekly_Hours_Total__c == bhatHourlyExemptMinHours &&  wk.Weekly_Hours_Total__c == (minWorkDaysInt * minHourPerDay ) && count_Complete == minWorkDaysInt   )
                   {
                        wk.Status__c  = 'Complete';
                   }
                   else if (wk.Weekly_Hours_Total__c > bhatHourlyExemptMinHours &&  wk.Weekly_Hours_Total__c > (minWorkDaysInt * minHourPerDay ) && count_Overtime >= 1 && count_Incomplete == 0  )
                   {
                        wk.Status__c  = 'Overtime';
                   }
                   else {
                        wk.Status__c  = 'Incomplete';
                   }
                   
  
            }
            else
            {
                
                //Test begins....
           
                   if(count_Complete>=0 && count_Overtime >=1 && count_Incomplete >= 0 && count_NoEntry >= 0)
                   {
                        wk.Status__c  = 'Overtime';
                   } 
                   else if(count_Complete >=5 && count_Overtime ==0 && count_Incomplete >= 0 && count_NoEntry >= 0)
                   {
                        wk.Status__c  = 'Complete';
                   }
                   else if(count_Complete ==0 && count_Overtime ==0 && count_Incomplete == 0 && count_NoEntry >0)
                   {
                        wk.Status__c  = 'No Entry';
                   }
                   else
                   {
                        wk.Status__c  ='Incomplete';
                   }
                
            }
           
          
           
           
      }