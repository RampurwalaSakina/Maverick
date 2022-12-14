trigger NoDeleteonTask on Task (before delete)
{
   String ProfileId = UserInfo.getProfileId();  
   List<Profile> profiles=[select id from Profile where name='PB Administrator'];

       for (Task a : Trigger.old)      
       {            
          if ( (ProfileId!=profiles[0].id) && (a.Contact__c!=null || a.Listing__c!=null ) )
          {
             a.Description.addError('You cannot delete this task record');
          }
       }            
}