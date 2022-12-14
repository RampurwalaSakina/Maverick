@isTest
private class LinkedListingRollupTest {

	static Contact createContact(String fname, String lname) {

    	Contact c = new Contact();
    	c.FirstName = fname;
        c.LastName = lname;
    	insert c;

		return c;

	}

    static testMethod void addLinkedListings() {

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
            
 		insert inquiry1;
        
        pba__Listing__c listing1 = new pba__Listing__c();
            listing1.Name = 'Test Listing';
            listing1.pba__Status__c = 'Rented';
            listing1.pba__ListingType__c = 'Rent';
            listing1.pba__PropertyType__c = 'Apartment';
            listing1.pba__PropertySubType_pb__c = 'Residential - Apartment';
            listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
            listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Maverick-2-5329';
            listing1.pba__UnitNumber__c = '2345';
            listing1.pba_uaefields__Furnished__c = 'Yes';
            listing1.pba_uaefields__RERA_Permit_Number__c = '654323';
            listing1.RERA_Expiry_Date__c = date.parse('31/07/2020');
            listing1.pba__Bedrooms_pb__c = 2;
            listing1.pba__FullBathrooms_pb__c = 2;
            listing1.pba__TotalArea_pb__c = 500;
            listing1.pba__Listing_Agent_Firstname__c = 'listing agent first';
            listing1.pba__Listing_Agent_Lastname__c = 'listing agent Last';
            listing1.pba__Listing_Agent_Phone__c = '8765456543';
            listing1.pba__Listing_Agent_Email__c = 'listingagent1@test.com';
            listing1.pba__ListingPrice_pb__c = 5000;
            listing1.pba_uaefields__Propertyfinder_Region__c = 'Abu Dhabi - Al Ghadeer - Al Sabeel Building';
            listing1.pba_uaefields__City_Propertyfinder__c = 'Abu Dhabi';
            listing1.pba_uaefields__Community_Propertyfinder__c = 'Al Ghadeer';
            listing1.pba_uaefields__City_Dubizzle__c = 'Abu Dhabi';
        insert listing1;

    	List<pba__Favorite__c> items = new List<pba__Favorite__c>();

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

    	insert items;

    	// fetch the contacts
    	contactIds.add(Contact1.Id);
    	contactIds.add(Contact2.Id);

    	// query for the contacts
    	Map<id,Contact> contactMap = new Map<id,Contact>([select Id, Count_of_Linked_Listings__c from Contact where Id IN :contactIds]);

    	System.assertEquals(contact1ItemCount+7,contactMap.get(Contact1.Id).Count_of_Linked_Listings__c);
    	System.assertEquals(contact2ItemCount-7,contactMap.get(Contact2.Id).Count_of_Linked_Listings__c);

    	// now update an inventory item
    	items.get(0).pba__Contact__c = null;
    	update items.get(0);

    	// query the contact to find out the total items now
    	Contact contact3 = [select Count_of_Linked_Listings__c from Contact where Id = :Contact1.id];

    	// assert that the contact is one less than the original
    	System.assertEquals(contact1ItemCount-1,contact3.Count_of_Linked_Listings__c-8);

    }
}