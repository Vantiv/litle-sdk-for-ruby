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

class TestXmlfields < Test::Unit::TestCase
	def test_cardnoRequiredtypeortrack
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'number' =>'4100000000000001',
		 'expDate' =>'1210',
		 'cardValidationNum'=> '123'
		 }}
		 response= LitleOnlineRequest.sale(hash)
		 assert(response.message =~ /Error validating xml data against the schema/)
	end
	def test_cardbothtypeandtrack
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI',
		 'track'=>'1234',
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.sale(hash)}
   		 assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
	end
	def test_simpleCustomBilling
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'customBilling'=>{'phone'=>'123456789','descriptor'=>'good'},
		 'card'=>{
		 'type'=>'VI',
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.sale(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_customBillingwithtwoChoices
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'customBilling'=>{'phone'=>'1234567890','url'=>'www.litle.com'},
		 'card'=>{
		 'type'=>'VI',
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.sale(hash)}
		 assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
	end
	def test_customBillingwiththreeChoices
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'customBilling'=>{'phone'=>'123456789','url'=>'www.litle.com','city'=>'lowell'},
		 'card'=>{
		 'type'=>'VI',
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.sale(hash)}
		 assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
	end
	def test_BillMeLater
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'billMeLaterRequest'=>{'bmlMerchantId'=>'12345','preapprovalNumber'=>'12345678909023',
		 'customerPhoneChnaged'=>'False','itemCategoryCode'=>'2'},
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.sale(hash)
		 assert_equal('000', response.saleResponse.response)
	end
	def test_CustomerInfo
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'CustomerInfo'=>{'ssn'=>'12345','incomeAmount'=>'12345','incomeCurrency'=>'dollar','yearsAtResidence'=>'2'},
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.sale(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_paypalmissingPayerid
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'paypal'=>{
		 'token'=>'1234',
		 'transactionId'=>'123456'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.authorization(hash)}
   	 	 assert_match /Missing Required Field: payerId!!!!/, exception.message
	end
	def test_paypalmissingtransactionId
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'litleTxnId'=>'123456',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'paypal'=>{
		 'token'=>'1234',
		 'payerId'=>'123456'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.authorization(hash)}
   	 	 assert_match /Missing Required Field: transactionId!!!!/, exception.message
	end
	def test_simplebilltoAddress
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
		 'card'=>{
		 'type'=>'VI',
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.authorization(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_processingInstructions
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		}}
		 response= LitleOnlineRequest.authorization(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_pos
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'pos'=>{'capability'=>'notused','entryMode'=>'track1','cardholderId'=>'pin'},
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'
		 }}
		 response= LitleOnlineRequest.authorization(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_poswithoutCapability
	 	 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
	 	 'reportGroup'=>'Planets',
	 	 'orderId'=>'12344',
	 	 'amount'=>'106',
	 	 'orderSource'=>'ecommerce',
	 	 'pos'=>{'entryMode'=>'track1','cardholderId'=>'pin'},
	  	 'card'=>{
	 	 'type'=>'VI', 
	 	 'number' =>'4100000000000001',
	 	 'expDate' =>'1210'
	 	 }}
	 	 exception = assert_raise(RuntimeError){LitleOnlineRequest.authorization(hash)}
   	 	 assert_match /Missing Required Field: capability!!!!/, exception.message
	end
	def test_poswithinvalidentryMode
	 	 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
	 	 'reportGroup'=>'Planets',
	 	 'orderId'=>'12344',
	 	 'amount'=>'106',
	 	 'orderSource'=>'ecommerce',
	 	 'pos'=>{'entryMode'=>'none','cardholderId'=>'pin','capability'=>'notused'},
	  	 'card'=>{
	 	 'type'=>'VI', 
	 	 'number' =>'4100000000000001',
	 	 'expDate' =>'1210'
	 	 }}
	 	 response= LitleOnlineRequest.credit(hash)
		 assert(response.message =~ /Error validating xml data against the schema/)
	end
	def test_amexData
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'},
		 'orderSource'=>'ecommerce',
		 'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'1234','sellerId'=>'1234Id'}
		 }
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_amexDatamissingsellerId
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'},
		 'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'1234'}
		 }
		 response= LitleOnlineRequest.credit(hash)
   	 	 assert(response.message =~ /Error validating xml data against the schema/)
	end
	def test_simpleEnhancedData
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'},
		 'orderSource'=>'ecommerce',
		 'enhancedData'=>{
		 'customerReference'=>'Litle',
		 'salesTax'=>'50',
		 'deliveryType'=>'TBD',
		 'restriction'=>'DIG',
		 'shipFromPostalCode'=>'01741',
		 'destinationPostalCode'=>'01742'}
		 }
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
        def test_simpleEnhancedDataincorrectEnumforCountryCode
		  hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'},
		 'orderSource'=>'ecommerce',
		 'enhancedData'=>{
		 'destinationCountryCode'=>'001',
		 'customerReference'=>'Litle',
		 'salesTax'=>'50',
		 'deliveryType'=>'TBD',
		 'shipFromPostalCode'=>'01741',
		 'destinationPostalCode'=>'01742'}
		 }
		 response= LitleOnlineRequest.credit(hash)
		 assert(response.message =~ /Error validating xml data against the schema/)
	end
	def test_EnhancedDatawithdetailtax
		  hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'},
		 'orderSource'=>'ecommerce',
		 'enhancedData'=>{
		 'detailtax'=>{'taxAmount'=>'1234','tax'=>'50'},
		 'customerReference'=>'Litle',
		 'salesTax'=>'50',
		 'deliveryType'=>'TBD',
		 'restriction'=>'DIG',
		 'shipFromPostalCode'=>'01741',
		 'destinationPostalCode'=>'01742'}
		 }
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_EnhancedDatawithlineItem
		  hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'card'=>{
		 'type'=>'VI', 
		 'number' =>'4100000000000001',
		 'expDate' =>'1210'}, 'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
		 'orderSource'=>'ecommerce',
		 'lineItemData'=>{
	  	 'itemSequenceNumber'=>'98765',
		 'itemDescription'=>'VERYnice',
		 'productCode'=>'10010100',
		 'quantity'=>'7',
		 'unitOfMeasure'=>'pounds',
		 'enhancedData'=>{
		 'detailtax'=>{'taxAmount'=>'1234','tax'=>'50'}},
		 'customerReference'=>'Litle',
		 'salesTax'=>'50',
		 'deliveryType'=>'TBD',
		 'restriction'=>'DIG',
		 'shipFromPostalCode'=>'01741',
		 'destinationPostalCode'=>'01742'}
		 }
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_simpletoken
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'token'=> {
		 'litleToken'=>'123456789101112',
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'
		 }}
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_tokenmissingtoken
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'token'=> {
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'
		 }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.credit(hash)}
   	 	 assert_match /Missing Required Field: litleToken!!!!/, exception.message
	end
	def test_tokenwithincorrecttokenLength
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'token'=> {
		 'litleToken'=>'123456',
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'
		  }}
		 response= LitleOnlineRequest.credit(hash)
		 assert(response.message =~ /Error validating xml data against the schema/)
	end
	def test_tokenmissingexpDatandvalidNum
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'token'=> {
		 'litleToken'=>'123456789101112',
		 'type'=>'VI'
		  }}
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_simplePaypage
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'paypage'=> {
		 'paypageRegistrationId'=>'123456789101112',
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'
		  }}
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_paypagemissingexpDatandvalidNum
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'paypage'=> {
		 'paypageRegistrationId'=>'123456789101112',
		 'type'=>'VI'
		  }}
		 response= LitleOnlineRequest.credit(hash)
		 assert_equal('Valid Format', response.message)
	end
	def test_paypagemissingId
		 hash = {
		 'merchantId' => '101',
		 'user' => 'PHXMLTEST',
		 'password'=> 'certpass',
		 'version'=>'8.8',
		 'reportGroup'=>'Planets',
		 'orderId'=>'12344',
		 'amount'=>'106',
		 'orderSource'=>'ecommerce',
		 'paypage'=> {
		 'expDate'=>'1210',
		 'cardValidationNum'=>'555',
		 'type'=>'VI'
		  }}
		 exception = assert_raise(RuntimeError){LitleOnlineRequest.credit(hash)}
   	 	 assert_match /Missing Required Field: paypageRegistrationId!!!!/, exception.message
	end
	#def test_simpleTaxBilling
	#	 hash = {
	#	 'reportGroup'=>'Planets',
	#	 'litleTxnId'=>'123456',
	#	 'orderId'=>'12344',
	#	 'amount'=>'106',
	# 	 'customBilling'=>{'phone'=>'123456789','descriptor'=>'good'},
	#	 'taxBilling'=>{'taxAuthority'=>'1232345656667788990','state'=>'MA','govtTxnType'=>'payment'},
	#	 'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'1234','sellerId'=>'1234Id'}
	#	 'orderSource'=>'ecommerce',
	#	 'card'=>{
	#	 'type'=>'VI', 
	#	'number' =>'4100000000000001',
	#	 'expDate' =>'1210'
	#	 }}
	#	 response= LitleOnlineRequest.sale(hash)
	#	  assert_equal('Valid Format', response.message)
	#end 
	#def test_simpleTaxBillingmissingfield
	#	 hash = {
	#	 'reportGroup'=>'Planets',
	#	 'litleTxnId'=>'123456',
	#	 'orderId'=>'12344',
	#	 'amount'=>'106',
		# 'taxBilling'=>{'taxAuthority'=>'1232345656667788990','govtTxnType'=>'payment'},
	#	 'orderSource'=>'ecommerce',
	#	 'card'=>{
	#	 'type'=>'VI', 
	#	'number' =>'4100000000000001',
	#	 'expDate' =>'1210'
	#	 }}
		# exception = assert_raise(RuntimeError){LitleOnlineRequest.sale(hash)}
   		# assert_match /Missing Required Field: state!!!!/, exception.message
	#end 
end





























