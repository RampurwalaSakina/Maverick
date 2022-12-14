@isTest
public  class contActivePropAcqDocRecTaskBatchScheduleTest {

    @isTest static void testMethod1(){
        Test.StartTest();
        contActivePropAcqDocRecTaskBatchSchedule sh1 = new contActivePropAcqDocRecTaskBatchSchedule();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
    }
        
    
}
