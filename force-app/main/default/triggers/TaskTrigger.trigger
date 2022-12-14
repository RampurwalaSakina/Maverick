trigger TaskTrigger on Task ( after insert, after update,before update) {

    /*if(Trigger.isAfter || Trigger.isUpdate){
        TaskTriggerHandler.changeStatus(Trigger.New);   
    }else if(Trigger.isAfter || Trigger.isInsert){
        TaskTriggerHandler.changeStatus(Trigger.New);   
    }
if(Trigger.isAfter || Trigger.isUpdate){
        TaskTriggerHandler.CheckStatus(Trigger.New);   
    }else if(Trigger.isAfter || Trigger.isInsert){
        TaskTriggerHandler.CheckStatus(Trigger.New);   
    }

    if(Trigger.isBefore || Trigger.isUpdate){
        TaskTriggerHandler.changeStatus(Trigger.New);   
    }else if(Trigger.isBefore || Trigger.isInsert){
        TaskTriggerHandler.changeStatus(Trigger.New);   
    }*/
    if(Trigger.isAfter && Trigger.isUpdate){
        TaskTriggerHandler.changeStatus(Trigger.New);   
    }else if(Trigger.isAfter && Trigger.isInsert){
        TaskTriggerHandler.changeStatus(Trigger.New);   
    }
    
    
    
    
    
    
}