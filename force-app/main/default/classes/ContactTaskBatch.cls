Global class ContactTaskBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
       
        System.debug('Normal Schedule Run');
        String query = 'SELECT Id,OwnerId, Stage__c, lastactivitydate, pba__ContactType_pb__c, (SELECT Id, Field, DataType,ContactId,CreatedDate, OldValue, NewValue FROM Histories WHERE Field = \'stage__c\' ORDER BY CreatedDate DESC) FROM Contact WHERE Stage__c IN (\'Documents Received\') AND owner.isactive =True AND pba__ContactType_pb__c IN (\'Landlord\', \'Seller\')';
        System.debug('query----->>>>'+query);
        return Database.getQueryLocator(query);
    
        
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> Conlist) {
        
        // List<Contact> Conlist = [SELECT Id, Stage__c,OwnerId, lastactivitydate, pba__ContactType_pb__c, (SELECT Id, Field, DataType,ContactId,CreatedDate, OldValue, NewValue FROM Histories WHERE Field = 'stage__c' ORDER BY CreatedDate DESC) FROM Contact WHERE Stage__c IN ('Documents Received') AND owner.isactive =True AND pba__ContactType_pb__c IN ('Landlord', 'Seller')];
        // System.debug('size=='+conlist.size());


        // Date todayMinus4Days = Date.Today().addDays(-4);
        // System.debug('todayMinus4Days==='+todayMinus4Days);
        Set<Id> ContactIdSet = new Set<Id>();
        for(Contact con : Conlist){
            ContactIdSet.add(con.Id);
        }

        // // Create a set of Contact with All Tasks where Contact Type only Landlord
        // Set<Id> contIdsLandLordOrSellerAllTask = new Map<Id, AggregateResult>([
        //     SELECT WhoId Id FROM Task WHERE WhoId IN :ContactIdSet
        //     GROUP BY WhoId]).keySet(); 
        
        // // Create a set of Contacts with All Tasks where Contact Type only Landlord whose Due Date is in Future
        // Set<Id> contIdsOnSellerOrLandlordFutureTask = new Map<Id, AggregateResult>([
        //     SELECT WhoId Id FROM Task WHERE WhoId IN :ContactIdSet AND ActivityDate > :todayMinus4Days
        //     GROUP BY WhoId]).keySet();
        
        // system.debug('Contacts with All Task where Contact Type only Seller Or Landlord-->'+contIdsLandLordOrSellerAllTask);//1 2 3
        // system.debug('Contacts with Future Task where Contact Type only Seller Or Landlord-->'+contIdsOnSellerOrLandlordFutureTask); //2 3
        
        // if(!contIdsOnSellerOrLandlordFutureTask.isEmpty()){
        //     for(Id objId: contIdsOnSellerOrLandlordFutureTask){     
        //         if(contIdsLandLordOrSellerAllTask.contains(objId))
        //             contIdsLandLordOrSellerAllTask.remove(objId);
        //     }
        // }

        // system.debug('Contacts where Contact Type only Landlord for which Recurring Task needs to be Created-->'+contIdsLandLordOrSellerAllTask);

        Map<Id,DateTime> HistoryDateMap = new Map<Id,DateTime>();
        if(Conlist.size() > 0 ){
            for(Contact con : Conlist){
                for(ContactHistory his : con.Histories){
                    
                    Date CreateDate = date.newinstance(his.CreatedDate.year(), his.CreatedDate.month(), his.CreatedDate.day());
                  
                    if(his.NewValue == 'Documents Received' && !HistoryDateMap.containskey(his.ContactId)){
                        
                        System.debug('Testing==='+his.ContactId+'===='+his.createddate+'===='+his.Field+'==='+his.NewValue);
                        // if(fourDaysBackdate == CreateDate){
                            HistoryDateMap.put(his.ContactId, CreateDate);
                        // }
                        

                    }
                    else if(his.NewValue == 'Documents Received' && HistoryDateMap.containskey(his.ContactId)){
                        System.debug('CreatedDate=='+CreateDate);
                        System.debug('OldDate=='+HistoryDateMap.get(his.contactId));
                        HistoryDateMap.remove(his.contactId);
                        if(CreateDate > HistoryDateMap.get(his.contactId)){

                            // if(fourDaysBackdate == CreateDate){
                                HistoryDateMap.put(his.ContactId, CreateDate);
                                // HistoryDateMap.put(his.ContactId, CreateDate);
                            // }
                        }

                        // HistoryDateMap.get(his.contactId).put(his.createddate);
                    }
                   
                }
            }
            System.debug('HistoryDateMap==='+HistoryDateMap);
            System.debug('HistoryDateMap size==='+HistoryDateMap.size());

            List <Task> taskList = new List<Task>();
            if(HistoryDateMap.size() > 0){
                Date fourDaysBack = Date.Today()-4;
                Date fourDaysBackdate = date.newinstance(fourDaysBack.year(), fourDaysBack.month(), fourDaysBack.day());

                // Map<Id,Task> tskMap = new Map<Is,Task>([SELECT Id FROM Task WHERE Subject = 'List the Property' AND ActivityDate = ]);
                
                for(Contact con : Conlist){
                    System.debug('91=='+HistoryDateMap.get(con.id));
                    if(HistoryDateMap.containskey(con.Id) && HistoryDateMap.get(con.id) == fourDaysBackdate){
                        System.debug('35==='+con.Id);
                        Task tsk             = new Task();
                        tsk.OwnerId          = con.OwnerId;
                        tsk.WhoId            = con.Id;
                        // tsk.ActivityDate     =  HistoryDateMap.get(con.Id).addDays(4).date();
                        tsk.ActivityDate     =  System.today();
                        tsk.Status           = 'Not Started';
                        tsk.Priority         = 'High';
                        tsk.Subject          = 'List the Property';
                        taskList.add(tsk);
                    }
                }
                
                
                system.debug('List of Task to be Inserted -->'+taskList);
                try {
                    insert taskList;
                } catch (system.dmlexception e) {
                    System.debug('Tasks not inserted: ' + e);
                }
            
            }
        }
            
            
     
    }
  
    global void finish(Database.BatchableContext BC) {
        
        // execute any post-processing operations like sending email
        
    }
}