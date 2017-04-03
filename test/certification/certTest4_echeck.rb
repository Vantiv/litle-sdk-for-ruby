require File.expand_path("../../../lib/LitleOnline",__FILE__) 
require 'test/unit'

module LitleOnline
  class Litle_certTest4 < Test::Unit::TestCase
    # test echeck
    @@merchant_hash = {'reportGroup'=>'Planets',
      'merchantId'=>'101',
      'id'=>'test'
    }
  
  #  test 37-49 merchant authorizate to do echeck using 087901 with same username IMPTEST, password cert3d6Z
  #  test 37-40 echeckVerification
      def test_37
        customer_hash = {
          'orderId' => '37',
          'amount' => '3001',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Tom',
          'lastName' => 'Black'},
    
          'echeck'=>{
          'accNum' =>'10@BC99999',
          'accType' => 'Checking',
          'routingNum' => '053100300'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_verification(hash)
        assert_equal('301', echeck_response.echeckVerificationResponse.response)
        assert_equal('Invalid Account Number', echeck_response.echeckVerificationResponse.message)
      end
  
    def test_38
      customer_hash = {
        'orderId' => '38',
        'amount' => '3002',
        'orderSource'=>'telephone',
        'billToAddress'=>{
          'firstName' => 'John',
          'lastName' => 'Smith',
          'phone' => '999-999-9999'
        },
  
        'echeck'=>{
        'accNum' =>'1099999999',
        'accType' => 'Checking',
        'routingNum' => '053000219'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      echeck_response = LitleOnlineRequest.new.echeck_verification(hash)
      assert_equal('000', echeck_response.echeckVerificationResponse.response)
      assert_equal('Approved', echeck_response.echeckVerificationResponse.message)
    end
  
      def test_39
        customer_hash = {
          'orderId' => '39',
          'amount' => '3003',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Robert',
          'lastName' => 'Jones',
          'companyName' => 'Good Goods Inc',
          'phone' => '9999999999'
          },
    
          'echeck'=>{
          'accNum' =>'3099999999',
          'accType' => 'Corporate',
          'routingNum' => '053100300'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_verification(hash)
        assert_equal('950', echeck_response.echeckVerificationResponse.response)
        # assert_equal('Declined - Negative Information on File', echeck_response.echeckVerificationResponse.message)
      end
    
      def test_40
        customer_hash = {
          'orderId' => '40',
          'amount' => '3004',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Peter',
          'lastName' => 'Green',
          'companyName' => 'Green Co',
          'phone' => '9999999999'
          },
    
          'echeck'=>{
          'accNum' =>'8099999999',
          'accType' => 'Corporate',
          'routingNum' => '063102152'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_verification(hash)
        assert_equal('951', echeck_response.echeckVerificationResponse.response)
        assert_equal('Absolute Decline', echeck_response.echeckVerificationResponse.message)
      end
  
    #  #test 41-44 echeckSales
      def test_41
        customer_hash = {
          'orderId' => '41',
          'amount' => '2008',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Mike',
          'middleInitial' => 'J',
          'lastName' => 'Hammer'
          },
          'echeck'=>{
          'accNum' =>'10@BC99999',
          'accType' => 'Checking',
          'routingNum' => '053100300'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_sale(hash)
    
        assert_equal('301', echeck_response.echeckSalesResponse.response)
        assert_equal('Invalid Account Number', echeck_response.echeckSalesResponse.message)
      end
    
      def test_42
        customer_hash = {
          'orderId' => '42',
          'amount' => '2004',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Tom',
          'lastName' => 'Black'
          },
          'echeck'=>{
          'accNum' =>'4099999992',
          'accType' => 'Checking',
          'routingNum' => '211370545'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_sale(hash)
    
        assert_equal('000', echeck_response.echeckSalesResponse.response)
        assert_equal('Approved', echeck_response.echeckSalesResponse.message)
      end
    
      def test_43
        customer_hash = {
          'orderId' => '43',
          'amount' => '2007',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Peter',
          'lastName' => 'Green',
          'companyName' => 'Green Co'
          },
    
          'echeck'=>{
          'accNum' =>'6099999992',
          'accType' => 'Corporate',
          'routingNum' => '211370545'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_sale(hash)
    
        assert_equal('000', echeck_response.echeckSalesResponse.response)
        assert_equal('Approved', echeck_response.echeckSalesResponse.message)
      end
    
      def test_44
        customer_hash = {
          'orderId' => '44',
          'amount' => '2009',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Peter',
          'lastName' => 'Green',
          'companyName' => 'Green Co'
          },
    
          'echeck'=>{
          'accNum' =>'9099999992',
          'accType' => 'Corporate',
          'routingNum' => '053133052'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_sale(hash)
    
        assert_equal('900', echeck_response.echeckSalesResponse.response)
        assert_equal('Invalid Bank Routing Number', echeck_response.echeckSalesResponse.message)
      end
    
    #  #test 45-49 echeckCredit
      def test_45
        customer_hash = {
          'orderId' => '45',
          'amount' => '1001',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'John',
          'lastName' => 'Smith'
          },
          'echeck'=>{
          'accNum' =>'10@BC99999',
          'accType' => 'Checking',
          'routingNum' => '053100300'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_credit(hash)
    
        # assert_equal('301', echeck_response.echeckCreditResponse.response)
      end
    
      def test_46
        customer_hash = {
          'orderId' => '46',
          'amount' => '1003',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Robert',
          'lastName' => 'Jones',
          'companyName' => 'Widget Inc'
          },
          'echeck'=>{
          'accNum' =>'3099999999',
          'accType' => 'Corporate',
          'routingNum' => '063102152'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_credit(hash)
    
        assert_equal('000', echeck_response.echeckCreditResponse.response)
        
      end
    
      def test_47
        customer_hash = {
          'orderId' => '47',
          'amount' => '1007',
          'orderSource'=>'telephone',
          'billToAddress'=>{
          'firstName' => 'Peter',
          'lastName' => 'Green',
          'companyName' => 'Green Co'
          },
          'echeck'=>{
          'accNum' =>'6099999993',
          'accType' => 'Corporate',
          'routingNum' => '211370545'}
        }
        hash = customer_hash.merge(@@merchant_hash)
        echeck_response = LitleOnlineRequest.new.echeck_credit(hash)
    
        assert_equal('000', echeck_response.echeckCreditResponse.response)
        
      end
      
    def test_48
      customer_hash = {
        'litleTxnId' => '430000000000000000'
      }
      hash = customer_hash.merge(@@merchant_hash)
      echeck_response = LitleOnlineRequest.new.echeck_credit(hash)
  
      assert_equal('000', echeck_response.echeckCreditResponse.response)
      
    end
    
    def test_49
      customer_hash = {
        
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456789101000',
        'amount'=>'12'
      }
      hash = customer_hash.merge(@@merchant_hash)
      echeck_response = LitleOnlineRequest.new.echeck_credit(hash)
  
      assert_equal('000', echeck_response.echeckCreditResponse.response)
      
    end
  end
end