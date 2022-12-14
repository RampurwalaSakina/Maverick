global class updateTargetAchieveOnUserBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Collect the batches of User records to be passed to execute
        //String query = 'SELECT Id, TargetAchieved__c FROM User WHERE Id  IN (\'0054J000001qSZjQAM\', \'0054J000000x4gYQAQ\')';
        String query = 'SELECT Id, TargetAchieved__c FROM User WHERE Profile.Name  IN (\'PB Team Leader\', \'PB Agent\') AND IsActive = True';
        //need to remove the user Id's in the where clause before moving to prod.
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<User> userList) {
                 
        Date firstDayOfMonth = System.today().toStartOfMonth();
        System.debug('First Day of the Month-->'+firstDayOfMonth);
        system.debug('Query Results = ' +userList);
        
        //Map of Id and Decimal to hold the Key value pair of User Id and Target Acheived.
        Map<Id, Decimal> userIDClosingMap = new Map<Id, Decimal>();
        
        //List of all the closings related to the users in the Query list.
        List<pba__Closing__c> closingRecsList = new List<pba__Closing__c>([
            SELECT OwnerId, Agent_Commission__c, TotalCommissionAmount__c FROM pba__Closing__c
            WHERE ClosingDate__c >= :firstDayOfMonth AND OwnerId IN :userList]);
        system.debug('Closing Recrods-->'+closingRecsList);
        
        List<User> usersToUpdate = new List<User>();
        if(!closingRecsList.isEmpty()){
            for(User userId: userList){
                system.debug('Inside 1st For Loop');
                userIDClosingMap.put(UserId.Id, 0);
                for(pba__Closing__c closingList: closingRecsList){                
                    If(userId.Id == closingList.OwnerId && closingList.TotalCommissionAmount__c != null){
                        userIDClosingMap.put(userId.Id, userIDClosingMap.get(userId.Id) + closingList.TotalCommissionAmount__c);
                    }
                }
                system.debug('End of 2nd For Loop');
                if(!userIDClosingMap.isEmpty()){
                    userId.TargetAchieved__c = userIDClosingMap.get(userId.Id);
                    usersToUpdate.add(userId);
                }
            }
            system.debug('Map of UserId and Agent Commission Contains-->'+userIDClosingMap);
            
            system.debug('List of Users to be Updated -->'+usersToUpdate);
            try {
                update usersToUpdate;
            } catch (system.dmlexception e) {
                System.debug('Users not Updated: ' + e);
            }
        }        
    }
     
    global void finish(Database.BatchableContext BC) {
                
        // execute any post-processing operations like sending email
    }
}