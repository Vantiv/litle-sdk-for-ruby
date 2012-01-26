=begin
Copyright (c) 20011 Litle & Co.

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

require_relative '../lib/LitleOnline'
require_relative '../lib/LitleOnlineRequest'
require 'test/unit'

 class Test_capture < Test::Unit::TestCase
	 def test_simplecapture
		 hash = {
	 	 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456', 
		 'amount'=>'106',
		 }
		 response= LitleOnlineRequest.capture(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_simplecapturewithpartial
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'partial'=>'true',
		 'litleTxnId'=>'123456', 
		 'amount'=>'106',
		 }
		 response= LitleOnlineRequest.capture(hash)
		 assert_equal('Valid Format', response.message)
	end
        def test_noReportGroup
		hash = {
		 'litleTxnId'=>'123456', 
		 'amount'=>'106',
		 }
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.capture(hash)}
   		 assert_match /Missing Required Field: @reportGroup!!!!/, exception.message
	end
	def test_noTxnId
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'amount'=>'106',
		 }
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.capture(hash)}
   		assert_match /Missing Required Field: litleTxnId!!!!/, exception.message
	end
	def test_complexcapture
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456', 
		 'amount'=>'106',
		 'enhancedData'=>{
		 'customerReference'=>'Litle',
		 'salesTax'=>'50',
		 'deliveryType'=>'TBD'},
		 'payPalOrderComplete'=>'true'
		 }
		 response= LitleOnlineRequest.capture(hash)
		 assert_equal('Valid Format', response.message)
	end
end

 