trigger ListingDateUpdate on pba__Listing__c (after update) {
    Set<id> setContactId = new Set<id>();
    // List<pba__Listing__c> listing = [select Id,Name,pba__Status__c,pba__PropertyOwnerContact_pb__c,pba_uaefields__Available_from__c from pba__Listing__c where Id IN : Trigger.New];
    // System.debug('listing----->'+listing);
    List<Contact> cList = new List<Contact>();
    
    
    for(pba__Listing__c li : Trigger.New){
        setContactId.add(li.PropertyOwnerContact__c);
        System.debug('setContactId---->'+setContactId); 
    }
    
    Map<id,Contact> contactMap = new Map<id,Contact>([select id, Next_date_property_can_be_Available__c from Contact where id IN :setContactId]);
    System.debug('contactMap---->'+contactMap); 
    
    for(pba__Listing__c li : Trigger.new){
        Contact con = new Contact();
        System.debug('list date ---->'+li.pba_uaefields__Available_from__c);
        System.debug('setContactId---->'+setContactId); 
        System.debug('status---->'+li.pba__Status__c);
        if(li.pba__Status__c == 'Withdrawn' || li.pba__Status__c == 'Rented'){
            System.debug('list date--- ---->'+li.pba_uaefields__Available_from__c);
          //    con.Next_date_property_can_be_Available__c = li.pba_uaefields__Available_from__c;
            li.pba_uaefields__Available_from__c = contactMap.get(li.PropertyOwnerContact__c).Next_date_property_can_be_Available__c;
            System.debug('Contact date ---->>'+con.Next_date_property_can_be_Available__c);
            cList.add(con);
        }
        // update cList;
    }
        
        System.debug('cList------->'+cList);
       System.debug('Success--->');


       
}