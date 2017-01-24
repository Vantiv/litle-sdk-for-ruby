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
  class Test_capture < Test::Unit::TestCase
    def test_simple_capture
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
      }
      response= LitleOnlineRequest.new.capture(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_simple_capture_with_partial
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'partial'=>'true',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
      }
      response= LitleOnlineRequest.new.capture(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_complex_capture
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
        'enhancedData'=>{
        'customerReference'=>'Litle',
        'salesTax'=>'50',
        'deliveryType'=>'TBD'},
        'payPalOrderComplete'=>'true'
      }
      response= LitleOnlineRequest.new.capture(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_no_txn_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'pin'=>'3333'
      }
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.capture(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
    
     def test_custom_billing
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'secondaryAmount'=>'20',
        'litleTxnId'=>'1234',
        'customBilling'=>{
        'city' =>'boston',
        'descriptor' => 'card was present',
        }}
      response= LitleOnlineRequest.new.capture(hash)
      assert_equal('Valid Format', response.message)   
    end
    
      def test_simple_capture_with_pin
      hash = {
        'merchantId' => '101',
        'id' => '102',
        'reportGroup'=>'Planets',
        'amount'=>'106',
        'secondaryAmount'=>'20',
        'litleTxnId'=>'123456000',
        'pin'=>'1234'
      }
      response= LitleOnlineRequest.new.capture(hash)
      assert_equal('Valid Format', response.message) 
    end
    
 
  
  end
end