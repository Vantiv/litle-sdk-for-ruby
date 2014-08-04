require 'LitleOnline'
include LitleOnline

rfrHash1 = {
        'merchantId'=>101,
        'postDay'=>'2013-06-04'  
}
 
rfrHash2 = {
        'litleSessionId'=>'123123123'
}
      
path = Dir.pwd
request = LitleOnline::LitleRequest.new({'sessionId'=>'8675309'})
request.create_new_litle_request(path)
request.add_rfr_request(rfrHash1)
request.add_rfr_request(rfrHash2)


