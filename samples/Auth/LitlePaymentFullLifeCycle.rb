require 'LitleOnline'
include LitleOnline
 
#Authorization
#Puts a hold on the funds
auth_hash = {
  'orderId' => '1',
  'amount' => '10010',
  'orderSource'=>'ecommerce',
  'billToAddress'=>{
  'name' => 'John Smith',
  'addressLine1' => '1 Main St.',
  'city' => 'Burlington',
  'state' => 'MA',
  'zip' => '01803-3747',
  'country' => 'US'},
  'card'=>{
  'number' =>'4**************9',
  'expDate' => '0112',
  'cardValidationNum' => '349',
  'type' => 'VI'}
}
auth_response = LitleOnlineRequest.new.authorization(auth_hash)
 
#Capture
#Captures the authorization and results in money movement
capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
capture_response = LitleOnlineRequest.new.capture(capture_hash)
 
#Credit
#Refund the customer
credit_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId}
credit_response = LitleOnlineRequest.new.credit(credit_hash)
 
#Void
#Cancel the refund, note that a deposit can be Voided as well
void_hash =  {'litleTxnId' => credit_response.creditResponse.litleTxnId}
void_response = LitleOnlineRequest.new.void(void_hash)