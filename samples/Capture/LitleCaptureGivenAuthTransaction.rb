require_relative '../../lib/LitleOnline'
#Capture Given Auth
capture_given_auth_info = {
  'merchantId' => '101',
   'id'=>'test',
  'version'=>'8.8',
  'reportGroup'=>'Planets',
  'orderId'=>'12344',
  'amount'=>'106',
  'authInformation' => {
    'authDate'=>'2002-10-09',
    'authCode'=>'543216',
    'authAmount'=>'12345'
  },
  'orderSource'=>'ecommerce',
  'card'=>{
    'type'=>'VI',
    'number' =>'4100000000000001',
    'expDate' =>'1210'
    }
}
response = LitleOnline::LitleOnlineRequest.new.capture_given_auth(capture_given_auth_info)
 
#display results
puts "Response: " + response.captureGivenAuthResponse.response
puts "Message: " + response.captureGivenAuthResponse.message
puts "Litle Transaction ID: " + response.captureGivenAuthResponse.litleTxnId

if (!response.captureGivenAuthResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitleCaptureGivenAuthTransaction has not been Approved", caller
end