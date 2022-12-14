trigger newSalesTargetRecsForNewUser on User (after insert) {
	
    Set<Id> setUserids = new Set<Id>();
    
    for(User userID : Trigger.NEW) {
        setUserids.add(userID.id);    
    }  
    createNewSalesTargetClass.createNewSalesTarget(setUserids);   
}