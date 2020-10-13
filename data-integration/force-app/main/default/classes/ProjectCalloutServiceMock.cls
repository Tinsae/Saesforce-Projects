public class ProjectCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
   public HTTPResponse respond(HTTPRequest req) {
      // Create a fake response.
      // Set response values, and 
      // return response.
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatus('Created');
      res.setStatusCode(201);
      return res;
  }
}