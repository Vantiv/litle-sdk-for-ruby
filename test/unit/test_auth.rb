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
require 'mocha/setup'

#test Authorization Transaction
module LitleOnline
 class TestAuth < Test::Unit::TestCase
    def test_success_re_auth
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456'
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<litleTxnId>123456<\/litleTxnId>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_success_applepay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'applepay'=>{
        'data'=>'user',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        },
        'signature' =>'sign',
        'version' =>'10000'
        }
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<authorization.*?<applepay>.*?<data>user<\/data>.*?<\/applepay>.*?<\/authorization>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_both_choices_card_and_applepay
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
        'applepay'=>{
        'data'=>'user',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        },
        'signature' =>'sign',
        'version' =>'10000'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

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
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
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
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_all_choices_card_and_paypage_and_paypal_and_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
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
        'token'=>'1234',
        'transactionId'=>'123456'},
        'token'=> {
        'litleToken'=>'1234567890123',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_merchant_data_auth
      hash = {
        'merchantId' => '101',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'0',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'merchantData'=> {
        'campaign'=>'foo'
        }
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<merchantData>.*?<campaign>foo<\/campaign>.*?<\/merchantData>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_fraud_filter_override
      hash = {
        'merchantId' => '101',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'0',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'fraudFilterOverride'=> 'true'
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<authorization.*?<fraudFilterOverride>true<\/fraudFilterOverride>.*?<\/authorization>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
    
 


    def test_pos_without_capability
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'pos'=>{'entryMode'=>'track1','cardholderId'=>'pin'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
      assert_match /If pos is specified, it must have a capability/, exception.message
    end

    def test_paypal_missing_payer_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypal'=>{
        'token'=>'1234',
        'transactionId'=>'123456'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
     assert_match /If paypal is specified, it must have a payerId/, exception.message
    end

    def test_paypal_missing_transaction_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypal'=>{
        'token'=>'1234',
        'payerId'=>'123456'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
      assert_match /If paypal is specified, it must have a transactionId/, exception.message
    end

    def test_pos_without_capability_and_entry_mode
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'pos'=>{'cardholderId'=>'pin','capability'=>'notused'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
      assert_match /If pos is specified, it must have a entryMode/, exception.message
    end

    def test_auth_override_username
      hash = {
        'merchantId' => '101',
        'user' => 'UNIT',
        'password' => 'TEST',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'0',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'fraudFilterOverride'=> 'true'
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<authentication.*?<user>UNIT<\/user>.*?<\/authentication>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_auth_override_password
      hash = {
        'merchantId' => '101',
        'user' => 'UNIT',
        'password' => 'TEST',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'0',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'fraudFilterOverride'=> 'true'
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<authentication.*?<password>TEST<\/password>.*?<\/authentication>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_logged_in_user
      hash = {
        'merchantSdk' => 'Ruby;8.14.0',
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'loggedInUser'=>'gdake'
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_surcharge_amount
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'surchargeAmount' => '1',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><surchargeAmount>1<\/surchargeAmount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_secondary_amount
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'secondaryAmount' => '1',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><secondaryAmount>1<\/secondaryAmount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_surcharge_amount_optional
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_method_of_payment_allows_giftcard
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'card' => {
        'number' => '4141000000000000',
        'expDate' => '1210',
        'type' => 'GC'
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<card><type>GC<\/type><number>4141000000000000<\/number><expDate>1210<\/expDate><\/card>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_advanced_fraud_check
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'card' => {
        'number' => '4141000000000000',
        'expDate' => '1210',
        'type' => 'GC'        
        },
        'advancedFraudChecks' => {'threatMetrixSessionId'=>'1234'}        
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<advancedFraudChecks><threatMetrixSessionId>1234<\/threatMetrixSessionId><\/advancedFraudChecks>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_mpos
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'mpos'=>
        {
        'ksn'=>'ksnString',
        'formatId'=>'30',
        'encryptedTrack'=>'encryptedTrackString',
        'track1Status'=>'0',
        'track2Status'=>'0'
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<mpos><ksn>ksnString<\/ksn><formatId>30<\/formatId><encryptedTrack>encryptedTrackString<\/encryptedTrack><track1Status>0<\/track1Status><track2Status>0<\/track2Status><\/mpos>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
    
    def test_processingType_originalNetworkTransactionId_originalTransactionAmount
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'card' => {
        'number' => '4141000000000000',
        'expDate' => '1210',
        'type' => 'GC'        
        },
        'processingType' => 'initialInstallment',
        'originalNetworkTransactionId' => '9876543210',
        'originalTransactionAmount' => '536981'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<processingType>initialInstallment<\/processingType><originalNetworkTransactionId>9876543210<\/originalNetworkTransactionId><originalTransactionAmount>536981<\/originalTransactionAmount>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
    
     def test_processingType_wallet
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'orderId'=>'67890',
        'amount'=>'10000',
        'orderSource'=>'ecommerce',
        'processingType' => 'initialInstallment',
        'originalNetworkTransactionId' => '9876543210',
        'originalTransactionAmount' => '536981',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1215'
        },
        'wallet'=>{
          'walletSourceType'=>'VisaCheckout',
          'walletSourceTypeId' => 'VCIND'
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<wallet><walletSourceType>VisaCheckout<\/walletSourceType><walletSourceTypeId>VCIND<\/walletSourceTypeId><\/wallet>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
    
  end
end
