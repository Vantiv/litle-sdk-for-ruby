require File.expand_path("../../../lib/LitleOnline",__FILE__) 
require 'test/unit'

module LitleOnline
  class Litle_certTest5 < Test::Unit::TestCase
    @@merchant_hash = {'reportGroup'=>'Planets',
      'merchantId'=>'101',
      'id'=>'test'
    }
  
    def test_50
      customer_hash = {
        'orderId' => '50',
        'accountNumber' => '4457119922390123'
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('445711', token_response.registerTokenResponse.bin)
      assert_equal('VI', token_response.registerTokenResponse['type'])
      assert_equal('801', token_response.registerTokenResponse.response)
      assert_equal('1111222233330123', token_response.registerTokenResponse.litleToken)
      assert_equal('Account number was successfully registered', token_response.registerTokenResponse.message)
    end
  
    def test_51
      customer_hash = {
        'orderId' => '51',
        'accountNumber' => '4457119999999999'
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('820', token_response.registerTokenResponse.response)
      assert_equal('Credit card number was invalid', token_response.registerTokenResponse.message)
    end
  
    def test_52
      customer_hash = {
        'orderId' => '52',
        'accountNumber' => '4457119922390123'
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('445711', token_response.registerTokenResponse.bin)
      assert_equal('VI', token_response.registerTokenResponse['type'])
      assert_equal('802', token_response.registerTokenResponse.response)
      assert_equal('1111222233330123', token_response.registerTokenResponse.litleToken)
      assert_equal('Account number was previously registered', token_response.registerTokenResponse.message)
    end
  
    def test_53
      customer_hash = {
        'orderId' => '53',
        'echeckForToken'=>{'accNum'=>'1099999998','routingNum'=>'114567895'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('EC', token_response.registerTokenResponse['type'])
      assert_equal('998', token_response.registerTokenResponse.eCheckAccountSuffix)
      assert_equal('801', token_response.registerTokenResponse.response)
      assert_equal('Account number was successfully registered', token_response.registerTokenResponse.message)
      assert_equal('111922223333000998', token_response.registerTokenResponse.litleToken)
    end
  
    def test_54
      customer_hash = {
        'orderId' => '54',
        'echeckForToken'=>{'accNum'=>'1022222102','routingNum'=>'1145_7895'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.register_token_request(hash)
      assert_equal('900', token_response.registerTokenResponse.response)
      # assert_equal('Invalid bank routing number', token_response.registerTokenResponse.message)
    end
  
    def test_55
      customer_hash = {
        'orderId' => '55',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'card' => {'number' => '5435101234510196', 'expDate' => '1112', 'cardValidationNum' => '987', 'type' => 'MC'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', token_response.authorizationResponse.response)
      assert_equal('Approved', token_response.authorizationResponse.message)
      assert_equal('801', token_response.authorizationResponse.tokenResponse.tokenResponseCode)
      assert_equal('Account number was successfully registered', token_response.authorizationResponse.tokenResponse.tokenMessage)
      assert_equal('MC', token_response.authorizationResponse.tokenResponse['type'])
      assert_equal('543510', token_response.authorizationResponse.tokenResponse.bin)
    end
  
    def test_56
      customer_hash = {
        'orderId' => '56',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'card' => {'number' => '5435109999999999', 'expDate' => '1112', 'cardValidationNum' => '987', 'type' => 'MC'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('301', token_response.authorizationResponse.response)
      # assert_equal('Invalid account number', token_response.authorizationResponse.message)
    end
  
    def test_57
      customer_hash = {
        'orderId' => '57',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'card' => {'number' => '5435101234510196', 'expDate' => '1112', 'cardValidationNum' => '987', 'type' => 'MC'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', token_response.authorizationResponse.response)
      assert_equal('Approved', token_response.authorizationResponse.message)
      assert_equal('802', token_response.authorizationResponse.tokenResponse.tokenResponseCode)
      assert_equal('Account number was previously registered', token_response.authorizationResponse.tokenResponse.tokenMessage)
      assert_equal('MC', token_response.authorizationResponse.tokenResponse['type'])
      assert_equal('543510', token_response.authorizationResponse.tokenResponse.bin)
    end
    
    def test_59
      customer_hash = {
        'orderId' => '59',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'token' => {'litleToken' => '1712990000040196', 'expDate' => '1112'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('822', token_response.authorizationResponse.response)
      assert_equal('Token was not found', token_response.authorizationResponse.message)
    end
  
    def test_60
      customer_hash = {
        'orderId' => '60',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'token' => {'litleToken' => '1712999999999999', 'expDate' => '1112'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('823', token_response.authorizationResponse.response)
      # assert_equal('Token was invalid', token_response.authorizationResponse.message)
    end
  
    def test_61
      customer_hash = {
        'orderId' => '61',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'billToAddress'=>{
        'firstName' => 'Tom',
        'lastName' => 'Black'},
        'echeck' => {'accType' => 'Checking', 'accNum' => '1099999003', 'routingNum' => '114567895'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('801', token_response.echeckSalesResponse.tokenResponse.tokenResponseCode)
      assert_equal('Account number was successfully registered', token_response.echeckSalesResponse.tokenResponse.tokenMessage)
      assert_equal('EC', token_response.echeckSalesResponse.tokenResponse['type'])
      assert_equal('003', token_response.echeckSalesResponse.tokenResponse.eCheckAccountSuffix)
      assert_equal('111922223333444003', token_response.echeckSalesResponse.tokenResponse.litleToken)
    end
  
    def test_62
      customer_hash = {
        'orderId' => '62',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'billToAddress'=>{
        'firstName' => 'Tom',
        'lastName' => 'Black'},
        'echeck' => {'accType' => 'Checking', 'accNum' => '1099999999', 'routingNum' => '114567895'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('801', token_response.echeckSalesResponse.tokenResponse.tokenResponseCode)
      assert_equal('Account number was successfully registered', token_response.echeckSalesResponse.tokenResponse.tokenMessage)
      assert_equal('EC', token_response.echeckSalesResponse.tokenResponse['type'])
      assert_equal('999', token_response.echeckSalesResponse.tokenResponse.eCheckAccountSuffix)
      assert_equal('111922223333444999', token_response.echeckSalesResponse.tokenResponse.litleToken)
    end
  
    def test_63
      customer_hash = {
        'orderId' => '63',
        'amount' => '15000',
        'orderSource' => 'ecommerce',
        'billToAddress'=>{
        'firstName' => 'Tom',
        'lastName' => 'Black'},
        'echeck' => {'accType' => 'Checking', 'accNum' => '1099999999', 'routingNum' => '214567892'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      token_response = LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('801', token_response.echeckSalesResponse.tokenResponse.tokenResponseCode)
      assert_equal('Account number was successfully registered', token_response.echeckSalesResponse.tokenResponse.tokenMessage)
      assert_equal('EC', token_response.echeckSalesResponse.tokenResponse['type'])
      assert_equal('999', token_response.echeckSalesResponse.tokenResponse.eCheckAccountSuffix)
      assert_equal('111922223333555999', token_response.echeckSalesResponse.tokenResponse.litleToken)
    end
  end
end