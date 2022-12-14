@IsTest
public class FieldCheckForApprovalTest {

    static testMethod void addListing() {     
        //List<pba__Listing__c> lc = new List <pba__Listing__c>();
        pba__Listing__c listing1 = new pba__Listing__c();
            listing1.Name = 'Test Listing';
            listing1.pba__Status__c = 'Pending';
        	listing1.pba_uaefields__Property_Sub_Type__c = 'Residential - Apartment';
            listing1.pba__ListingType__c = 'Rent';
            listing1.pba__PropertyType__c = 'Apartment';
            listing1.pba__PropertySubType_pb__c = 'Residential - Apartment';
            listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
            listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Maverick-2-5329';
            listing1.pba__UnitNumber__c = '2345';
         	listing1.pba_uaefields__Number_Of_Cheques__c='2';
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
        	listing1.Is_the_Listing_Approved__c=False;
        	listing1.pba__Description_pb__c='Test Description';
            listing1.pba_uaefields__LocationText_Dubizzle__c ='Abu';
            listing1.pba_uaefields__Completion_Status__c ='Completed';
            listing1.CompletionStatus__c ='Finished';
            listing1.pba__CompletionStatus_pb__c ='Finished';
        
        	insert listing1;
        
        
           /* listing1.pba__ListingPrice_pb__c = 6000;
        	listing1.Is_the_Listing_Approved__c=True;
        	listing1.Bayut_Boost__c='Hot';
        	listing1.pba_uaefields__Sub_Community_Propertyfinder__c='Test Location';
                                          
        update listing1;*/
        
        Test.startTest();  
			try
			{
                listing1.pba__ListingPrice_pb__c = 6000;
                listing1.Is_the_Listing_Approved__c=True;
                listing1.pba_uaefields__Sub_Community_Propertyfinder__c='Test Location';
                                              
                update listing1;       
			}
			catch(Exception e)
			{
				Boolean expectedExceptionThrown =  e.getMessage().contains('You must select a value for the field Bayut Boost in order to approve this Listing.') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);                
			}
		Test.stopTest(); 
    }
}