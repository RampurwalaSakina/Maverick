@isTest
public class createNewSalesTargetClassTest {
	
    static testMethod void TestCreateNewSalesTargetClass() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='PB Agent'];
        system.debug('Profile Id -->'+p.Id);
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Test.StartTest();
        	Insert u;
        	system.debug('User Created-->'+u.Id);
        Test.StopTest();
    }
}