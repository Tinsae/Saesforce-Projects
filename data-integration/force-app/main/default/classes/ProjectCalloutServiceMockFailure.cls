public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
    public HTTPResponse respond(HTTPRequest req) {
      // Create a fake response.
      // Set response values, and 
      // return response.
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatus('Failure');
      res.setStatusCode(500);
      return res;
  }
}