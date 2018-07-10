public  class SOS_Utility {
    public static Set<Id> getUserIdsFromGroup(Set<Id> groupIds) {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();
        // Loop through all group members in a group
        for(GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId in :groupIds]) {
            // If the user or group id is a user
            if(((String)m.UserOrGroupId).startsWith(userType)) {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType)) {
                // Call this function again but pass in the group found within this group
                groupIdProxys.add(m.UserOrGroupId);
            }
        }
        if(groupIdProxys.size() > 0) {
            result.addAll(getUSerIdsFromGroup(groupIdProxys));
        }
        return result;  
    }
    public static Set<String> getUserEmailIdsFromGroup(String groupId) {
        Set<String> emailSet = new Set<String>();
        Set<Id> groupIds = new Set<Id>();
        groupIds.add(Id.valueOf(groupId));
        for( User usr : [Select Id, email from user where id in : getUSerIdsFromGroup(groupIds)]) {
            emailSet.add(usr.email);
        }
        return emailSet;
    }
    public static Boolean isSrchStrPresent(String str, String srchStr) {
        Boolean bol = false;
        List<String> strLst = new List<String>();
        strLst.addAll(str.split(';'));
        for(String strg : strLst) {
            if(strg.equalsIgnoreCase(srchStr)) {
                bol = true;
                break;
            }           
        }
        return bol;
    } 
    
}