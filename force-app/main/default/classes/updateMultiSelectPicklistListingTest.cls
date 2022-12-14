@isTest
public class updateMultiSelectPicklistListingTest {
    static testMethod void  testUpdateMSelectPickField()
    {
		pba__Listing__c ct = new pba__Listing__c(
            Name = 'Brand New 6BR | Pool View | Premium Finish',
            pba__ListingType__c = 'Sale',
            pba__PropertyType__c	 = 'Penthouse',
            pba_uaefields__Property_Sub_Type__c = 'Residential - Apartment',
            pba_uaefields__Broker_s_Listing_ID__c	= '5344',
            pba_uaefields__Broker_s_Listing_ID_2__c = 'pralay-4-5344',
            pba_uaefields__Completion_Status__c	= 'Completed',
            pba_uaefields__Furnished__c	 = 'Yes',
            pba_uaefields__RERA_Permit_Number__c = '23145',
            RERA_Expiry_Date__c = date.newInstance(2020, 12, 16),
            pba__Bedrooms_pb__c	 = 4,
            pba__FullBathrooms_pb__c = 4,
            pba__ListingPrice_pb__c	= 7000,
            pba_uaefields__Private_Amenities__c	= 'Study;Central A/C & Heating;Balcony;Private Garden;Private Pool;Private Gym;Private Jacuzzi;Shared Pool;Shared Spa;Shared Gym',
            pba_uaefields__Commercial_Amenities__c	= 'Available Furnished;Availabe Networked;Shared Gym;Shared Spa;Dining in Building;Retail in Building;View of Water',
            pba_uaefields__Propertyfinder_Region__c	 = 'Test',
            pba_uaefields__City_Propertyfinder__c	= 'Test',
            pba_uaefields__Community_Propertyfinder__c	= 'Test',
            pba_uaefields__City_Dubizzle__c = 'Test');
        Test.startTest();
        	insert ct;  
        Test.stopTest();
    }
}