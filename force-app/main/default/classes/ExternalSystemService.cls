public  class ExternalSystemService {
    // no need to pass cases its useless
    // nested loops make the code complicated and not readeable
    @future(callout=true)
    public static void registerAttendees(list<ID> accountIds){
        
        list<Contact> attendees = ContactRepository.getContactsByAccountIds(accountIds);
      
        // send request
        HttpResponse response = ContactCalloutService.fireCallout(attendees);

        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
           // Everything went as expected.
           notifyAttendeeByEmail(attendees);
        }

    }

    public void notifyAttendeeByEmail(Contact account){
      
        Task tk = new Task();
        tk.Subject = 'Send Email To' + account.name;
        tk.Status = 'Open';
        tk.Priority = 'Normal';
        tk.WhatId = account.ID;
        insert tk;
    } 
}
