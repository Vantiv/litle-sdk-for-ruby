=begin
Copyright (c) 2017 Vantiv eCommerce

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
require File.expand_path("../../../lib/LitleOnline",__FILE__)
require 'test/unit'

module LitleOnline
  class TestcaptureGivenAuth < Test::Unit::TestCase
    def test_simple_capture_given_auth_with_card
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_simple_capture_given_auth_with_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216', 'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
        'authAmount'=>'12345'
        },
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'token'=> {
        'litleToken'=>'123456789101112',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_fields_out_of_order
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'orderSource'=>'ecommerce',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        },
        'reportGroup'=>'Planets',
        'orderId'=>'12344'
      }
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_invalid_field
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'NOexistantField' => 'ShouldNotCauseError',
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_complex_capture_given_auth
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_auth_info
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345','fraudResult'=>{'avsResult'=>'12','cardValidationResult'=>'123','authenticationResult'=>'1',
        'advancedAVSResult'=>'123',
        'advancedFraudResults' => {'deviceReviewStatus' => 'deviceReviewStatusString',
        'deviceReputationScore' => '100',
        'triggeredRule' => ['rule1','rule2']
        }
        }
        },
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_no_amount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.capture_given_auth(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_simple_captureGivenAuth_with_mpos
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'orderSource'=>'ecommerce',
        'mpos'=>
        {
        'ksn'=>'ksnString',
        'formatId'=>'30',
        'encryptedTrack'=>'encryptedTrackString',
        'track1Status'=>'0',
        'track2Status'=>'0'
        }
      }
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_simple_capture_given_auth_with_secondaryAmount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216', 'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
        'authAmount'=>'12345'
        },
        'amount'=>'106',
        'secondaryAmount'=>'50',
        'orderSource'=>'ecommerce',
        'token'=> {
        'litleToken'=>'123456789101112',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end
    
     def test_simple_capture_given_auth_with_processingType
      hash = {
        'merchantId' => '101',
        'id'=>'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'processingType'=>'initialRecurring',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end    

    def test_simple_capture_given_auth_with_originalNetworkTransactionId_originalTransactionAmount
      hash = {
        'merchantId' => '101',
        'id'=>'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'originalNetworkTransactionId'=>'987654321098765432109876543210',
        'originalTransactionAmount'=>'10661'
        }
      response= LitleOnlineRequest.new.capture_given_auth(hash)
      assert_equal('Valid Format', response.message)
    end 
    
  end
end
