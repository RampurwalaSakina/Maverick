global class contQualBookDepRecvTaskBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Collect the batches of Contact records to be passed to execute
        String query = 'SELECT Id, Stage__c, lastactivitydate FROM Contact WHERE Stage__c IN (\'Qualified\', \'Booking/Deposit Received\') AND Owner.Name NOT IN (\'Nishchay Mehra\',\'Vansh Mehra\',\'Maverick Realty\') AND owner.isactive =True';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
                 
        Date todayMinusSevenDays = Date.Today().addDays(-7);
        system.debug('Date Seven days earlier from Today-->'+todayMinusSevenDays);
        system.debug('Query Results = ' + conList); 
        
        // Create a set of Contact with All Tasks
        Set<Id> contactIdsWithAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :conList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contact with Tasks whose Due Date is in Future
        Set<Id> contactIdsWithFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE ActivityDate > :todayMinusSevenDays
            AND WhoId IN :conList
            GROUP BY WhoId]).keySet();
        
        system.debug('Contacts with All Task -->'+contactIdsWithAllTask);
        system.debug('Contacts with Future Task -->'+contactIdsWithFutureTask);
        
        if(!contactIdsWithFutureTask.isEmpty()){
            for(Id objId: contactIdsWithFutureTask){
                if(contactIdsWithAllTask.contains(objId))
                    contactIdsWithAllTask.remove(objId);
            }
        }
        system.debug('====setAIds==='+contactIdsWithAllTask);
        system.debug('Contacts in Stage "Qualified OR Booking/Deposit Received" for which Recurring Task needs to be Created-->'+contactIdsWithAllTask);
        
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
                tsk.ActivityDate     = System.today();
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Gentle Reminder: Update the Contact Record';
                
                taskList.add(tsk);
            } 
            
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