trigger UpdateSellerANDBuyer on pba__Listing__c (after update) {

    // List<pba__Closing__c>
    Set<pba__Listing__c> listingId = new Set<pba__Listing__c>();

    if(trigger.isAfter && trigger.isUpdate){
        for (pba__Listing__c item : Trigger.new){
            System.debug('itenm ' + item);
            pba__Listing__c oldListing = Trigger.oldMap.get(item.ID);

            if(item.pba__Status__c=='Sold' && item.pba__Status__c != oldListing.pba__Status__c){
                listingId.add(item);
                 

            }
        }
            
    }
    

}