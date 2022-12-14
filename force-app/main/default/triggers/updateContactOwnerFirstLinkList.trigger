trigger updateContactOwnerFirstLinkList on pba__Favorite__c (after insert) {
    
    List<pba__Favorite__c> linkListing = [SELECT pba__Listing__r.OwnerId,
                                          pba__Contact__r.OwnerId,
                                          pba__Contact__r.Count_of_Linked_Listings__c,
                                          pba__Contact__r.Stage__c,
                                          pba__Request__c
                                          FROM    pba__Favorite__c 
                                          WHERE   Id IN :Trigger.New];
    
    system.debug('Linked Listing-->'+linkListing);
    Set<id> contactIds = new Set<id>();
    Set<id> inquiryIds = new Set<id>();
    
    for (pba__Favorite__c item : Trigger.new){
            inquiryIds.add(item.pba__Request__c);
    }
    
    for (pba__Favorite__c item : Trigger.new){
            contactIds.add(item.pba__Contact__c);
    }
    
    List<Contact> contactsToUpdate = new List<Contact>();
    List<pba__Request__c> inquiriesToUpdate = new List<pba__Request__c>();
    
    // get a map of the contacts with the contact owner
    Map<id,Contact> contactMap = new Map<id,Contact>([select id, OwnerId from Contact where id IN :contactIds]);
    
    // get a map of the Inquiries with the Inquiry owner
    Map<id,pba__Request__c> inquiryMap = new Map<id,pba__Request__c>([select id, OwnerId from pba__Request__c where id IN :inquiryIds]);
    
    for(pba__Favorite__c newLinkListing: linkListing){
        System.debug('Value in Listing-->'+newLinkListing.pba__Listing__c);
        if(newLinkListing.pba__Listing__c != null && newLinkListing.pba__Contact__c != null){            
            if(newLinkListing.pba__Contact__r.Count_of_Linked_Listings__c == 0.0 && newLinkListing.pba__Contact__r.Stage__c == 'New Lead'&& newLinkListing.pba__Contact__r.OwnerId != newLinkListing.pba__Listing__r.OwnerId){
                
                contactMap.get(newLinkListing.pba__Contact__c).OwnerId = newLinkListing.pba__Listing__r.OwnerId;
                contactsToUpdate.add(contactMap.get(newLinkListing.pba__Contact__c));
                
                inquiryMap.get(newLinkListing.pba__Request__c).OwnerId = newLinkListing.pba__Listing__r.OwnerId;
                inquiriesToUpdate.add(inquiryMap.get(newLinkListing.pba__Request__c));                
            }
        }
    }
    Update contactsToUpdate;
    Update inquiriesToUpdate;
}