require File.expand_path("../../../lib/LitleOnline",__FILE__) 
require 'test/unit'

module LitleOnline
  class Litle_certTest2 < Test::Unit::TestCase
    #test enhanced data on auth response
    @@merchant_hash = {'reportGroup'=>'Planets',
      'merchantId'=>'101',
      'id'=>'test'
    }
  
    #test 14-31 enhanced data need merchant with smart authorization features.
    def test_14
      customer_hash = {
        'orderId' => '14',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4457010200000247',
        'expDate' => '0812',
        'type' => 'VI'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type']) #Ruby 1.8.7 has type as an attribute of Object
      assert_equal('2000', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('NO', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('GIFT', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_15
      customer_hash = {
        'orderId' => '15',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5500000254444445',
        'expDate' => '0312',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type'])
      assert_equal('2000', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_16
      customer_hash = {
        'orderId' => '16',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5592106621450897',
        'expDate' => '0312',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type'])
      assert_equal('0', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_17
      customer_hash = {
        'orderId' => '17',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5590409551104142',
        'expDate' => '0312',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type'])
      assert_equal('6500', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_18
      customer_hash = {
        'orderId' => '18',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5587755665222179',
        'expDate' => '0312',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type'])
      assert_equal('12200', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_19
      customer_hash = {
        'orderId' => '19',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5445840176552850',
        'expDate' => '0312',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type'])
      assert_equal('20000', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_20
      customer_hash = {
        'orderId' => '20',
        'amount' => '3000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5390016478904678',
        'expDate' => '0312',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource['type'])
      assert_equal('10050', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
    def test_21
      customer_hash = {
        'orderId' => '21',
        'amount' => '5000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4457010201000246',
        'expDate' => '0912',
        'type' => 'VI'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
    end
  
    def test_22
      customer_hash = {
        'orderId' => '22',
        'amount' => '5000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4457010202000245',
        'expDate' => '1111',
        'type' => 'VI'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('MASS AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
    end
  
    def test_23
      customer_hash = {
        'orderId' => '23',
        'amount' => '5000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5112010201000109',
        'expDate' => '0412',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
    end
  
    def test_24
      customer_hash = {
        'orderId' => '24',
        'amount' => '5000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5112010202000108',
        'expDate' => '0812',
        'type' => 'MC'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('MASS AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
    end
  
    def test_25
      customer_hash = {
        'orderId' => '25',
        'amount' => '5000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4100204446270000',
        'expDate' => '1112',
        'type' => 'VI'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('BRA', auth_response.authorizationResponse.enhancedAuthResponse.issuerCountry)
    end
  
    # test 26-31 healthcare iias
    def test_26
      customer_hash = {
        'orderId' => '26',
        'amount' => '18698',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5194560012341234',
        'expDate' => '1212',
        'type' => 'MC'},
        'allowPartialAuth' => 'true',
        'healthcareIIAS' => {
        'healthcareAmounts' => {
        'totalHealthcareAmount' =>'20000'
        },
        'IIASFlag' => 'Y'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('341', auth_response.authorizationResponse.response)
      # assert_equal('Invalid healthcare amounts', auth_response.authorizationResponse.message)
    end
  
    def test_27
      customer_hash = {
        'orderId' => '27',
        'amount' => '18698',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5194560012341234',
        'expDate' => '1212',
        'type' => 'MC'},
        'allowPartialAuth' => 'true',
        'healthcareIIAS' => {
        'healthcareAmounts' => {
        'totalHealthcareAmount' =>'15000',
        'RxAmount' => '16000'
        },
        'IIASFlag' => 'Y'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('341', auth_response.authorizationResponse.response)
      # assert_equal('Invalid healthcare amounts', auth_response.authorizationResponse.message)
    end
  
    def test_28
      customer_hash = {
        'orderId' => '28',
        'amount' => '15000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'5194560012341234',
        'expDate' => '1212',
        'type' => 'MC'},
        'allowPartialAuth' => 'true',
        'healthcareIIAS' => {
        'healthcareAmounts' => {
        'totalHealthcareAmount' =>'15000',
        'RxAmount' => '3698'
        },
        'IIASFlag' => 'Y'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
    end
  
    def test_29
      customer_hash = {
        'orderId' => '29',
        'amount' => '18699',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4024720001231239',
        'expDate' => '1212',
        'type' => 'VI'},
        'allowPartialAuth' => 'true',
        'healthcareIIAS' => {
        'healthcareAmounts' => {
        'totalHealthcareAmount' =>'31000',
        'RxAmount' => '1000',
        'visionAmount' => '19901',
        'clinicOtherAmount' => '9050',
        'dentalAmount' => '1049'
        },
        'IIASFlag' => 'Y'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('341', auth_response.authorizationResponse.response)
      # assert_equal('Invalid healthcare amounts', auth_response.authorizationResponse.message)
    end
  
    def test_30
      customer_hash = {
        'orderId' => '30',
        'amount' => '20000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4024720001231239',
        'expDate' => '1212',
        'type' => 'VI'},
        'allowPartialAuth' => 'true',
        'healthcareIIAS' => {
        'healthcareAmounts' => {
        'totalHealthcareAmount' =>'20000',
        'RxAmount' => '1000',
        'visionAmount' => '19901',
        'clinicOtherAmount' => '9050',
        'dentalAmount' => '1049'
        },
        'IIASFlag' => 'Y'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('341', auth_response.authorizationResponse.response)
      # assert_equal('Invalid healthcare amounts', auth_response.authorizationResponse.message)
    end
  
    def test_31
      customer_hash = {
        'orderId' => '31',
        'amount' => '25000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'4024720001231239',
        'expDate' => '1212',
        'type' => 'VI'},
        'allowPartialAuth' => 'true',
        'healthcareIIAS' => {
        'healthcareAmounts' => {
        'totalHealthcareAmount' =>'18699',
        'RxAmount' => '1000',
        'visionAmount' => '15099'
        },
        'IIASFlag' => 'Y'
        }
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('010', auth_response.authorizationResponse.response)
      assert_equal('Partially Approved', auth_response.authorizationResponse.message)
      assert_equal('18699', auth_response.authorizationResponse.approvedAmount)
    end
  
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
      authorization_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', authorization_response.authorizationResponse.response)
      assert_equal('Approved', authorization_response.authorizationResponse.message)
      assert_equal('01', authorization_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('M', authorization_response.authorizationResponse.fraudResult.cardValidationResult)
  
      #test 32A
      capture_hash =  {'litleTxnId' => authorization_response.authorizationResponse.litleTxnId, 'amount' => '5005'}
      hash32a = capture_hash.merge(@@merchant_hash)
      capture_response = LitleOnlineRequest.new.capture(hash32a)
      assert_equal('000', capture_response.captureResponse.response)
      
  
      #test 32B
      authReversal_hash =  {'litleTxnId' => '123456789000'}
      hash1b = authReversal_hash.merge(@@merchant_hash)
      authReversal_response = LitleOnlineRequest.new.auth_reversal(hash1b)
      assert_equal('000', authReversal_response.authReversalResponse.response)
      
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
      authorization_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', authorization_response.authorizationResponse.response)
      assert_equal('Approved', authorization_response.authorizationResponse.message)
      assert_equal('22222', authorization_response.authorizationResponse.authCode)
      assert_equal('10', authorization_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('M', authorization_response.authorizationResponse.fraudResult.cardValidationResult)
  
      #test 33A
      authReversal_hash =  {'litleTxnId' => authorization_response.authorizationResponse.litleTxnId}
      hash1b = authReversal_hash.merge(@@merchant_hash)
      authReversal_response = LitleOnlineRequest.new.auth_reversal(hash1b)
      assert_equal('000', authReversal_response.authReversalResponse.response)
      
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
        'type' => 'DI'},
      }
      hash = customer_hash.merge(@@merchant_hash)
      authorization_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', authorization_response.authorizationResponse.response)
      assert_equal('Approved', authorization_response.authorizationResponse.message)
      assert_equal('33333', authorization_response.authorizationResponse.authCode)
      assert_equal('10', authorization_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('M', authorization_response.authorizationResponse.fraudResult.cardValidationResult)
  
      #test 34A
      authReversal_hash =  {'litleTxnId' => authorization_response.authorizationResponse.litleTxnId}
      hash1b = authReversal_hash.merge(@@merchant_hash)
      authReversal_response = LitleOnlineRequest.new.auth_reversal(hash1b)
      assert_equal('000', authReversal_response.authReversalResponse.response)
      
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
      authorization_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', authorization_response.authorizationResponse.response)
      assert_equal('Approved', authorization_response.authorizationResponse.message)
      assert_equal('44444', authorization_response.authorizationResponse.authCode)
      assert_equal('12', authorization_response.authorizationResponse.fraudResult.avsResult)
  
      #test 35A
      capture_hash =  {'litleTxnId' => authorization_response.authorizationResponse.litleTxnId, 'amount' => '20020'}
      hash32a = capture_hash.merge(@@merchant_hash)
      capture_response = LitleOnlineRequest.new.capture(hash32a)
      assert_equal('000', capture_response.captureResponse.response)
      
  
      #test 35B
      authReversal_hash =  {'litleTxnId' => authorization_response.authorizationResponse.litleTxnId, 'amount' => '20020'}
      hash1b = authReversal_hash.merge(@@merchant_hash)
      authReversal_response = LitleOnlineRequest.new.auth_reversal(hash1b)
      assert_equal('000', authReversal_response.authReversalResponse.response)
      
    end
    
    def test_36
      customer_hash = {
        'orderId' => '36',
        'amount' => '20500',
        'orderSource'=>'ecommerce',
        'card'=>{
        'number' =>'375000026600004',
        'expDate' => '0512',
        'type' => 'AX'},
      }
      hash = customer_hash.merge(@@merchant_hash)
      authorization_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', authorization_response.authorizationResponse.response)
      assert_equal('Approved', authorization_response.authorizationResponse.message)
  
      #test 36A
      authReversal_hash =  {'litleTxnId' => '123456789000', 'amount' => '10000'}
      hash1b = authReversal_hash.merge(@@merchant_hash)
      authReversal_response = LitleOnlineRequest.new.auth_reversal(hash1b)
      assert_equal('000', authReversal_response.authReversalResponse.response)
      
    end
  
  end
end