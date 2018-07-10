public class SOSTriggerLib
{
    
    public Static void UpdatePacketNameOnProjectZoneContact( List<Project_Packet_Contact_SOSP__c> newlist, Map<ID,Project_Packet_Contact_SOSP__c> newmap) {
    
    
        //List<Project_Packet_Contact_SOSP__c> ppcList = [SELECT Contact__c,Id,Name,ProjectID__c,Project_Packet__c, Project_Zone_ID__c FROM 
         //   Project_Packet_Contact_SOSP__c WHERE Id in :newmap.keyset() AND Project_Packet__c != NULL];
    
    	/*
        List<Project_Zone_Contact_SOSP__c> pzcToUpdatedList =  new List<Project_Zone_Contact_SOSP__c>();
    
        for(Project_Packet_Contact_SOSP__c ppc: newlist )
        {
        	
        	if (ppc.Project_Packet__c != null)
        	{
    
	            //SELECT Id, Name,Contact__c, Project_Packet__c,Project_Zone_ID__c,ZoneID__c FROM Project_Packet_Contact_SOSP__c
	    
	            List<Project_Zone_Contact_SOSP__c> pzcList = [SELECT Contact__c,Id,ProjectID__c,Project_Packet__c,Project_Zone_ID__c,Project_Zone__c FROM Project_Zone_Contact_SOSP__c 
	                WHERE Project_Zone__r.Id =: ppc.Project_Zone_ID__c AND Contact__c =:ppc.Contact__c  ];
	            
	            for(Project_Zone_Contact_SOSP__c ppcToBeUpdated: pzcList )
	            {
	            	if (ppcToBeUpdated.Project_Packet__c == NULL)
	            	{
		                ppcToBeUpdated.Project_Packet__c = ppc.Project_Packet__c;
		                pzcToUpdatedList.add(ppcToBeUpdated);
	            	}
	            }
            
        	}
        }
    
        update  pzcToUpdatedList;   
        */
    }
    

}