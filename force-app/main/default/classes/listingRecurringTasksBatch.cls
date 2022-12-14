global class listingRecurringTasksBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        if(Test.isRunningTest()){
            System.debug('Test Class Method');
            
            //Collect the batches of Listing records to be passed to execute
            String query = 'SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE PropertyOwnerContact__c <> null AND pba__Status__c IN (\'Active\', \'Pending\') AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES  (\'Seller\', \'Landlord\', \'Developer\', \'Property Management Company\') LIMIT 1900';
            return Database.getQueryLocator(query);
        }else{ 
            System.debug('Normal Schedule Run'); 
            
            //Below Query is for testin purpose, need to delete it at time of deployment to prod.
            //String query = 'SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE Id IN (\'0033H000002p2KNQAY\')  AND PropertyOwnerContact__c <> null AND pba__Status__c IN (\'Active\', \'Pending\')';
            
            //Collect the batches of Listing records to be passed to execute
            String query = 'SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE PropertyOwnerContact__c <> null AND pba__Status__c IN (\'Active\', \'Pending\') AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES  (\'Seller\', \'Landlord\', \'Developer\', \'Property Management Company\')';
            return Database.getQueryLocator(query);
        }
    }
     
    global void execute(Database.BatchableContext BC, List<pba__Listing__c> listingList) {
                 
          Date todayMinusThirtyDays = Date.Today().addDays(-30);
          Date todayMinusTwentyOneDays = Date.Today().addDays(-21);
          Date todayMinusTwentyEightDays = Date.Today().addDays(-28);
          Date todayMinusFortyFiveDays = Date.Today().addDays(-45);

      /* Date todayMinusThirtyDays = Date.Today();
       Date todayMinusTwentyOneDays = Date.Today();
        Date todayMinusTwentyEightDays = Date.Today();
        Date todayMinusFortyFiveDays = Date.Today();
        */       
        system.debug('Date Thirty days earlier from Today-->'+todayMinusThirtyDays);
        system.debug('Date Twenty One days earlier from Today-->'+todayMinusTwentyOneDays);
        system.debug('Date Twenty Eight days earlier from Today-->'+todayMinusTwentyEightDays);
        system.debug('Date Forty Five days earlier from Today-->'+todayMinusFortyFiveDays);
        system.debug('Query Results = ' + listingList);
        
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> listingIdSet = new Set<Id>();
    
        for(pba__Listing__c listing : listingList){
            if (listing.PropertyOwnerContact__c != null) {
                contactIdSet.add(listing.PropertyOwnerContact__c);
            }
            listingIdSet.add(listing.Id);
        }
        System.debug('Value in Contact Set--->'+contactIdSet);
        System.debug('Value in Listing Set--->'+listingIdSet);
        
        //Below is the Original query.
        List<pba__Listing__c> landPMCListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE pba__ListingType__c = 'Rent' AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Landlord;Property Management Company') AND Id IN :listingIdSet]);
        //The below is query for testing
        //List<pba__Listing__c> landPMCListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Landlord;Property Management Company') AND Id IN :listingIdSet]);
        System.debug('Value in Listing Set with Property Owner Contact Type both Landlord and PMC --->'+landPMCListingList);
        
        List<pba__Listing__c> onlyLandlordListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE pba__ListingType__c = 'Rent' AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Landlord') AND PropertyOwnerContact__r.pba__ContactType_pb__c EXCLUDES ('Property Management Company') AND Id IN :listingIdSet]);
        System.debug('Value in Listing Set with Property Owner Contact Type Only Landlord --->'+onlyLandlordListingList);
        
        List<pba__Listing__c> onlyPMCListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE pba__ListingType__c = 'Rent' AND PropertyOwnerContact__r.pba__ContactType_pb__c EXCLUDES ('Landlord') AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Property Management Company') AND Id IN :listingIdSet]);
        System.debug('Value in Listing Set with Property Owner Contact Type Only PMC --->'+onlyPMCListingList);
        
        List<pba__Listing__c> sellerDevListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE pba__ListingType__c = 'Sale' AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Seller;Developer') AND Id IN :listingIdSet]);
        System.debug('Value in Listing Set with Property Owner Contact Type both Seller and Developer --->'+sellerDevListingList);
        
        List<pba__Listing__c> onlySellerListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE pba__ListingType__c = 'Sale' AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Seller') AND PropertyOwnerContact__r.pba__ContactType_pb__c EXCLUDES ('Developer') AND Id IN :listingIdSet]);
        System.debug('Value in Listing Set with Property Owner Contact Type Only Seller --->'+onlySellerListingList);
        
        List<pba__Listing__c> onlyDeveloperListingList = new List<pba__Listing__c>([SELECT Id, pba__ListingType__c, pba__Status__c, PropertyOwnerContact__r.pba__ContactType_pb__c FROM pba__Listing__c WHERE pba__ListingType__c = 'Sale' AND PropertyOwnerContact__r.pba__ContactType_pb__c EXCLUDES ('Seller') AND PropertyOwnerContact__r.pba__ContactType_pb__c INCLUDES ('Developer') AND Id IN :listingIdSet]);
        System.debug('Value in Listing Set with Property Owner Contact Type Only Developer --->'+onlyDeveloperListingList);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type both Landlord and PMC
        Set<Id> listingIdsLandPMCAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :landPMCListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type both Landlord and PMC whose Due Date is in Future
        Set<Id> listingIdsLandPMCFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :landPMCListingList AND ActivityDate > :todayMinusTwentyEightDays
            GROUP BY WhatId]).keySet();
        
        system.debug('Listings with All Task where Property Owner Contact Type both Landlord and PMC-->'+listingIdsLandPMCAllTask);
        system.debug('Listings with Future Task where Property Owner Contact Type both Landlord and PMC-->'+listingIdsLandPMCFutureTask);
        
        if(!listingIdsLandPMCFutureTask.isEmpty()){
            for(Id objId: listingIdsLandPMCFutureTask){
                if(listingIdsLandPMCAllTask.contains(objId))
                    listingIdsLandPMCAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type both Landlord and PMC for which Recurring Task needs to be Created-->'+listingIdsLandPMCAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Landlord
        Set<Id> listingIdsLandlordAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyLandlordListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Landlord whose Due Date is in Future
        Set<Id> listingIdsLandlordFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyLandlordListingList AND ActivityDate > :todayMinusTwentyOneDays
            GROUP BY WhatId]).keySet();
        
        system.debug('Listings with All Task where Property Owner Contact Type is only Landlord-->'+listingIdsLandlordAllTask);
        system.debug('Listings with Future Task where Property Owner Contact Type is only Landlord-->'+listingIdsLandlordFutureTask);
        
        if(!listingIdsLandlordFutureTask.isEmpty()){
            for(Id objId: listingIdsLandlordFutureTask){
                if(listingIdsLandlordAllTask.contains(objId))
                    listingIdsLandlordAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only Landlord for which Recurring Task needs to be Created-->'+listingIdsLandlordAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only PMC       
        Set<Id> listingIdsPMCAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyPMCListingList
            GROUP BY WhatId]).keySet();
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only PMC whose Due Date is in Future
        Set<Id> listingIdsPMCFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyPMCListingList AND ActivityDate > :todayMinusTwentyEightDays
            GROUP BY WhatId]).keySet();
        
        system.debug('Listings with All Task where Property Owner Contact Type is only PMC-->'+listingIdsPMCAllTask);
        system.debug('Listings with Future Task where Property Owner Contact Type is only PMC-->'+listingIdsPMCFutureTask);
        
        if(!listingIdsPMCFutureTask.isEmpty()){
            for(Id objId: listingIdsPMCFutureTask){
                if(listingIdsPMCAllTask.contains(objId))
                    listingIdsPMCAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only PMC for which Recurring Task needs to be Created-->'+listingIdsPMCAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type both Seller and Developer
        Set<Id> listingIdsSellDevAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :sellerDevListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type both Seller and Developer whose Due Date is in Future
        Set<Id> listingIdsSellDevFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :sellerDevListingList AND ActivityDate > :todayMinusFortyFiveDays
            GROUP BY WhatId]).keySet();
        
        system.debug('Listings with All Task where Property Owner Contact Type both Seller and Developer-->'+listingIdsSellDevAllTask);
        system.debug('Listings with Future Task where Property Owner Contact Type both Seller and Developer-->'+listingIdsSellDevFutureTask);
        
        if(!listingIdsSellDevFutureTask.isEmpty()){
            for(Id objId: listingIdsSellDevFutureTask){
                if(listingIdsSellDevAllTask.contains(objId))
                    listingIdsSellDevAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type both Seller and Developer for which Recurring Task needs to be Created-->'+listingIdsSellDevAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Seller
        Set<Id> listingIdsSellerAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlySellerListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Seller whose Due Date is in Future
        Set<Id> listingIdsSellerFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlySellerListingList AND ActivityDate > :todayMinusThirtyDays
            GROUP BY WhatId]).keySet();
        
        system.debug('Listings with All Task where Property Owner Contact Type is only Seller-->'+listingIdsSellerAllTask);
        system.debug('Listings with Future Task where Property Owner Contact Type is only Seller-->'+listingIdsSellerFutureTask);
        
        if(!listingIdsSellerFutureTask.isEmpty()){
            for(Id objId: listingIdsSellerFutureTask){
                if(listingIdsSellerAllTask.contains(objId))
                    listingIdsSellerAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only Seller for which Recurring Task needs to be Created-->'+listingIdsSellerAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Developer
        Set<Id> listingIdsDeveloperAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyDeveloperListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Developer whose Due Date is in Future
        Set<Id> listingIdsDeveloperFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyDeveloperListingList AND ActivityDate > :todayMinusFortyFiveDays
            GROUP BY WhatId]).keySet();
        
        system.debug('Listings with All Task where Property Owner Contact Type is only Developer-->'+listingIdsDeveloperAllTask);
        system.debug('Listings with Future Task where P                                                                   roperty Owner Contact Type is only Developer-->'+listingIdsDeveloperFutureTask);
        
        if(!listingIdsDeveloperFutureTask.isEmpty()){
            for(Id objId: listingIdsDeveloperFutureTask){
                if(listingIdsDeveloperAllTask.contains(objId))
                    listingIdsDeveloperAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only Developer for which Recurring Task needs to be Created-->'+listingIdsDeveloperAllTask);
        
        List <Task> taskList = new List<Task>();
        
        //Create Task for Listings where Property Owner Contact Type is both Landlord and PMC
        if(!listingIdsLandPMCAllTask.isEmpty()){
            Map<Id, pba__Listing__c> listingIdsLandPMCIdMap = new Map<Id, pba__Listing__c>([
                SELECT Id, OwnerId FROM pba__Listing__c
                WHERE Id IN :listingIdsLandPMCAllTask]);
            system.debug('Value in Map of Listings where Property Owner Contact Type is both Landlord and PMC-->'+listingIdsLandPMCIdMap);
            system.debug('Listing to Iterate where Property Owner Contact Type is both Landlord and PMC-->'+listingIdsLandPMCIdMap.keySet());
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsLandPMCIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsLandPMCIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsLandPMCIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsLandPMCIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';                
                taskList.add(tsk);
                System.debug('task--->'+tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is Only Landlord
        if(!listingIdsLandlordAllTask.isEmpty()){
            Map<Id, pba__Listing__c> listingIdsOnlyLandIdMap = new Map<Id, pba__Listing__c>([
                SELECT Id, OwnerId FROM pba__Listing__c
                WHERE Id IN :listingIdsLandlordAllTask]);
            system.debug('Value in Map where Property Owner Contact Type is only Landlord-->'+listingIdsOnlyLandIdMap);
            system.debug('Listing to Iterate where Property Owner Contact Type is only Landlord -->'+listingIdsOnlyLandIdMap.keySet());            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsOnlyLandIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsOnlyLandIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsOnlyLandIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsOnlyLandIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is only PMC
        if(!listingIdsPMCAllTask.isEmpty()){
            Map<Id, pba__Listing__c> listingIdsOnlyPMCIdMap = new Map<Id, pba__Listing__c>([
                SELECT Id, OwnerId FROM pba__Listing__c
                WHERE Id IN :listingIdsPMCAllTask]);
            system.debug('Value in Map where Property Owner Contact Type is only PMC-->'+listingIdsOnlyPMCIdMap);
            system.debug('Listing to Iterate where Property Owner Contact Type is only PMC-->'+listingIdsOnlyPMCIdMap.keySet());            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsOnlyPMCIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsOnlyPMCIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsOnlyPMCIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsOnlyPMCIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is both Seller and Developer
        if(!listingIdsSellDevAllTask.isEmpty()){
            Map<Id, pba__Listing__c> listingIdsSellDevIdMap = new Map<Id, pba__Listing__c>([
                SELECT Id, OwnerId FROM pba__Listing__c
                WHERE Id IN :listingIdsSellDevAllTask]);
            system.debug('Value in Map where Property Owner Contact Type is both Seller and Developer-->'+listingIdsSellDevIdMap);
            system.debug('Listing to Iterate where Property Owner Contact Type is both Seller and Developer-->'+listingIdsSellDevIdMap.keySet());
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsSellDevIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsSellDevIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsSellDevIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsSellDevIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is only Seller
        if(!listingIdsSellerAllTask.isEmpty()){
            Map<Id, pba__Listing__c> listingIdsSellerOnlyIdMap = new Map<Id, pba__Listing__c>([
                SELECT Id, OwnerId FROM pba__Listing__c
                WHERE Id IN :listingIdsSellerAllTask]);
            system.debug('Value in Map where Property Owner Contact Type is only Seller-->'+listingIdsSellerOnlyIdMap);
            system.debug('Listing to Iterate where Property Owner Contact Type is only Seller -->'+listingIdsSellerOnlyIdMap.keySet());
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsSellerOnlyIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsSellerOnlyIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsSellerOnlyIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsSellerOnlyIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }        
        //Create Task for Listings where Property Owner Contact Type is Developer
        if(!listingIdsDeveloperAllTask.isEmpty()){
            Map<Id, pba__Listing__c> listingIdsDevOnlyMap = new Map<Id, pba__Listing__c>([
                SELECT Id, OwnerId FROM pba__Listing__c
                WHERE Id IN :listingIdsDeveloperAllTask]);
            system.debug('Value in Map where Property Owner Contact Type is only Developer-->'+listingIdsDevOnlyMap);
            system.debug('Listing to Iterate where Property Owner Contact Type is only Developer -->'+listingIdsDevOnlyMap.keySet());            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsDevOnlyMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsDevOnlyMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsDevOnlyMap.get(c).Id;
                tsk.Listing__c       = listingIdsDevOnlyMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';                
                taskList.add(tsk);
            } 
        } 
        Set<Id> listIds = new Set<Id>();           
        system.debug('List of Task to be Inserted -->'+taskList);
        try {
            insert taskList;
            for(Task t : taskList){
                listIds.add(t.WhatId);

            }
            System.debug(listIds);

        } catch (system.dmlexception e) {
            System.debug('Tasks not inserted: ' + e);
        }   
    }     
    global void finish(Database.BatchableContext BC) {                
        // execute any post-processing operations like sending email
    }
}