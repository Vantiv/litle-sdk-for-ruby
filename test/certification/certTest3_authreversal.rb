require File.expand_path("../../../lib/LitleOnline",__FILE__) 
require 'test/unit'

module LitleOnline
  class Litle_certTest3 < Test::Unit::TestCase
    #test auth reversal
    @@merchant_hash = {'reportGroup'=>'Planets','id'=>'321','customerId'=>'123',
      'merchantId'=>'101',
      'id'=>'test'
    }
  
    def test_32
      customer_hash = {
        'orderId' => '32',
        'amount' => '10010',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'John Smith',
        'addressLine1' => '1 Main St.',
        'city' => 'Burlington',
        'state' => 'MA',
        'zip' => '01803-3747',
        'country' => 'US'},
        'card'=>{
        'number' =>'4457010000000009',
        'expDate' => '0112',
        'cardValidationNum' => '349',
        'type' => 'VI'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('11111 ', auth_response.authorizationResponse.authCode)
      assert_equal('01', auth_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('M', auth_response.authorizationResponse.fraudResult.cardValidationResult)
  
      #test 32A
      capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '5005'}
      hash1a = capture_hash.merge(@@merchant_hash)
      capture_response = LitleOnlineRequest.new.capture(hash1a)
      assert_equal('000', capture_response.captureResponse.response)
      
  
      #test 32B
      auth_r_hash =  {'litleTxnId' => '123456789000' }
      hash1b = auth_r_hash.merge(@@merchant_hash)
      auth_r_response = LitleOnlineRequest.new.auth_reversal(hash1b)
      assert_equal('000', auth_r_response.authReversalResponse.response)
      
    end
  
    def test_33
      customer_hash = {
        'orderId' => '33',
        'amount' => '20020',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Mike J. Hammer',
        'addressLine1' => '2 Main St.',
        'addressLine2' => 'Apt. 222',
        'city' => 'Riverside',
        'state' => 'RI',
        'zip' => '02915',
        'country' => 'US'},
        'card'=>{
        'number' =>'5112010000000003',
        'expDate' => '0212',
        'cardValidationNum' => '261',
        'type' => 'MC'},
        'cardholderAuthentication' => {'authenticationValue'=> 'BwABBJQ1AgAAAAAgJDUCAAAAAAA=' }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('22222', auth_response.authorizationResponse.authCode)
      assert_equal('10', auth_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('M', auth_response.authorizationResponse.fraudResult.cardValidationResult)
  
      #test 33A
      auth_reversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
      hash1a = auth_reversal_hash.merge(@@merchant_hash)
      auth_reversal_response = LitleOnlineRequest.new.auth_reversal(hash1a)
      assert_equal('000', auth_reversal_response.authReversalResponse.response)
      
    end
  
    def test_34
      customer_hash = {
        'orderId' => '34',
        'amount' => '30030',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Eileen Jones',
        'addressLine1' => '3 Main St.',
        'city' => 'Bloomfield',
        'state' => 'CT',
        'zip' => '06002',
        'country' => 'US'},
        'card'=>{
        'number' =>'6011010000000003',
        'expDate' => '0312',
        'cardValidationNum' => '758',
        'type' => 'DI'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('33333', auth_response.authorizationResponse.authCode)
      assert_equal('10', auth_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('M', auth_response.authorizationResponse.fraudResult.cardValidationResult)
  
      #test 34A
      auth_reversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
      hash1a = auth_reversal_hash.merge(@@merchant_hash)
      auth_reversal_response = LitleOnlineRequest.new.auth_reversal(hash1a)
      assert_equal('000', auth_reversal_response.authReversalResponse.response)
      
    end
  
    def test_35
      customer_hash = {
        'orderId' => '35',
        'amount' => '40040',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Bob Black',
        'addressLine1' => '4 Main St.',
        'city' => 'Laurel',
        'state' => 'MD',
        'zip' => '20708',
        'country' => 'US'},
        'card'=>{
        'number' =>'375001000000005',
        'expDate' => '0412',
        'type' => 'AX'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('44444', auth_response.authorizationResponse.authCode)
      assert_equal('12', auth_response.authorizationResponse.fraudResult.avsResult)
  
      #    #test 35A
      capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '20020'}
      hash1a = capture_hash.merge(@@merchant_hash)
      capture_response = LitleOnlineRequest.new.capture(hash1a)
      assert_equal('000', capture_response.captureResponse.response)
      
  
      #    #test 35B
      auth_reversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '20020'}
      hash2a = auth_reversal_hash.merge(@@merchant_hash)
      auth_reversal_response = LitleOnlineRequest.new.auth_reversal(hash2a)
      assert_equal('000', auth_reversal_response.authReversalResponse.response)
      
    end
    
    def test_36
      customer_hash = {
        'orderId' => '36',
        'amount' => '20500',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'375000026600004',
        'expDate' => '0512',
        'type' => 'AX'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
  
      #test 36A
      auth_reversal_hash =  {'litleTxnId' => '123456789000', 'amount' => '10000'}
      hash1a = auth_reversal_hash.merge(@@merchant_hash)
      auth_reversal_response = LitleOnlineRequest.new.auth_reversal(hash1a)
      assert_equal('000', auth_reversal_response.authReversalResponse.response)
      
    end
  
  end
end