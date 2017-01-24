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

module LitleOnline
  class TestSale < Test::Unit::TestCase
    def test_both_choices_fraud_check_and_card_holder
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'},
        'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_success_applepay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'}, 
        'applepay'=>{
        'data'=>'user',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        },
        'signature' =>'sign',
       # 'version' =>'1'
          'version' =>'10000'
        }
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<sale.*?<applepay>.*?<data>user<\/data>.*?<\/applepay>.*?<\/sale>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    # for test the choice functionality
    def test_success_card
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
                'fraudCheck'=>{'authenticationTransactionId'=>'123'}, #for test
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<sale.*?<card>.*?<type>VI<\/type>.*?<\/card>.*?<\/sale>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_both_choices_card_and_paypal
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        },
        'paypal'=>{
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_both_choices_card_and_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'},
        'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        },
        'token'=> {
        'litleToken'=>'1234567890123',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_both_choices_card_and_paypage
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'},
        'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        },
        'paypage'=> {
        'paypageRegistrationId'=>'1234',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_three_choices_card_and_paypage_and_paypal
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>{'authenticationTransactionId'=>'123'},
        'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
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

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
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
        'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
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
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_merchant_data_sale
      hash = {
        'merchantId' => '101',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'0',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'merchantData'=> {
        'affiliate'=>'bar'
        }
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<merchantData>.*?<affiliate>bar<\/affiliate>.*?<\/merchantData>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_invalid_embedded_field_values
      #becasue there are sub fields under fraud check that are not specified
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'fraudCheck'=>'one',
        'cardholderAuthentication'=>'two',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_fraud_filter_override
      hash = {
        'merchantId' => '101',
        'version'=>'8.12',
        'orderId'=>'1',
        'amount'=>'0',
        'orderSource'=>'ecommerce',
        'reportGroup'=>'Planets',
        'fraudFilterOverride'=> 'false'
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<sale.*?<fraudFilterOverride>false<\/fraudFilterOverride>.*?<\/sale>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_illegal_card_type
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'NO',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /If card type is specified, it must be in /, exception.message
    end

    def test_logged_in_user
      hash = {
        'loggedInUser' => 'gdake',
        'merchantSdk' => 'Ruby;8.14.0',
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
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
      LitleOnlineRequest.new.sale(hash)
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
      LitleOnlineRequest.new.sale(hash)
    end

    def test_surcharge_amount_optional
      hash = {
        'orderId' => '12344',
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_recurringRequest
      hash = {
        'card'=>{
        'type'=>'VI',
        'number'=>'4100000000000001',
        'expDate'=>'1213',
        },
        'orderId'=>'12344',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'fraudFilterOverride'=>'true',
        'recurringRequest'=>{
        'subscription'=>{
        'planCode'=>'abc123',
        'numberOfPayments'=>'12'
        }
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<fraudFilterOverride>true<\/fraudFilterOverride><recurringRequest><subscription><planCode>abc123<\/planCode><numberOfPayments>12<\/numberOfPayments><\/subscription><\/recurringRequest>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_recurringRequest_optional
      hash = {
        'card'=>{
        'type'=>'VI',
        'number'=>'4100000000000001',
        'expDate'=>'1213',
        },
        'orderId'=>'12344',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'fraudFilterOverride'=>'true',
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<fraudFilterOverride>true<\/fraudFilterOverride><\/sale>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_litleInternalRecurringRequest
      hash = {
        'card'=>{
        'type'=>'VI',
        'number'=>'4100000000000001',
        'expDate'=>'1213',
        },
        'orderId'=>'12344',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'fraudFilterOverride'=>'true',
        'litleInternalRecurringRequest'=>{
        'subscriptionId'=>'1234567890123456789',
        'recurringTxnId'=>'1234567890123456789',
        'finalPayment'=>'false'
        },
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<fraudFilterOverride>true<\/fraudFilterOverride><litleInternalRecurringRequest><subscriptionId>1234567890123456789<\/subscriptionId><recurringTxnId>1234567890123456789<\/recurringTxnId><finalPayment>false<\/finalPayment><\/litleInternalRecurringRequest>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_litleInternalRecurringRequest_optional
      hash = {
        'card'=>{
        'type'=>'VI',
        'number'=>'4100000000000001',
        'expDate'=>'1213',
        },
        'orderId'=>'12344',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'fraudFilterOverride'=>'true',
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<fraudFilterOverride>true<\/fraudFilterOverride><\/sale>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
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
        } ,
        'advancedFraudChecks' => {'threatMetrixSessionId'=>'1234'}
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<advancedFraudChecks><threatMetrixSessionId>1234<\/threatMetrixSessionId><\/advancedFraudChecks>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end
    
     def test_processingType
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'MC',
        'number' =>'5400000000000000',
        'expDate' =>'1210'
        },
        'processingType'=>'initialInstallment'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<processingType>initialInstallment<\/processingType>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_originalNetworkTransactionId_originalTransactionAmount_pin
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'VI',
        'number' =>'4100700000000000',
        'expDate' =>'1210',
        'pin'=>'1111'
        },
        'originalNetworkTransactionId'=>'98765432109876543210',
        'originalTransactionAmount'=>'7001'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<originalNetworkTransactionId>98765432109876543210<\/originalNetworkTransactionId><originalTransactionAmount>7001<\/originalTransactionAmount>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

    def test_wallet
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'VI',
        'number' =>'4100700000000000',
        'expDate' =>'1210',
        },
        'wallet'=>{
          'walletSourceType'=>'VisaCheckout',
          'walletSourceTypeId'=>'VCIND'
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<wallet><walletSourceType>VisaCheckout<\/walletSourceType><walletSourceTypeId>VCIND<\/walletSourceTypeId><\/wallet>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end


  def test_sepaDirectDebit
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'sepaDirectDebit'=> {
        'mandateProvider'=>'Merchant',
        'sequenceType'=>'OneTime',
        'iban'=>'123456789123456789',
        }}
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<sepaDirectDebit><mandateProvider>Merchant<\/mandateProvider><sequenceType>OneTime<\/sequenceType><iban>123456789123456789<\/iban><\/sepaDirectDebit>.*/m), is_a(Hash))
      LitleOnlineRequest.new.sale(hash)
    end

  end
end
