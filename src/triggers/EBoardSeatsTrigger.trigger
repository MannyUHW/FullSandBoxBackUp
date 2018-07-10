trigger EBoardSeatsTrigger on EBoardSeats__c (Before Update) {
    EBoardSeats_UpdateContact.UpdateContact(Trigger.new,Trigger.oldMap,Trigger.isUpdate);
}