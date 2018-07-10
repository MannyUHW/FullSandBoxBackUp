public class KaiserSiteController {

    @RemoteAction
    public static Boolean grant(String code) {
    String cleanCode;
    String currentCode;
    Integer codeVal;
    Integer currentVal;
    Common_Settings__c uhwCommentSettings = Common_Settings__c.getValues('UHWCommonSettings');
    currentCode = uhwCommentSettings.KaiserCode__c;
    
    cleanCode  = code.stripHtmlTags();
    codeVal    = Integer.valueOf(cleanCode);
    currentVal = Integer.valueOf(currentCode);

    if(codeVal == currentVal)
        return true;
    else
        return false;
    }

    @RemoteAction
    public static String gc() {
        return 'United_Healthcare_Workers_West_10-Mar-2016_MTQ4OTEwNDAwMDAwMA==575a9957bde70d692feff6c444540406';
    }

    @RemoteAction
    public static List <sObject> getCsData() {

        List <sObject> data;
        if(data == null) {
            data = [
                Select Contact__r.Id, Contact__r.LastName, Contact__r.FirstName, CellPhone__c, Email__c
                From ContractSpecialists__c
                Where Division__c = 'Kaiser' And Contact__r.Firstname != null
                Order By Contact__r.FirstName,Contact__r.LastName
            ];
        }
        return data;
    }

    @RemoteAction
    public static List <sObject> getData() {

        List <sObject> data;
        if(data == null) {
            data = [Select Account.Id, Account.Name, TeamMemberRole, User.FirstName, User.LastName
                From AccountTeamMember
                Where TeamMemberRole IN('Coordinator', 'Organizer1', 'Organizer2') AND Account.Account_Group__c = 'Kaiser' AND Account.Type = 'Employer' Order By Account.Name, TeamMemberRole
            ];

            data = [
                Select Name,Contract_Specialist__c,Coordinator__r.FirstName,Coordinator__r.LastName,Coordinator__r.Email, Coordinator__r.MobilePhone,
                Organizer_1__r.FirstName,Organizer_1__r.LastName,Organizer_1__r.Email, Organizer_1__r.MobilePhone,
                Organizer_2__r.FirstName,Organizer_2__r.LastName,Organizer_2__r.Email, Organizer_2__r.MobilePhone
                From Account Where Account_Group__c = 'Kaiser' And Type = 'Employer' Order By Account.Name
            ];

        }
        return data;
    }
}