trigger NotifyOnContactDelete on Contact (after delete) {
    system.debug('Delete Start');
    Messaging.reserveSingleEmailCapacity(trigger.size);
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Contact cont : Trigger.old) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'pralayankar.monu@gmail.com'});
        email.setSubject('Deleted Contact Alert');
        email.setPlainTextBody('This message is to alert you that the contact named ' + cont.FirstName + ' has been deleted.');
        emails.add(email);
        system.debug('Email Body-->');
    }
    
    Messaging.sendEmail(emails);

}