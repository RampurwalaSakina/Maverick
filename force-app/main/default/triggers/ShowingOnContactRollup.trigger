trigger ShowingOnContactRollup on Event (after delete, after insert, after update, after undelete) {
	Set<id> contactIds = new Set<id>();
    List<Contact> contactsToUpdate = new List<Contact>();
    if (trigger.isInsert || trigger.isUndelete) {
        for (Event item : Trigger.new)
            contactIds.add(item.WhoId);
    }
    
    if (Trigger.isUpdate || Trigger.isDelete) {
        for (Event item : Trigger.old)
            contactIds.add(item.WhoId);
    }
    
    // get a map of the contacts with the number of Showings Active Till date
    Map<id,Contact> contactMap = new Map<id,Contact>([select id, Count_of_Showing_still_Active__c from Contact where id IN :contactIds]);
    
	Date referenceDate = Date.today()-60;   
    system.debug('Register Date --> '+referenceDate);
    
    // query the contacts and the related Showings Active Till date and add the size of the Showings Active Till date to the contact's Count_of_Showing_still_Active__c	
    for (Contact contactWithShowingsStillActive : [select Id, Name, Count_of_Showing_still_Active__c, (select id from Events where EndDateTime >= :referenceDate) from Contact where Id IN :contactIds]) {
        contactMap.get(contactWithShowingsStillActive.Id).Count_of_Showing_still_Active__c = contactWithShowingsStillActive.Events.size();
        // add the value/contact in the map to a list so we can update it
        contactsToUpdate.add(contactMap.get(contactWithShowingsStillActive.Id));
    }
    
    update contactsToUpdate;
}