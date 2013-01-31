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
require 'mocha'

module LitleOnline
  
  class TestCredit < Test::Unit::TestCase
    def test_both_choices_card_and_paypal
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'paypal'=>{
        'payerEmail'=>'a@b.com',
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}
  
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end
  
    def test_three_choices_card_and_paypage_and_paypal
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'paypage'=> {
        'paypageRegistrationId'=>'1234',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'},
        'paypal'=>{
        'payerEmail'=>'a@b.com',
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end
  
    def test_all_choices_card_and_paypage_and_paypal_and_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'},
        'bypassVelocityCheckcardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'paypage'=> {
        'paypageRegistrationId'=>'1234',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'},
        'paypal'=>{
        'payerId'=>'1234',
        'payerEmail'=>'a@b.com',
        'token'=>'1234',
        'transactionId'=>'123456'},
        'token'=> {
        'litleToken'=>'1234567890123',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}
  
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end
    
    def test_action_reason_on_orphaned_refund
      hash = {
        'merchantId' => '101',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'actionReason'=> 'SUSPECT_FRAUD'
      }
      XMLObject.expects(:new)
      Communications.expects(:http_post).with(regexp_matches(/.*<actionReason>SUSPECT_FRAUD<\/actionReason>.*/m),kind_of(Hash))
      LitleOnlineRequest.new.credit(hash)
    end

    def test_simple_enhanced_data_incorrect_enum_for_country_code
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'},
        'orderSource'=>'ecommerce',
        'enhancedData'=>{
        'destinationCountryCode'=>'001',
        'customerReference'=>'Litle',
        'salesTax'=>'50',
        'deliveryType'=>'TBD',
        'shipFromPostalCode'=>'01741',
        'destinationPostalCode'=>'01742'}
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /If enhancedData destinationCountryCode is specified, it must be/, exception.message
    end

    def test_token_with_incorrect_token_Length
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'token'=> {
        'litleToken'=>'123456789012',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /If token litleToken is specified, it must be between/, exception.message
    end
    
    def test_token_missing_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'token'=> {
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /If token is specified, it must have a litleToken/, exception.message
    end

    def test_pos_with_invalid_entry_mode
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'pos'=>{'entryMode'=>'none','cardholderId'=>'pin','capability'=>'notused'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /If pos entryMode is specified, it must be in/, exception.message
    end
    
    def test_paypage_missing_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypage'=> {
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      assert_match /If paypage is specified, it must have a paypageRegistrationId/, exception.message
    end
    
    def test_logged_in_user
      hash = {
      	'loggedInUser' => 'gdake',
        'merchantId' => '101',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*loggedInUser="gdake".*merchantSdk="Ruby;8.14.0".*/m), is_a(Hash))
      LitleOnlineRequest.new.credit(hash)
    end
    
  end
end