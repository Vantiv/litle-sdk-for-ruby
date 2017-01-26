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
  class TestToken < Test::Unit::TestCase
    def test_simple_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789103801'
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_simple_token_with_paypage
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'paypageRegistrationId'=>'QU1pTFZnV2NGQWZrZzRKeTNVR0lzejB1K2Q5VDdWMTVqb2J5WFJ2Snh4U0U4eTBxaFg2cEVWaDBWSlhtMVZTTw=='
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Valid Format', response.message)
      assert_equal('1111222233334444', response.registerTokenResponse.litleToken)
    end

    def test_simple_token_with_applepay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'applepay'=>{
          'data'=>'1234',
          'header'=>{
            'applicationData'=>'454657413164',
            'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            'transactionId'=>'1234'
          },
          'signature' =>'1',
          'version'=>'10000'
        }
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Valid Format', response.message)
      assert_equal('0', response.registerTokenResponse.applepayResponse.transactionAmount)
    end

    def test_simple_token_echeck
      hash = {
        'reportGroup'=>'Planets',
        'merchantId' => '101',
        'id'=>'test',
        'version'=>'8.8',
        'orderId'=>'12344',
        'echeckForToken'=>{'accNum'=>'12344565','routingNum'=>'123476545'}
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_fields_out_of_order
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789103801',
        'reportGroup'=>'Planets',
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_invalid_field
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'NOSUCHFIELD'=>'none',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789103801',
        'reportGroup'=>'Planets',
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_simple_token_with_androidpay
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'test',
        'orderId'=>'androidpay',
        'accountNumber'=>'1233456789103801'
      }
      response= LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('Account number was successfully registered', response.registerTokenResponse.message)
      assert_equal('01', response.registerTokenResponse.androidpayResponse.expMonth)
      assert_equal('2050', response.registerTokenResponse.androidpayResponse.expYear)
      assert_equal('aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ0K', response.registerTokenResponse.androidpayResponse.cryptogram)
    end
  end
end