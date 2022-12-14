global class createDuplicateContactBatchSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new createDuplicateContactBatch());
    } 
}