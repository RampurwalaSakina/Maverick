@IsTest
public class TaskTriggerTest {
    @isTest 
    static void myTest() {
        TaskTriggerHandler.changeStatus(New List<Task>());
        TaskTriggerHandler.recursionController= false;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {
            Contact con =new Contact();
            con.LastName='test';
            con.Email='test@test.com';
            con.pba__ContactType_pb__c = 'Property Management Company';
            con.Stage__c = 'Active';
            con.MailingStreet = 'Test';
            con.MailingCity = 'Test';
            con.MailingCountry = 'India';
            con.LeadSource = 'Open House';
            con.MobilePhone ='11122222222'; 
            insert con;
            
            Id ListingTypeId = Schema.SObjectType.pba__Listing__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
    
            pba__Listing__c listing1 = new pba__Listing__c();
            listing1.Name = 'Test Listing';
            listing1.RecordTypeId = ListingTypeId;
            listing1.pba_uaefields__Broker_s_Listing_ID__c = '1234';
            listing1.pba_uaefields__Broker_s_Listing_ID_2__c = 'Waseem-2-5329';
            listing1.pba__Broker_s_Listing_ID__c =listing1.autonumber_test__c;
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
            listing1.pba_uaefields__Available_from__c=Date.today().addDays(7);
            // listing1.PropertyOwnerContact__c=con.Id;
            insert listing1;
           
       
            List <Task> tasks = new List <Task>();
                
            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            // tsk1.WhatId           = null;
            tsk1.ActivityDate     = System.today().addDays(-30);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Check Updates';
            // tsk1.Is_the_Property_still_with_Landlord__c='Available';
            tasks.add(tsk1);   
            insert tasks;

            tasks[0].WhatId= listing1.Id;
             update tasks;
            
        }

    }
}