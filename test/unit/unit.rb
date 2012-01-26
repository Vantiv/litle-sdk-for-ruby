require_relative '../../lib/LitleOnline'
require_relative '../../lib/LitleOnlineRequest'
require 'test/unit'
require 'mocha'

class Newtest < Test::Unit::TestCase
      def test_simple
          hash = {
                  'merchantId' => '101',
		  'id'=>'001',
                  'reportGroup'=>'Planets',
                  'orderId'=>'12344',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                   }}
                                   
	   Communications.expects(:http_post).with(regexp_matches(/<litleOnlineRequest merchantId="101" .*/m))
	   XMLObject.expects(:new)
	   
           response = LitleOnlineRequest.authorization(hash)
        end
	
	def test_authorization_missing_attributes
	    hash={
		  'id' => '002',
                  'orderId'=>'12344',
		  'reportGroup'=>'Planets',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                 }}

	    exception = assert_raise(RuntimeError){LitleOnlineRequest.authorization(hash)}
	    assert_match /Missing Required Field: @merchantId!!!!/, exception.message	
	end

	def test_authorization_attributes
	    hash={
		  'merchantId' => '101',
                  'reportGroup'=>'Planets',
		  'id' => '003',
                  'orderId'=>'12344',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                 }}

	    Communications.expects(:http_post).with(regexp_matches(/.*<authorization id="003" reportGroup="Planets".*/m))
	    XMLObject.expects(:new)

	    response = LitleOnlineRequest.authorization(hash)
	end

	def test_authorization_elements
	    hash={
		  'merchantId' => '101',
                  'reportGroup'=>'Planets',
		  'id' => '004',
                  'orderId'=>'12344',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                 }}

	    Communications.expects(:http_post).with(regexp_matches(/.*<authorization.*<orderId>12344.*<amount>106.*<orderSource>ecommerce.*/m))
	    XMLObject.expects(:new)

	    response = LitleOnlineRequest.authorization(hash)
	end

	def test_authorization_card_field
	    hash={
		  'merchantId' => '101',
                  'reportGroup'=>'Planets',
		  'id' => '005',
                  'orderId'=>'12344',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                 }}

	    Communications.expects(:http_post).with(regexp_matches(/.*<authorization.*<card>.*<number>4100000000000001.*<expDate>1210.*/m))
	    XMLObject.expects(:new)

	    response = LitleOnlineRequest.authorization(hash)
	end

	def test_sale_card_field
	    hash={
		  'merchantId' => '101',
                  'reportGroup'=>'Planets',
		  'id' => '006',
                  'orderId'=>'12344',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                 }}

	    Communications.expects(:http_post).with(regexp_matches(/<litleOnlineRequest.*<sale.*<card>.*<number>4100000000000001.*<expDate>1210.*/m))
	    XMLObject.expects(:new)

	    response = LitleOnlineRequest.sale(hash)
	end
end 
