@isTest
public class contActivePropAcqDocRecTaskBatchTest {

    static Contact createContact(String fname, String lname, String contType) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.pba__ContactType_pb__c = contType;
        c.Stage__c = 'Active';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
        c.LeadSource = 'Open House';
        c.MobilePhone ='11122222222'; 
        insert c;
        
        return c;
    }
    
    static testMethod void TestcontActivePropAcqDocRecTaskBatch() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Landlord');
        Contact Contact1Copy = createContact('First1', 'Test1','Landlord');

        Contact Contact2 = createContact('First2', 'Test2','Seller');
        Contact Contact2Copy = createContact('First2', 'Test2','Seller');

        Contact Contact3 = createContact('First3', 'Test3','Landlord;Seller');
        Contact Contact3Copy = createContact('First3', 'Test3','Landlord;Seller');

        Contact Contact4 = createContact('First3', 'Test4','Landlord;Developer');
        Contact Contact4Copy = createContact('First3', 'Test4','Landlord;Developer');

        // Contact Contact5 = createContact('First3', 'Test3','Landlord; Property Management Company');
        // Contact Contact5Copy = createContact('First4', 'Test4','Landlord; Property Management Company');

        // Contact Contact6 = createContact('First3', 'Test3','Landlord;  Mortgage Broker');
      
        // SELECT WhoId Id FROM Task
        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact2.Id;
        tsk2.ActivityDate     = System.today().addDays(-30);
        tsk2.Status           = 'Completed';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        tsk2.pba__CompletedDate__c = Date.newInstance(2021, 04,01);
        tasks.add(tsk2);

        Task tsk3           = new Task();
        tsk3.OwnerId          = u.Id;
        tsk3.WhoId            = Contact1Copy.Id;
        tsk3.ActivityDate     = System.today().addDays(-1);
        tsk3.Status           = 'Not Started';
        tsk3.Priority         = 'High';
        tsk3.Subject          = 'Check Updates';
        
        tasks.add(tsk3);

        Task tsk4             = new Task();
        tsk4.OwnerId          = u.Id;
        tsk4.WhoId            = Contact2Copy.Id;
        tsk4.ActivityDate     = System.today().addDays(-1);
        tsk4.Status           = 'Completed';
        tsk4.Priority         = 'High';
        tsk4.Subject          = 'Check Updates';
        tsk4.pba__CompletedDate__c = Date.newInstance(2021, 04,01);
        tasks.add(tsk4);


        
        Task tsk5            = new Task();
        tsk5.OwnerId          = u.Id;
        tsk5.WhoId            = Contact3.Id;
        tsk5.ActivityDate     = System.today().addDays(-30);
        tsk5.Status           = 'Not Started';
        tsk5.Priority         = 'High';
        tsk5.Subject          = 'Check Updates';
        tasks.add(tsk5);

            
        Task tsk6            = new Task();
        tsk6.OwnerId          = u.Id;
        tsk6.WhoId            = Contact3Copy.Id;
        tsk6.ActivityDate     = System.today().addDays(-1);
        tsk6.Status           = 'Not Started';
        tsk6.Priority         = 'High';
        tsk6.Subject          = 'Check Updates';
        tasks.add(tsk6);

             
        Task tsk7            = new Task();
        tsk7.OwnerId          = u.Id;
        tsk7.WhoId            = Contact4.Id;
        tsk7.ActivityDate     = System.today().addDays(-30);
        tsk7.Status           = 'Not Started';
        tsk7.Priority         = 'High';
        tsk7.Subject          = 'Check Updates';
        tasks.add(tsk7);

        Task tsk8            = new Task();
        tsk8.OwnerId          = u.Id;
        tsk8.WhoId            = Contact4Copy.Id;
        tsk8.ActivityDate     = System.today().addDays(-1);
        tsk8.Status           = 'Not Started';
        tsk8.Priority         = 'High';
        tsk8.Subject          = 'Check Updates';
        tasks.add(tsk8);

        // Task tsk9            = new Task();
        // tsk9.OwnerId          = u.Id;
        // tsk9.WhoId            = Contact5.Id;
        // tsk9.ActivityDate     = System.today();
        // tsk9.Status           = 'Not Started';
        // tsk9.Priority         = 'High';
        // tsk9.Subject          = 'Check Updates';
        // tasks.add(tsk9);


        // Task tsk10            = new Task();
        // tsk10.OwnerId          = u.Id;
        // tsk10.WhoId            = Contact5.Id;
        // tsk10.ActivityDate     = System.today().addDays(-60);
        // tsk10.Status           = 'Not Started';
        // tsk10.Priority         = 'High';
        // tsk10.Subject          = 'Check Updates';
        // tasks.add(tsk10);

        // Task tsk11            = new Task();
        // tsk11.OwnerId          = u.Id;
        // tsk11.WhoId            = Contact6.Id;
        // tsk11.ActivityDate     = System.today().addDays(-1);
        // tsk11.Status           = 'Not Started';
        // tsk11.Priority         = 'High';
        // tsk11.Subject          = 'Check Updates';
        // tasks.add(tsk11);

        // Task tsk12           = new Task();
        // tsk12.OwnerId          = u.Id;
        // tsk12.WhoId            = Contact6Copy.Id;
        // tsk12.ActivityDate     = System.today().addDays(-30);
        // tsk12.Status           = 'Completed';
        // tsk12.Priority         = 'High';
        // tsk12.Subject          = 'Call the Lead';
        // tsk12.pba__CompletedDate__c = Date.newInstance(2021, 04,01);

        // tasks.add(tsk12);

        // Task tsk13           = new Task();
        // tsk13.OwnerId          = u.Id;
        // tsk13.WhoId            = Contact7.Id;
        // tsk13.ActivityDate     = System.today().addDays(-1);
        // tsk13.Status           = 'Not Started';
        // tsk13.Priority         = 'High';
        // tsk13.Subject          = 'Call the Lead';
        // tasks.add(tsk13);

        // Task tsk14           = new Task();
        // tsk14.OwnerId          = u.Id;
        // tsk14.WhoId            = Contact7Copy.Id;
        // tsk14.ActivityDate     = System.today().addDays(-1);
        // tsk14.Status           = 'Not Started';
        // tsk14.Priority         = 'High';
        // tsk14.Subject          = 'Call the Lead';
        // tasks.add(tsk14);

        

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch2() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {
        Contact Contact1 = createContact('First1', 'Test1','Buyer;Investor');
        Contact Contact1Copy = createContact('First1', 'Test1','Buyer;Investor');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        
        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch3() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Landlord;Property Management Company');
        Contact Contact1Copy = createContact('First1', 'Test1','Landlord;Property Management Company');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch4() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Seller; Buyer;Tenant');
        Contact Contact1Copy = createContact('First1', 'Test1','Seller; Buyer;Tenant');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch5() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Landlord; Buyer;Tenant');
        Contact Contact1Copy = createContact('First1', 'Test1','Landlord; Buyer;Tenant');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch6() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Seller;Developer');
        Contact Contact1Copy = createContact('First1', 'Test1','Seller;Developert');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }
    }
    static testMethod void TestcontActivePropAcqDocRecTaskBatch7() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Landlord');
        Contact Contact1Copy = createContact('First1', 'Test1','Landlord');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
        
    
        }
   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch8() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = createContact('First1', 'Test1','Landlord;Mortgage Broker');
        Contact Contact1Copy = createContact('First1', 'Test1','Landlord;Mortgage Broker');


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
        
    
        }
   
    }

}