public class Deemo {
	public static void testschedule() {
    Test.StartTest();
    listingRecurringTasksBatchSchedule testsche = new listingRecurringTasksBatchSchedule();
    String sch = '0 0 00 * * ?';
    system.schedule('Test status Check', sch, testsche );
    Test.stopTest();
    System.debug('Success');
  }
}