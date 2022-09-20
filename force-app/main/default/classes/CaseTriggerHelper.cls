public class CaseTriggerHelper {

    public static void validateReservationRequests(list<Case> reservationRequests) {
        for(Case reservationRequest: reservationRequests) {
        
            ID accountId = reservationRequest.accountId;

            if(resRequest != null && resRequest.AccountId != null){
                // using layering (soc) (Data access layer)
                Account account = AccountRepository.getAccountById(accountId);
                Integer contactsCount = account.Contacts.size();
                checkRequestErrors(reservationRequest, contactsCount);
            }else{
                resRequest.addError('You cannot create a request without attaching an account');
            }
         
        }
    }

    public static void sendRequestsToReservationSystem(list<Case> reservationRequests) {
        Set<ID> accountIds = new Set<ID>();
        for(Case reservationRequest: reservationRequests) {
            // we can use a constant or utility class to avoid hardcoding 'closed'
            if(r.Status == 'Closed'){
                accountIds.add(reservationRequest.accountId);
            }
        }
        ExternalSystemService.registerAttendees(accountIds);
    }
    

    private Static void checkRequestErrors(Case request, Integer contactsCount) {
        if(contactsCount ==0){     
            request.addError('You cannot create a request for accounts without contacts');
            Log.error('You cannot create a request for accounts without contacts');
        }  else {
            switch on request.Origin {
                when 'Web' {
                    if(contactsCount >= 2 ){
                        request.addError('Web request are only allowed to have one attendee');
                        Log.error('Web request are only allowed to have one attendee');
                    }
                }
                when 'Phone'{
                    if(contactsCount >= 4 ){
                        request.addError('Phone request are only allowed to have three attendee');
                        Log.error('Phone request are only allowed to have three attendee');
                    }
                }
            }                          
        }
    }
}