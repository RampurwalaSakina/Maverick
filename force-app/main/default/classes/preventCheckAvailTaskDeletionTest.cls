@isTest
private class preventCheckAvailTaskDeletionTest {
	
    static testMethod void testPreventCheckAvailTaskDel(){
        Task taskRecord = new Task(Subject='testAccount');
        insert taskRecord;
        
        try{
            delete taskRecord;
        }catch(DMLexception e){
            system.assert(e.getMessage().contains('This task Cannot be deleted'),'This task Cannot be deleted');                       
        }
    }
}