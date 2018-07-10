/* Trigger to Update the Duplicate value of the Visist object */

public class UpdatePacketContactOnVisitHandler{
    
    public static List<CVRSOS__Packet_Contact__c> packetContactList = new List<CVRSOS__Packet_Contact__c>();
    Static Map<Id, CVRSOS__Visits__c> visitBeforeInsertMap = new Map<Id, CVRSOS__Visits__c>();
    
    public UpdatePacketContactOnVisitHandler()
    {
    
    }
    
    public static void beforeInsertTrigger(Map<Id, CVRSOS__Visits__c> visitBeforeInsertMaps, List<CVRSOS__Visits__c> visitBeforeInsertList){
        
        for(CVRSOS__Visits__c visit :visitBeforeInsertList){
        
            packetContactList= [Select Id from CVRSOS__Packet_Contact__c Where CVRSOS__Contact__c  =: visit.CVRSOS__Contact__c LIMIT 1];
            if (packetContactList.size() > 0 )
            {
                visit.Packet_Contact__c = packetContactList[0].id;
            }
        }
        
        
    }
         
 }