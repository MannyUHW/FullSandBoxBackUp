public class SOSTimeOffBalanceTriggerHandler {
    public static void onBeforeInsert(List<SOS_Time_Off_Balance__c> triggerNew) {
        Set<Id> newEmpSet = new Set<Id>();
        Set<Id> oldEmpSet = new Set<Id>();
        
        for(SOS_Time_Off_Balance__c tob : triggerNew) {
            if(tob.Employee_Name__c != null)
                newEmpSet.add(tob.Employee_Name__c);
        }
                
        if(newEmpSet.size()>0) {
            for(SOS_Time_Off_Balance__c tob : [Select Id,Employee_Name__c from SOS_Time_Off_Balance__c 
            where Employee_Name__c in: newEmpSet]) {
                oldEmpSet.add(tob.Employee_Name__c);
            }
                        
            for(SOS_Time_Off_Balance__c tob : triggerNew) {
                if(oldEmpSet.contains(tob.Employee_Name__c))
                    tob.Employee_Name__c.addError('Employee Name should not be duplicate, already a record exists for this Employee.');    
            }      
        }       
    }  


  //is after update 
   public static void onBeforeUpdate (List<SOS_Time_Off_Balance__c> newObjects, Map<id, SOS_Time_Off_Balance__c> OldObjects){
       
       for(Integer i = 0; i < newObjects.size(); i++)
       { 
       	
       	   system.debug('Sun : onBeforeUpdate:' + newObjects[i]);
       	   
       	   
       	          	
           SOS_Time_Off_Balance__c tb = newObjects[i];
           
           system.debug('Sun : tb.Vacation_Bal__c:' + tb.Vacation_Bal__c);
           
           tb.Bereavement_Time_Rem__c= tb.Bereavement_Bal__c - (tb.Bereavement_Time_Pending__c + tb.Bereavement_Time_Approved__c);
           tb.Birthday_Time_Rem__c= tb.Birthday_Bal__c - (tb.Birthday_Time_Pending__c + tb.Birthday_Time_Approved__c);
           tb.Float_Time_Rem__c= tb.Float_Bal__c - (tb.Float_Time_Pending__c + tb.Float_Time_Approved__c);
           tb.Holiday_work_days_Time_Rem__c= tb.Holiday_work_days_Bal__c - (tb.Holiday_work_days_Time_Pending__c + tb.Holiday_work_days_Time_Approved__c);
           tb.Jury_Duty_Time_Rem__c= tb.Jury_Duty_Bal__c - (tb.Jury_Duty_Time_Pending__c + tb.Jury_Duty_Time_Approved__c);
           tb.Relieve_Time_Rem__c= tb.Relieve_Bal__c - (tb.Relieve_Time_Pending__c + tb.Relieve_Time_Approved__c);
           tb.Religious_OPEIU_Only_Time_Rem__c= tb.Religious_OPEIU_Only_Bal__c - (tb.Religious_OPEIU_Only_Time_Pending__c + tb.Religious_OPEIU_Only_Time_Approved__c);
           tb.Sick_Time_Rem__c= tb.Sick_Bal__c - (tb.Sick_Time_Pending__c + tb.Sick_Time_Approved__c);
           tb.Unpaid_Time_Rem__c= tb.Unpaid_Bal__c - (tb.Unpaid_Time_Pending__c + tb.Unpaid_Time_Approved__c);
           tb.Vacation_Time_Rem__c= tb.Vacation_Bal__c - (tb.Vacation_Time_Pending__c + tb.Vacation_Time_Approved__c);
           
           
           
           
           
       	   system.debug('Sun : tb.Vacation_Time_Rem__c:' + tb.Vacation_Time_Rem__c);
           
       }

   }


    
}