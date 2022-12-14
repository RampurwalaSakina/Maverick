trigger InquiryRollupToContact on pba__Request__c (after delete, after insert, after update, after undelete) {
	Set<id> contactIds = new Set<id>();
    List<Contact> contactsToUpdate = new List<Contact>();
    if (trigger.isInsert || trigger.isUndelete) {
        for (pba__Request__c item : Trigger.new)
            contactIds.add(item.pba__Contact__c);
    }
    
    if (Trigger.isUpdate || Trigger.isDelete) {
        for (pba__Request__c item : Trigger.old)
            contactIds.add(item.pba__Contact__c);
    }
    
    // get a map of the contacts with the number of Inquiries
    Map<id,Contact> contactMap = new Map<id,Contact>([select id, Count_of_Inquiry__c from Contact where id IN :contactIds]);
    
    // query the contacts and the related Inquiries and add the size of the Inquiries to the contact's Count_of_Linked_Listings__c
    for (Contact contactWithInquiries : [select Id, Name, Count_of_Inquiry__c,(select id from pba__Requests__r where pba__Status__c	 = 'Active') from Contact where Id IN :contactIds]) {
        contactMap.get(contactWithInquiries.Id).Count_of_Inquiry__c = contactWithInquiries.pba__Requests__r.size();
        // add the value/contact in the map to a list so we can update it
        contactsToUpdate.add(contactMap.get(contactWithInquiries.Id));
    }
    
    update contactsToUpdate;
}