global class contActivePropAcqDocRecTaskBatchSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new contActivePropAcqDocRecTaskBatch());
    } 
}