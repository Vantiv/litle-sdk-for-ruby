require 'LitleOnline'
include LitleOnline
 
#Capture
#litleTxnId contains the Litle Transaction Id returned on the authorization
capture_info =  {'litleTxnId' => '100000000000000001'}
capture_response = LitleOnlineRequest.new.capture(capture_info)
 
#display results
puts "Response: " + capture_response.captureResponse.response
puts "Message: " + capture_response.captureResponse.message
puts "Litle Transaction ID: " + capture_response .captureResponse.litleTxnId

if (!capture_response.captureResponse.message.eql?'Approved')
   raise ArgumentError, "LitleCaptureTransaction has not been Approved", caller
end