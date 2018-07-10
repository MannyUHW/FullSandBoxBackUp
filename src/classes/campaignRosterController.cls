public with sharing class campaignRosterController
{
    public List<CampaignMember> campaignMembers { get; private set; }
    public campaignRosterController(ApexPages.StandardController controller)
    {
        campaignMembers = [
                SELECT Campaign.Name, Campaign.Startdate, Campaign.Type FROM CampaignMember
                WHERE ContactId = :controller.getId()

        ];
    }
}