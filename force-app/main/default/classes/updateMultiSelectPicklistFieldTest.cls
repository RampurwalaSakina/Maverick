@isTest
public class updateMultiSelectPicklistFieldTest {
    static testMethod void  testContactDeleteController()
    {
		      
        
        
        Contact ct = new Contact(lastname='Contact',firstName = 'Test', pba__ContactType_pb__c = 'Buyer;Seller', Approved_for_Deletion__c='No');
        Test.startTest();
        insert ct;  
        //Contact[] Contact1 = Trigger.new;
        //updateMultiSelectPicklistField.updateMSelectPickField(Contact1);
        Test.stopTest();
        //system.assertequals('Buyer', ct.Contact_Type_Multiselect_to_Text__c);
    }

}