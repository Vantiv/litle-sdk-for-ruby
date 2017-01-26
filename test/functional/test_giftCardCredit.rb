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

#test GiftCardCapture Transaction
module LitleOnline
  class TestGiftCardCredit < Test::Unit::TestCase
    def test_giftCardCredit
      hash = {
        'id'=>'test',
        'merchantId' => '101',
        'version'=>'8.8',
        'litleTxnId' => '5000',
        'creditAmount' =>'1000',
        #'orderId' =>'1230',
        'card'=>{
          'type'=>'GC',
          'number' =>'400000000000000',
          'expDate' =>'0150',
          'pin' => '1234',
          'cardValidationNum' => '411'
        },
        'reportGroup'=>'Planets',
      }

      response= LitleOnlineRequest.new.giftCardCredit(hash)
      assert_equal('000', response.giftCardCreditResponse.response)
      assert_equal('0', response.giftCardCreditResponse.giftCardResponse.systemTraceId)
    end

    def test_simple_error
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id'=>'test',
        'reportGroup'=>'Planets',
      }

      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.giftCardCredit(hash)}
      #Test
      assert(exception.message =~ /Error validating xml data against the schema/)
    end

  end
end
