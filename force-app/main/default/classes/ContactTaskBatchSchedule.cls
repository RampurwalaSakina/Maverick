global class ContactTaskBatchSchedule implements schedulable{
	global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new ContactTaskBatch());
    } 
}