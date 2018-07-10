public class SOS_UpdateContactOnTaskChanges {
    public static Boolean updateContact(Contact c, Boolean refusedToSign, Boolean visitedlastsixmonths, Boolean noonehome) {
        Boolean doupdate = false;
        
        if (c.RefusedToSign__c != refusedToSign) {
            c.RefusedToSign__c = refusedToSign;
            doupdate = true;
        }
        if (c.VisitLast6Months__c != visitedlastsixmonths) {
            c.VisitLast6Months__c = visitedlastsixmonths;
            doupdate = true;
        }
        if (c.No_one_home__c != noonehome) {
            c.No_one_home__c = noonehome;
            doupdate = true;
        }
        
        return doupdate;
    }
}