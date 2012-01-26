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

require_relative '../../lib/LitleOnline'
require_relative '../../lib/LitleOnlineRequest'
require 'test/unit'

class TestcaptureGivenAuth < Test::Unit::TestCase
	 def test_simplecaptureGivenAuth_withCard
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.captureGivenAuth(hash)
		 assert_equal('Valid Format', response.message)
	 end
	 def test_simplecaptureGivenAuth_withToken
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216', 'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
		 'authAmount'=>'12345'
		 },
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'token'=> {
		 'litleToken'=>'123456789101112',
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'
		 }}
		 response= LitleOnlineRequest.captureGivenAuth(hash)
		 assert_equal('Valid Format', response.message)
	 end
	 def test_noReportGroup
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'orderId'=>'12344',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.captureGivenAuth(hash)}
   		 assert_match /Missing Required Field: @reportGroup!!!!/, exception.message
	 end
	 def test_noamount
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.captureGivenAuth(hash)}
    		 assert_match /Missing Required Field: amount!!!!/, exception.message
	 end
	 def test_FieldsOutOfOrder
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'orderSource'=>'ecommerce',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'amount'=>'106',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 },
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344'
		 }
		 response= LitleOnlineRequest.captureGivenAuth(hash)
		 assert_equal('Valid Format', response.message)
	end
        def test_InvalidField
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'NOexistantField' => 'ShouldNotCauseError',
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.captureGivenAuth(hash)
		 assert_equal('Valid Format', response.message)
	end
 	def test_BothChoicesCardandToken
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'token'=> {
		 'litleToken'=>'123456789101112',
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'},
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.captureGivenAuth(hash)}
   		 assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
	 end
	 def test_allthreechoices
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
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

		 exception = assert_raise(RuntimeError){LitleOnlineRequest.captureGivenAuth(hash)}
   		 assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
	 end
	 def test_complex_captureGivenAuth
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345'
		 },
		 'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
		  'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.captureGivenAuth(hash)
		 assert_equal('Valid Format', response.message)
	 end
	 def test_authInfo
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'authInformation' => {
		 'authDate'=>'2002-10-09','authCode'=>'543216',
		 'authAmount'=>'12345','fraudResult'=>{'avsResult'=>'12','cardValidationResult'=>'123','authenticationResult'=>'1',
		 'advancedAVSResult'=>'123'}
		 },
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.captureGivenAuth(hash)
		 assert_equal('Valid Format', response.message)
	 end
end

 
