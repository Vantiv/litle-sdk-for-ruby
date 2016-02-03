require_relative '../../lib/LitleOnline'
#Credit
#litleTxnId contains the Litle Transaction Id returned on 
#the capture or sale transaction being credited
#the amount is optional, if it isn't submitted the full amount will be credited
credit_info =  {'id'=>'test','litleTxnId' => '100000000000000002', 'amount' => '1010'}
credit_response = LitleOnline::LitleOnlineRequest.new.credit(credit_info)
 
#display results
puts "Response: " + credit_response.creditResponse.response
puts "Message: " + credit_response.creditResponse.message
puts "Litle Transaction ID: " + credit_response.creditResponse.litleTxnId

 if (!credit_response.creditResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitleCreditTransaction has not been Approved", caller
 end