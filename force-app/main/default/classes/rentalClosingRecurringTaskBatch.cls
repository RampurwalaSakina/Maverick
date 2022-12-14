global class rentalClosingRecurringTaskBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        // Jira tickt number Ms-7
        Date todayPlusFortyFiveDays = Date.Today().addDays(90);
        system.debug('Date 45 days from Today-->'+todayPlusFortyFiveDays);
        // if(Test.isRunningTest()){
        //     System.debug('Test Class Method');
        //     // collect the batches of records or objects to be passed to execute
        //     String query = 'SELECT Id, RecordType.Name, Renter__c , Rental_Agreement_End_Date__c, OwnerId FROM pba__Closing__c WHERE RecordType.Name IN (\'Rent\') AND Rental_Agreement_End_Date__c = :todayPlusFortyFiveDays LIMIT 1900';
        //     return Database.getQueryLocator(query);
        // }else{ 
            System.debug('Normal Schedule Run');
            // collect the batches of records or objects to be passed to execute
            String query = 'SELECT Id, RecordType.Name, Renter__c , Rental_Agreement_End_Date__c, OwnerId FROM pba__Closing__c WHERE RecordType.Name IN (\'Rent\') AND Rental_Agreement_End_Date__c = :todayPlusFortyFiveDays';
            return Database.getQueryLocator(query);
        // }
    }
     
    global void execute(Database.BatchableContext BC, List<pba__Closing__c> closingList) {
                 
        system.debug('Query Results = ' + closingList);
        // Create a set of Closings
        Set<Id> closingIdSet = new Set<Id>();
        // Create a set of Closings with Active Owner
        Set<Id> activeOwnerClosingIdSet = new Set<Id>();
        // Create a set of Closings with Active Owner
        Set<Id> inactiveOwnerClosingIdSet = new Set<Id>();
        
        for(pba__Closing__c closing: closingList){
            closingIdSet.add(closing.Id);
        }
         // Jira tickt number Ms-7
        Id systemUser = [SELECT Id, Name ,Email from User WHERE Email ='cyril@maverickrealty.ae' Limit 1].id;
        system.debug('User Id-->'+systemUser);
        
        Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
                      .get('Closing').getRecordTypeId();
        system.debug('Task Record Type Id-->'+recordTypeId);
        
        Map<Id, pba__Closing__c> closingIdMap = new Map<Id, pba__Closing__c>([
            SELECT Id, OwnerId, Renter__c , Owner.IsActive FROM pba__Closing__c
            WHERE Id IN :closingIdSet]);
        system.debug('Value in Map-->'+closingIdMap);
        system.debug('Closings to Iterate -->'+closingIdMap.keySet());
            List <Task> taskList = new List<Task>();
            
            // Iterate through the whole query of Closings
            // Create a Task that's associated with each Closing.
        for(Id c : closingIdMap.keySet()) {
            System.debug(closingIdMap.get(c).Renter__c);
            if(closingIdMap.get(c).Owner.IsActive == True) {
                activeOwnerClosingIdSet.add(c);
            }else{
                inactiveOwnerClosingIdSet.add(c);
            }
        }
        
        for(Id c : activeOwnerClosingIdSet) {
            Task tsk             = new Task();
             // Start Jira tickt number Ms-7
            // tsk.RecordTypeId     = recordTypeId;
            tsk.OwnerId          = systemUser;
             // End Jira tickt number Ms-7
            tsk.WhatId           = closingIdMap.get(c).Id;
            tsk.ActivityDate     = System.today();
            tsk.Status           = 'Not Started';
            tsk.Priority         = 'High';
            tsk.Subject          = 'Follow up Tenant/Landlord';
            
            taskList.add(tsk);                    
        } 
        //close for-loop
        
        for(Id c : inactiveOwnerClosingIdSet) {
            Task tsk             = new Task();
             // Start Jira tickt number Ms-7
            // tsk.RecordTypeId     = recordTypeId/;
            tsk.OwnerId          = systemUser;
             // End Jira tickt number Ms-7
            tsk.WhatId           = closingIdMap.get(c).Id;
            tsk.ActivityDate     = System.today();
            tsk.Status           = 'Not Started';
            tsk.Priority         = 'High';
            tsk.Subject          = 'Follow up Tenant/Landlord';
            
            taskList.add(tsk);                    
        } //close for-loop
        system.debug('List of Task to be Inserted -->'+taskList);
        try {
            insert taskList;
        } catch (system.dmlexception e) {
            System.debug('Tasks not inserted: ' + e);
        }
        
    }
     
    global void finish(Database.BatchableContext BC) {
        
        
        // execute any post-processing operations like sending email
    }
}