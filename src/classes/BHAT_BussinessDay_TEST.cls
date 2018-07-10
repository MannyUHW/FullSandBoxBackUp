@isTest(SeeAllData = true)
    public class BHAT_BussinessDay_TEST{
    
        public static testMethod void test1(){
            Date d;
            BusinessDay b = new BusinessDay();
           
            d = Date.Today();
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()+10;           
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
             d = Date.Today()+40;           
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 30;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 60;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 90;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 120;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 150;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 180;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 210;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 240;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
            d = Date.Today()- 270;
            b.getStartWeekData(d);
            b.getEndWeekData(d);
            b.getMonthStart(d);
            b.getMonthEnd(d);
            
        }
    }