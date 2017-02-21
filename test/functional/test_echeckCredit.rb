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
  class Test_echeckCredit < Test::Unit::TestCase
    def test_simple_echeckcredit
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456789101112',
        'amount'=>'12'
      }
      response= LitleOnlineRequest.new.echeck_credit(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_no_amount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_credit(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

    def test_echeck_credit_with_echeck
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
      response= LitleOnlineRequest.new.echeck_credit(hash)
      assert_equal('Valid Format', response.message)
    end

    def test_echeck_credit_with_echeck_token
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
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_credit(hash)
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
      response= LitleOnlineRequest.new.echeck_credit(hash)
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
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_credit(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/) 
    end

    def test_echeck_credit_with_secondaryAmount
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
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_credit(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_echeck_credit_with_txnId_secondaryAmount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456789101112',
        'amount'=>'12',
        'secondaryAmount'=>'50'
      }
      response= LitleOnlineRequest.new.echeck_credit(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_echeck_credit_with_customIdentifier
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
      response= LitleOnlineRequest.new.echeck_credit(hash)
      assert_equal('Valid Format', response.message)
    end
  end
end
