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
  class Test_echeckVerification < Test::Unit::TestCase
  
    def test_simple_echeck_verification
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_verification(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_echeck_verification_with_echeck_token
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeckToken' => {'accType'=>'Checking','litleToken'=>'1234565789012','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_verification(hash)
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
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
      response= LitleOnlineRequest.new.echeck_verification(hash)
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
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_verification(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
    
    def test_no_amount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId'=>'12345'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_verification(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
  
    def test_no_order_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_verification(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
  
    def test_no_order_source
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'orderId'=>'12345'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.echeck_verification(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
    
    def test_no_litleTxnId
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount'=>'123',
        'invalidfield'=>'nonexistant',
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        #'litleTxnId'=>'123456',
      }
      response= LitleOnlineRequest.new.echeck_verification(hash)
      assert_equal('Valid Format', response.message)
    end
  
  end

end