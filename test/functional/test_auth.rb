=begin
Copyright (c) 2012 Litle & Co.

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
require 'test/unit'

#test Authorization Transaction
module LitleOnline
  class TestAuth < Test::Unit::TestCase
    def test_simple_auth_with_card
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', response.authorizationResponse.response)
    end
  
    def test_simple_auth_with_paypal
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'orderId'=>'123456',
        'orderSource'=>'ecommerce',
        'paypal'=>{
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal 'Valid Format', response.message
    end
  
    def test_illegal_order_source
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecomerce', #This order source is mispelled on purpose!
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end
  
    def test_fields_out_of_order
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        },
        'orderSource'=>'ecommerce',
        'amount'=>'106'
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', response.authorizationResponse.response)
    end
  
    def test_invalid_field
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'NOexistantField' => 'ShouldNotCauseError',
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', response.authorizationResponse.response)
    end
  
    def test_pos_without_capability_and_entry_mode
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'pos'=>{'cardholderId'=>'pin'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end
    
    def test_no_order_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end
    
    def test_no_amount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end
  
    def test_no_order_source
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        #      'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
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
  
      response= LitleOnlineRequest.new.authorization(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end
  
    def test_orderId_required
      start_hash = {
        'merchantId'=>'101',
        'reportGroup'=>'Planets',
        'amount'=>'101',
        'orderSource'=>'ecommerce',
        'card' => {
        'type' => 'VI',
        'number' => '1111222233334444'
        }
      }
      response= LitleOnlineRequest.new.authorization(start_hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    
      response = LitleOnlineRequest.new.authorization(start_hash.merge({'orderId'=>'1234'}))
      assert_equal('000', response.authorizationResponse.response)
    end
  
    def test_ssn_optional
      start_hash = {
        'orderId'=>'12344',
        'merchantId'=>'101',
        'reportGroup'=>'Planets',
        'amount'=>'101',
        'orderSource'=>'ecommerce',
        'card' => {
        'type' => 'VI',
        'number' => '1111222233334444'
        },
      }
      response = LitleOnlineRequest.new.authorization(start_hash)
      assert_equal('000', response.authorizationResponse.response)
    
      response = LitleOnlineRequest.new.authorization(start_hash.merge({'customerInfo'=>{'ssn'=>'000112222'} }))
      assert_equal('000', response.authorizationResponse.response)
    end
    
  end
end  
