public class ListingDateUpdateClass {
    public static void accountMethod(List<Contact>aclist,map<id,Contact> oldmap){
        set<id> listId=new set<id>();
		for(Contact ac:aclist){
        Contact listOld=oldmap.get(ac.id);
        if(ac.Name!=listOld.Name){
            listId.add(ac.Id);
        }
    }
 	if(listId.size()>0){  
       //  map<id,Contact> accountmap=new map<id,Contact>([select id,Name,(select id,Name from pba__Listing__r) from Contact where id in:listId]);
    }
}
}