trigger preventCheckAvailTaskDeletion on Task (before delete) {
	/*for(Task checkAvailTask : trigger.old){
        if(checkAvailTask.Subject.contains('Check Availability')){
        	checkAvailTask.adderror('This task Cannot be deleted');
        }
    }*/
}