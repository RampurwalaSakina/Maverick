trigger FieldCheckForApproval on pba__Listing__c (before update, after update) {
	for(pba__Listing__c cr : Trigger.New)
    {
        Boolean oldStatus=Trigger.oldMap.get(cr.Id).Is_the_Listing_Approved__c;
        if(cr.Is_the_Listing_Approved__c== True && oldStatus!= True)
        {
            // Bayut Boost is required if approved
            
            if(cr.Bayut_Boost__c==null && cr.pba__Status__c != 'Withdrawn' && cr.pba__Status__c != 'Rented' && cr.pba__Status__c != 'Sold') 
            {
                
                //isValid = false; 
                cr.addError('You must select a value for the field Bayut Boost in order to approve this Listing.');
            }
            
            // Sub Community - Propertyfinder is required if approved
            
            if(cr.pba_uaefields__Sub_Community_Propertyfinder__c ==null && cr.Propertyfinder_Boost__c != null) 
            {
                
                //isValid = false;
                cr.addError('You must select a value for the field Sub Community - Propertyfinder in order to approve this Listing.');
            }
         }                            
	}
}