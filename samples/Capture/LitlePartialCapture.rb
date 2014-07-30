require 'LitleOnline'
include LitleOnline
 
#Partial Capture
#litleTxnId contains the Litle Transaction Id returned as part of the authorization
#submit the amount to capture which is less than the authorization amount
#to generate a partial capture
capture_info =  {'litleTxnId' => '320000000000000001', 'amount' => '5005'}
capture_response = LitleOnlineRequest.new.capture(capture_info)
 
#display results
puts "Response: " + capture_response.captureResponse.response
puts "Message: " + capture_response.captureResponse.message
puts "Litle Transaction ID: " + capture_response.captureResponse.litleTxnId