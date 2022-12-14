@isTest
public class NoDeleteonTaskTest {
	
    static Contact createContact(String fname, String lname) {

    	Contact c = new Contact();
    	c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = 'Landlord';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Tetst';
        c.MailingCountry = 'India';
    	insert c;

		return c;

	}
    
    static testMethod void addTask() {
        // create test contacts
    	Contact Contact1 = createContact('First1', 'Test');
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'PB Office Manager' LIMIT 1];
         
        User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@mav.com',
                           Username = 'jason.liveston@mav.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           MobilePhone = '+91 9326582649',
                           Phone = '+919326582649',
                           LocaleSidKey = 'en_US'
                           );
        System.runAs(usr) {
        Task task1 = new Task();
        task1.Subject = 'Delete Task Test';
        task1.Priority = 'High';
        task1.Status = 'Not Started';
        task1.Contact__c = Contact1.id;
        
        insert task1;
        
        
            Task tsk =[SELECT Id from Task where Subject = 'Delete Task Test'];
            
            try
			{
				Delete 	tsk;
			}
			catch(Exception ee)
			{}
            //delete tsk;
        }
        
    }
}