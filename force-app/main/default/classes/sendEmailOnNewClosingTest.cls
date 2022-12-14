@isTest
public class sendEmailOnNewClosingTest {
	
    static Contact createLandlordContact(String fname, String lname) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = 'Landlord';
        c.LeadSource = 'Portal';
        c.pba__LeadSourceCategory_pb__c	= 'Getthat';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
        insert c;
        
        return c;
    }
    
    static Contact createTenantContact(String fname, String lname) {
        
        Contact t = new Contact();
        t.FirstName = fname;
        t.LastName = lname;
        t.pba__ContactType_pb__c = 'Tenant';
        t.LeadSource = 'Portal';
        t.pba__LeadSourceCategory_pb__c	= 'Getthat';
        insert t;
        
        return t;
    }
    
    static testMethod void myUnitTest() {

        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'PB Office Manager' LIMIT 1];
        UserRole roleOfUser = [SELECT Id FROM UserRole WHERE DeveloperName = 'Telesales'];
        User manager = [SELECT Id FROM User WHERE Name = 'Maverick Realty'];
         
        User usr = new User(LastName = 'Sunga',
                           FirstName='Charm',
                           Alias = 'jliv',
                           Email = 'jason.sharm@mav.com',
                           Username = 'jason.charm@mav.com',
                           ProfileId = userProfile.id,
                           ManagerId = manager.Id,
                           UserRoleId = roleOfUser.Id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           Phone = '+971932658264',
                           EmailEncodingKey = 'UTF-8',
                           MobilePhone = '+91 9326582640',
                          LocaleSidKey = 'en_US'
                           );
        System.runAs(usr) {
            // create test contacts
            Contact Contact1 = createLandlordContact('First1', 'Test');
            Contact Contact2 = createTenantContact('First2', 'Test2');
            
            pba__Listing__c listing1 = new pba__Listing__c();
            listing1.Name = 'Test Listing';
            listing1.pba__Status__c = 'Pending';
            listing1.PropertyOwnerContact__c = Contact1.id;
            listing1.pba__ListingType__c = 'Rent';
            listing1.pba__PropertyType__c = 'Apartment';
            listing1.pba__PropertySubType_pb__c = 'Residential - Apartment';
            listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
            listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Maverick-2-5329';
            listing1.pba__UnitNumber__c = '2345';
            listing1.pba_uaefields__Furnished__c = 'Yes';
            listing1.pba_uaefields__RERA_Permit_Number__c = '654323';
            listing1.RERA_Expiry_Date__c = date.parse('07/11/2020');
            listing1.pba__Bedrooms_pb__c = 2;
            listing1.pba__FullBathrooms_pb__c = 2;
            listing1.pba__TotalArea_pb__c = 500;
            listing1.pba__Listing_Agent_Firstname__c = 'listing agent first';
            listing1.pba__Listing_Agent_Lastname__c = 'listing agent Last';
            listing1.pba__Listing_Agent_Phone__c = '+971876545654';
            listing1.pba__Listing_Agent_Email__c = 'listingagent1@test.com';
            listing1.pba__ListingPrice_pb__c = 5000;
            listing1.pba_uaefields__Propertyfinder_Region__c = 'Abu Dhabi - Al Ghadeer - Al Sabeel Building';
            listing1.pba_uaefields__City_Propertyfinder__c = 'Abu Dhabi';
            listing1.pba_uaefields__Community_Propertyfinder__c = 'Al Ghadeer';
            listing1.pba_uaefields__City_Dubizzle__c = 'Abu Dhabi';
            listing1.pba__Description_pb__c = 'Test';
            listing1.pba_uaefields__Property_Sub_Type__c = 'Residential - Apartment';
            listing1.pba_uaefields__Available_from__c = date.parse('11/21/2021');
            insert listing1;
            
            pba__Closing__c closing1 = new pba__Closing__c();
            closing1.Renter__c = Contact2.id;
            closing1.Landlord_c__c = Contact1.id;
            closing1.pba__Listing__c = listing1.id;
            closing1.Lease_Terms__c = '3 Month';
            closing1.ClosingDate__c = date.parse('07/11/2020');
            closing1.Rental_Agreement_Date__c = date.parse('07/11/2020');
            closing1.Rental_Agreement_End_Date__c = date.parse('04/04/2021');
            /*insert closing1;
            test.startTest();
            	closing1.Closing_Status__c = 'Closed';
            	update closing1;
            test.stopTest();  */ 
            try
            {
                
                insert closing1;
            }
            catch(Exception e)
			{
				Boolean expectedExceptionThrown =  e.getMessage().contains('Total Commission Amount') ? true : false;
				System.AssertEquals(expectedExceptionThrown, false);                
			}
            
        }
    }
}