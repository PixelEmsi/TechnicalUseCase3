public class ContactCalloutService { 

    // url is hardcoded look for another alternative
    private String webServiceURL;

    public ExternalSystemService(){
        this.webServiceURL = 'https://th-apex-http-callout.herokuapp.com/animals';
    }

    public static HttpResponse fireCallout(List<Contact> contacts){
        
        Map<String, Object> contactsData = buildContactsData(contacts);
        // found this pattern on the web it encapsulates everything and let us use object chaining 
        CalloutUtils callout = new CalloutUtils();
        // use a configuration class
        callout.endPoint()        	      
                .method('POST')            
                .addHeader('Content-Type', 'application/json;charset=UTF-8')
                .body(JSON.serialize(payload));    
                            
        HttpResponse response = callout.send();
        return response;
    }
    
    private static Map<String, Object> buildContactsData(List<Contact> contacts){
        Map<String, Object> result = new Map<String, Object>();
        for(Contact contact : contacts){
            result.put('name', contact.name +'-'+contact.email);
        }
        return result;
    }
    
}