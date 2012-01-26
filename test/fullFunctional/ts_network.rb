require_relative '../../lib/LitleOnline'
require_relative '../../lib/LitleOnlineRequest'
require 'mocha'

#test Authorization Transaction
class TestNetwork < Test::Unit::TestCase
                             
                def test_httpsSystem
                                hash = {
                         	'merchantId' => '101',
                                'user' => 'PHXMLTEST',
                                'password'=> 'certpass',
                                 'version'=>'8.8',
                                'reportGroup'=>'Planets',
                                'orderId'=>'12344',
                                'amount'=>'106',
                                'orderSource'=>'ecommerce',
                                'card'=>{
                                'type'=>'VI', 
                                 'number' =>'4100000000000001',
                                'expDate' =>'1210'
                                }}

                                XMLObject.expects(:new).with(regexp_matches(/<litleOnliseResponse.*/m))
				
                                response = LitleOnlineRequest.authorization(hash)
				
		end
		#def test_url		
end
