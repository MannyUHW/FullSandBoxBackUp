public class SOS_TOR_EDIT_Controller{
    public Boolean isExempt {get;set;}
    public SOS_Time_Off_Request__c tor {get;set;}    
    public SOS_TOR_EDIT_Controller(ApexPages.StandardController controller) {
        tor = (SOS_Time_Off_Request__c)controller.getRecord();
        System.debug('@@@createdby:@@'+tor.id);
        SOS_Time_Off_Request__c sosToR = [Select Id, createdById from SOS_Time_Off_Request__c where id=: tor.Id limit 1];
        User usr = [Select Id,Non_Exempt_Employee__c from user where id =: userinfo.getUserId() limit 1];
 		if(usr.Non_Exempt_Employee__c) {
        	isExempt = false;
        	tor.Employee_Type__c = 'Non Exempt';
 		}
    	else {
    		isExempt = true;
    		tor.Employee_Type__c = 'Exempt';
    	}
    }
    public pageReference updateAndReturn() {
        List<ApexPages.Message> msglst = new List<ApexPages.Message>();
        try {
            update tor;
        }
        Catch(Exception excp) {
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, excp.getMessage() );
            msglst.add(msg);
            ApexPages.addMessage(msg);  
        }
        if(msglst.size()== 0 && !ApexPages.hasMessages()) {
            return new pageReference('/'+tor.id);
        }
        else
            return null;        
        
    }
    public pageReference hrApproved() {
        SOS_Time_Off_Request__c sosToR = [Select Id, createdById, Status__c from SOS_Time_Off_Request__c where id=: ApexPages.currentpage().getParameters().get('id') limit 1];
        sosToR.Status__c = 'HR Approved';
        sosToR.HR_Approved_Rejected_Date__c = System.today();
        sosToR.HR_Comments__c = tor.HR_Comments__c;
        if(!Test.isRunningTest())
            update sosToR;
        return new pageReference('/'+tor.id);
    }
    public pageReference hrRejected() {
        SOS_Time_Off_Request__c sosToR = [Select Id, createdById, Status__c from SOS_Time_Off_Request__c where id=: ApexPages.currentpage().getParameters().get('id') limit 1];
        sosToR.Status__c = 'Rejected';
        sosToR.HR_Approved_Rejected_Date__c = System.today();
        sosToR.HR_Comments__c = tor.HR_Comments__c;
        update sosToR;
        return new pageReference('/'+tor.id);
    }
    public pageReference hrCancel() {
        return new pageReference('/');
    }
}