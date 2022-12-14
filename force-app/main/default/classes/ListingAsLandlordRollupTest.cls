@isTest
public class ListingAsLandlordRollupTest {


	static Contact createContact(String fname, String lname) {

    	Contact c = new Contact();
    	c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = 'Landlord';

        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
    	insert c;

		return c;

	}

    static testMethod void addListings() {
        
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='cyril@maverickrealty.ae', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;


        System.runAs(u) {


    	Set<id> contactIds = new Set<id>();
    	Integer contact1ItemCount = 1;
    	Integer contact2ItemCount = 1;
        
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
        
        
        
        Id ListingTypeId = Schema.SObjectType.pba__Listing__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
        pba__Listing__c listing1 = new pba__Listing__c();
        listing1.Name = 'Test Listing';
        listing1.RecordTypeId = ListingTypeId;
        listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
        listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Waseem-2-5329';
        listing1.pba__Broker_s_Listing_ID__c =listing1.autonumber_test__c;
                	listing1.PropertyOwnerContact__c = Contact1.id;

        insert listing1;
        }


    }
}