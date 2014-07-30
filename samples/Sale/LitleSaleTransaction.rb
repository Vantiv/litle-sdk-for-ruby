require 'LitleOnline'
include LitleOnline
 
#Sale
my_sale_info = {
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
  'number' =>'5***********5100',
  'expDate' => '0112',
  'cardValidationNum' => '349',
  'type' => 'MC'}
}
sale_response = LitleOnlineRequest.new.sale(my_sale_info)
 
#display results
puts "Response: " + sale_response.saleResponse.response
puts "Message: " + sale_response.saleResponse.message
puts "Litle Transaction ID: " + sale_response.saleResponse.litleTxnId
