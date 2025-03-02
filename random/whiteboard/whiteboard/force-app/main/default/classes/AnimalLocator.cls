// public with sharing class AnimalLocator {
//     public AnimalLocator() {}

//     // Returns the animal name by calling the external REST endpoint.
//     public static String getAnimalNameById(Integer id) {
//         Http http = new Http();
//         HttpRequest request = new HttpRequest();
//         // Replace <id> with the actual id
//         request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + id);
//         request.setHeader('Content-Type', 'application/json;charset=UTF-8');
//         request.setMethod('GET');

//         HttpResponse response = http.send(request);

//         if (response.getStatusCode() == 200) {
//             // Deserialize the JSON response and return the 'name' property
//             Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
//             if (result.containsKey('name')) {
//                 return (String) result.get('name');
//             }
//         }
//         return null;
//     }
// }


public class AnimalLocator
{

  public static String getAnimalNameById(Integer id)
   {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
          String strResp = '';
           system.debug('******response '+response.getStatusCode());
           system.debug('******response '+response.getBody());
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) 
        {
            // Deserializes the JSON string into collections of primitive data types.
           Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
           Map<string,object> animals = (map<string,object>) results.get('animal');
            System.debug('Received the following animals:' + animals );
            strResp = string.valueof(animals.get('name'));
            System.debug('strResp >>>>>>' + strResp );
        }
        return strResp ;
   }
  
}