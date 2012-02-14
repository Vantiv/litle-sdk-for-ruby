=begin
Copyright (c) 2012 Litle & Co.

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
require 'test/unit'

class TestForceCapture < Test::Unit::TestCase
  def test_noOrderId
    hash = {
      'merchantId' => '101',
      'version'=>'8.8',
      'reportGroup'=>'Planets',
      'litleTxnId'=>'123456',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'token'=> {
      'litleToken'=>'123456789101112',
      'expDate'=>'1210',
      'cardValidationNum'=>'555',
      'type'=>'VI'
      }}
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.forceCapture(hash)}
    assert_match /Missing Required Field: orderId!!!!/, exception.message
  end

  def test_noOrderSource
    hash = {
      'merchantId' => '101',
      'version'=>'8.8',
      'reportGroup'=>'Planets',
      'litleTxnId'=>'123456',
      'orderId'=>'12344',
      'amount'=>'106',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.forceCapture(hash)}
    assert_match /Missing Required Field: orderSource!!!!/, exception.message
  end

  def test_BothChoicesCardandtoken
    hash = {
      'merchantId' => '101',
      'version'=>'8.8',
      'reportGroup'=>'Planets',
      'litleTxnId'=>'123456',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'fraudCheck'=>{'authenticationTransactionId'=>'123'},
      'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      },
      'token'=> {
      'litleToken'=>'1234',
      'expDate'=>'1210',
      'cardValidationNum'=>'555',
      'type'=>'VI'
      }}
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.forceCapture(hash)}
    assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
  end

  def test_allChoices
    hash = {
      'merchantId' => '101',
      'version'=>'8.8',
      'reportGroup'=>'Planets',
      'litleTxnId'=>'123456',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'fraudCheck'=>{'authenticationTransactionId'=>'123'},
      'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      },
      'paypage'=> {
      'paypageRegistrationId'=>'1234',
      'expDate'=>'1210',
      'cardValidationNum'=>'555',
      'type'=>'VI'},
      'token'=> {
      'litleToken'=>'1234',
      'expDate'=>'1210',
      'cardValidationNum'=>'555',
      'type'=>'VI'
      }}
    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.forceCapture(hash)}
    assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
  end

end

