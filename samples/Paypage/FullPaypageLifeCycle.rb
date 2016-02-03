require_relative '../../lib/LitleOnline'
hash = {
  'orderId'=>'1234',
  'id'=>'test',
  'amount'=>'106',
  'orderSource'=>'ecommerce',
  'paypage'=>{
    'type'=>'VI',
    'paypageRegistrationId' =>'QU1pTFZnV2NGQWZrZzRKeTNVR0lzejB1K2Q5VDdWMTVqb2J5WFJ2Snh4U0U4eTBxaFg2cEVWaDBWSlhtMVZTTw==',
    'expDate' =>'1210',
    'cardValidationNum' => '123'
  }
}
auth_response = LitleOnline::LitleOnlineRequest.new.authorization(hash)
#display results, sample output from sandbox
puts "Response: " + auth_response.authorizationResponse.response #prints 000
puts "Message: " + auth_response.authorizationResponse.message #prints Approved
puts "Litle Transaction ID: " + auth_response.authorizationResponse.litleTxnId #prints 492578641509469583
puts "Litle Token: " + auth_response.authorizationResponse.tokenResponse.litleToken #prints 1234567890123456 - save this away so you can issue future authorizations against it
 
 if (!auth_response.authorizationResponse.message.eql?'Approved')
   raise ArgumentError, "FullPaypageLifeCycle's auth has not been Approved", caller
 end
#Now, we capture the authorization
hash = {
  'id'=>auth_response.authorizationResponse.id,
  'litleTxnId'=>auth_response.authorizationResponse.litleTxnId #Use the litleTxnId from the auth we want to capture
}
capture_response = LitleOnline::LitleOnlineRequest.new.capture(hash)
puts "Response: " + capture_response.captureResponse.response
puts "Message: " + capture_response.captureResponse.message
puts "Litle Transaction ID: " + capture_response.captureResponse.litleTxnId

  if (!capture_response.captureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "FullPaypageLifeCycle's capture has not been Approved", caller
 end
#Now, we issue a refund against the capture
hash = {
  'id'=>capture_response.captureResponse.id,
  'litleTxnId'=>capture_response.captureResponse.litleTxnId #Use the litleTxnId from the capture we want to refund against
}
credit_response = LitleOnline::LitleOnlineRequest.new.credit(hash)
puts "Response: " + credit_response.creditResponse.response
puts "Message: " + credit_response.creditResponse.message
puts "Litle Transaction ID: " + credit_response.creditResponse.litleTxnId
 
#Now, we issue an auth reversal against the refund
hash = {
  'id'=>credit_response.creditResponse.id,
  'litleTxnId'=>credit_response.creditResponse.litleTxnId #Use the litleTxnId from the capture we want to refund against
}
reversal_response = LitleOnline::LitleOnlineRequest.new.auth_reversal(hash)
puts "Response: " + reversal_response.authReversalResponse.response
puts "Message: " + reversal_response.authReversalResponse.message
puts "Litle Transaction ID: " + reversal_response.authReversalResponse.litleTxnId

 if (!reversal_response.authReversalResponse.message.eql?'Transaction Received')
   raise ArgumentError, "FullPaypageLifeCycle's reversal has not been Approved", caller
 end
#Let's assume next month we want to create a sale for the same card as the original authorization.  The paypageRegistrationId is expired, but we have the token and can use it
hash = {
  'orderId'=>'4321',
  'id'=>'test',
  'amount'=>'106',
  'orderSource'=>'ecommerce',
  'token'=>{
    'type'=>'VI',
    'litleToken' => auth_response.authorizationResponse.tokenResponse.litleToken,
    'expDate' =>'1210'
  }
}
sale_response = LitleOnline::LitleOnlineRequest.new.sale(hash)
puts "Response: " + sale_response.saleResponse.response
puts "Message: " + sale_response.saleResponse.message
puts "Litle Transaction ID: " + sale_response.saleResponse.litleTxnId

if (!sale_response.saleResponse.message.eql?'Approved')
   raise ArgumentError, "FullPaypageLifeCycle's sale has not been Approved", caller
 end