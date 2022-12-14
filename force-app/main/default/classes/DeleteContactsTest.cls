@isTest
Public class DeleteContactsTest 
{
    static testMethod void  testDeleteContact()
    {
        
        Contact[] contactsToCreate = new Contact[]{};

         for(Integer x=0; x<50;x++)
        {
         Contact ct = new Contact(lastname='Contact',firstName = 'Test');
         contactsToCreate.add(ct);
        }
        
        insert contactsToCreate;
        
        List<Id> testcontactRecDeleteList=new List<Id>();
        for (Contact cr : contactsToCreate)
        {
            testcontactRecDeleteList.add(cr.Id);
        }
        Test.startTest();
              DeleteContacts.deleteNow(testcontactRecDeleteList);              
        Test.stopTest();    
    }    
}