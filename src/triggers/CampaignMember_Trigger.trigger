trigger CampaignMember_Trigger on CampaignMember(before insert, before update, before delete) {

  Campaign_Member_Trigger_Helper.propagateResponse(Trigger.new, Trigger.oldMap, Trigger.isInsert, Trigger.isDelete);
  
  
}