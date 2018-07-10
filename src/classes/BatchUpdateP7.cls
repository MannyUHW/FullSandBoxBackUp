global class BatchUpdateP7 Implements Schedulable{
    global void execute(SchedulableContext sc){
        setToActive();
    }
    
    public void setToActive(){
        List<Contact> updateContacts = new List<Contact>();
        List<String> survey_codes = new List<String>{'TN1','P11','PC1','PR1','V02','EN3','PS1','P10','EN2','NH1','V04','PR3','EN5','PS3','P13','TN3','PC2'};
        for (AggregateResult ar:[Select Contact__c From Survey_Response__c Where Survey_Code__c IN:survey_codes AND Contact__r.X80_P7_Active__c=false Group By Contact__c]){        
            Contact c = new Contact();
            //system.debug(ar.get('Contact__c'));
            String cid = ar.get('Contact__c').toString();
            c.Id = cid;
            c.X80_P7_Active__c = true;    
            updateContacts.add(c);    
        }
        Database.update(updateContacts);
    }
    public static String sched = '0 0 00 ? * *';  //EveryDay, 12AM
	// used for scheduling a repeating job - currently set for 12AM Daily.
	global static String scheduleMe() {    	
        BatchUpdateP7 dailyActive = new BatchUpdateP7();
    	return System.schedule('Schedule P7UpdateActive - 12AM', sched,dailyActive);
	}

}