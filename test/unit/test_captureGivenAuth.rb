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
  class TestcaptureGivenAuth < Test::Unit::TestCase
    def test_both_choices_card_and_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'token'=> {
        'litleToken'=>'123456789101112',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.capture_given_auth(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_all_three_choices
      hash = {
        'merchantId' => '101',
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
        'paypage'=> {
        'paypageRegistrationId'=>'1234',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'},
        'token'=> {
        'litleToken'=>'1234567890123',
        'expDate'=>'1210',
        'cardValidationNum'=>'555',
        'type'=>'VI'
        }}

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.capture_given_auth(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_logged_in_user
      hash = {
        'loggedInUser' => 'gdake',
        'merchantSdk' => 'Ruby;8.14.0',
        'merchantId' => '101',
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
        }}
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
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
      LitleOnlineRequest.new.capture_given_auth(hash)
    end

    def test_surcharge_amount
      hash = {
        'amount' => '2',
        'surchargeAmount' => '1',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><surchargeAmount>1<\/surchargeAmount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
    end

    def test_surcharge_amount_optional
      hash = {
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><orderSource>ecommerce<\/orderSource>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
    end

    def test_fraudResult
      hash = {
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345',
        'fraudResult' => {
        'advancedFraudResults' =>
        {'deviceReviewStatus' => 'deviceReviewStatusString',
        'deviceReputationScore' => '100'
        }
        }
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<advancedFraudResults><deviceReviewStatus>deviceReviewStatusString<\/deviceReviewStatus><deviceReputationScore>100<\/deviceReputationScore><\/advancedFraudResults>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
    end

    def test_fraudResult1
      hash = {
        'amount' => '2',
        'orderSource' => 'ecommerce',
        'reportGroup' => 'Planets',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345',
        'fraudResult' => {
        'advancedFraudResults' =>
        {'deviceReviewStatus' => 'deviceReviewStatusString',
        'deviceReputationScore' => '100',
        'triggeredRule' => ['rule1','rule2']
        }
        }
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<advancedFraudResults><deviceReviewStatus>deviceReviewStatusString<\/deviceReviewStatus><deviceReputationScore>100<\/deviceReputationScore><triggeredRule>rule1<\/triggeredRule><triggeredRule>rule2<\/triggeredRule><\/advancedFraudResults>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
    end
    
     def test_processingType
      hash = {
        'merchantId' => '101',
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
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<processingType>initialRecurring<\/processingType>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
    end    

    def test_originalNetworkTransactionId_originalTransactionAmount
      hash = {
        'merchantId' => '101',
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
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<originalNetworkTransactionId>987654321098765432109876543210<\/originalNetworkTransactionId><originalTransactionAmount>10661<\/originalTransactionAmount>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture_given_auth(hash)
    end 

  end
end
