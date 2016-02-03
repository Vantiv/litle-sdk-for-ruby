require_relative '../../lib/LitleOnline'
 
#Authorization
#Puts a hold on the funds
auth_hash = {
  'orderId' => '1',
  'id'=>'test',
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
auth_response = LitleOnline::LitleOnlineRequest.new.authorization(auth_hash)
 
#Capture
#Captures the authorization and results in money movement
capture_hash =  {'id'=>auth_response.authorizationResponse.id,
                  'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
capture_response = LitleOnline::LitleOnlineRequest.new.capture(capture_hash)

if (!capture_response.captureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitlePaymentFullLifeCycle's Capture Transaction has not been Approved", caller
end
#Credit
#Refund the customer
credit_hash =  {'id'=>capture_response.captureResponse.id,
                'litleTxnId' => capture_response.captureResponse.litleTxnId}

credit_response = LitleOnline::LitleOnlineRequest.new.credit(credit_hash)

if (!credit_response.creditResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitlePaymentFullLifeCycle's credit Transaction has not been Approved", caller
end
#Void
#Cancel the refund, note that a deposit can be Voided as well
void_hash =  {'id'=>credit_response.creditResponse.id,
              'litleTxnId' => credit_response.creditResponse.litleTxnId}

void_response = LitleOnline::LitleOnlineRequest.new.void(void_hash)

if (!void_response.voidResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitlePaymentFullLifeCycle's Void Transaction has not been Approved", caller
end
