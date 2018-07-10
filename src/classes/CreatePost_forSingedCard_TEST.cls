@IsTest(seealldata=true)
public class CreatePost_forSingedCard_TEST
{
    public static testMethod void test1()
    {
    Chatter_Group_Cuztomization__c cstmsetting=new Chatter_Group_Cuztomization__c(name='Test chatter Group',Active__c=true);
    insert cstmsetting;
    system.assertequals(cstmsetting.name,'Test chatter Group');
    
    CollaborationGroup chattergroup= new CollaborationGroup(Name='Test chatter Group', CollaborationType='Public',OwnerId = UserInfo.getUserId());
    insert chattergroup;
    system.assertequals(chattergroup.name,'Test chatter Group');
    
    CollaborationGroup chattergroup1=[SELECT Id,Name From CollaborationGroup WHERE CollaborationType='Public' and name =:cstmsetting.name];
    system.assertequals(chattergroup1.name,'Test chatter Group');
    
    Contact newctct=new Contact(lastname='testnewname',Signed_Membership_Card__c=false,FID__c = '3312-23212529');
    insert newctct;
    newctct.Signed_Membership_Card__c=true;
    update newctct;
    system.assertequals(newctct.Signed_Membership_Card__c,true);
    
        FeedItem post = new FeedItem();
        post.ParentId = chattergroup1.id;
        post.CreatedById = newctct.OwnerId;
        post.Body = 'I just signed up a new member!!!';
        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + newctct.Id;
        post.title=newctct.lastname;
        insert post;
        
    newctct.Signed_Membership_Card__c=false;
    update newctct;
    }
}