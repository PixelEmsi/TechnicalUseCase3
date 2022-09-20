trigger CaseBeforeInsertTrigger on Case (before insert) {
    
    // Bulkifying Code
    for(Case reservationRequest: Trigger.new) {
        
        ID accountId = reservationRequest.accountId;

        if(reservationRequest == null || accountId == null) {
            reservationRequest.addError('You cannot create a request without attaching an account');
        }

        // using layering (soc)
        Account account = AccountService.getAccountById(accountId);
        Integer contactsCount = account.Contacts.size();
        checkRequestErrors(reservationRequest, contactsCount);
     
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