public class ExternalSystemService {
    @future(callout=true)
    public static void registerAttendees(list<ID> accountIds){
        
        list<Contact> attendees = ContactRepository.getContactsByAccountIds(accountIds);
        // why not do exception handling in the client web or mobile ??
        HttpResponse response = ContactCalloutService.fireCallout(attendees);

        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
           notifyAttendeeByEmail(attendees);
        }

    }

    public static void notifyAttendeeByEmail(List<Contact> contacts){
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
