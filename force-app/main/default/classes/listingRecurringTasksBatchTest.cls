@isTest(SeeAllData=true)
public class listingRecurringTasksBatchTest {    
     
	static Contact createContact(String fname, String lname, String contType) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = contType;
        c.Stage__c = 'New Lead';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
        insert c;
        
        return c;
    }
    
    static testMethod void insertListings() {           
       
        Test.StartTest();            
        listingRecurringTasksBatch m=new listingRecurringTasksBatch();
        Database.executeBatch(m);
        Test.StopTest();
            
    }	
}