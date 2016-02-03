require_relative '../../lib/LitleOnline'
#Force Capture
force_capture_info = {
  'merchantId' => '101',
    'id'=>'test',
  'version'=>'8.8',
  'reportGroup'=>'Planets',
  'litleTxnId'=>'123456',
  'orderId'=>'12344',
  'amount'=>'106',
  'orderSource'=>'ecommerce',
  'card'=>{
    'type'=>'VI',
    'number' =>'4100000000000001',
    'expDate' =>'1210'
  }
}
response= LitleOnline::LitleOnlineRequest.new.force_capture(force_capture_info)
 
#display results
puts "Response: " + response.forceCaptureResponse.response
puts "Message: " + response.forceCaptureResponse.message
puts "Litle Transaction ID: " + response.forceCaptureResponse.litleTxnId

if (!response.forceCaptureResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitleForceCaptureTransaction has not been Approved", caller
end