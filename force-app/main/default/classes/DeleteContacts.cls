public class DeleteContacts {
    @future
    public static void deleteNow(String[] contactRecForDeleteList)
    {
        List<Contact> recordDeleteList=new List<Contact>();
        for(Id recId: contactRecForDeleteList)
        {
            Contact contactRec=new Contact(id=recId);
            recordDeleteList.add(contactRec);
        }
        delete recordDeleteList;
    }
}