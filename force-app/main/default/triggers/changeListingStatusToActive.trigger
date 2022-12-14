trigger changeListingStatusToActive on Task (after insert, after update) {
    if(Trigger.isAfter || Trigger.isUpdate){
        changeListingStatusToActiveHandler.changeStatus(Trigger.New);
       
    }


}