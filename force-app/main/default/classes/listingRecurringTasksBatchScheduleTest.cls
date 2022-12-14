@istest
class listingRecurringTasksBatchScheduleTest{
  public static testMethod void testschedule() {
    Test.StartTest();
    listingRecurringTasksBatchSchedule testsche = new listingRecurringTasksBatchSchedule();
    String sch = '0 0 23 * * ?';
    system.schedule('Test status Check', sch, testsche );
    Test.stopTest();
  }
}