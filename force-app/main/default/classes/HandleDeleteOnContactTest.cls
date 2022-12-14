@isTest
public class HandleDeleteOnContactTest {
    static testMethod void  testHandleDeleteOnContactTest()
    { 
        List<Contact> lc = new List <contact>();
        Account acct = new Account(name='test account');
        insert acct;
        Contact[] contactsToCreate = new Contact[]{};
            
            for(Integer x=0; x<50;x++)
        {
            Contact ct = new Contact(AccountId=acct.Id,lastname='Contact',firstName = 'Test');
            contactsToCreate.add(ct);
        }
        
        insert contactsToCreate;
        
        for (Contact c : contactsToCreate) 
        { 
            c.Approved_for_Deletion__c = 'Yes';
            lc.add(c);                                 
        }    
        update lc;
        
        system.assert(lc.size()>0);
    }
}