trigger updateOwnerOnContact on pba__Request__c (after update) {
	Set<Id> contactIdSet = new Set<Id>();
    Set<Id> listingIdSet = new Set<Id>();
    
    for(pba__Request__c newInquiry : Trigger.New){
        if (newInquiry.pba__Contact__c != null) {
            contactIdSet.add(newInquiry.pba__Contact__c);
        }
        
        if (newInquiry.Listing__c != null) {
            listingIdSet.add(newInquiry.Listing__c);
        }
    }
    System.debug('Value in Contact Set--->'+contactIdSet);
    System.debug('Value in Listing Set--->'+listingIdSet);
    
    Map<Id, pba__Listing__c> listingMap = new Map<Id, pba__Listing__c>([Select OwnerId, Owner.IsActive from pba__Listing__c Where Id in: listingIdSet]);
    System.debug('Value in Listing Map-->'+listingMap);
    
    Map<Id, Contact> contactMap = new Map<Id, Contact>([Select OwnerId, Stage__c from Contact Where Id in: contactIdSet]);
    System.debug('Value in Contact Map--->'+contactMap);
	
    if(listingMap.size()>0) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for(pba__Request__c newInquiry : Trigger.New){
            system.debug('Inside For loop');
            if(newInquiry.pba__Contact__c != null && newInquiry.Listing__c != null){
                system.debug('Inside 1st If loop');
                system.debug('Status of Owner-->'+listingMap.get(newInquiry.Listing__c).Owner.IsActive);
                if((contactMap.get(newInquiry.pba__Contact__c).Stage__c == 'Contract Signed' || contactMap.get(newInquiry.pba__Contact__c).Stage__c == 'Disqualified') 
                   && contactMap.get(newInquiry.pba__Contact__c).OwnerId != listingMap.get(newInquiry.Listing__c).OwnerId && listingMap.get(newInquiry.Listing__c).Owner.IsActive == True ){
                       system.debug('Inside 2nd If loop');
                       contactMap.get(newInquiry.pba__Contact__c).OwnerId = listingMap.get(newInquiry.Listing__c).OwnerId;
                       contactsToUpdate.add(contactMap.get(newInquiry.pba__Contact__c));
                   }
            }
        }  
        //Create a map that will hold the values of the list.
        Map<Id, Contact> conMapToUpdate = new Map<Id, Contact>();
        
        //Put all the values form the list contactsToUpdate to the above map.
        conMapToUpdate.putall(contactsToUpdate);
        
        if(conMapToUpdate.size()>0) {
        	update conMapToUpdate.values();
        }
    }
}