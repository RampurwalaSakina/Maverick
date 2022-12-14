public with sharing class ContactDeleteController
{
	String recordId{get;set;}
    public String loggedInUserId{get;set;}
    public String user1{get;set;}
    public String user2{get;set;}
    public String user3{get;set;}
	public ContactDeleteController(ApexPages.StandardController StandardController)
	{
		recordId=ApexPages.currentPage().getParameters().get('id');
        system.debug('Record submitted for Deletion-->'+recordId);
        loggedInUserId = Userinfo.getUserId();
        system.debug('Logged in User Id -->'+loggedInUserId);
        user1 = [SELECT User_Id__c FROM UsersExemptedForContactDelete__mdt WHERE MasterLabel = 'User 1'].User_Id__c;
        system.debug('1st User Expempted from Contact Delete Approval -->'+user1);
        user2 = [SELECT User_Id__c FROM UsersExemptedForContactDelete__mdt WHERE MasterLabel = 'User 2'].User_Id__c;
        system.debug('2nd User Expempted from Contact Delete Approval -->'+user2);
        user3 = [SELECT User_Id__c FROM UsersExemptedForContactDelete__mdt WHERE MasterLabel = 'User 3'].User_Id__c;
        system.debug('3rd User Expempted from Contact Delete Approval -->'+user3);
        //List<UsersExemptedForContactDelete__mdt> usersExemptedFromContactDelete = new List<UsersExemptedForContactDelete__mdt>([SELECT User_Id__c FROM UsersExemptedForContactDelete__mdt]);
        //System.debug('Users Expempted from Contact Delete Approval -->'+usersExemptedFromContactDelete);
	}
 
	public PageReference submitForApproval()
	{
        system.debug('Record Going For Approval Process');
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(recordId);         
        try            
        {            
            Approval.ProcessResult result = Approval.process(req);
        }         
        catch(Exception e)            
        {            
            return null;            
        }        
        return null;        
    }     
}