trigger sendEmailOnNewClosing on pba__Closing__c (after insert) {
    
    set<id> ContactId = new set<id>();
    Set<Id> listingIds = new Set<Id>();
    // Step 0: Create a master list to hold the emails we'll send
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
    for (pba__Closing__c newClo : Trigger.new) {
        if (newClo.pba__Listing__c != null) {
            listingIds.add(newClo.pba__Listing__c);
        }
    }
    
    Map<Id, pba__Listing__c> listingMap = new Map<Id, pba__Listing__c>([Select PropertyOwnerContact__c, pba_uaefields__Community_Propertyfinder__c, pba_uaefields__Sub_Community_Propertyfinder__c from pba__Listing__c Where Id in: listingIds]);
	
    Set<Id> landlordIds = new Set<Id>();
    for (pba__Closing__c newClo : Trigger.new) {
        if (newClo.pba__Listing__c != null && listingMap.containsKey(newClo.pba__Listing__c)){
            landlordIds.add(listingMap.get(newClo.pba__Listing__c).PropertyOwnerContact__c);
        }
        /*else{
            if(newClo.Seller__c != null){
                landlordIds.add(newClo.Seller__c);
            }   
        }*/
    }
    system.debug('Size of Listing -->'+listingIds.size());
    system.debug('Size of Landlord -->'+landlordIds.size());
    system.debug('Id of Landlord -->'+landlordIds);
    
    if(landlordIds.size()>0) {
        
        //Map<Id, pba__Listing__c> listingMap = new Map<Id, pba__Listing__c>([Select PropertyOwnerContact__c, pba_uaefields__Community_Propertyfinder__c, pba_uaefields__Sub_Community_Propertyfinder__c from pba__Listing__c Where Id in: listingIds]);
        Map<Id, Contact> conMap = new Map<Id, Contact>([Select createdby.Name, Previous_Agent__c, Previous_Agent_Role__c, Previous_Agent_Email__c, createdby.UserRole.DeveloperName from Contact Where Id in: landlordIds and (Previous_Agent_Role__c = 'TeleSales' OR createdby.UserRole.DeveloperName = 'TeleSales' )]);
        system.debug('Size of Map -->'+conMap.size());
        if(conMap.size()>0) {
            for (pba__Closing__c newClosing : Trigger.new) {
                system.debug('Inside For loop-->' +conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c));
                //system.debug('Inside For loop-->' +conMap.get(newClosing.Seller__c));
                if (listingMap.get(newClosing.pba__Listing__c) != null && (conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c).Previous_Agent_Role__c == 'TeleSales' ||conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c).createdby.UserRole.DeveloperName == 'TeleSales')) {
                    system.debug('Inside first if');
                    ContactId.add(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c); 
                } 
                /*else {
                    if (newClosing.Seller__c != null && ( conMap.get(newClosing.Seller__c).Previous_Agent__c == 'Charm Sunga' || conMap.get(newClosing.Seller__c).createdby.Name == 'Charm Sunga')) {   
                        system.debug('Inside 2nd if');
                        ContactId.add(newClosing.Seller__c);
                    }
                }*/
                
                Contact con = [Select firstname, lastname, id, name, createdby.email, Previous_Agent_Email__c, createdby.Name, Previous_Agent__c from Contact where id in :ContactId];
                system.debug('Value in Contact -->'+con);
                // Step 1: Create a new Email
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                
                // Step 2: Set list of people who should get the email
                List<String> sendTo = new List<String>();
                //sendTo.add('vansh@maverickrealty.ae');
                //sendTo.add('charm@maverickrealty.ae');
                if(conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c).Previous_Agent_Role__c == 'TeleSales' && conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c).createdby.UserRole.DeveloperName == 'TeleSales') {
                    sendTo.add(con.Previous_Agent_Email__c);
                }else{
                    if(conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c).createdby.UserRole.DeveloperName == 'TeleSales'){
                        sendTo.add(con.createdby.email);
                    }else{
                        if(conMap.get(listingMap.get(newClosing.pba__Listing__c).PropertyOwnerContact__c).Previous_Agent_Role__c == 'TeleSales')
                            sendTo.add(con.Previous_Agent_Email__c);
                    }
                }
                system.debug('Contact Previous Agent Email -->'+sendTo);
                mail.setToAddresses(sendTo);
                system.debug('Listing -->'+newClosing.pba__Listing__c);
                // Step 3: Set who the email is sent from
                mail.setReplyTo('admin@maverickrealty.ae');
                mail.setSenderDisplayName('Maverick Realty');
                
                // Step 4. Set email contents - you can use variables!
                //mail.setSubject('A new Closing created for '+con.name);
                mail.setSubject('Hurray! You have a new closing');
                String body = 'Hello '+con.Previous_Agent__c+''+'<br/><br/>';
                body += 'Congratulations for this new closing. Keep up the hard work and consistency.'+'<br/>';
                body += 'Below are the closing details for your reference:'+'<br/><br/>';
                body += '<b>Closing ID - </b>'+newClosing.Name+'<br/>';
                body += '<b>Name - </b>'+con.Name+'<br/>';
                body += '<b>Total Commission Amount - </b>AED '+newClosing.TotalCommissionAmount__c+'<br/>';
                body += '<b>Community - Propertyfinder - </b>'+listingMap.get(newClosing.pba__Listing__c).pba_uaefields__Community_Propertyfinder__c+'<br/><br/>';
                //body += '<b>Sub Community - Propertyfinder - </b>'+listingMap.get(newClosing.pba__Listing__c).pba_uaefields__Sub_Community_Propertyfinder__c+'<br/>';
                
                body += 'Best Regards,'+'<br/><br/>';
                //body += '<html><body><image src="https://my-maverickae--maverick--c.documentforce.com/servlet/servlet.ImageServer?id=0153H000000DtUB&oid=00D3H0000008k8R&lastMod=1614074801000"/>';
                body += '<html><body><image src="https://c.cs122.content.force.com/servlet/servlet.ImageServer?id=0153H000000DtUB&oid=00D3H0000008k8R&lastMod=1614074801000" /></body></html>';
                body += '<b>Maverick Realty</b>'+'<br/>';
                body += 'Suite 2003, Opal Tower'+'<br/>';
                body += 'Al Abraj Street, Business Bay, Dubai, UAE'+'<br/>';
                body += 'P.O.Box: 86236'+'<br/>';
                body += 'ORN: 16455'+'<br/>';
                body += 'T: +971 4 4579928'+'<br/>';
                body += 'M:+971-564479823'+'<br/>';
                body += '<b>maverickrealty.ae</b>';
                
                system.debug('Body -->'+body);
                mail.setHtmlBody(body);
                system.debug('Mail -->'+mail);   
                // Step 5. Add your email to the master list
                mails.add(mail);
                // Step 6: Send all emails in the master list
                Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                                 + results[0].errors[0].message);
                }
            }
        }
    }
}