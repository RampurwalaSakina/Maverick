public class updateMultiSelectPicklistFieldListing {
    public static void updateMSelectPickField (pba__Listing__c[] Listing){
        for(pba__Listing__c c: Listing){        
            String PrivatePickValuesStr;
            String CommercialPickValuesStr;
			if(!String.isBlank(c.pba_uaefields__Private_Amenities__c)){
                System.Debug('Private Amenities is not Blank');
				List<String> pickValues = c.pba_uaefields__Private_Amenities__c.split(';');
				for(String str : pickValues){
					if(String.isBlank(PrivatePickValuesStr)){
						PrivatePickValuesStr = str;
					}
					else{
						PrivatePickValuesStr = PrivatePickValuesStr + '; ' + str;
					}
				}
			}
			c.Private_Amenities_Multiselect_to_Text__c = PrivatePickValuesStr;  
            if(!String.isBlank(c.pba_uaefields__Commercial_Amenities__c)){
                System.Debug('Commercial Amenities is not Blank');
				List<String> commPickValues = c.pba_uaefields__Commercial_Amenities__c.split(';');
				for(String commStr : commPickValues){
					if(String.isBlank(CommercialPickValuesStr)){
						CommercialPickValuesStr = commStr;
					}
					else{
						CommercialPickValuesStr = CommercialPickValuesStr + '; ' +commStr;
					}
				}
			}
            c.Commercial_Amenities_Multiselect_to_Text__c = CommercialPickValuesStr;
        }
    }
}