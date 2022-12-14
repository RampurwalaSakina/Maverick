public with sharing class changeListingStatusToActiveHandler {
    
    public static void changeStatus(List<Task> taskList){
        try{
        Set<Id> ListingId = new Set<Id>();
        if(taskList.size() >0){
            for(Task t :taskList){
                ListingId.add(t.WhatId);
            }
        }

        List<pba__Listing__c> newRentList = new List<pba__Listing__c>();

        List<pba__Listing__c> listing =[Select Id , pba__Status__c , pba__ListingType__c , Name FRom pba__Listing__c Where Id=:ListingId];
       if(listing.size() > 0){
        for(pba__Listing__c pbaList :listing){
            for(Task tsk :taskList){
                if(tsk.Is_the_Property_still_with_Landlord__c == 'Available' && (pbaList.pba__Status__c == 'Withdrawn' || pbaList.pba__Status__c== 'Rented')){
                    tsk.addError('Change Listing Status To Active');
                }

                if(tsk.Is_the_Property_still_with_Landlord__c == 'Rented' && pbaList.pba__ListingType__c =='Rent'){
                    pbaList.pba__Status__c = tsk.Is_the_Property_still_with_Landlord__c;
                    newRentList.add(pbaList);  
                }
        }

    }

       }
       


        if(newRentList.size() > 0){
            update newRentList;
        }
    }catch(Exception e){
        
    }

    }
}