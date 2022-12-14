@istest
class contactCalledNoReplySchedulerTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		contactCalledNoReplyRecBatchSchedule testsche = new contactCalledNoReplyRecBatchSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}