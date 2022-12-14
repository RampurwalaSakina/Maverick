global class rentalClosingRecurringTaskBatchScheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new rentalClosingRecurringTaskBatch());
    } 
}