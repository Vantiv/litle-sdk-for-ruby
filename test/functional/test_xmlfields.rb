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
  class TestXmlfields < Test::Unit::TestCase
    def test_card_no_required_type_or_track
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
  
    def test_simple_custom_billing
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'customBilling'=>{'phone'=>'123456789','descriptor'=>'good'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_bill_me_later
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end
  
    def test__customer_info
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'CustomerInfo'=>{'ssn'=>'12345','incomeAmount'=>'12345','incomeCurrency'=>'dollar','yearsAtResidence'=>'2'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_simple_bill_to_address
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_processing_instructions
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'processingInstructions'=>{'bypassVelocityCheck'=>'true'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_pos
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'pos'=>{'capability'=>'notused','entryMode'=>'track1','cardholderId'=>'pin'},
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_amex_data
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'},
        'orderSource'=>'ecommerce',
        'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'1234','sellerId'=>'1234Id'}
      }
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_amex_data_missing_seller_id
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
      #Get exceptions
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.credit(hash)}
      #Test 
      assert(exception.message =~ /Error validating xml data against the schema/)
    end
  
    def test_simple_enhanced_data
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
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
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_enhanced_data_with_detail_tax
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
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
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_enhanced_data_with_line_item
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
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
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_simple_token
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_token_missing_exp_dat_and_valid_num
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'token'=> {
        'litleToken'=>'123456789101112',
        'type'=>'VI'
        }}
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_simple_paypage
      hash = {
        'merchantId' => '101',
        'id' => 'test',
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
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_paypage_missing_exp_dat_and_valid_num
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypage'=> {
        'paypageRegistrationId'=>'123456789101112',
        'type'=>'VI'
        }}
      response= LitleOnlineRequest.new.credit(hash)
      assert_equal('Valid Format', response.message)
    end
    
    def test_line_item_data
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'1',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'enhancedData'=>
        {
        'lineItemData'=>[
        {'itemSequenceNumber'=>'1', 'itemDescription'=>'desc1'},
        {'itemSequenceNumber'=>'2', 'itemDescription'=>'desc2'}
        ]
        }
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_detail_tax
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'1',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'enhancedData'=>
        {
        'detailTax'=>[
        {'taxIncludedInTotal'=>'true', 'taxAmount'=>'0'},
        {'taxIncludedInTotal'=>'false', 'taxAmount'=>'1'}
        ]
        }
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Valid Format', response.message)
    end
  
    def test_detail_tax_in_lineItem
      hash = {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'1',
        'amount'=>'2',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        },
        'enhancedData'=>      
        {
        'lineItemData'=>[
        {'itemSequenceNumber'=>'1', 'itemDescription'=>'desc1','detailTax'=>[
        {'taxAmount'=>'1'},
        {'taxAmount'=>'2'}]
        },
        {'itemSequenceNumber'=>'2', 'itemDescription'=>'desc2','detailTax'=>[
        {'taxAmount'=>'3'},
        {'taxAmount'=>'4'}]
        }],
        'detailTax'=>[
        {'taxAmount'=>'5'},
        {'taxAmount'=>'6'}
        ]}
      }
      response= LitleOnlineRequest.new.authorization(hash)
      assert_equal('Valid Format', response.message)
    end
  end
end