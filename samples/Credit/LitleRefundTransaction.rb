require_relative '../../lib/LitleOnline'
#Stand alone credit
credit_info = {
  'orderId' => '1',
   'id'=>'test',
  'amount' => '1010',
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
credit_response= LitleOnline::LitleOnlineRequest.new.credit(credit_info)
 
#display results
puts "Response: " + credit_response.creditResponse.response
puts "Message: " + credit_response.creditResponse.response
puts "Litle Transaction ID: " + credit_response.creditResponse.litleTxnId

 if (!credit_response.creditResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitleRefundTransaction has not been Approved", caller
 end