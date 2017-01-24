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

# TESTING THE WALLET FEATURE FOR SALE TRANSACTION
# TYPE 1 - Success Scenarios
# TYPE 2 - Error Scenarios

module LitleOnline
=begin
  Definition: Class Definition for the Testing Class TestWallet
  Created on: 01-29-2016
  Reason: To test the incorporation new features developed in Ruby SDK as per XML 10.1 schema. 
=end
  
class TestWallet < Test::Unit::TestCase 
  
=begin
      Name - test_sale_wallet_no_sourcetype
      Type - 2
      Description - To validate request without providing a walletSourceType node
      Expected Response - Error messgae -If wallet is specified, it must have a walletSourceType. 
=end 
    def test_sale_wallet_no_sourcetype
         hash = 
         {
            'merchantId' => '101',
            'id' => 'test',
            'version'=>'8.8',
            'reportGroup'=>'Planets',
            'litleTxnId'=>'123456',
            'orderId'=>'12344',
            'amount'=>'106',
            'orderSource'=>'ecommerce',
            'paypal'=>
              {
                'payerId'=>'1234',
                'token'=>'1234',
                'transactionId'=>'123456'
              },
              'wallet'=> 
                {
                  'walletSourceTypeId' => '102'                  
                }
          }
         
         exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
         assert_match /If wallet is specified, it must have a walletSourceType/, exception.message
         
    end
   
=begin
       Name - test_sale_wallet_no_sourcetypeid
       Type - 2
       Description - To validate request without providing a walletSourceTypeId node
       Expected Response - Error messgae -If wallet is specified, it must have a walletSourceTypeId. 
=end 
    def test_sale_wallet_no_sourcetypeid
      hash = 
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypal'=>
          {
            'payerId'=>'1234',
            'token'=>'1234',
            'transactionId'=>'123456'
          },
            
         'wallet'=> 
          {
            'walletSourceType' => 'MasterPass'
          }
      } 
      
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /If wallet is specified, it must have a walletSourceTypeId/, exception.message
   
   end

   
=begin
       Name - test_success_sale_wallet
       Type - 1
       Description - To validate request by providing both walletSourceTypeId and walletSourceType nodes
       Expected Response - Success Request. 
=end 
    def test_success_sale_wallet
      hash = 
        {
          'merchantId' => '101',
          'id' => 'test',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'litleTxnId'=>'123456',
          'orderId'=>'12344',
          'amount'=>'106',
          'orderSource'=>'ecommerce',
          'paypal'=>
            {
              'payerId'=>'1234',
              'token'=>'1234',
              'transactionId'=>'123456'
            },
            
            'wallet'=> 
              {
                'walletSourceType' => 'MasterPass',
                'walletSourceTypeId' => '102'
              }
        }              
        
        LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<sale.*?<wallet>.*?<walletSourceType>MasterPass<\/walletSourceType>.*?<\/wallet>.*?<\/sale>.*?/m), is_a(Hash))
        LitleOnlineRequest.new.sale(hash)
    end
      
    
# TESTING THE WALLET FEATURE FOR AUTHORIZATION TRANSACTION
# TYPE 1 - Success Scenarios
# TYPE 2 - Error Scenarios   
    
=begin
       Name - test_success_auth_wallet
       Type - 1
       Description - To validate request by providing both walletSourceTypeId and walletSourceType nodes
       Expected Response - Success Request. 
=end       
  def test_success_auth_wallet
      hash = 
        {
          'merchantId' => '101',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'orderId'=>'12344',
          'amount'=>'106',
          'orderSource'=>'ecommerce',
          'applepay'=>
          {
            'data'=>'user',
            'header'=>
              {
                 'applicationData'=>'454657413164',
                 'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                 'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                 'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
              },
        
              'signature' =>'sign',
              'version' =>'10000'
          },
            'wallet'=> 
              {
              'walletSourceType' => 'MasterPass',
              'walletSourceTypeId' => '102'                  
              }
       }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<authorization.*?<wallet>.*?<walletSourceType>MasterPass<\/walletSourceType><walletSourceTypeId>102<\/walletSourceTypeId>.*?<\/wallet>.*?<\/authorization>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
    
=begin
       Name - test_auth_wallet_no_sourcetype
       Type - 2
       Description - To validate request without providing a walletSourceType node
       Expected Response - Error messgae -If wallet is specified, it must have a walletSourceType. 
=end       
def test_auth_wallet_no_sourcetype
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'applepay'=>{
        'data'=>'user',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        },
        'signature' =>'sign',
        'version' =>'10000'
        },
        'wallet'=> {
          'walletSourceTypeId' => '102'                  
       }
      }

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /If wallet is specified, it must have a walletSourceType/, exception.message
    end
    
=begin
       Name - test_auth_wallet_no_sourcetypeid
       Type - 2
       Description - To validate request without providing a walletSourceTypeId node
       Expected Response - Error messgae -If wallet is specified, it must have a walletSourceTypeId.
=end       
   def test_auth_wallet_no_sourcetypeid
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'applepay'=>{
        'data'=>'user',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        },
        'signature' =>'sign',
        'version' =>'10000'
        },
        'wallet'=> {
          'walletSourceType' => 'MasterPass',               
       }
      }

      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /If wallet is specified, it must have a walletSourceTypeId/, exception.message
    end    
  end
end