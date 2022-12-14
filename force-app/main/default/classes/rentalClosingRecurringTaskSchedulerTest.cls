@istest
class rentalClosingRecurringTaskSchedulerTest{
  public static testMethod void testschedule() {
    Test.StartTest();
    rentalClosingRecurringTaskBatchScheduler testsche = new rentalClosingRecurringTaskBatchScheduler();
    String sch = '0 0 23 * * ?';
    system.schedule('Test status Check', sch, testsche );
    Test.stopTest();
  }
}