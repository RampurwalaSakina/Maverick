global class contQualBookDepRecvTaskBatchSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new contQualBookDepRecvTaskBatch());
    } 
}