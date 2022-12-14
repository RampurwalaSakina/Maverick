trigger updateListingOnInquiry on pba__Favorite__c (after insert) {
    Set<Id> inquiryIdSet = new Set<Id>();
    Set<Id> listingIdSet = new Set<Id>();
    
    for(pba__Favorite__c newLinkedListing : Trigger.New){
        System.debug('trigger.new is' + newLinkedListing);
        if (newLinkedListing.pba__Request__c != null) {
            inquiryIdSet.add(newLinkedListing.pba__Request__c);
        }
        
        if (newLinkedListing.pba__Listing__c != null) {
            listingIdSet.add(newLinkedListing.pba__Listing__c);
        }
    }
    System.debug('Value in Inquiry Set--->'+inquiryIdSet);
    System.debug('Value in Listing Set--->'+listingIdSet);
    
    Map<Id, pba__Request__c> inquiryMap = new Map<Id, pba__Request__c>([Select Listing__c, pba__TechnicalSourceSystem__c from pba__Request__c Where Id in: inquiryIdSet]);
    System.debug('Value in Inquiry Map-->'+inquiryMap);
    
    Map<Id, pba__Listing__c> listingMap = new Map<Id, pba__Listing__c>([Select Id from pba__Listing__c Where Id in: listingIdSet]);
    System.debug('Value in Listing Map-->'+listingMap);
    
    if(inquiryMap.size()>0) {
        List<pba__Request__c> inquiryToUpdate = new List<pba__Request__c>();
        for(pba__Favorite__c newLinkedListing : Trigger.New){
            system.debug('Inside For Loop');
            if(inquiryMap.get(newLinkedListing.pba__Request__c).pba__TechnicalSourceSystem__c == 'FrontDesk'){
                system.debug('Inside If Loop');
                inquiryMap.get(newLinkedListing.pba__Request__c).Listing__c = listingMap.get(newLinkedListing.pba__Listing__c).Id;
                inquiryToUpdate.add(inquiryMap.get(newLinkedListing.pba__Request__c));
            }
        }
        
        //Create a map that will hold the values of the list.
        Map<Id, pba__Request__c> inquiryMapToUpdate = new Map<Id, pba__Request__c>();
        
        //Put all the values form the list inquiryToUpdate to the above map.
        inquiryMapToUpdate.putall(inquiryToUpdate);
        
        if(inquiryMapToUpdate.size()>0) {
            update inquiryMapToUpdate.values();
        }
    }
}