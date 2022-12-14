@istest
class createDuplicateContactBatchScheduleTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		createDuplicateContactBatchSchedule testsche = new createDuplicateContactBatchSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}