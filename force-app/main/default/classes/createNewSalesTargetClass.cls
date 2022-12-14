public class createNewSalesTargetClass {
	@future 
    public static void createNewSalesTarget(set<Id> setUserids)
    {
        List <Sales_Target__c> newSalesTargetRec = new List<Sales_Target__c>();    
        for(User user1 : [SELECT ID, ManagerId FROM User WHERE Id IN : setUserids]){

            Sales_Target__c ST = new Sales_Target__c();   
            ST.User__c = user1.id;
            ST.OwnerId = user1.ManagerId;
            newSalesTargetRec.add(ST);
        }
        insert newSalesTargetRec;   
    }
}