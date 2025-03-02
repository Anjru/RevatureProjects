@isTest
global class AnimalLocatorFailureMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404); // Simulate a failure
        response.setBody('{"error": "Not Found"}');
        return response;
    }
}