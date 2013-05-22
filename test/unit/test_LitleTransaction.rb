=begin
Copyright (c) 2011 Litle & Co.

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
require 'lib/LitleOnline'
require 'lib/LitleOnlineRequest'
require 'lib/LitleBatchRequest'
require 'test/unit'
require 'mocha/setup'

module LitleOnline
  
  class TestLitleTransaction < Test::Unit::TestCase
    def test_authorization
      ltlTxn = LitleTransaction.new
      #Auithorization.expects(:new).omce
      authHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      result = ltlTxn.authorization(authHash)
      assert_equal "<authorization><orderId>12344</orderId><amount>106</amount><orderSource>ecommerce</orderSource><card><type>VI</type><number>4100000000000001</number><expDate>1210</expDate></card></authorization>", result.save_to_xml.to_s
    end    
  
  end
end