@istest
class historicalSalesTargetBatchSchedulerTest{
  public static testMethod void testschedule() {
    Test.StartTest();
    historicalSalesTargetBatchScheduler testsche = new historicalSalesTargetBatchScheduler();
    String sch = '0 0 23 * * ?';
    system.schedule('Test status Check', sch, testsche );
    Test.stopTest();
  }
}