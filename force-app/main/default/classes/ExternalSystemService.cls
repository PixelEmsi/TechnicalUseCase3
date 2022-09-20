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
    // To be reviewed
    public void notifyAttendeeByEmail(List<Contact> contacts){
        // If email is sent now why need a task for it
        addTasks(contacts);
        SendEmailUtility.sendEmailTo(contacts);

    } 

    public static void addTasks(list<Contact> contacts) {
        List<Task> taskList = new List<Task>();
        for(Contact contact : contacts) {
            Task task = new Task();
            task.Subject = 'Send Email To' + contact.name;
            task.Status = 'Open';
            task.Priority = 'Normal';
            task.WhatId = contact.accountId;
            taskList.add(task);
        }

        if(taskList.size() > 0) {
            insert taskList;
        }
        
    }
}
