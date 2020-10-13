public class BillingCalloutServiceMock implements WebServiceMock{
   //Implement http mock callout here
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
         BillingServiceProxy.billProjectResponse_element responseElement;
         responseElement = new BillingServiceProxy.billProjectResponse_element();
         responseElement.status = 'OK';
         response.put('response_x', responseElement);
   }
}