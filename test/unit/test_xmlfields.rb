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
require 'mocha'

module LitleOnline
  class TestXmlfields < Test::Unit::TestCase
    def test_custom_billing_with_two_choices
      hash = {
        'merchantId' => '101',
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
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end
  
    def test_custom_billing_with_three_choices
      hash = {
        'merchantId' => '101',
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
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end
  
    def test_line_item_data
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'enhancedData'=>
        {
        'lineItemData'=>[
        {'itemSequenceNumber'=>'1', 'itemDescription'=>'desc1'},
        {'itemSequenceNumber'=>'2', 'itemDescription'=>'desc2'}
        ]
        }
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<enhancedData>.*<lineItemData>.*<itemSequenceNumber>1<\/itemSequenceNumber>.*<itemDescription>desc1<\/itemDescription>.*<\/lineItemData>.*<lineItemData>.*<itemSequenceNumber>2<\/itemSequenceNumber>.*<itemDescription>desc2<\/itemDescription>.*<\/lineItemData>.*<\/enhancedData>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
  
    def test_detail_tax
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'enhancedData'=>
        {
        'detailTax'=>[
        {'taxIncludedInTotal'=>'true', 'taxTypeIdentifier'=>'00'},
        {'taxIncludedInTotal'=>'false', 'taxTypeIdentifier'=>'01'}
        ]
        }
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<enhancedData>.*<detailTax>.*<taxIncludedInTotal>true<\/taxIncludedInTotal>.*<taxTypeIdentifier>00<\/taxTypeIdentifier>.*<\/detailTax>.*<detailTax>.*<taxIncludedInTotal>false<\/taxIncludedInTotal>.*<taxTypeIdentifier>01<\/taxTypeIdentifier>.*<\/detailTax>.*<\/enhancedData>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
  
    def test_detail_tax_in_lineItem
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
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
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<enhancedData>.*<detailTax>.*<taxAmount>5<\/taxAmount>.*<\/detailTax>.*<detailTax>.*<taxAmount>6<\/taxAmount>.*<\/detailTax>.*<lineItemData>.*<itemSequenceNumber>1<\/itemSequenceNumber>.*<itemDescription>desc1<\/itemDescription>.*<detailTax>.*<taxAmount>1<\/taxAmount>.*<\/detailTax>.*<detailTax>.*<taxAmount>2<\/taxAmount>.*<\/detailTax>.*<\/lineItemData>.*<lineItemData>.*<itemSequenceNumber>2<\/itemSequenceNumber>.*<itemDescription>desc2<\/itemDescription>.*<detailTax>.*<taxAmount>3<\/taxAmount>.*<\/detailTax>.*<detailTax>.*<taxAmount>4<\/taxAmount>.*<\/detailTax>.*<\/lineItemData>.*<\/enhancedData>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
  
  end

end