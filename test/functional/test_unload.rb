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

#test Unload Transaction
module LitleOnline
 class TestUnload < Test::Unit::TestCase
  
def test_simple_happy
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'orderId' =>'1001',
        'amount' =>'500',
        'orderSource' =>'ecommerce',
        'card'=>{
        'type'=>'GC',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
                }
	   }

    response= LitleOnlineRequest.new.unload_request(hash)
    assert_equal('Valid Format', response.message)
  end

  def test_simple_out_of_order
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'amount' =>'500',
        'orderId' =>'1001',
        'orderSource' =>'ecommerce',
        'card'=>{
        'type'=>'GC',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
                }
	   }

    response= LitleOnlineRequest.new.unload_request(hash)
    assert_equal('Valid Format', response.message)
  end

  def test_simple_error
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount' =>'500',	
	   }

    #Get exceptions
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.unload_request(hash)}
    #Test 
    assert(exception.message =~ /Error validating xml data against the schema/)
  end
  
  def test_GiftCardCardType_NotPresent
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' =>'test',
        'reportGroup'=>'Planets',
        'amount' =>'500',
        'orderId' =>'1001',
        'orderSource' =>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
                }
     }

   #Get exceptions
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.unload_request(hash)}
    #Test 
    assert(exception.message =~ /Error validating xml data against the schema/)
  end
 end
end
