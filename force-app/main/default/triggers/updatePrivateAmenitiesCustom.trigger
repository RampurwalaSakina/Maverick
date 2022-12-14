trigger updatePrivateAmenitiesCustom on pba__Listing__c (before insert, before update) {
	pba__Listing__c[] Listing = Trigger.new;
    updateMultiSelectPicklistFieldListing.updateMSelectPickField(Listing);
}