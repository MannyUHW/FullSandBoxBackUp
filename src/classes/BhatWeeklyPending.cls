public class BhatWeeklyPending
    {
        public String UserId { get; set; }
        public list<String> BhatWeek { get; set; }
        
        public String BhatWeekName { get; set; }
        public String BhatWeekId { get; set; }
        public String Status { get; set; }
        
        public BhatWeeklyPending()
        {
        
            this.BhatWeek = new List<String>();
        
        }
        
    }