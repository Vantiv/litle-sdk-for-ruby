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
  class Test_echeckSale < Test::Unit::TestCase
    def test_echeck_sale_with_echeck
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_no_amount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_sale(hash)}
      #Test 
      assert(exception.message =~ /The content of element 'echeckSale' is not complete/) 
    end

    def test_echeck_sale_with_echeck1
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_echeck_sale_with_ship_to
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'shipToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_echeck_sale_with_echeck_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeckToken' => {'accType'=>'Checking','litleToken'=>'1234565789012','routingNum'=>'123456789','checkNum'=>'123455'},
        'customBilling'=>{'phone'=>'123456789','descriptor'=>'good'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_extra_field_and_incorrect_order
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123',
        'invalidfield'=>'nonexistant',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_extra_field_and_missing_billing
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123',
        'invalidfield'=>'nonexistant',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_sale(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_simple_echeck_sale
      hash = {
        'reportGroup'=>'Planets',
        'id'=>'test',
        'litleTxnId'=>'123456789101112',
        'orderId'=>'12345',
        'amount'=>'12',
        'orderSource'=>'ecommerce',
        'echeckToken' => {'accType'=>'Checking','litleToken'=>'1234565789012','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'shipToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_simple_echeck_sale_with_custom_billing
      hash = {
        'reportGroup'=>'Planets',
        'id'=>'test',
        'litleTxnId'=>'123456',
        'orderId'=>'12345',
        'amount'=>'10',
        'orderSource'=>'ecommerce',
        'echeckToken' => {'accType'=>'Checking','litleToken'=>'1234565789012','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'shipToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_echeck_sale_with_secondaryAmount_ccd
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'secondaryAmount'=>'50',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455','ccdPaymentInformation'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_echeck_sale_with_secondaryAmount_ccd_longer_than_80
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'secondaryAmount'=>'50',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455','ccdPaymentInformation'=>'123456789012345678901234567890123456789012345678901234567890123456789012345678901'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      assert_raises RuntimeError do 
        response= LitleOnlineRequest.new.echeck_sale(hash)
        puts "validation for ccdPaymentInformation"
      end
    end
    
    def test_echeck_sale_with_txnId_secondaryAmount
      hash = {
        'reportGroup'=>'Planets',
        'id'=>'test',
        'litleTxnId'=>'123456789101112',
        'amount'=>'12',
        'secondaryAmount'=>'50'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_sale(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
    
    def test_echeck_sale_with_customIdentifier
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'shipToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'merchantData'=>{'campaign'=>'camping'},
        'customIdentifier' =>'identifier',   
      }
      response= LitleOnlineRequest.new.echeck_sale(hash)
      assert_equal('Valid Format', response.message)
    end

  end
end