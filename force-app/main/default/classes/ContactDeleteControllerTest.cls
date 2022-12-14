@isTest
public class ContactDeleteControllerTest 
{
    static testMethod void  testContactDeleteController()
    {        
        Contact ct = new Contact(lastname='Contact',firstName = 'Test',Approved_for_Deletion__c='No');
        insert ct;
        
        Test.startTest();
            ContactDeleteController deleteController = new ContactDeleteController(new ApexPages.StandardController(new Contact()));         
            deleteController.submitForApproval();
        system.debug('Contact ID-->'+ct.id);
        system.debug('Contact Name-->'+ct.firstname);
        system.debug('Contact Approved for Deletion?-->'+ct.Approved_for_Deletion__c);
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(ct.id);     
        	req1.setSubmitterId(userinfo.getuserid());
            // Submit the approval request for the 
            Approval.ProcessResult result = Approval.process(req1);            
            // Verify the result
            System.assert(result.isSuccess());        
            ct.Approved_for_Deletion__c='Yes';
            update ct;
        Test.stopTest();
    }
}