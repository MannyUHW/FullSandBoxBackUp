@isTest(SeeAllData=true)
public class BhatPopulateNoEntryRecordsTest{

    public static TestMethod void DeleteNoEntryRecordsTest()
    {
    
        BhatPopulateNoEntryRecordsController bprc = new BhatPopulateNoEntryRecordsController();
        bprc.DeleteNoEntryRecords();
    
    }

    public static TestMethod void PopulateTest()
    {
    
        BhatPopulateNoEntryRecordsController bprc = new BhatPopulateNoEntryRecordsController();
        bprc.Populate();
    
    }



}