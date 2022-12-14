@istest
class contQualBookDepRecvTaskSchedulerTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		contQualBookDepRecvTaskBatchSchedule testsche = new contQualBookDepRecvTaskBatchSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}