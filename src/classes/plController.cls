global class plController {

    //--assigning a few things every time someone loads the visualforce page--
    //
    //this is the current user id
    public String userid{get;set;}
    //current user name
    public String username{get;set;}
    //
    //user contact field setup (all needed since objet only passes id to vf page)
    public string userContactId{get;set;}

    public string userContactName{get;set;}
    public string userContactEmployer{get;set;}
    public string userContactDept{get;set;}
    public string userContactTitle{get;set;}
    public string userContactDiv{get;set;}
    public decimal userContactPetqty{get;set;}
    public string userContactMobile{get;set;}
    
    public string currentCampaignId{get;set;}
    //Boolean to store user access to checkin and burn forms
    public boolean userCheckinBurn{get;set;}
    //boolean to store user heirarchy as coord/mgr can transfer b/n staff
    public boolean userStaffXfr{get;set;}

    //controller code loaded when called(used for petition ledger entry vf page load code)
    public plController(){
        //get current userid populated
        userid = Userinfo.getUserId();
        //get current username
        username = Userinfo.getUserName();
        //setup current user contact for vfp reference
        Contact usercontact = getusrContact();
        userContactId = usercontact.Id;
        userContactName = usercontact.Name;
        userContactEmployer = usercontact.Account.Name;
        userContactDept = usercontact.Department;
        userContactTitle = usercontact.Title;
        userContactDiv = usercontact.Division_Type__c;
        userContactPetqty = usercontact.PetitionQty__c;
        userContactMobile = usercontact.MobilePhone;
        //disable checkinburn by default
        userCheckinBurn = true;     
        //get admin list usernames from custom settings table
        List<pl_upl__c> upl = pl_upl__c.getall().values();
        Set<string> upl_names = new Set<string>();
        for(pl_upl__c up :upl){
            upl_names.add(up.Username__c);
        }
        //if current user in admin list, then turn on checkin&burn buttons
        if(upl_names.contains(username)){
            userCheckinBurn = false;
        }

        //disable staff transfers by default
        userStaffXfr = true;        
        //get list of permissionset names current user is assigned to 
        List<PermissionSetAssignment> user_psa_list = new List<PermissionSetAssignment>([
                SELECT PermissionSet.Name 
                FROM PermissionSetAssignment 
                WHERE AssigneeId =:userid
        ]);
        //if the permission set found then remove
        //disabled transfers
        for(PermissionSetAssignment psa :user_psa_list){
            if(psa.PermissionSet.Name == 'Petition_Ledger_StaffXfr' || !userCheckinBurn){
                userStaffXfr = false;
            }
        }

        List<UHW_Campaign__c> apc = Database.query('SELECT Id FROM UHW_Campaign__c WHERE (Start_Date__c = null OR Start_Date__c <= TODAY) AND (End_Date__c = null OR End_Date__c >= TODAY) AND Petition_Campaign__c = true');
        
        if(apc.size() == 0){            
                throw new DMLException('Can\'t find campaign for petitions. Please contact Data Group to see if any petition campaigns are active.');
        }
        else if(apc.size() > 1){
                throw new DMLException('Only one petition campaign can be active at any one time.  Please contact Data Group to limit active petition campaigns.');
        }
        else{
            currentCampaignId = apc[0].Id;
        }
        

    }
    
    private static contact getusrContact(){

        String myContactId = [Select Staff_Contact_Id__c From User Where Id = :UserInfo.getUserId()][0].Staff_Contact_Id__c;

        string q_string = 'Select Id, Name, MobilePhone, PetitionQty__c, Account.Name, Department, Title, Division_Type__c ';
        q_string += 'FROM Contact ';

        if(string.isNotBlank(myContactId)){
            q_string += 'Where Id =\'' + myContactId + '\'  ';
        }                
        else{
            q_string += 'Where FirstName = \'' + UserInfo.getFirstName() + '\' and LastName = \''+UserInfo.getLastName() +'\'';
        }
        
        system.debug('[pl_userContact] contact id:'+myContactId);   
        List<Contact> c_list = Database.query(q_string);
        system.debug('[pl_userContact] all info:'+c_list);   
        Contact c = new Contact();
        if(c_list.size()>0){
            c = c_list[0];
        }
        return c;
    }

    private static string getStaffXfr(boolean staffxfr){
        string queryclause = '';
        if(staffxfr){            
            queryclause = ' Division_Type__c != \'Staff\' ';
        }
        return queryclause;
    }

    private static string getUOP(string username){        
        
        //build out base list of ofice location permissions
        Set<string> base_nums = new Set<string>();
        for (Integer i = 1; i < 8; i++) {
            string num = '00-' + String.valueOf(i);
            base_nums.add(num);
        }

        //build user permissions granted from custom setting list
        List<pl_upl__c> upl = pl_upl__c.getall().values();
        Set<string> upl_nums = new Set<string>();
        for(pl_upl__c up :upl){
            if(username == up.Username__c){                
                upl_nums.add(up.LocationNumber__c);
            }            
        }
        //remove user permission granted from restriction string list
        for(String remove :upl_nums){
            if(base_nums.contains(remove)){
                base_nums.remove(remove);
            }
        }        
        

        string user_office_permstring = '';
        if(base_nums.size()>0){
            //create restriction string list for passing into contact queries        
            user_office_permstring = '(';
            for (string n :base_nums) {
                string this_num = '\'' + n + '\',';
                if(!upl_nums.contains(this_num)){
                    user_office_permstring += this_num;
                }
            }
            user_office_permstring = user_office_permstring.substring(0,user_office_permstring.length()-1);
            //mainstring='('\'00-1\',\'00-2\',\'00-3\',\'00-4\',\'00-5\',\'00-6\',\'00-7\')'
            user_office_permstring += ') ';
        }        
        return ' In_Current_BU__c = true and Division_Type__c != \'Home Care\' and FID__c not in '+user_office_permstring;
    }

    //--finished assignments on controller load of visualforce page--//
    //--now begins the remote functions linked to javascript on page-//
    @RemoteAction
    global static void saveCheckInEntries(String plJson_List){
        if(plJson_List != null){
            List<Petition_Ledger__c> deserializedObject = (List<Petition_Ledger__c>)System.JSON.deserialize(plJson_List, List<Petition_Ledger__c>.class);
            if(deserializedObject.size()>0)
            {
                insert deserializedObject;
            }
            else
            {
                throw new DMLException('No rows to check in');
            }
        }
    }

    @RemoteAction
    global static void saveXfrEntry(String plJson) {
        if(plJson!=null) {
            Petition_Ledger__c pl = (Petition_Ledger__c)System.JSON.deserialize(plJson, Petition_Ledger__c.class);
            insert pl;
        }
    }

    @RemoteAction
    global static List<Contact> sosl_remote(String searchText, String username, boolean staffxfr)
    {                
        
       List<Contact> foundContacts = new List<Contact>();
       if(searchText.length() > 1){
           String uop = getUOP(username);
           String q_xfr = getStaffXfr(staffxfr);
           String searchStr1 = '*'+searchText+'*';
           String searchQuery = 'FIND \'' + searchStr1 + '\' IN NAME FIELDS RETURNING  Contact(Id, Name, MobilePhone, PetitionQty__c, Account.Name, Department, Title, Worksite__c , Division_Type__c';
           if(uop.length()>0 || staffxfr){
               searchQuery += ' WHERE ';
               searchQuery += uop ;
               if(uop.length() > 0 && staffxfr){
                searchQuery += ' AND ';
               }
               searchQuery += q_xfr ;
           }
               
           searchQuery += ')';
           system.debug('[pl_query] full query:'+searchQuery);
           system.debug('[pl_query] text input:'+searchText);
           system.debug('[pl_query] staff xfr bool:'+staffxfr);
           List<List <sObject>> searchList = search.query(searchQuery);
           foundContacts = ((List<Contact>)searchList[0]);
       }
       return foundContacts;
    }       

   @RemoteAction
   global static List<Contact> listContacts_recentv1(string username, boolean staffxfr){
        
       String q_xfr = getStaffXfr(staffxfr); 

       String uop = getUOP(username);
       if(uop.length()>0){
           uop = 'AND ' + uop;
       }
       if(staffxfr){            
             uop += ' AND ' + q_xfr;            
       }

       string q_s = 'Select Id, Name, MobilePhone, PetitionQty__c, Account.Name, Worksite__c, Department, Title, Division_Type__c ';
        q_s += 'FROM Contact ';
        q_s += 'Where FID__c in (\'00-1\',\'00-2\',\'00-3\',\'00-4\',\'00-5\',\'00-6\') ' + uop;
        //TODO:make this work with q_s for recent staff workaround fix

       List<Contact> officeBuckets = Database.query(q_s);

       string q_string = 'SELECT Id, Name, MobilePhone, PetitionQty__c, Account.Name, Worksite__c, Department, Title, Division_Type__c FROM Contact WHERE LastViewedDate != NULL '+ uop +' ORDER BY LastViewedDate DESC LIMIT 20';
       
       List<Contact> foundContacts = Database.query(q_string);

       List<Contact> finalContacts = new List<Contact>();       
       finalContacts.addAll(officeBuckets);
       finalContacts.addAll(foundContacts);
       return finalContacts;
   }
}