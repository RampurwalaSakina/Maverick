public class test {
    public static boolean recursionController = false;
    
    public static void changeStatus(List<Task> taskList){
        System.debug('Task record=='+JSON.serialize(taskList));
        if(!TaskTriggerHandler.recursionController){
            try{
                Set<Id> ListingIdSet = new Set<Id>();
                if(taskList.size() >0){
                    for(Task t :taskList){
                        ListingIdSet.add(t.WhatId);
                    }
                }
                
                List<pba__Listing__c> newRentList = new List<pba__Listing__c>();
                
                if(ListingIdSet.size() > 0){
                    
                    List<pba__Listing__c> listing =[SELECT Id ,RecordType.Name, RecordTypeId, Name, pba__Status__c , pba__ListingType__c FROM pba__Listing__c Where Id IN:ListingIdSet];
                    
                    for(pba__Listing__c pbaList :listing){
                        for(Task tsk :taskList){

                            if(tsk.WhatId == pbaList.Id){
                                System.debug('recordtyep==='+pbaList.RecordType.Name);
                                System.debug('task status==='+tsk.Is_the_Property_still_with_Landlord__c);
                                System.debug('Listing status==='+pbaList.pba__Status__c);
                                
                                if(pbaList.RecordType.Name == 'Rent' && pbaList.pba__Status__c == 'Active'){
                                    tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                                }else if(pbaList.RecordType.Name == 'Rent' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Rented') ){
                                    tsk.Is_the_Property_still_with_Landlord__c = 'Rented';
                                }else if(pbaList.RecordType.Name == 'Sale' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Sold') ){
									 tsk.Is_the_Property_still_with_Landlord__c = 'Sold';   
                                }else if(pbaList.RecordType.Name == 'Sale' && pbaList.pba__Status__c == 'Active' ){
                                	tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                                }
                                // if(pbaList.RecordType.Name == 'Rent' && tsk.Is_the_Property_still_with_Landlord__c == 'Available' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Rented')){
                                //     System.debug('In First==');
                                //     tsk.addError('Change Listing Status To Active');
                                // }else if(pbaList.RecordType.Name == 'Rent' && tsk.Is_the_Property_still_with_Landlord__c == 'Rented' && pbaList.pba__Status__c == 'Active' ){
                                //     System.debug('In Seconf==');
                                //     tsk.addError('Update Listings Status to Rented/Withdrawn');
                                // }else if(pbaList.RecordType.Name == 'Sale' && tsk.Is_the_Property_still_with_Landlord__c == 'Available' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Sold')){
                                //     System.debug('In Third==');
                                //     tsk.addError('Update Listings Status to Active');                                	
                                // }else if(pbaList.RecordType.Name == 'Sale' && tsk.Is_the_Property_still_with_Landlord__c == 'Sold' && pbaList.pba__Status__c == 'Active'){
	                            //     System.debug('In Fourth==');
                                //     tsk.addError('Update Listings Status to Sold/Withdrawn');                                	
                                // }
                                /*if(tsk.Is_the_Property_still_with_Landlord__c == 'Available' && pbaList.RecordTypeId.Name = 'Rent' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Rented')){
                                    tsk.addError('Change Listing Status To Active');
                                }
                                
                               	if(tsk.Is_the_Property_still_with_Landlord__c == 'Rented' && pbaList.pba__ListingType__c =='Rent'){
                                    pbaList.pba__Status__c = tsk.Is_the_Property_still_with_Landlord__c;
                                    newRentList.add(pbaList);  
                                }*/
                            }
                        }
                        
                    }
                    
                    
                }
                /*if(newRentList.size() > 0){
                    update newRentList;
                    TaskTriggerHandler.recursionController = true;
                }*/
            }catch(Exception e){
                System.debug(e);
            }     
            
        }
    }
    public static void checkStatus(List<Task> taskList){
        if(!TaskTriggerHandler.recursionController){
            try{
                Set<Id> ListingIdSet = new Set<Id>();
                if(taskList.size() >0){
                    for(Task t :taskList){
                        ListingIdSet.add(t.WhatId);
                    }
                }
                
                List<pba__Listing__c> newRentList = new List<pba__Listing__c>();
                
                if(ListingIdSet.size() > 0){
                    
                    List<pba__Listing__c> listing =[SELECT Id ,RecordType.Name, RecordTypeId, Name, pba__Status__c , pba__ListingType__c FROM pba__Listing__c Where Id IN:ListingIdSet];
                    
                    for(pba__Listing__c pbaList :listing){
                        for(Task tsk :taskList){

                            if(tsk.WhatId == pbaList.Id){
                                System.debug('recordtyep==='+pbaList.RecordType.Name);
                                System.debug('task status==='+tsk.Is_the_Property_still_with_Landlord__c);
                                System.debug('Listing status==='+pbaList.pba__Status__c);
                                
                                
                                if(pbaList.RecordType.Name == 'Rent' && tsk.Is_the_Property_still_with_Landlord__c == 'Available' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Rented')){
                                    System.debug('In First==');
                                    tsk.addError('Change Listing Status To Active');
                                }else if(pbaList.RecordType.Name == 'Rent' && tsk.Is_the_Property_still_with_Landlord__c == 'Rented' && pbaList.pba__Status__c == 'Active' ){
                                    System.debug('In Seconf==');
                                    tsk.addError('Update Listings Status to Rented/Withdrawn');
                                }else if(pbaList.RecordType.Name == 'Sale' && tsk.Is_the_Property_still_with_Landlord__c == 'Available' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Sold')){
                                    System.debug('In Third==');
                                    tsk.addError('Update Listings Status to Active');                                	
                                }else if(pbaList.RecordType.Name == 'Sale' && tsk.Is_the_Property_still_with_Landlord__c == 'Sold' && pbaList.pba__Status__c == 'Active'){
	                                System.debug('In Fourth==');
                                    tsk.addError('Update Listings Status to Sold/Withdrawn');                                	
                                }
                              
                            }
                        }
                        
                    }
                    
                    
                }
                /*if(newRentList.size() > 0){
                    update newRentList;
                    TaskTriggerHandler.recursionController = true;
                }*/
            }catch(Exception e){
                System.debug(e);
            }  
        }
    }
}