public class updateMultiSelectPicklistField {
    public static void updateMSelectPickField (Contact[] Contact1){
        for(Contact c: Contact1){        
            String pickValuesStr;
			if(!String.isBlank(c.pba__ContactType_pb__c)){
                System.Debug('Contact Type is not Blank');
				List<String> pickValues = c.pba__ContactType_pb__c.split(';');
				for(String str : pickValues){
					if(String.isBlank(pickValuesStr)){
						pickValuesStr = str;
					}
					else{
						pickValuesStr = pickValuesStr + '; ' + str;
					}
				}
			}
			c.Contact_Type_Multiselect_to_Text__c = pickValuesStr;  
        }
    }
}