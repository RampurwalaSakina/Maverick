Global class ContactBatchTaskClass implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
       
        System.debug('Normal Schedule Run');
        String query = 'SELECT Id, Stage__c, lastactivitydate, pba__ContactType_pb__c FROM Contact WHERE Stage__c IN (\'Documents Received\') AND owner.isactive =True AND pba__ContactType_pb__c IN (\'Landlord\', \'Seller\')';
        System.debug('query====>>'+query);
        return Database.getQueryLocator(query);       
    }
    global void execute(Database.BatchableContext BC, List<Contact> SellerOrLandlordlist) {
        System.debug('In execute method');
        System.debug('SellerOrLandlordlist===>'+SellerOrLandlordlist);

        List<ContactHistory> s = [SELECT Id,ContactId,CreatedDate,NewValue FROM ContactHistory where ContactId IN : SellerOrLandlordlist];
        System.debug('s--->'+s);

        Map<Id,ContactHistory> m =new Map<Id,ContactHistory>([SELECT Id,ContactId,CreatedDate,NewValue FROM ContactHistory where ContactId IN : SellerOrLandlordlist]);
        System.debug('m--->>'+m);




        // List<Task> lstTasktoInsert = new List<Task>();
        // Date plus4day = Date.Today()+4;
        // system.debug('Date 4 days earlier from Today-->'+plus4day);
        // Set<Id> landlordOrseller = new Map<Id, AggregateResult>([SELECT WhoId Id FROM Task WHERE WhoId IN :SellerOrLandlordlist GROUP BY WhoId]).keySet();
        
        // system.debug('Contacts only Seller Or Landlord-->'+landlordOrseller);

        // List <Task> taskList = new List<Task>();
        // System.debug(landlordOrseller );
        // if(!landlordOrseller.isEmpty()){
        //     Map<Id, Contact> contIdSellerOrLandlordIdMap = new Map<Id, Contact>([SELECT Id, OwnerId FROM Contact WHERE Id IN :landlordOrseller]);
        //     system.debug('Map of Contacts Type is only Landlord-->'+contIdSellerOrLandlordIdMap);
        //     system.debug('Contact Type is only Landlord-->'+contIdSellerOrLandlordIdMap.keySet());
            
        //     for(Id c : contIdSellerOrLandlordIdMap.keySet()) {
        //         Task tsk             = new Task();
        //         tsk.OwnerId          = contIdSellerOrLandlordIdMap.get(c).OwnerId;
        //         tsk.WhoId            = contIdSellerOrLandlordIdMap.get(c).Id;
        //         tsk.ActivityDate     = System.today()+4 ;
        //         tsk.Status           = 'Not Started';
        //         tsk.Priority         = 'High';
        //         tsk.Subject          = '23 december';
                
        //         taskList.add(tsk);
        //     } 
        // }
        // system.debug('List of Task to be Inserted -->'+taskList);
        // try {
        //     insert taskList;
        // } catch (system.dmlexception e) {
        //     System.debug('Tasks not inserted: ' + e);
        // }
    }
    global void finish(Database.BatchableContext BC) {
        
        // finish
        
    }
}