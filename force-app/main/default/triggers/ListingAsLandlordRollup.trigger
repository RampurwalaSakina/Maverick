trigger ListingAsLandlordRollup on pba__Listing__c (after delete, after insert, after update, after undelete) {
    Set<id> contactIds = new Set<id>();
    Map<Id,Contact> contactsToUpdate = new Map<Id,Contact>();
    // List<Contact> contactsToUpdate = new List<Contact>();

    if (trigger.isInsert || trigger.isUndelete) {
        for (pba__Listing__c item : Trigger.new)
            contactIds.add(item.PropertyOwnerContact__c);
    }
    
    if (Trigger.isUpdate || Trigger.isDelete) {
        for (pba__Listing__c item : Trigger.old)
            contactIds.add(item.PropertyOwnerContact__c);
    }
    
    // get a map of the contacts with the number of Listings as Landlord
    Map<id,Contact> contactMap = new Map<id,Contact>([select id, Count_of_Listings_as_Landlord__c    from Contact where id IN :contactIds]);
    

    List<pba__Listing__c> listingList = new List<pba__Listing__c>();
    listingList = [SELECT Id, PropertyOwnerContact__c FROM pba__Listing__c WHERE PropertyOwnerContact__c IN : contactMap.keySet()];
   
    Map<Id,List<pba__Listing__c>> ListingMap = new Map<Id,List<pba__Listing__c>>();

    for(pba__Listing__c listing: listingList){
        if(!ListingMap.containskey(listing.PropertyOwnerContact__c)){
            ListingMap.put(listing.PropertyOwnerContact__c,new List<pba__Listing__c>());
        }
        ListingMap.get(listing.PropertyOwnerContact__c).add(listing);
    }

    for(pba__Listing__c listing: listingList){
        if(listing.PropertyOwnerContact__c == contactMap.get(listing.PropertyOwnerContact__c).Id){
            contactMap.get(Listing.PropertyOwnerContact__c).Count_of_Listings_as_Landlord__c = ListingMap.get(listing.PropertyOwnerContact__c).size();
            
            if(!contactsToUpdate.containskey(listing.PropertyOwnerContact__c))
            contactsToUpdate.Put(listing.PropertyOwnerContact__c,contactMap.get(listing.PropertyOwnerContact__c));

                // contactsToUpdate.add(contactMap.get(listing.PropertyOwnerContact__c));

        }
    }


    // query the contacts and the related Listings as Landlord and add the size of the Listings as Landlord to the contact's Count_of_Listings_as_Landlord__c   
    // for (Contact contactWithListingAsLandlord : [select Id, Name, Count_of_Listings_as_Landlord__c  ,(select id from PropertyOwnerContactListing__r) from Contact where Id IN :contactIds]) {
       
        
        
    //     contactMap.get(contactWithListingAsLandlord.Id).Count_of_Listings_as_Landlord__c = contactWithListingAsLandlord.PropertyOwnerContactListing__r.size();
    //     // add the value/contact in the map to a list so we can update it
    //     contactsToUpdate.add(contactMap.get(contactWithListingAsLandlord.Id));
    // }
    
    update contactsToUpdate.values();
    // update contactsToUpdate;
}