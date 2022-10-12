public class CaseTriggerHelper {

    public static void validateReservationRequests(list<Case> reservationRequests) {
        List<ID> accountsIDs = new List<ID>();
        for(Case request : reservationRequests){
            accountsIDs.add(request.AccountId);
        }

        Map<ID, Account> accountsMap = new Map<ID, Account>([SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE Id IN : accountsIds]);
        
        for(Case reservationRequest: reservationRequests) { 

            if(reservationRequest != null && reservationRequest.AccountId != null){
                // using layering (soc) (Data access layer)
                // query inside loop removed
                Account account = accountsMap.get(reservationRequest.AccountId);
                Integer contactsCount = account.Contacts.size();
                checkRequestErrors(reservationRequest, contactsCount);
            }else{
                // labels
                //System.labels.
                reservationRequest.addError('You cannot create a request without attaching an account');
            }
         
        }
    }

    // didn't take old reservation requests in consideration

    /* public static void sendRequestsToReservationSystem(list<Case> reservationRequests) {
        Set<ID> accountIds = new Set<ID>();
        for(Case reservationRequest: reservationRequests) {
            // we can use a constant or utility class to avoid hardcoding 'closed'
            if(r.Status == 'Closed'){
                accountIds.add(reservationRequest.accountId);
            }
        }
        ExternalSystemService.registerAttendees(accountIds);
    } */

    public static void sendRequestsToReservationSystem(List <Case> updatedCases, Map<Id, Case> oldCasesMap){
        List<Id> accountsIDs = new List<Id>();
        for(Case updatedCase : updatedCases){
            Case oldCaseId = oldCasesMap.get(updatedCase.Id);
            if (oldCaseId.Status != 'Closed' && updatedCase.Status == 'Closed'){
                accountsIDs.add(updatedCase.accountId);
            }
        }
        ExternalSystemService.registerAttendees(accountsIDs);
    }
    // labels

    private Static void checkRequestErrors(Case request, Integer contactsCount) {
        if(contactsCount ==0){     
            request.addError('You cannot create a request for accounts without contacts');
            //Log.error('You cannot create a request for accounts without contacts');
        }  else {
            switch on request.Origin {
                when 'Web' {
                    if(contactsCount >= 2 ){
                        request.addError('Web request are only allowed to have one attendee');
                        //Log.error('Web request are only allowed to have one attendee');
                    }
                }
                when 'Phone'{
                    if(contactsCount >= 4 ){
                        request.addError('Phone request are only allowed to have three attendee');
                        //Log.error('Phone request are only allowed to have three attendee');
                    }
                }
            }                          
        }
    }
}