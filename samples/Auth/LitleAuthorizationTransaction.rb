require_relative '../../lib/LitleOnline'
 
#Authorization
auth_info = {
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
auth_response = LitleOnline::LitleOnlineRequest.new.authorization(auth_info)
 
#display results
puts "Response: " + auth_response.authorizationResponse.response
puts "Message: " + auth_response.authorizationResponse.message
puts "Litle Transaction ID: " + auth_response.authorizationResponse.litleTxnId

if (!auth_response.authorizationResponse.message.eql?'Approved')
   raise ArgumentError, "LitleAuthorizationTransaction has not been Approved", caller
end

