global class listingRecurringTasksBatchSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new listingRecurringTasksBatch());
    } 
}