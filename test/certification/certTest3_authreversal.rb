require 'lib/LitleOnline'
require 'test/unit'

class Litle_certTest3 < Test::Unit::TestCase
  #test auth reversal
  @@merchant_hash = {'reportGroup'=>'Planets',
    'merchantId'=>'101'
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
    assert_equal('Approved', capture_response.captureResponse.message)

    #    #test 32B
    #    authR_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId }
    #    hash1b = authR_hash.merge(@@merchant_hash)
    #    authR_response = LitleOnlineRequest.new.authReversal(hash1b)
    #    assert_equal('111', authR_response.authReversalResponse.response)
    #    assert_equal('Authorization amount has already been depleted', authR_response.authReversalResponse.message)
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

    #    #test 33A
    #    authReversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
    #    hash1a = authReversal_hash.merge(@@merchant_hash)
    #    authReversal_response = LitleOnlineRequest.new.authReversal(hash1a)
    #    assert_equal('000', authReversal_response.authReversalResponse.response)
    #    assert_equal('Approved', authReversal_response.authReversalResponse.message)
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

    #    #test 34A
    #    authReversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
    #    hash1a = authReversal_hash.merge(@@merchant_hash)
    #    authReversal_response = LitleOnlineRequest.new.authReversal(hash1a)
    #    assert_equal('000', authReversal_response.authReversalResponse.response)
    #    assert_equal('Approved', authReversal_response.authReversalResponse.message)
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
    assert_equal('Approved', capture_response.captureResponse.message)

#    #    #test 35B
#    authReversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '20020'}
#    #authReversal_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId, 'amount' => '20020'}
#    hash2a = authReversal_hash.merge(@@merchant_hash)
#    authReversal_response = LitleOnlineRequest.new.authReversal(hash2a)
#    assert_equal('000', authReversal_response.authReversalResponse.response)
#    assert_equal('Approved', authReversal_response.authReversalResponse.message)
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
    authReversal_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '10000'}
    hash1a = authReversal_hash.merge(@@merchant_hash)
    authReversal_response = LitleOnlineRequest.new.authReversal(hash1a)
    assert_equal('336', authReversal_response.authReversalResponse.response)
    assert_equal('Reversal Amount does not match Authorization amount', authReversal_response.authReversalResponse.message)
  end

end
