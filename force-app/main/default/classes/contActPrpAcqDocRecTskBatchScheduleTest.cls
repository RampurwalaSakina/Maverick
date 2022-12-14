@istest
class contActPrpAcqDocRecTskBatchScheduleTest{
  public static testMethod void testschedule() {
    Test.StartTest();
    contActivePropAcqDocRecTaskBatchSchedule testsche = new contActivePropAcqDocRecTaskBatchSchedule();
    String sch = '0 0 23 * * ?';
    system.schedule('Test status Check', sch, testsche );
    Test.stopTest();
  }
}