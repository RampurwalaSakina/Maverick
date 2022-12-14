@isTest
public class InquiryRollupToContactTest {

    	static Contact createContact(String fname, String lname) {

    	Contact c = new Contact();
    	c.FirstName = fname;
        c.LastName = lname;
    	insert c;

		return c;

	}

    static testMethod void addInquiry() {

    	Set<id> contactIds = new Set<id>();
    	Integer contact1ItemCount = 10;
    	Integer contact2ItemCount = 7;
        
        // create test contacts
    	Contact Contact1 = createContact('First1', 'Test');
    	Contact Contact2 = createContact('First2', 'Test');
        
        pba__Request__c inquiry1 = new pba__Request__c();
            inquiry1.pba__Contact__c = Contact1.id;
            inquiry1.pba__Type_pb__c = 'Buyer';
            inquiry1.pba__ListingType__c = 'Sale';
            inquiry1.pba__PropertyType__c = 'Villa';
            inquiry1.City__c = 'Dubai';
            inquiry1.pba__PropertyStatus_pb__c = 'Active';
            inquiry1.Area__c = 'Al Safa';
            inquiry1.pba__ListingPrice_pb_min__c = 1000;
            inquiry1.pba__ListingPrice_pb_max__c = 2000;
            inquiry1.pba_uaefields__Furnished__c = 'Yes';
            inquiry1.pba__Bedrooms_pb_min__c= 3;
        	inquiry1.pba__Status__c= 'Active';
            
 		insert inquiry1;

    	/*List<pba__Favorite__c> items = new List<pba__Favorite__c>();

    	for (Integer i=0;i<contact1ItemCount;i++) {

			pba__Favorite__c item = new pba__Favorite__c();
			item.pba__Listing__c = listing1.id;
			item.pba__Request__c = inquiry1.Id;

			items.add(item);

    	}

    	for (Integer i=0;i<contact2ItemCount;i++) {

			pba__Favorite__c item = new pba__Favorite__c();
			item.pba__Listing__c = listing1.id;
			item.pba__Request__c = inquiry1.Id;

			items.add(item);

    	}

    	insert items;*/

    	// fetch the contacts
    	contactIds.add(Contact1.Id);
    	contactIds.add(Contact2.Id);

    	// query for the contacts
    	Map<id,Contact> contactMap = new Map<id,Contact>([select Id, Count_of_Inquiry__c from Contact where Id IN :contactIds]);

    	System.assertEquals(1,contactMap.get(Contact1.Id).Count_of_Inquiry__c);
    	//System.assertEquals(contact2ItemCount-7,contactMap.get(Contact2.Id).Count_of_Linked_Listings__c);

    	// now update an inventory item
    	inquiry1.pba__Contact__c = Contact2.Id;
    	update inquiry1;

    	// query the contact to find out the total items now
    	Contact contact3 = [select Count_of_Inquiry__c from Contact where Id = :Contact1.id];

    	// assert that the contact is one less than the original
    	System.assertEquals(0,contact3.Count_of_Inquiry__c);

    }
    
}