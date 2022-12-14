@isTest
public class ShowingOnContactRollupTest {
    
	static Contact createContact(String fname, String lname) {

    	Contact c = new Contact();
    	c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = 'Landlord';
        c.Count_of_Showing_still_Active__c = 0.0;
    	insert c;
		return c;
	}
    
    static testMethod void addListings() {
    	Set<id> contactIds = new Set<id>();
    	Integer contact1ItemCount = 1;
        // create test contacts
    	Contact Contact1 = createContact('First1', 'Test');
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst1', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649',
            TimeZoneSidKey='America/Los_Angeles', UserName='standtest1@mavtestorg.com');
        Insert u;
        
        List<Event> items = new List<Event>();

    	for (Integer i=0;i<contact1ItemCount;i++) {

			Event evnt = new Event();
            evnt.Subject = 'Showing for howardchoys record can be deleted';
        	evnt.OwnerId = u.Id;
        	evnt.Type = 'Showing';
        	evnt.WhoId = contact1.Id;
        	evnt.StartDateTime = datetime.newInstance(2021, 12, 30, 12, 30, 0);
        	evnt.EndDateTime = datetime.newInstance(2021, 12, 31, 12, 30, 0);
        	evnt.Location = 'Test Location';
        	evnt.Description = 'Test Description';
			items.add(evnt);

    	}
        insert items;
        
        // fetch the contacts
    	contactIds.add(Contact1.Id);
        system.debug('Event Created --->'+items);
        
        // query for the contacts
    	Map<id,Contact> contactMap = new Map<id,Contact>([select Id, Count_of_Showing_still_Active__c from Contact where Id IN :contactIds]);

    	System.assertEquals(contact1ItemCount,contactMap.get(Contact1.Id).Count_of_Showing_still_Active__c);
		system.debug('Event Id-->'+items.get(0));
    	// now update an inventory item
    	items.get(0).WhoId = null;
    	update items.get(0);

    	// query the contact to find out the total items now
    	Contact contact3 = [select Count_of_Showing_still_Active__c from Contact where Id = :Contact1.id];

    	// assert that the contact is one less than the original
    	System.assertEquals(contact1ItemCount-1,contact3.Count_of_Showing_still_Active__c);
        
    }
    

}