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

#test Authorization Transaction
module LitleOnline
  class TestAuth < Test::Unit::TestCase
    def test_simple_auth_with_card
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
        'id' => 'test',
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

    def test_simple_auth_with_applepay_and_secondaryAmount
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'110',
        'secondaryAmount'=>'50',
        'orderSource'=>'ecommerce',
        'applepay'=>{
        'data'=>'1234',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'1234'
        },
        'signature' =>'1',
        # RUby SDK XML 10
        #'version'=>'1'
         'version'=>'1000000'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Insufficient Funds', response.authorizationResponse.message)
      assert_equal('110', response.authorizationResponse.applepayResponse.transactionAmount)
    end

    def test_illegal_order_source
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleOnlineRequest.new.authorization(hash)
        }
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_fields_out_of_order
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
        'id' => 'test',
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

    def test_no_order_id
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleOnlineRequest.new.authorization(hash)
        }
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_no_amount
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleOnlineRequest.new.authorization(hash)
        }
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
   
    def test_no_order_source
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        # 'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleOnlineRequest.new.authorization(hash)
        }
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
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
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleOnlineRequest.new.authorization(hash)
        }
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_orderId_required
      hash = {
        'merchantId'=>'101',
        'reportGroup'=>'Planets',
        'amount'=>'101',
        'orderSource'=>'ecommerce',
        'card' => {
        'type' => 'VI',
        'number' => '1111222233334444'
        }
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleOnlineRequest.new.authorization(hash)
        }
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
      #SDK XML 10
      #response = LitleOnlineRequest.new.authorization(start_hash.merge({'orderId'=>'1234'}))
      response = LitleOnlineRequest.new.authorization(hash.merge({'orderId'=>'1234','id'=>'test'}))
      assert_equal('000', response.authorizationResponse.response)
    end

    def test_ssn_optional
      start_hash = {
        'orderId'=>'12344',
        'id' => 'test',
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

    def test_simple_auth_with_paypage
      hash = {
        'orderId'=>'12344',
        'id' => 'test',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypage'=>{
        'type'=>'VI',
        'paypageRegistrationId' =>'QU1pTFZnV2NGQWZrZzRKeTNVR0lzejB1K2Q5VDdWMTVqb2J5WFJ2Snh4U0U4eTBxaFg2cEVWaDBWSlhtMVZTTw==',
        'expDate' =>'1210',
        'cardValidationNum' => '123'
        }
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', response.authorizationResponse.response)
    end

    def test_simple_auth_with_advanced_fraud_checks
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12355',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        },
        'advancedFraudChecks' => {'threatMetrixSessionId'=>'1234'}
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', response.authorizationResponse.response)
    end

    def test_simple_auth_with_mpos
      hash = {
        'orderId'=>'12344',
        'id' => 'test',
        'amount'=>'106',
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
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', response.authorizationResponse.response)
    end
    
    #SDK XML 10 
    def test_simple_auth_with_wallet1
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'orderId'=>'123456',
        'orderSource'=>'ecommerce',
        'paypal'=>
         {
           'payerId'=>'1234',
           'token'=>'1234',
           'transactionId'=>'123456'
          },
         'wallet'=> {
           'walletSourceType' => 'MasterPass',
           'walletSourceTypeId' => '102'                  
         }}  
         response= LitleOnlineRequest.new.authorization(hash)
         assert_equal 'Valid Format', response.message
       end
       
    def test_simple_auth_with_enhancedAuthResponse
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12355',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
          'type'=>'VI',
          'number' =>'4100800000000000',
          'expDate' =>'1210'
        },
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('visa', response.authorizationResponse.enhancedAuthResponse.networkResponse.endpoint)
      assert_equal('135798642', response.authorizationResponse.enhancedAuthResponse.networkResponse.networkField.fieldValue)
      assert_equal('4', response.authorizationResponse.enhancedAuthResponse.networkResponse.networkField['fieldNumber'])
      assert_equal('Transaction Amount', response.authorizationResponse.enhancedAuthResponse.networkResponse.networkField['fieldName'])
    end
    
    def test_simple_auth_with_networkTransactionId
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12355',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
          'type'=>'VI',
          'number' =>'4100800000000000',
          'expDate' =>'1210'
        },
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('63225578415568556365452427825', response.authorizationResponse.networkTransactionId)
    end
    
    def test_processingType_originalNetworkTransactionId_originalTransactionAmount
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12355',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
          'type'=>'VI',
          'number' =>'4100800000000000',
          'expDate' =>'1210'
        },
        'processingType' => 'initialInstallment',
        'originalNetworkTransactionId' => '9876543210',
        'originalTransactionAmount' => '536981'
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal 'Valid Format', response.message
    end
    
    def test_eciIndicator
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12355',
        'amount'=>'106',
        'orderSource'=>'androidpay',
        'card'=>{
          'type'=>'VI',
          'number' =>'4100800000000000',
          'expDate' =>'1210'
        },
        'processingType' => 'initialInstallment',
        'originalNetworkTransactionId' => '9876543210',
        'originalTransactionAmount' => '536981'
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal 'Valid Format', response.message
    end
    
  end
end
