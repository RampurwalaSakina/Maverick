global class historicalSalesTargetBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Collect the batches of Sales Target records to be passed to execute
        //
        //I have applied the where clause just for testing, need to remove before moving to prod.
        //
        if(Test.isRunningTest()){
            System.debug('Test Class Method');
            // collect the batches of records or objects to be passed to execute
            String query = 'SELECT Id, User__c, Target__c, Target_Achieved__c FROM Sales_Target__c LIMIT 10';
        	return Database.getQueryLocator(query);
        }else{ 
            System.debug('Normal Schedule Run');
            // collect the batches of records or objects to be passed to execute
            String query = 'SELECT Id, User__c, Target__c, Target_Achieved__c FROM Sales_Target__c WHERE id IN (\'a183H00000074MOQAY\')';
        	return Database.getQueryLocator(query);
        }
        
    }
     
    global void execute(Database.BatchableContext BC, List<Sales_Target__c> salesTargetList) {
        
        DateTime dt = Datetime.now();
        String monthName = dt.format('MMM');
        Integer year = dt.Year();
        System.debug('Year ===> '+year);
        System.debug('Month Name Short ===> '+monthName);
        // Create a set of Closings
        Set<Id> userIdSet = new Set<Id>();     
        for(Sales_Target__c salesTarget: salesTargetList){
            userIdSet.add(salesTarget.User__c);
        }
        
        Map<Id, Sales_Target__c> saleTargetIdMap = new Map<Id, Sales_Target__c>([
            SELECT Id, User__r.firstName, User__c, Target__c, Target_Achieved__c FROM Sales_Target__c
            WHERE User__c IN :userIdSet]);
        system.debug('Value in Map-->'+saleTargetIdMap);
        system.debug('Sales Target to Iterate -->'+saleTargetIdMap.keySet());
        
        List <Historical_Sales_Target__c> historicalSalesTargetList = new List<Historical_Sales_Target__c>();
        
        for(Id c : saleTargetIdMap.keySet()) {
            Historical_Sales_Target__c HST = new Historical_Sales_Target__c();
            HST.User__c = saleTargetIdMap.get(c).User__c;
            HST.Target__c = saleTargetIdMap.get(c).Target__c;
            HST.Target_Achieved__c = saleTargetIdMap.get(c).Target_Achieved__c;
            HST.Name = saleTargetIdMap.get(c).User__r.firstName+'\'s Sales Target for '+monthName;
            historicalSalesTargetList.add(HST);       
        }
        
        system.debug('List of Historical Sales Target record to be Inserted -->'+historicalSalesTargetList);
        try {
            insert historicalSalesTargetList;
        } catch (system.dmlexception e) {
            System.debug('Historical Sales Target records not inserted: ' + e);
        }
    }
     
    global void finish(Database.BatchableContext BC) {
                
        // execute any post-processing operations like sending email
    }
}