global class contactCalledNoReplyRecTaskBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {    
        // collect the batches of records or objects to be passed to execute
         System.debug('Start Batch class');
        //String query = 'SELECT Id, Stage__c, lastactivitydate, (SELECT ActivityDate,Id,WhoId FROM Tasks WHERE Status NOT IN (\'Completed\') AND ActivityDate > TODAY) FROM Contact WHERE Stage__c IN (\'Called: No Reply\')';
        String query = 'SELECT Id, Stage__c, lastactivitydate FROM Contact WHERE Stage__c IN (\'Called: No Reply\') AND Owner.Name NOT IN (\'Nishchay Mehra\',\'Vansh Mehra\',\'Maverick Realty\') AND owner.isactive =True';
        //String query = 'SELECT Id, Stage__c, lastactivitydate FROM Contact WHERE Stage__c IN (\'Called: No Reply\')';
        System.debug(Database.getQueryLocator(query));
         return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
        // Date todayMinusThreeDays = Date.Today().addDays(-3);
        // Start Jira Ticket MS- 3
        Date todayMinusThreeDays = Date.Today().addDays(-1);
        // End Jira Ticket MS- 3
        system.debug('Date two days earlier from Today-->'+todayMinusThreeDays);
        system.debug('Query Results = ' + conList); 
        // Create a set of Contact with All Tasks
        Set<Id> contactIdsWithAllTask = new Map<Id, AggregateResult>([
            //SELECT WhoId Id FROM Task WHERE Status NOT IN ('Completed')
            //SELECT WhoId Id FROM Task WHERE ActivityDate = :todayMinusThreeDays
            SELECT WhoId Id FROM Task WHERE WhoId IN :conList
            GROUP BY WhoId]).keySet(); 
        /*// Create a List of Contact with open Tasks
        List<Task> contactIdsWithOpenTask = new List<Task>([
            SELECT WhoId FROM Task  WHERE Status NOT IN ('Completed')
            AND WhoId IN :conList]); 
        */
        // Create a set of Contact with Tasks whose Due Date is in Future
        Set<Id> contactIdsWithFutureTask = new Map<Id, AggregateResult>([
            //SELECT WhoId Id FROM Task WHERE Status IN ('Completed')
            //AND pba__CompletedDate__c = :todayMinusThreeDays
            SELECT WhoId Id FROM Task WHERE ActivityDate > :todayMinusThreeDays
            AND WhoId IN :conList
            GROUP BY WhoId]).keySet();
        
        /*// Create a List of Contact with Closed Tasks
        List<Task> contactIdsWithFutureTask = new List<Task>([
            SELECT WhoId FROM Task WHERE Status IN ('Completed')
            AND WhoId IN :conList]); 
        */
        system.debug('Contacts with Open Task -->'+contactIdsWithAllTask);
        system.debug('Contacts with Closed Task -->'+contactIdsWithFutureTask);
        
        if(!contactIdsWithFutureTask.isEmpty()){
            for(Id objId: contactIdsWithFutureTask){
                if(contactIdsWithAllTask.contains(objId))
                    contactIdsWithAllTask.remove(objId);
            }
        }
        system.debug('====setAIds==='+contactIdsWithAllTask);
        system.debug('Contacts in Stage "Called: No Reply" for which Recurring Task needs to be Created-->'+contactIdsWithAllTask);
        if(!contactIdsWithAllTask.isEmpty()){
            Map<Id, Contact> contactIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contactIdsWithAllTask]);
            system.debug('Value in Map-->'+contactIdMap);
            system.debug('Contact to Iterate -->'+contactIdMap.keySet());
            List <Task> taskList = new List<Task>();
            
            // Iterate through the whole query of Contacts
            // Create a Task that's associated with each Contact.
            for(Id c : contactIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contactIdMap.get(c).OwnerId;
                tsk.WhoId            = contactIdMap.get(c).Id;
                //tsk.WhatId           = c.AccountId;
                tsk.ActivityDate     = System.today();
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Call the Lead';
                //tsk.Description      = 'This Lead is in stage Called: No Reply, need to call the lead.';
                //tsk.IsReminderSet    = true;
                //tsk.ReminderDateTime = System.now();
                
                taskList.add(tsk);
            } //close for-loop
            system.debug('List of Task to be Inserted -->'+taskList);
            try {
                insert taskList;
            } catch (system.dmlexception e) {
                System.debug('Tasks not inserted: ' + e);
            }
        }
    }
     
    global void finish(Database.BatchableContext BC) {
        
        
        // execute any post-processing operations like sending email
    }
}