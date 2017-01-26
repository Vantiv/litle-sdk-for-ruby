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
  class TestToken < Test::Unit::TestCase
    def test_success_applepay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'applepay'=>{
          'data'=>'user',
          'header'=>{
            'applicationData'=>'454657413164',
            'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
          },
          'signature' =>'sign',
          #  'version' =>'1'
          # SDL Ruby XML 10
          'version' =>'10000'
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<registerTokenRequest.*?<applepay>.*?<data>user<\/data>.*?<\/applepay>.*?<\/registerTokenRequest>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.register_token_request(hash)
    end

    def test_account_num_and_applepay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789101112',
        'applepay'=>{
          'data'=>'user',
          'header'=>{
            'applicationData'=>'454657413164',
            'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
          },
          'signature' =>'sign',
          #  'version' =>'1'
          # SDL Ruby XML 10
          'version' =>'10000'
        }
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.register_token_request(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_account_num_and_paypage
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789101112',
        'paypageRegistrationId'=>'1233456789101112'
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.register_token_request(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_echeck_and_Paypage
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'echeckForToken'=>{'accNum'=>'12344565','routingNum'=>'123476545'},
        'paypageRegistrationId'=>'1233456789101112'
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.register_token_request(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_echeck_and_Paypage_and_accountnum
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789101112',
        'echeckForToken'=>{'accNum'=>'12344565','routingNum'=>'123476545'},
        'paypageRegistrationId'=>'1233456789101112'
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.register_token_request(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_token_echeck_missing_required
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'echeckForToken'=>{'routingNum'=>'132344565'}
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.register_token_request(hash)}
      assert_match /If echeckForToken is specified, it must have a accNum/, exception.message
    end

    def test_logged_in_user
      hash = {
        'loggedInUser'=>'gdake',
        'merchantSdk' => 'Ruby;8.14.0',
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'echeckForToken'=>{'accNum'=>'12344565','routingNum'=>'123476545'}
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      LitleOnlineRequest.new.register_token_request(hash)
    end

    def test_androidpay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'test',
        'orderId'=>'androidpay',
        'accountNumber'=>'1233456789103801'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<orderId>androidpay<\/orderId>.*<accountNumber>1233456789103801<\/accountNumber>.*/m), is_a(Hash))
      LitleOnlineRequest.new.register_token_request(hash)
    end
  end
end