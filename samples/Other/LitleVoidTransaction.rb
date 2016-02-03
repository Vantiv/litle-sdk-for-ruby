require_relative '../../lib/LitleOnline'
 
#Void
void_info = {
  #litleTxnId contains the Litle Transaction Id returned on the deposit/refund
  'litleTxnId' => '100000000000000001',
  'id'=>'test'
}
 
response = LitleOnline::LitleOnlineRequest.new.void(void_info)
 
#display results
puts "Response: " + response.voidResponse.response
puts "Message: " + response.voidResponse.message
puts "Litle Transaction ID: " + response.voidResponse.litleTxnId

 if (!response.voidResponse.message.eql?'Transaction Received')
   raise ArgumentError, "LitleVoidTransaction has not been Approved", caller
 end