trigger HandleDeleteOnContact on Contact (after update) {

    List<Id> contactRecForDeleteList=new List<Id>();
	for (Contact contactRec : trigger.New) {        
        if(contactRec.Approved_for_Deletion__c =='Yes' && trigger.oldMap.get(contactRec.Id).Approved_for_Deletion__c=='No')           
        {            
            contactRecForDeleteList.add(contactRec.Id);  
        }        
     } 
    
    system.debug('Contacts for Deletion after approval from Sayam Butt-->'+contactRecForDeleteList);
    if(contactRecForDeleteList.size()>0) {        
        DeleteContacts.deleteNow(contactRecForDeleteList);        
    }    
}