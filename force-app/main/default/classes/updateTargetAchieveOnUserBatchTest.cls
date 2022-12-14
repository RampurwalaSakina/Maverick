@isTest
private class updateTargetAchieveOnUserBatchTest {
   
    static Contact createLandlordContact(String fname, String lname) {
        
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
    
    static Contact createTenantContact(String fname, String lname) {
        
        Contact t = new Contact();
        t.FirstName = fname;
        t.LastName = lname;
        t.pba__ContactType_pb__c = 'Tenant';
        t.LeadSource = 'Portal';
        t.pba__LeadSourceCategory_pb__c  = 'Getthat';
        t.MailingStreet = 'Test';
        t.MailingCity = 'Test';
        t.MailingCountry = 'India';
        insert t;
        
        return t;
    }
    
    static testMethod void TestUpdateTargetAchieveOnUserBatch() {
        
        
        Date firstDayOfMonth = System.today().toStartOfMonth();
        System.debug('First Day of the Month-->'+firstDayOfMonth);
        Profile p = [SELECT Id FROM Profile WHERE Name='PB Agent'];
        User manager = [SELECT Id FROM User WHERE Name = 'Maverick Realty'];
        system.debug('Profile Id -->'+p.Id);
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com',ManagerId = manager.Id);
        Insert u;
        system.debug('User Created-->'+u.Id);
        
        User agentUser = [SELECT Id, Email, Phone, FirstName, LastName, Alias FROM User WHERE ProfileId = '00e4J000001DjG1' AND IsActive = True LIMIT 1];
        system.debug('User Email From Org-->'+agentUser.Email);
        system.debug('User Phone From Org-->'+agentUser.Phone);
        System.runAs(agentUser){
            // create test contacts
            Contact Contact1 = createLandlordContact('First1', 'Test1');
            Contact Contact2 = createTenantContact('First2', 'Test2');         
            
            /*List <Contact> contacts = new List <Contact>();
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
            listing1.RERA_Expiry_Date__c = Date.newInstance(2021, 12, 9);
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
            listing1.pba__Description_pb__c = 'Test';
            listing1.pba_uaefields__Property_Sub_Type__c = 'Residential - Apartment';
            listing1.pba_uaefields__Available_from__c = Date.newInstance(2021, 07, 07);
        	insert listing1;
            
            pba__Closing__c closing1 = new pba__Closing__c();
            closing1.Renter__c = Contact2.id;
            closing1.Landlord_c__c = Contact1.id;
            closing1.pba__Listing__c = listing1.id;
            closing1.Lease_Terms__c = '3 Month';
            closing1.ClosingDate__c = Date.newInstance(2021, 05, 05);
            closing1.Rental_Agreement_Date__c = Date.newInstance(2021, 05, 05);
            closing1.Rental_Agreement_End_Date__c = Date.newInstance(2021, 06, 06);
            closing1.Agent_Commission__c = 1000;
            closing1.Closing_Status__c = 'Closed';
            insert closing1;*/
            
            pba__Listing__c listing1 = new pba__Listing__c();
            listing1.Name = 'Test Listing';
            listing1.pba__Status__c = 'Pending';
            listing1.PropertyOwnerContact__c = Contact1.id;
            listing1.pba__ListingType__c = 'Rent';
            listing1.pba__PropertyType__c = 'Apartment';
            listing1.pba__PropertySubType_pb__c = 'Residential - Apartment';
            listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
            listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Waseem-2-5329';
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
            listing1.pba_uaefields__Available_from__c = date.parse('09/09/2021');
            listing1.pba_uaefields__Building_Dubizzle__c = 'Test';
            insert listing1;
            system.debug('Listing Created-->'+listing1);
            
            pba__Closing__c closing1 = new pba__Closing__c();
            closing1.Renter__c = Contact2.id;
            closing1.Landlord_c__c = Contact1.id;
            closing1.pba__Listing__c = listing1.id;
            closing1.Lease_Terms__c = '3 Month';
            closing1.ClosingDate__c = Date.newInstance(2021, 08, 28);
            closing1.Rental_Agreement_Date__c = date.parse('07/11/2021');
            closing1.Rental_Agreement_End_Date__c = date.parse('10/10/2021');
            closing1.Closing_Status__c = 'Closed';
            closing1.Agent_Commission__c = 1000;
            closing1.TotalCommissionAmount__c = 1000;
            closing1.OwnerId = agentUser.Id;
            
            pba__Closing__c closing2 = new pba__Closing__c();
            closing2.Renter__c = Contact2.id;
            closing2.Landlord_c__c = Contact1.id;
            closing2.pba__Listing__c = listing1.id;
            closing2.Lease_Terms__c = '3 Month';
            closing2.ClosingDate__c = Date.newInstance(2021, 05, 18);
            closing2.Rental_Agreement_Date__c = date.parse('07/11/2021');
            closing2.Rental_Agreement_End_Date__c = date.parse('09/09/2021');
            closing2.Closing_Status__c = 'Closed';
            closing1.TotalCommissionAmount__c = 3000;
            closing2.Agent_Commission__c = 2000;
            closing2.OwnerId = agentUser.Id;
            
            system.debug('1st Closing Created-->'+closing1);
            system.debug('2nd Closing Created-->'+closing2);
            system.debug('1st Closing Close Date-->'+closing1.ClosingDate__c);            
            system.debug('2nd Closing Close Date-->'+closing2.ClosingDate__c);
            system.debug('Closing Owner Id-->'+closing1.OwnerId);
            
            Test.StartTest();
            
            	insert closing1;
                insert closing2;    
            // Call the Batch Apex method.
                updateTargetAchieveOnUserBatch fue = new updateTargetAchieveOnUserBatch();
                ID batchprocessid = Database.executeBatch(fue);
                
            Test.StopTest();
        }
    }
    
}