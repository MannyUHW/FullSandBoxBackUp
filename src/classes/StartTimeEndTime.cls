public with sharing class StartTimeEndTime {
	
	public Time startTime {get; set;}
	public Time endTime   {get; set;}
	public Datetime startDT  {get; set;}
	public DateTime  endDT   {get; set;}
	
	public StartTimeEndTime(DateTime startT, DateTime endT){
		startTime = startT.time();
		endTime = endT.time();
	  startDT = startT;
	  endDT = endT;
	}

}