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
  
  class TestLitleTransaction < Test::Unit::TestCase
    

    def test_authorization
      ltlTxn = LitleTransaction.new
      authHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      result = ltlTxn.authorization(authHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal "12344", result.orderId
      assert_equal "106", result.amount
      assert_equal "ecommerce", result.orderSource
      assert_equal "4100000000000001", result.card.number
      assert_equal "VI", result.card.mop
      assert_equal "1210", result.card.expDate
    end    
    
    def test_sale
      ltlTxn = LitleTransaction.new
      saleHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'amount'=>'6000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      result = ltlTxn.sale(saleHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal "12344", result.orderId
      assert_equal "6000", result.amount
      assert_equal "ecommerce", result.orderSource
      assert_equal "4100000000000001", result.card.number
      assert_equal "VI", result.card.mop
      assert_equal "1210", result.card.expDate
    end
    
    def test_credit
      ltlTxn = LitleTransaction.new
      creditHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      
      result = ltlTxn.credit(creditHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12344', result.orderId
      assert_equal '106', result.amount
      assert_equal 'ecommerce', result.orderSource
      assert_equal '4100000000000001', result.card.number
      assert_equal 'VI', result.card.mop
      assert_equal '1210', result.card.expDate
    end
    
    def test_auth_reversal
      ltlTxn = LitleTransaction.new
      authReversalHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'litleTxnId'=>'12345678000',
        'amount'=>'106',
        'payPalNotes'=>'Notes'
        }
      
      result = ltlTxn.auth_reversal(authReversalHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12345678000', result.litleTxnId
      assert_equal '106', result.amount
      assert_equal 'Notes', result.payPalNotes
    end
    
    def test_register_token_request
      ltlTxn = LitleTransaction.new
      registerTokenHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789103801'
      }
      
      result = ltlTxn.register_token_request(registerTokenHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12344', result.orderId
      assert_equal '1233456789103801', result.accountNumber
    end
    
    def test_update_card_validation_num_on_token
      ltlTxn = LitleTransaction.new
      updateCardHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'litleToken'=>'1233456789103801',
        'cardValidationNum'=>'123'
      }
      
      result = ltlTxn.update_card_validation_num_on_token(updateCardHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12344', result.orderId
      assert_equal '1233456789103801', result.litleToken
      assert_equal '123', result.cardValidationNum
    end
    
    def test_force_capture
      ltlTxn = LitleTransaction.new
      forceCaptHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
      
      result = ltlTxn.force_capture(forceCaptHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12344', result.orderId
      assert_equal '106', result.amount
      assert_equal 'ecommerce', result.orderSource
      assert_equal 'VI', result.card.mop
      assert_equal '4100000000000001', result.card.number
      assert_equal '1210', result.card.expDate
    end
    
    def test_capture
      ltlTxn = LitleTransaction.new
      captHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
      }
      
      result = ltlTxn.capture(captHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '123456000', result.litleTxnId
      assert_equal '106', result.amount
    end
    
    def test_capture_given_auth
      ltlTxn = LitleTransaction.new
      captGivenAuthHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'amount'=>'106',
        'authInformation' => {
        'authDate'=>'2002-10-09',
        'authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      
      result = ltlTxn.capture_given_auth(captGivenAuthHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12344', result.orderId
      assert_equal '106', result.amount
      assert_equal 'ecommerce', result.orderSource
      assert_equal 'VI', result.card.mop
      assert_equal '4100000000000000', result.card.number
      assert_equal '1210', result.card.expDate
      assert_equal '2002-10-09', result.authInformation.authDate
      assert_equal '543216', result.authInformation.authCode
      assert_equal '12345', result.authInformation.authAmount
    end
    
    def test_echeck_verification
      ltlTxn = LitleTransaction.new
      echeckVerificationHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'amount'=>'123456',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking',
        'accNum'=>'12345657890',
        'routingNum'=>'123456789',
        'checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob',
        'city'=>'lowell',
        'state'=>'MA',
        'email'=>'litle.com'}
      }
      
      result = ltlTxn.echeck_verification(echeckVerificationHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12345', result.orderId
      assert_equal '123456', result.amount
      assert_equal 'ecommerce', result.orderSource
      assert_equal 'Checking', result.echeck.accType
      assert_equal '12345657890', result.echeck.accNum
      assert_equal '123456789', result.echeck.routingNum
      assert_equal '123455', result.echeck.checkNum
      assert_equal 'Bob', result.billToAddress.name
      assert_equal 'lowell', result.billToAddress.city
      assert_equal 'MA', result.billToAddress.state
      assert_equal 'litle.com', result.billToAddress.email
    end
    
    def test_echeck_credit
      ltlTxn = LitleTransaction.new
      echeckCreditHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'litleTxnId'=>'123456789101112',
        'amount'=>'12'
      }
      
      result = ltlTxn.echeck_credit(echeckCreditHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '123456789101112', result.litleTxnId
      assert_equal '12', result.amount
    end
    
    def test_echeck_redeposit
      ltlTxn = LitleTransaction.new
      echeckRedeopsitHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'litleTxnId'=>'123456'
      }
      
      result = ltlTxn.echeck_redeposit(echeckRedeopsitHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '123456', result.litleTxnId
    end
    
    def test_echeck_sale
      ltlTxn = LitleTransaction.new
      echeckSaleHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      
      result = ltlTxn.echeck_sale(echeckSaleHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal '12345', result.orderId
      assert_equal '123456', result.amount
      assert_equal 'true', result.verify
      assert_equal 'ecommerce', result.orderSource
      assert_equal 'Checking', result.echeck.accType
      assert_equal '12345657890', result.echeck.accNum
      assert_equal '123456789', result.echeck.routingNum
      assert_equal '123455', result.echeck.checkNum
      assert_equal 'Bob', result.billToAddress.name
      assert_equal 'lowell', result.billToAddress.city
      assert_equal 'MA', result.billToAddress.state
      assert_equal 'litle.com', result.billToAddress.email
    end
    
    def test_account_update
      ltlTxn = LitleTransaction.new
      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      result = ltlTxn.account_update(accountUpdateHash)
      assert_equal 'Planets', result.reportGroup
      assert_equal '12345', result.transactionId
      assert_equal '0987', result.customerId
      assert_equal "4100000000000001", result.card.number
      assert_equal "VI", result.card.mop
      assert_equal "1210", result.card.expDate
    end   

    
    def test_queryTransaction
          ltlTxn = LitleTransaction.new
      queryTransactionHash = {
            'merchantId' => '101',
            'version'=>'8.8',
            'reportGroup'=>'Planets',
            'id'=>'12345',
            'customerId'=>'0987',
            'origId'=>'834262',
            'origActionType'=>'A',
            'origLitleTxnId'=>'123456',
            'origOrderId' => '65347567',
            'origAccountNumber'=>'4000000000000001'
          }
          
          result = ltlTxn.query_Transaction(queryTransactionHash)
          assert_equal 'Planets', result.reportGroup
          assert_equal '12345', result.transactionId
          assert_equal '0987', result.customerId
          assert_equal '834262', result.origId
          assert_equal 'A', result.origActionType
          assert_equal '123456', result.origLitleTxnId
          #assert_equal '65347567', result.origOrderId
          #assert_equal '4000000000000001', result.origAccountNumber
        end 
  end
end