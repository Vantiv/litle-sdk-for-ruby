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
  class TestUnloadReversal < Test::Unit::TestCase

    def test_simple
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId' => '5000',
        'card'=>{
          'type'=>'GC',
          'number' =>'400000000000001',
          'expDate' =>'0150',
          'pin' => '1234',
          'cardValidationNum' => '411'
        },
        'originalRefCode' => '101',
        'originalAmount' => '34561',
        'originalTxnTime' => '2017-01-24T09:00:00',
        'originalSystemTraceId' => '33',
        'originalSequenceNumber' => '111111',
      }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<litleTxnId>5000<\/litleTxnId><card><type>GC<\/type><number>400000000000001<\/number><expDate>0150<\/expDate><cardValidationNum>411<\/cardValidationNum><pin>1234<\/pin><\/card>.*/m), is_a(Hash))
      LitleOnlineRequest.new.deposit_reversal(hash)
    end
   end

end
