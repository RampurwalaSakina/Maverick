trigger LinkedListingsRollup on pba__Favorite__c (after delete, after insert, after update, after undelete) {
    Set<id> contactIds = new Set<id>();
    List<Contact> contactsToUpdate = new List<Contact>();
    if (trigger.isInsert || trigger.isUndelete) {
        for (pba__Favorite__c item : Trigger.new)
            contactIds.add(item.pba__Contact__c);
    }
    
    if (Trigger.isUpdate || Trigger.isDelete) {
        for (pba__Favorite__c item : Trigger.old)
            contactIds.add(item.pba__Contact__c);
    }
    
    // get a map of the contacts with the number of Linked Listings
    Map<id,Contact> contactMap = new Map<id,Contact>([select id, Count_of_Linked_Listings__c from Contact where id IN :contactIds]);
    
    // query the contacts and the related Linked Listings and add the size of the Linked Listings to the contact's Count_of_Linked_Listings__c
    for (Contact contactWithLinkedListings : [select Id, Name, Count_of_Linked_Listings__c,(select id from pba__Favorites__r) from Contact where Id IN :contactIds]) {
        contactMap.get(contactWithLinkedListings.Id).Count_of_Linked_Listings__c = contactWithLinkedListings.pba__Favorites__r.size();
        // add the value/contact in the map to a list so we can update it
        contactsToUpdate.add(contactMap.get(contactWithLinkedListings.Id));
    }
    
    update contactsToUpdate;

}