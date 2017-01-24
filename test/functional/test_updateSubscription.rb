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

#test Authorization Transaction
module LitleOnline
 class TestUpdateSubscription < Test::Unit::TestCase
  
def test_simple_happy
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'subscriptionId' =>'1001'  
	   }

    response= LitleOnlineRequest.new.update_subscription(hash)
    assert_equal('Valid Format', response.message)
  end

  def test_simple_out_of_order
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
        'subscriptionId' =>'1001',
	'billingDate'=>'2014-03-11',
	'planCode'=>'planCodeString',
        'deleteDiscount'=>[{'discountCode'=>'discCode3'},{'discountCode'=>'discCode33'}],
        'updateAddOn'=>[
              {
		'addOnCode'=>'addOnCode2',
              }],
              'deleteAddOn'=>[{'addOnCode'=>'addOnCode3'}]
             
	   }

    response= LitleOnlineRequest.new.update_subscription(hash)
    assert_equal('Valid Format', response.message)
  end

  def test_simple_error
    hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
	   }

    #Get exceptions
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.update_subscription(hash)}
    #Test 
    assert(exception.message =~ /Error validating xml data against the schema/)
  end
 end
end
