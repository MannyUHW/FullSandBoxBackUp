public with sharing class uhw_censusmap_helper {

	public List<Account> uhwLocations {get;set;}
	public List<Contact> members {get;set;}
	public List<Contact> leaders {get;set;}




	public uhw_censusmap_helper() {
		uhwLocations = [SELECT Parent.name, name, billingstreet, billingcity, billingstate, billingpostalcode, billingLatitude, billingLongitude, billingaddress, billingGeocodeAccuracy From Account WHERE Parent.name LIKE '%SEIU-UHW%' Order By name];
		members = [SELECT MailingAddress,MailingCity,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,Name,Account.name FROM Contact WHERE MailingLatitude != NULL Limit 1000];
		//uhwLocations = [select id,name,(select id, name, billingstreet, billingcity, billingstate, billingpostalcode from ChildAccounts) from account WHERE name LIKE '%SEIU-UHW%'];

	}
}