require 'lib/LitleOnline'
require 'test/unit'

class Litle_certTest2 < Test::Unit::TestCase
  #test enhanced data on auth response
  @@merchant_hash = {'reportGroup'=>'Planets',
    'merchantId'=>'101'
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
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
      assert_equal('PREPAID', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.type)
      assert_equal('10050', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.availableBalance)
      assert_equal('YES', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.reloadable)
      assert_equal('PAYROLL', auth_response.authorizationResponse.enhancedAuthResponse.fundingSource.prepaidCardType)
    end
  
  
#  def test_21
#    customer_hash = {
#      'orderId' => '21',
#      'amount' => '5000',
#      'orderSource'=>'ecommerce',
#      'card'=>{
#      'number' =>'4457010201000246',
#      'expDate' => '0912',
#      'type' => 'VI'
#      }
#    }
#    hash = customer_hash.merge(@@merchant_hash)
#    auth_response = LitleOnlineRequest.new.authorization(hash)
#    assert_equal('000', auth_response.authorizationResponse.response)
#    assert_equal('Approved', auth_response.authorizationResponse.message)
#    assert_equal('AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
#  end
#
#  def test_22
#    customer_hash = {
#      'orderId' => '22',
#      'amount' => '5000',
#      'orderSource'=>'ecommerce',
#      'card'=>{
#      'number' =>'4457010202000245',
#      'expDate' => '1111',
#      'type' => 'VI'
#      }
#    }
#    hash = customer_hash.merge(@@merchant_hash)
#    auth_response = LitleOnlineRequest.new.authorization(hash)
#    assert_equal('000', auth_response.authorizationResponse.response)
#    assert_equal('Approved', auth_response.authorizationResponse.message)
#    assert_equal('MASS AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
#  end

#  def test_23
#    customer_hash = {
#      'orderId' => '23',
#      'amount' => '5000',
#      'orderSource'=>'ecommerce',
#      'card'=>{
#      'number' =>'5112010201000109',
#      'expDate' => '0412',
#      'type' => 'MC'
#      }
#    }
#    hash = customer_hash.merge(@@merchant_hash)
#    auth_response = LitleOnlineRequest.new.authorization(hash)
#    assert_equal('000', auth_response.authorizationResponse.response)
#    assert_equal('Approved', auth_response.authorizationResponse.message)
#    assert_equal('AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
#  end
#
#  def test_24
#    customer_hash = {
#      'orderId' => '24',
#      'amount' => '5000',
#      'orderSource'=>'ecommerce',
#      'card'=>{
#      'number' =>'5112010202000108',
#      'expDate' => '0812',
#      'type' => 'MC'
#      }
#    }
#    hash = customer_hash.merge(@@merchant_hash)
#    auth_response = LitleOnlineRequest.new.authorization(hash)
#    assert_equal('000', auth_response.authorizationResponse.response)
#    assert_equal('Approved', auth_response.authorizationResponse.message)
#    assert_equal('MASS AFFLUENT', auth_response.authorizationResponse.enhancedAuthResponse.affluence)
#  end
#
#  def test_25
#    customer_hash = {
#      'orderId' => '25',
#      'amount' => '5000',
#      'orderSource'=>'ecommerce',
#      'card'=>{
#      'number' =>'4100204446270000',
#      'expDate' => '1112',
#      'type' => 'VI'}
#    }
#    hash = customer_hash.merge(@@merchant_hash)
#    auth_response = LitleOnlineRequest.new.authorization(hash)
#    assert_equal('000', auth_response.authorizationResponse.response)
#    assert_equal('Approved', auth_response.authorizationResponse.message)
#    assert_equal('BRA', auth_response.authorizationResponse.enhancedAuthResponse.issuerCountry)
#  end

  # test 26-31 healthcare
end
