public with sharing class SendEmailUtility {

    public static void sendEmailTo(list<Contact> contacts) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = extractAddressesFromContacts(contacts);
        mail.setToAddresses(sendTo);
        // email payload can be queried from Database in another repository
        mail.setSubject('Reservation Request Received');
        mail.setPlainTextBody('Welcome');
        Messaging.sendEmail(mail);


    }

    public static list<String> extractAddressesFromContacts(list<Contact> contacts) {
        list<String> addresses = new list<String>();
        for(Contact contact: contacts) {
            addresses.add(contact.email);
        }
        return addresses;
    }
    
}
