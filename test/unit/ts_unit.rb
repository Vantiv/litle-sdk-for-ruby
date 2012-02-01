=begin
Copyright (c) 2011 Litle & Co.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end


require 'lib/LitleOnline'
require 'lib/LitleOnlineRequest'
require 'test/unit'
require 'mocha'

class Newtest < Test::Unit::TestCase
      def test_simple        
          hash = {
		  'reportGroup'=>'Planets',
                  'orderId'=>'12344',
                  'amount'=>'106',
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                   }}
                                   
	   Communications.expects(:http_post).with(regexp_matches(/<litleOnlineRequest .*/m))
	   XMLObject.expects(:new)
	   
           response = LitleOnlineRequest.authorization(hash)
        end
	
	def test_authorization_missing_attributes
	    hash={
		  'reportGroup'=>'Planets',
                  'amount'=>'106',
		
                  'orderSource'=>'ecommerce',
                  'card'=>{
                           'type'=>'VI', 
                           'number' =>'4100000000000001',
                           'expDate' =>'1210'
                 }}

	    exception = assert_raise(RuntimeError){LitleOnlineRequest.authorization(hash)}
	    assert_match /Missing Required Field: orderId!!!!/, exception.message	
	end

	def test_authorization_attributes
	    hash={
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
