@isTest(seeAllData=True)
public class historicalSalesTargetBatchTest {
    static Contact createContact(String fname, String lname) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = 'Landlord';
        c.LeadSource = 'Portal';
        c.pba__LeadSourceCategory_pb__c  = 'Getthat';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
        insert c;
        
        return c;
    
    }
    
    static testMethod void myUnitTest() {
        
        Test.StartTest();
        
            // Call the Batch Apex method.
            historicalSalesTargetBatch fue = new historicalSalesTargetBatch();
            ID batchprocessid = Database.executeBatch(fue);
        
        Test.StopTest();
    }
}