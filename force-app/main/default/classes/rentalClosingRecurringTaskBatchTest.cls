@isTest
public class rentalClosingRecurringTaskBatchTest {
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
    static Contact createContact(String fname, String lname) {

    	Contact c = new Contact();
    	c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = 'Landlord';
        c.MailingStreet='test';
        c.MailingCity='test';
        c.MailingState='tes';
        c.MailingPostalCode='3562';
        c.MailingCountry ='test2671';
    	insert c;

		return c;

	}

    
    static testMethod void myUnitTest() {
       
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='cyril@maverickrealty.ae', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;


        System.runAs(u) {

        Id closingTypeId = Schema.SObjectType.pba__Closing__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
        Contact Contact1 = createTenantContact('First1', 'Test1');

        Id ListingTypeId = Schema.SObjectType.pba__Listing__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
 
        pba__Listing__c listing1 = new pba__Listing__c();
        listing1.Name = 'Test Listing';
        listing1.RecordTypeId = ListingTypeId;
        listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
        listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Waseem-2-5329';
        listing1.pba__Broker_s_Listing_ID__c =listing1.autonumber_test__c;


       
        insert listing1;


        listing1.pba__Status__c='Pending';
        listing1.pba__SystemHasExclusiveOffer__c =true;
        listing1.pba__SystemHasAcceptedOffer__c=true;
        listing1.pba__Bedrooms_pb__c = 2;
        listing1.pba__SystemAllowedForPortals__c=false;
        listing1.pba__Description_pb__c ='test';
        listing1.pba__ListingPrice_pb__c = 100000;
        listing1.pba_uaefields__Property_Sub_Type__c  ='Residential - Bulk Units';
        listing1.pba_uaefields__RERA_Permit_Number__c ='654322';
        listing1.pba__Bedrooms_pb__c = 2;
        listing1.pba__FullBathrooms_pb__c = 2;
        listing1.pba__TotalArea_pb__c = 500;
        listing1.pba_uaefields__Propertyfinder_Region__c = 'Abu Dhabi - Al Ghadeer - Al Sabeel Building';
        listing1.pba_uaefields__City_Propertyfinder__c = 'Abu Dhabi';
        listing1.pba_uaefields__Community_Propertyfinder__c = 'Al Ghadeer';
        listing1.pba_uaefields__City_Dubizzle__c = 'Abu Dhabi';
        listing1.pba_uaefields__Building_Dubizzle__c = 'Test';


    update listing1;

    List<pba__Closing__c> closingList = new List<pba__Closing__c>();


        pba__Closing__c closing1 = new pba__Closing__c();
        closing1.Renter__c = Contact1.id;
        // closing1.Landlord_c__c = Contact1.id;
        closing1.pba__Listing__c = listing1.id;
        closing1.Lease_Terms__c = '3 Month';
        closing1.ClosingDate__c = Date.Today().addDays(90);
        closing1.Rental_Agreement_Date__c = Date.Today().addDays(-1);
        closing1.Rental_Agreement_End_Date__c = Date.Today().addDays(90);
        closing1.Closing_Status__c = 'Closed';
        closing1.Agent_Commission__c = 1000;
        closing1.TotalCommissionAmount__c = 1000;
        closing1.RecordTypeId=closingTypeId;
        // closing1.OwnerId=u.Id;


        closingList.add(closing1);

        pba__Closing__c closing2 = new pba__Closing__c();
        closing2.Renter__c = Contact1.id;
        closing2.pba__Listing__c = listing1.id;
        closing2.Lease_Terms__c = '9 Month';
        closing2.ClosingDate__c = Date.Today();
        closing2.Rental_Agreement_Date__c = Date.Today().addDays(-1);
        closing2.Rental_Agreement_End_Date__c = Date.Today().addDays(90);
        closing2.RecordTypeId=closingTypeId;
        closing2.Building_Name__c =listing1.pba_uaefields__Building_Dubizzle__c;
        // closing2.OwnerId=u.Id;


    closingList.add(closing2);

    pba__Closing__c closing3 = new pba__Closing__c();
    closing3.Renter__c = Contact1.id;
    closing3.pba__Listing__c = listing1.id;
    closing3.Lease_Terms__c = '9 Month';
    closing3.ClosingDate__c = Date.Today();
    closing3.Rental_Agreement_Date__c = Date.Today().addDays(-1);
    closing3.Rental_Agreement_End_Date__c = Date.Today().addDays(90);
    closing3.RecordTypeId=closingTypeId;
    closing3.Building_Name__c =listing1.pba_uaefields__Building_Dubizzle__c;
    // closing3.OwnerId=u.Id;


closingList.add(closing3);


Date todayPlusFortyFiveDays = Date.Today().addDays(90);


            Test.StartTest();
            insert closingList;
            List<pba__Closing__c>  clist=[SELECT Id, RecordType.Name, Renter__c , Rental_Agreement_End_Date__c, OwnerId FROM pba__Closing__c];
            System.debug(clist);
            // insert closing2;



            rentalClosingRecurringTaskBatch rentalClosing = new rentalClosingRecurringTaskBatch();
            ID batchprocessid = Database.executeBatch(rentalClosing, 1900);
            
            Test.StopTest();
        }
        
    
    }


    static testMethod void myUnitTest2() {
       
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='cyril@maverickrealty.ae', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;



        Id closingTypeId = Schema.SObjectType.pba__Closing__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
        Contact Contact1 = createTenantContact('First1', 'Test1');

        Id ListingTypeId = Schema.SObjectType.pba__Listing__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
 
        pba__Listing__c listing1 = new pba__Listing__c();
        listing1.Name = 'Test Listing';
        listing1.RecordTypeId = ListingTypeId;
        listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
        listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Waseem-2-5329';
        listing1.pba__Broker_s_Listing_ID__c =listing1.autonumber_test__c;


       
        insert listing1;


        listing1.pba__Status__c='Pending';
        listing1.pba__SystemHasExclusiveOffer__c =true;
        listing1.pba__SystemHasAcceptedOffer__c=true;
        listing1.pba__Bedrooms_pb__c = 2;
        listing1.pba__SystemAllowedForPortals__c=false;
        listing1.pba__Description_pb__c ='test';
        listing1.pba__ListingPrice_pb__c = 100000;
        listing1.pba_uaefields__Property_Sub_Type__c  ='Residential - Bulk Units';
        listing1.pba_uaefields__RERA_Permit_Number__c ='654322';
        listing1.pba__Bedrooms_pb__c = 2;
        listing1.pba__FullBathrooms_pb__c = 2;
        listing1.pba__TotalArea_pb__c = 500;
        listing1.pba_uaefields__Propertyfinder_Region__c = 'Abu Dhabi - Al Ghadeer - Al Sabeel Building';
        listing1.pba_uaefields__City_Propertyfinder__c = 'Abu Dhabi';
        listing1.pba_uaefields__Community_Propertyfinder__c = 'Al Ghadeer';
        listing1.pba_uaefields__City_Dubizzle__c = 'Abu Dhabi';
        listing1.pba_uaefields__Building_Dubizzle__c = 'Test';


    update listing1;

    List<pba__Closing__c> closingList = new List<pba__Closing__c>();


        pba__Closing__c closing1 = new pba__Closing__c();
        closing1.Renter__c = Contact1.id;
        // closing1.Landlord_c__c = Contact1.id;
        closing1.pba__Listing__c = listing1.id;
        closing1.Lease_Terms__c = '3 Month';
        closing1.ClosingDate__c = Date.Today().addDays(90);
        closing1.Rental_Agreement_Date__c = Date.Today().addDays(-1);
        closing1.Rental_Agreement_End_Date__c = Date.Today().addDays(90);
        closing1.Closing_Status__c = 'Closed';
        closing1.Agent_Commission__c = 1000;
        closing1.TotalCommissionAmount__c = 1000;
        closing1.RecordTypeId=closingTypeId;
        // closing1.OwnerId=u.Id;


        closingList.add(closing1);

        pba__Closing__c closing2 = new pba__Closing__c();
        closing2.Renter__c = Contact1.id;
        closing2.pba__Listing__c = listing1.id;
        closing2.Lease_Terms__c = '9 Month';
        closing2.ClosingDate__c = Date.Today();
        closing2.Rental_Agreement_Date__c = Date.Today().addDays(-1);
        closing2.Rental_Agreement_End_Date__c = Date.Today().addDays(90);
        closing2.RecordTypeId=closingTypeId;
        closing2.Building_Name__c =listing1.pba_uaefields__Building_Dubizzle__c;
        // closing2.OwnerId=u.Id;


    closingList.add(closing2);

    pba__Closing__c closing3 = new pba__Closing__c();
    closing3.Renter__c = Contact1.id;
    closing3.pba__Listing__c = listing1.id;
    closing3.Lease_Terms__c = '9 Month';
    closing3.ClosingDate__c = Date.Today();
    closing3.Rental_Agreement_Date__c = Date.Today().addDays(-1);
    closing3.Rental_Agreement_End_Date__c = Date.Today().addDays(90);
    closing3.RecordTypeId=closingTypeId;
    closing3.Building_Name__c =listing1.pba_uaefields__Building_Dubizzle__c;
    // closing3.OwnerId=u.Id;


closingList.add(closing3);


Date todayPlusFortyFiveDays = Date.Today().addDays(90);


            Test.StartTest();
            insert closingList;
            List<pba__Closing__c>  clist=[SELECT Id, RecordType.Name, Renter__c , Rental_Agreement_End_Date__c, OwnerId FROM pba__Closing__c];
            System.debug(clist);
            // insert closing2;



            rentalClosingRecurringTaskBatch rentalClosing = new rentalClosingRecurringTaskBatch();
            ID batchprocessid = Database.executeBatch(rentalClosing, 1900);
            
            Test.StopTest();
        }
        
    
    
    
}