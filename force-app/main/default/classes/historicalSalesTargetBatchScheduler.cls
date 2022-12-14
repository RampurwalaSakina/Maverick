global class historicalSalesTargetBatchScheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new historicalSalesTargetBatch());
    } 
}