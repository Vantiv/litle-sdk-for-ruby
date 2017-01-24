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
        {'taxIncludedInTotal'=>'true', 'taxTypeIdentifier'=>'00', 'taxAmount'=>'0'},
        {'taxIncludedInTotal'=>'false', 'taxTypeIdentifier'=>'01', 'taxAmount'=>'0'}
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
    
    def test_customerinfo_employerName_xml
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'customerInfo'=>
        {
        'employerName'=>'Greg'
        }
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<customerInfo>.*<employerName>Greg<\/employerName>.*<\/customerInfo>.*.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

  def test_billMeLaterRequest_bmlProductType_xml
    hash = {
      'merchantId' => '101',
      'version'=>'8.8',
      'reportGroup'=>'Planets',
      'billMeLaterRequest'=>
      {
      'bmlProductType'=>'12'
      }
    }
  
    LitleXmlMapper.expects(:request).with(regexp_matches(/.*<billMeLaterRequest>.*<bmlProductType>12<\/bmlProductType>.*<\/billMeLaterRequest>.*.*/m), is_a(Hash))
    LitleOnlineRequest.new.authorization(hash)
  end

        
    def test_contact_name
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).name)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'name'=>'abc' }}).name)
      assert_equal("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", Contact.from_hash({ 'contact'=>{'name'=>'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' }}).name)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'name'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901' }})
      }
      assert_equal "If contact name is specified, it must be between 1 and 100 characters long", exception.message
    end
    
    def test_contact_firstName
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).firstName)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'firstName'=>'abc' }}).firstName)
      assert_equal("1234567890123456789012345", Contact.from_hash({ 'contact'=>{'firstName'=>'1234567890123456789012345' }}).firstName)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'firstName'=>'12345678901234567890123456' }})
      }
      assert_equal "If contact firstName is specified, it must be between 1 and 25 characters long", exception.message
    end
    
    def test_contact_middleInitial
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).middleInitial)
      assert_equal("A", Contact.from_hash({ 'contact'=>{'middleInitial'=>'A' }}).middleInitial)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'middleInitial'=>'AB' }})
      }
      assert_equal "If contact middleInitial is specified, it must be between 1 and 1 characters long", exception.message
    end

    def test_contact_lastName
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).lastName)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'lastName'=>'abc' }}).lastName)
      assert_equal("1234567890123456789012345", Contact.from_hash({ 'contact'=>{'lastName'=>'1234567890123456789012345' }}).lastName)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'lastName'=>'12345678901234567890123456' }})
      }
      assert_equal "If contact lastName is specified, it must be between 1 and 25 characters long", exception.message
    end

    def test_contact_companyName
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).companyName)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'companyName'=>'abc' }}).companyName)
      assert_equal("1234567890123456789012345678901234567890", Contact.from_hash({ 'contact'=>{'companyName'=>'1234567890123456789012345678901234567890' }}).companyName)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'companyName'=>'12345678901234567890123456789012345678901' }})
      }
      assert_equal "If contact companyName is specified, it must be between 1 and 40 characters long", exception.message
    end
    
    def test_contact_addressLine1
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).addressLine1)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'addressLine1'=>'abc' }}).addressLine1)
      assert_equal("12345678901234567890123456789012345", Contact.from_hash({ 'contact'=>{'addressLine1'=>'12345678901234567890123456789012345' }}).addressLine1)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'addressLine1'=>'123456789012345678901234567890123456' }})
      }
      assert_equal "If contact addressLine1 is specified, it must be between 1 and 35 characters long", exception.message
    end

    def test_contact_addressLine2
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).addressLine2)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'addressLine2'=>'abc' }}).addressLine2)
      assert_equal("12345678901234567890123456789012345", Contact.from_hash({ 'contact'=>{'addressLine2'=>'12345678901234567890123456789012345' }}).addressLine2)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'addressLine2'=>'123456789012345678901234567890123456' }})
      }
      assert_equal "If contact addressLine2 is specified, it must be between 1 and 35 characters long", exception.message
    end
    
    def test_contact_addressLine3
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).addressLine3)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'addressLine3'=>'abc' }}).addressLine3)
      assert_equal("12345678901234567890123456789012345", Contact.from_hash({ 'contact'=>{'addressLine3'=>'12345678901234567890123456789012345' }}).addressLine3)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'addressLine3'=>'123456789012345678901234567890123456' }})
      }
      assert_equal "If contact addressLine3 is specified, it must be between 1 and 35 characters long", exception.message
    end
    
    def test_contact_city
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).city)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'city'=>'abc' }}).city)
      assert_equal("12345678901234567890123456789012345", Contact.from_hash({ 'contact'=>{'city'=>'12345678901234567890123456789012345' }}).city)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'city'=>'123456789012345678901234567890123456' }})
      }
      assert_equal "If contact city is specified, it must be between 1 and 35 characters long", exception.message
    end
    
    def test_contact_state
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).state)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'state'=>'abc' }}).state)
      assert_equal("123456789012345678901234567890", Contact.from_hash({ 'contact'=>{'state'=>'123456789012345678901234567890' }}).state)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'state'=>'1234567890123456789012345678901' }})
      }
      assert_equal "If contact state is specified, it must be between 1 and 30 characters long", exception.message
    end
    
    def test_contact_zip
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).zip)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'zip'=>'abc' }}).zip)
      assert_equal("12345678901234567890", Contact.from_hash({ 'contact'=>{'zip'=>'12345678901234567890' }}).zip)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'zip'=>'123456789012345678901' }})
      }
      assert_equal "If contact zip is specified, it must be between 1 and 20 characters long", exception.message
    end
    
    def test_contact_country
      assert_equal("USA", Contact.from_hash({ 'contact'=>{'country'=>'USA' }}).country)
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).country)
      assert_equal("AF", Contact.from_hash({ 'contact'=>{'country'=>'AF' }}).country)
      assert_equal("AX", Contact.from_hash({ 'contact'=>{'country'=>'AX' }}).country)
      assert_equal("AL", Contact.from_hash({ 'contact'=>{'country'=>'AL' }}).country)
      assert_equal("DZ", Contact.from_hash({ 'contact'=>{'country'=>'DZ' }}).country)
      assert_equal("AS", Contact.from_hash({ 'contact'=>{'country'=>'AS' }}).country)
      assert_equal("AD", Contact.from_hash({ 'contact'=>{'country'=>'AD' }}).country)
      assert_equal("AO", Contact.from_hash({ 'contact'=>{'country'=>'AO' }}).country)
      assert_equal("AI", Contact.from_hash({ 'contact'=>{'country'=>'AI' }}).country)
      assert_equal("AQ", Contact.from_hash({ 'contact'=>{'country'=>'AQ' }}).country)
      assert_equal("AG", Contact.from_hash({ 'contact'=>{'country'=>'AG' }}).country)
      assert_equal("AR", Contact.from_hash({ 'contact'=>{'country'=>'AR' }}).country)
      assert_equal("AM", Contact.from_hash({ 'contact'=>{'country'=>'AM' }}).country)
      assert_equal("AW", Contact.from_hash({ 'contact'=>{'country'=>'AW' }}).country)
      assert_equal("AU", Contact.from_hash({ 'contact'=>{'country'=>'AU' }}).country)
      assert_equal("AZ", Contact.from_hash({ 'contact'=>{'country'=>'AZ' }}).country)
      assert_equal("BS", Contact.from_hash({ 'contact'=>{'country'=>'BS' }}).country)
      assert_equal("BH", Contact.from_hash({ 'contact'=>{'country'=>'BH' }}).country)
      assert_equal("BD", Contact.from_hash({ 'contact'=>{'country'=>'BD' }}).country)
      assert_equal("BB", Contact.from_hash({ 'contact'=>{'country'=>'BB' }}).country)
      assert_equal("BY", Contact.from_hash({ 'contact'=>{'country'=>'BY' }}).country)
      assert_equal("BE", Contact.from_hash({ 'contact'=>{'country'=>'BE' }}).country)
      assert_equal("BZ", Contact.from_hash({ 'contact'=>{'country'=>'BZ' }}).country)
      assert_equal("BJ", Contact.from_hash({ 'contact'=>{'country'=>'BJ' }}).country)
      assert_equal("BM", Contact.from_hash({ 'contact'=>{'country'=>'BM' }}).country)
      assert_equal("BT", Contact.from_hash({ 'contact'=>{'country'=>'BT' }}).country)
      assert_equal("BO", Contact.from_hash({ 'contact'=>{'country'=>'BO' }}).country)
      assert_equal("BQ", Contact.from_hash({ 'contact'=>{'country'=>'BQ' }}).country)
      assert_equal("BA", Contact.from_hash({ 'contact'=>{'country'=>'BA' }}).country)
      assert_equal("BW", Contact.from_hash({ 'contact'=>{'country'=>'BW' }}).country)
      assert_equal("BV", Contact.from_hash({ 'contact'=>{'country'=>'BV' }}).country)
      assert_equal("BR", Contact.from_hash({ 'contact'=>{'country'=>'BR' }}).country)
      assert_equal("IO", Contact.from_hash({ 'contact'=>{'country'=>'IO' }}).country)
      assert_equal("BN", Contact.from_hash({ 'contact'=>{'country'=>'BN' }}).country)
      assert_equal("BG", Contact.from_hash({ 'contact'=>{'country'=>'BG' }}).country)
      assert_equal("BF", Contact.from_hash({ 'contact'=>{'country'=>'BF' }}).country)
      assert_equal("BI", Contact.from_hash({ 'contact'=>{'country'=>'BI' }}).country)
      assert_equal("KH", Contact.from_hash({ 'contact'=>{'country'=>'KH' }}).country)
      assert_equal("CM", Contact.from_hash({ 'contact'=>{'country'=>'CM' }}).country)
      assert_equal("CA", Contact.from_hash({ 'contact'=>{'country'=>'CA' }}).country)
      assert_equal("CV", Contact.from_hash({ 'contact'=>{'country'=>'CV' }}).country)
      assert_equal("KY", Contact.from_hash({ 'contact'=>{'country'=>'KY' }}).country)
      assert_equal("CF", Contact.from_hash({ 'contact'=>{'country'=>'CF' }}).country)
      assert_equal("TD", Contact.from_hash({ 'contact'=>{'country'=>'TD' }}).country)
      assert_equal("CL", Contact.from_hash({ 'contact'=>{'country'=>'CL' }}).country)
      assert_equal("CN", Contact.from_hash({ 'contact'=>{'country'=>'CN' }}).country)
      assert_equal("CX", Contact.from_hash({ 'contact'=>{'country'=>'CX' }}).country)
      assert_equal("CC", Contact.from_hash({ 'contact'=>{'country'=>'CC' }}).country)
      assert_equal("CO", Contact.from_hash({ 'contact'=>{'country'=>'CO' }}).country)
      assert_equal("KM", Contact.from_hash({ 'contact'=>{'country'=>'KM' }}).country)
      assert_equal("CG", Contact.from_hash({ 'contact'=>{'country'=>'CG' }}).country)
      assert_equal("CD", Contact.from_hash({ 'contact'=>{'country'=>'CD' }}).country)
      assert_equal("CK", Contact.from_hash({ 'contact'=>{'country'=>'CK' }}).country)
      assert_equal("CR", Contact.from_hash({ 'contact'=>{'country'=>'CR' }}).country)
      assert_equal("CI", Contact.from_hash({ 'contact'=>{'country'=>'CI' }}).country)
      assert_equal("HR", Contact.from_hash({ 'contact'=>{'country'=>'HR' }}).country)
      assert_equal("CU", Contact.from_hash({ 'contact'=>{'country'=>'CU' }}).country)
      assert_equal("CW", Contact.from_hash({ 'contact'=>{'country'=>'CW' }}).country)
      assert_equal("CY", Contact.from_hash({ 'contact'=>{'country'=>'CY' }}).country)
      assert_equal("CZ", Contact.from_hash({ 'contact'=>{'country'=>'CZ' }}).country)
      assert_equal("DK", Contact.from_hash({ 'contact'=>{'country'=>'DK' }}).country)
      assert_equal("DJ", Contact.from_hash({ 'contact'=>{'country'=>'DJ' }}).country)
      assert_equal("DM", Contact.from_hash({ 'contact'=>{'country'=>'DM' }}).country)
      assert_equal("DO", Contact.from_hash({ 'contact'=>{'country'=>'DO' }}).country)
      assert_equal("TL", Contact.from_hash({ 'contact'=>{'country'=>'TL' }}).country)
      assert_equal("EC", Contact.from_hash({ 'contact'=>{'country'=>'EC' }}).country)
      assert_equal("EG", Contact.from_hash({ 'contact'=>{'country'=>'EG' }}).country)
      assert_equal("SV", Contact.from_hash({ 'contact'=>{'country'=>'SV' }}).country)
      assert_equal("GQ", Contact.from_hash({ 'contact'=>{'country'=>'GQ' }}).country)
      assert_equal("ER", Contact.from_hash({ 'contact'=>{'country'=>'ER' }}).country)
      assert_equal("EE", Contact.from_hash({ 'contact'=>{'country'=>'EE' }}).country)
      assert_equal("ET", Contact.from_hash({ 'contact'=>{'country'=>'ET' }}).country)
      assert_equal("FK", Contact.from_hash({ 'contact'=>{'country'=>'FK' }}).country)
      assert_equal("FO", Contact.from_hash({ 'contact'=>{'country'=>'FO' }}).country)
      assert_equal("FJ", Contact.from_hash({ 'contact'=>{'country'=>'FJ' }}).country)
      assert_equal("FI", Contact.from_hash({ 'contact'=>{'country'=>'FI' }}).country)
      assert_equal("FR", Contact.from_hash({ 'contact'=>{'country'=>'FR' }}).country)
      assert_equal("GF", Contact.from_hash({ 'contact'=>{'country'=>'GF' }}).country)
      assert_equal("PF", Contact.from_hash({ 'contact'=>{'country'=>'PF' }}).country)
      assert_equal("TF", Contact.from_hash({ 'contact'=>{'country'=>'TF' }}).country)
      assert_equal("GA", Contact.from_hash({ 'contact'=>{'country'=>'GA' }}).country)
      assert_equal("GM", Contact.from_hash({ 'contact'=>{'country'=>'GM' }}).country)
      assert_equal("GE", Contact.from_hash({ 'contact'=>{'country'=>'GE' }}).country)
      assert_equal("DE", Contact.from_hash({ 'contact'=>{'country'=>'DE' }}).country)
      assert_equal("GH", Contact.from_hash({ 'contact'=>{'country'=>'GH' }}).country)
      assert_equal("GI", Contact.from_hash({ 'contact'=>{'country'=>'GI' }}).country)
      assert_equal("GR", Contact.from_hash({ 'contact'=>{'country'=>'GR' }}).country)
      assert_equal("GL", Contact.from_hash({ 'contact'=>{'country'=>'GL' }}).country)
      assert_equal("GD", Contact.from_hash({ 'contact'=>{'country'=>'GD' }}).country)
      assert_equal("GP", Contact.from_hash({ 'contact'=>{'country'=>'GP' }}).country)
      assert_equal("GU", Contact.from_hash({ 'contact'=>{'country'=>'GU' }}).country)
      assert_equal("GT", Contact.from_hash({ 'contact'=>{'country'=>'GT' }}).country)
      assert_equal("GG", Contact.from_hash({ 'contact'=>{'country'=>'GG' }}).country)
      assert_equal("GN", Contact.from_hash({ 'contact'=>{'country'=>'GN' }}).country)
      assert_equal("GW", Contact.from_hash({ 'contact'=>{'country'=>'GW' }}).country)
      assert_equal("GY", Contact.from_hash({ 'contact'=>{'country'=>'GY' }}).country)
      assert_equal("HT", Contact.from_hash({ 'contact'=>{'country'=>'HT' }}).country)
      assert_equal("HM", Contact.from_hash({ 'contact'=>{'country'=>'HM' }}).country)
      assert_equal("HN", Contact.from_hash({ 'contact'=>{'country'=>'HN' }}).country)
      assert_equal("HK", Contact.from_hash({ 'contact'=>{'country'=>'HK' }}).country)
      assert_equal("HU", Contact.from_hash({ 'contact'=>{'country'=>'HU' }}).country)
      assert_equal("IS", Contact.from_hash({ 'contact'=>{'country'=>'IS' }}).country)
      assert_equal("IN", Contact.from_hash({ 'contact'=>{'country'=>'IN' }}).country)
      assert_equal("ID", Contact.from_hash({ 'contact'=>{'country'=>'ID' }}).country)
      assert_equal("IR", Contact.from_hash({ 'contact'=>{'country'=>'IR' }}).country)
      assert_equal("IQ", Contact.from_hash({ 'contact'=>{'country'=>'IQ' }}).country)
      assert_equal("IE", Contact.from_hash({ 'contact'=>{'country'=>'IE' }}).country)
      assert_equal("IM", Contact.from_hash({ 'contact'=>{'country'=>'IM' }}).country)
      assert_equal("IL", Contact.from_hash({ 'contact'=>{'country'=>'IL' }}).country)
      assert_equal("IT", Contact.from_hash({ 'contact'=>{'country'=>'IT' }}).country)
      assert_equal("JM", Contact.from_hash({ 'contact'=>{'country'=>'JM' }}).country)
      assert_equal("JP", Contact.from_hash({ 'contact'=>{'country'=>'JP' }}).country)
      assert_equal("JE", Contact.from_hash({ 'contact'=>{'country'=>'JE' }}).country)
      assert_equal("JO", Contact.from_hash({ 'contact'=>{'country'=>'JO' }}).country)
      assert_equal("KZ", Contact.from_hash({ 'contact'=>{'country'=>'KZ' }}).country)
      assert_equal("KE", Contact.from_hash({ 'contact'=>{'country'=>'KE' }}).country)
      assert_equal("KI", Contact.from_hash({ 'contact'=>{'country'=>'KI' }}).country)
      assert_equal("KP", Contact.from_hash({ 'contact'=>{'country'=>'KP' }}).country)
      assert_equal("KR", Contact.from_hash({ 'contact'=>{'country'=>'KR' }}).country)
      assert_equal("KW", Contact.from_hash({ 'contact'=>{'country'=>'KW' }}).country)
      assert_equal("KG", Contact.from_hash({ 'contact'=>{'country'=>'KG' }}).country)
      assert_equal("LA", Contact.from_hash({ 'contact'=>{'country'=>'LA' }}).country)
      assert_equal("LV", Contact.from_hash({ 'contact'=>{'country'=>'LV' }}).country)
      assert_equal("LB", Contact.from_hash({ 'contact'=>{'country'=>'LB' }}).country)
      assert_equal("LS", Contact.from_hash({ 'contact'=>{'country'=>'LS' }}).country)
      assert_equal("LR", Contact.from_hash({ 'contact'=>{'country'=>'LR' }}).country)
      assert_equal("LY", Contact.from_hash({ 'contact'=>{'country'=>'LY' }}).country)
      assert_equal("LI", Contact.from_hash({ 'contact'=>{'country'=>'LI' }}).country)
      assert_equal("LT", Contact.from_hash({ 'contact'=>{'country'=>'LT' }}).country)
      assert_equal("LU", Contact.from_hash({ 'contact'=>{'country'=>'LU' }}).country)
      assert_equal("MO", Contact.from_hash({ 'contact'=>{'country'=>'MO' }}).country)
      assert_equal("MK", Contact.from_hash({ 'contact'=>{'country'=>'MK' }}).country)
      assert_equal("MG", Contact.from_hash({ 'contact'=>{'country'=>'MG' }}).country)
      assert_equal("MW", Contact.from_hash({ 'contact'=>{'country'=>'MW' }}).country)
      assert_equal("MY", Contact.from_hash({ 'contact'=>{'country'=>'MY' }}).country)
      assert_equal("MV", Contact.from_hash({ 'contact'=>{'country'=>'MV' }}).country)
      assert_equal("ML", Contact.from_hash({ 'contact'=>{'country'=>'ML' }}).country)
      assert_equal("MT", Contact.from_hash({ 'contact'=>{'country'=>'MT' }}).country)
      assert_equal("MH", Contact.from_hash({ 'contact'=>{'country'=>'MH' }}).country)
      assert_equal("MQ", Contact.from_hash({ 'contact'=>{'country'=>'MQ' }}).country)
      assert_equal("MR", Contact.from_hash({ 'contact'=>{'country'=>'MR' }}).country)
      assert_equal("MU", Contact.from_hash({ 'contact'=>{'country'=>'MU' }}).country)
      assert_equal("YT", Contact.from_hash({ 'contact'=>{'country'=>'YT' }}).country)
      assert_equal("MX", Contact.from_hash({ 'contact'=>{'country'=>'MX' }}).country)
      assert_equal("FM", Contact.from_hash({ 'contact'=>{'country'=>'FM' }}).country)
      assert_equal("MD", Contact.from_hash({ 'contact'=>{'country'=>'MD' }}).country)
      assert_equal("MC", Contact.from_hash({ 'contact'=>{'country'=>'MC' }}).country)
      assert_equal("MN", Contact.from_hash({ 'contact'=>{'country'=>'MN' }}).country)
      assert_equal("MS", Contact.from_hash({ 'contact'=>{'country'=>'MS' }}).country)
      assert_equal("MA", Contact.from_hash({ 'contact'=>{'country'=>'MA' }}).country)
      assert_equal("MZ", Contact.from_hash({ 'contact'=>{'country'=>'MZ' }}).country)
      assert_equal("MM", Contact.from_hash({ 'contact'=>{'country'=>'MM' }}).country)
      assert_equal("NA", Contact.from_hash({ 'contact'=>{'country'=>'NA' }}).country)
      assert_equal("NR", Contact.from_hash({ 'contact'=>{'country'=>'NR' }}).country)
      assert_equal("NP", Contact.from_hash({ 'contact'=>{'country'=>'NP' }}).country)
      assert_equal("NL", Contact.from_hash({ 'contact'=>{'country'=>'NL' }}).country)
      assert_equal("AN", Contact.from_hash({ 'contact'=>{'country'=>'AN' }}).country)
      assert_equal("NC", Contact.from_hash({ 'contact'=>{'country'=>'NC' }}).country)
      assert_equal("NZ", Contact.from_hash({ 'contact'=>{'country'=>'NZ' }}).country)
      assert_equal("NI", Contact.from_hash({ 'contact'=>{'country'=>'NI' }}).country)
      assert_equal("NE", Contact.from_hash({ 'contact'=>{'country'=>'NE' }}).country)
      assert_equal("NG", Contact.from_hash({ 'contact'=>{'country'=>'NG' }}).country)
      assert_equal("NU", Contact.from_hash({ 'contact'=>{'country'=>'NU' }}).country)
      assert_equal("NF", Contact.from_hash({ 'contact'=>{'country'=>'NF' }}).country)
      assert_equal("MP", Contact.from_hash({ 'contact'=>{'country'=>'MP' }}).country)
      assert_equal("NO", Contact.from_hash({ 'contact'=>{'country'=>'NO' }}).country)
      assert_equal("OM", Contact.from_hash({ 'contact'=>{'country'=>'OM' }}).country)
      assert_equal("PK", Contact.from_hash({ 'contact'=>{'country'=>'PK' }}).country)
      assert_equal("PW", Contact.from_hash({ 'contact'=>{'country'=>'PW' }}).country)
      assert_equal("PS", Contact.from_hash({ 'contact'=>{'country'=>'PS' }}).country)
      assert_equal("PA", Contact.from_hash({ 'contact'=>{'country'=>'PA' }}).country)
      assert_equal("PG", Contact.from_hash({ 'contact'=>{'country'=>'PG' }}).country)
      assert_equal("PY", Contact.from_hash({ 'contact'=>{'country'=>'PY' }}).country)
      assert_equal("PE", Contact.from_hash({ 'contact'=>{'country'=>'PE' }}).country)
      assert_equal("PH", Contact.from_hash({ 'contact'=>{'country'=>'PH' }}).country)
      assert_equal("PN", Contact.from_hash({ 'contact'=>{'country'=>'PN' }}).country)
      assert_equal("PL", Contact.from_hash({ 'contact'=>{'country'=>'PL' }}).country)
      assert_equal("PT", Contact.from_hash({ 'contact'=>{'country'=>'PT' }}).country)
      assert_equal("PR", Contact.from_hash({ 'contact'=>{'country'=>'PR' }}).country)
      assert_equal("QA", Contact.from_hash({ 'contact'=>{'country'=>'QA' }}).country)
      assert_equal("RE", Contact.from_hash({ 'contact'=>{'country'=>'RE' }}).country)
      assert_equal("RO", Contact.from_hash({ 'contact'=>{'country'=>'RO' }}).country)
      assert_equal("RU", Contact.from_hash({ 'contact'=>{'country'=>'RU' }}).country)
      assert_equal("RW", Contact.from_hash({ 'contact'=>{'country'=>'RW' }}).country)
      assert_equal("BL", Contact.from_hash({ 'contact'=>{'country'=>'BL' }}).country)
      assert_equal("KN", Contact.from_hash({ 'contact'=>{'country'=>'KN' }}).country)
      assert_equal("LC", Contact.from_hash({ 'contact'=>{'country'=>'LC' }}).country)
      assert_equal("MF", Contact.from_hash({ 'contact'=>{'country'=>'MF' }}).country)
      assert_equal("VC", Contact.from_hash({ 'contact'=>{'country'=>'VC' }}).country)
      assert_equal("WS", Contact.from_hash({ 'contact'=>{'country'=>'WS' }}).country)
      assert_equal("SM", Contact.from_hash({ 'contact'=>{'country'=>'SM' }}).country)
      assert_equal("ST", Contact.from_hash({ 'contact'=>{'country'=>'ST' }}).country)
      assert_equal("SA", Contact.from_hash({ 'contact'=>{'country'=>'SA' }}).country)
      assert_equal("SN", Contact.from_hash({ 'contact'=>{'country'=>'SN' }}).country)
      assert_equal("SC", Contact.from_hash({ 'contact'=>{'country'=>'SC' }}).country)
      assert_equal("SL", Contact.from_hash({ 'contact'=>{'country'=>'SL' }}).country)
      assert_equal("SG", Contact.from_hash({ 'contact'=>{'country'=>'SG' }}).country)
      assert_equal("SX", Contact.from_hash({ 'contact'=>{'country'=>'SX' }}).country)
      assert_equal("SK", Contact.from_hash({ 'contact'=>{'country'=>'SK' }}).country)
      assert_equal("SI", Contact.from_hash({ 'contact'=>{'country'=>'SI' }}).country)
      assert_equal("SB", Contact.from_hash({ 'contact'=>{'country'=>'SB' }}).country)
      assert_equal("SO", Contact.from_hash({ 'contact'=>{'country'=>'SO' }}).country)
      assert_equal("ZA", Contact.from_hash({ 'contact'=>{'country'=>'ZA' }}).country)
      assert_equal("GS", Contact.from_hash({ 'contact'=>{'country'=>'GS' }}).country)
      assert_equal("ES", Contact.from_hash({ 'contact'=>{'country'=>'ES' }}).country)
      assert_equal("LK", Contact.from_hash({ 'contact'=>{'country'=>'LK' }}).country)
      assert_equal("SH", Contact.from_hash({ 'contact'=>{'country'=>'SH' }}).country)
      assert_equal("PM", Contact.from_hash({ 'contact'=>{'country'=>'PM' }}).country)
      assert_equal("SD", Contact.from_hash({ 'contact'=>{'country'=>'SD' }}).country)
      assert_equal("SR", Contact.from_hash({ 'contact'=>{'country'=>'SR' }}).country)
      assert_equal("SJ", Contact.from_hash({ 'contact'=>{'country'=>'SJ' }}).country)
      assert_equal("SZ", Contact.from_hash({ 'contact'=>{'country'=>'SZ' }}).country)
      assert_equal("SE", Contact.from_hash({ 'contact'=>{'country'=>'SE' }}).country)
      assert_equal("CH", Contact.from_hash({ 'contact'=>{'country'=>'CH' }}).country)
      assert_equal("SY", Contact.from_hash({ 'contact'=>{'country'=>'SY' }}).country)
      assert_equal("TW", Contact.from_hash({ 'contact'=>{'country'=>'TW' }}).country)
      assert_equal("TJ", Contact.from_hash({ 'contact'=>{'country'=>'TJ' }}).country)
      assert_equal("TZ", Contact.from_hash({ 'contact'=>{'country'=>'TZ' }}).country)
      assert_equal("TH", Contact.from_hash({ 'contact'=>{'country'=>'TH' }}).country)
      assert_equal("TG", Contact.from_hash({ 'contact'=>{'country'=>'TG' }}).country)
      assert_equal("TK", Contact.from_hash({ 'contact'=>{'country'=>'TK' }}).country)
      assert_equal("TO", Contact.from_hash({ 'contact'=>{'country'=>'TO' }}).country)
      assert_equal("TT", Contact.from_hash({ 'contact'=>{'country'=>'TT' }}).country)
      assert_equal("TN", Contact.from_hash({ 'contact'=>{'country'=>'TN' }}).country)
      assert_equal("TR", Contact.from_hash({ 'contact'=>{'country'=>'TR' }}).country)
      assert_equal("TM", Contact.from_hash({ 'contact'=>{'country'=>'TM' }}).country)
      assert_equal("TC", Contact.from_hash({ 'contact'=>{'country'=>'TC' }}).country)
      assert_equal("TV", Contact.from_hash({ 'contact'=>{'country'=>'TV' }}).country)
      assert_equal("UG", Contact.from_hash({ 'contact'=>{'country'=>'UG' }}).country)
      assert_equal("UA", Contact.from_hash({ 'contact'=>{'country'=>'UA' }}).country)
      assert_equal("AE", Contact.from_hash({ 'contact'=>{'country'=>'AE' }}).country)
      assert_equal("GB", Contact.from_hash({ 'contact'=>{'country'=>'GB' }}).country)
      assert_equal("US", Contact.from_hash({ 'contact'=>{'country'=>'US' }}).country)
      assert_equal("UM", Contact.from_hash({ 'contact'=>{'country'=>'UM' }}).country)
      assert_equal("UY", Contact.from_hash({ 'contact'=>{'country'=>'UY' }}).country)
      assert_equal("UZ", Contact.from_hash({ 'contact'=>{'country'=>'UZ' }}).country)
      assert_equal("VU", Contact.from_hash({ 'contact'=>{'country'=>'VU' }}).country)
      assert_equal("VA", Contact.from_hash({ 'contact'=>{'country'=>'VA' }}).country)
      assert_equal("VE", Contact.from_hash({ 'contact'=>{'country'=>'VE' }}).country)
      assert_equal("VN", Contact.from_hash({ 'contact'=>{'country'=>'VN' }}).country)
      assert_equal("VG", Contact.from_hash({ 'contact'=>{'country'=>'VG' }}).country)
      assert_equal("VI", Contact.from_hash({ 'contact'=>{'country'=>'VI' }}).country)
      assert_equal("WF", Contact.from_hash({ 'contact'=>{'country'=>'WF' }}).country)
      assert_equal("EH", Contact.from_hash({ 'contact'=>{'country'=>'EH' }}).country)
      assert_equal("YE", Contact.from_hash({ 'contact'=>{'country'=>'YE' }}).country)
      assert_equal("ZM", Contact.from_hash({ 'contact'=>{'country'=>'ZM' }}).country)
      assert_equal("ZW", Contact.from_hash({ 'contact'=>{'country'=>'ZW' }}).country)
      assert_equal("RS", Contact.from_hash({ 'contact'=>{'country'=>'RS' }}).country)
      assert_equal("ME", Contact.from_hash({ 'contact'=>{'country'=>'ME' }}).country)

      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'country'=>'ABC' }})
      }
      assert_equal "If contact country is specified, it must be valid.  You specified ABC", exception.message
    end
    
    def test_contact_email
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).email)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'email'=>'abc' }}).email)
      assert_equal("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", Contact.from_hash({ 'contact'=>{'email'=>'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' }}).email)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'email'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901' }})
      }
      assert_equal "If contact email is specified, it must be between 1 and 100 characters long", exception.message
    end

    def test_contact_phone
      assert_equal(nil, Contact.from_hash({ 'contact'=>{}}).phone)
      assert_equal("abc", Contact.from_hash({ 'contact'=>{'phone'=>'abc' }}).phone)
      assert_equal("12345678901234567890", Contact.from_hash({ 'contact'=>{'phone'=>'12345678901234567890' }}).phone)
      exception = assert_raise(RuntimeError){
        Contact.from_hash({ 'contact'=>{'phone'=>'123456789012345678901' }})
      }
      assert_equal "If contact phone is specified, it must be between 1 and 20 characters long", exception.message
    end
    
    def test_customInfo_ssn
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).ssn)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'1' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'12' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'123' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'1234' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'12345' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'123456' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'1234567' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'12345678' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
      assert_equal("123456789", CustomerInfo.from_hash({'customerInfo'=>{'ssn'=>'123456789'}}).ssn)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'ssn'=>'1234567890' }})
      }
      assert_equal "If customerInfo ssn is specified, it must match the regular expression /\\A\\d{9}\\Z/", exception.message
    end
  
    def test_customerInfo_dob
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).dob)
      assert_equal("2012-04-11", CustomerInfo.from_hash({'customerInfo'=>{'dob'=>'2012-04-11'}}).dob)
      assert_equal("2012-11-04", CustomerInfo.from_hash({'customerInfo'=>{'dob'=>'2012-11-04'}}).dob)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'dob'=>'04-11-2012' }})
      }
      assert_equal "If customerInfo dob is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'dob'=>'11-04-2012' }})
      }
      assert_equal "If customerInfo dob is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'dob'=>'2012-4-11' }})
      }
      assert_equal "If customerInfo dob is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'dob'=>'2012-11-4' }})
      }
      assert_equal "If customerInfo dob is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'dob'=>'12-11-04' }})
      }
      assert_equal "If customerInfo dob is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'dob'=>'aaaa-mm-dd' }})
      }
      assert_equal "If customerInfo dob is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
    end
    
    def test_customerInfo_customerRegistrationDate
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).customerRegistrationDate)
      assert_equal("2012-04-11", CustomerInfo.from_hash({'customerInfo'=>{'customerRegistrationDate'=>'2012-04-11'}}).customerRegistrationDate)
      assert_equal("2012-11-04", CustomerInfo.from_hash({'customerInfo'=>{'customerRegistrationDate'=>'2012-11-04'}}).customerRegistrationDate)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerRegistrationDate'=>'04-11-2012' }})
      }
      assert_equal "If customerInfo customerRegistrationDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerRegistrationDate'=>'11-04-2012' }})
      }
      assert_equal "If customerInfo customerRegistrationDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerRegistrationDate'=>'2012-4-11' }})
      }
      assert_equal "If customerInfo customerRegistrationDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerRegistrationDate'=>'2012-11-4' }})
      }
      assert_equal "If customerInfo customerRegistrationDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerRegistrationDate'=>'12-11-04' }})
      }
      assert_equal "If customerInfo customerRegistrationDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}/", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerRegistrationDate'=>'aaaa-mm-dd' }})
      }
      assert_equal "If customerInfo customerRegistrationDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}/", exception.message
    end

    def test_customerInfo_customerType
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).customerType)
      assert_equal("New", CustomerInfo.from_hash({'customerInfo'=>{'customerType'=>'New'}}).customerType)
      assert_equal("Existing", CustomerInfo.from_hash({'customerInfo'=>{'customerType'=>'Existing'}}).customerType)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerType'=>'Deleted' }})
      }
      assert_equal "If customerInfo customerType is specified, it must be in [\"New\", \"Existing\"]", exception.message
    end
    
    def test_customerInfo_incomeAmount
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).incomeAmount)
      assert_equal("41235", CustomerInfo.from_hash({'customerInfo'=>{'incomeAmount'=>'41235'}}).incomeAmount)
      assert_equal("-9223372036854775808", CustomerInfo.from_hash({'customerInfo'=>{'incomeAmount'=>'-9223372036854775808'}}).incomeAmount)
      assert_equal("9223372036854775807", CustomerInfo.from_hash({'customerInfo'=>{'incomeAmount'=>'9223372036854775807'}}).incomeAmount)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'incomeAmount'=>'14.2' }})
      }
      assert_equal "If customerInfo incomeAmount is specified, it must be between -9223372036854775808 and 9223372036854775807", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'incomeAmount'=>'-9223372036854775809' }})
      }
      assert_equal "If customerInfo incomeAmount is specified, it must be between -9223372036854775808 and 9223372036854775807", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'incomeAmount'=>'9223372036854775808' }})
      }
      assert_equal "If customerInfo incomeAmount is specified, it must be between -9223372036854775808 and 9223372036854775807", exception.message
    end

    def test_customerInfo_incomeCurrency
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).incomeCurrency)
      assert_equal("AUD", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'AUD'}}).incomeCurrency)
      assert_equal("CAD", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'CAD'}}).incomeCurrency)
      assert_equal("CHF", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'CHF'}}).incomeCurrency)
      assert_equal("DKK", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'DKK'}}).incomeCurrency)
      assert_equal("EUR", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'EUR'}}).incomeCurrency)
      assert_equal("GBP", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'GBP'}}).incomeCurrency)
      assert_equal("HKD", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'HKD'}}).incomeCurrency)
      assert_equal("JPY", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'JPY'}}).incomeCurrency)
      assert_equal("NOK", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'NOK'}}).incomeCurrency)
      assert_equal("NZD", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'NZD'}}).incomeCurrency)
      assert_equal("SEK", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'SEK'}}).incomeCurrency)
      assert_equal("SGD", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'SGD'}}).incomeCurrency)
      assert_equal("USD", CustomerInfo.from_hash({'customerInfo'=>{'incomeCurrency'=>'USD'}}).incomeCurrency)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'incomeCurrency'=>'US' }})
      }
      assert_equal "If customerInfo incomeCurrency is specified, it must be in [\"AUD\", \"CAD\", \"CHF\", \"DKK\", \"EUR\", \"GBP\", \"HKD\", \"JPY\", \"NOK\", \"NZD\", \"SEK\", \"SGD\", \"USD\"]", exception.message
    end
    
    def test_customerInfo_customerCheckingAccount
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).customerCheckingAccount)
      assert_equal("true", CustomerInfo.from_hash({'customerInfo'=>{'customerCheckingAccount'=>'true'}}).customerCheckingAccount)
      assert_equal("false", CustomerInfo.from_hash({'customerInfo'=>{'customerCheckingAccount'=>'false'}}).customerCheckingAccount)
      assert_equal("1", CustomerInfo.from_hash({'customerInfo'=>{'customerCheckingAccount'=>'1'}}).customerCheckingAccount)
      assert_equal("0", CustomerInfo.from_hash({'customerInfo'=>{'customerCheckingAccount'=>'0'}}).customerCheckingAccount)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerCheckingAccount'=>'vrai' }}) #French true
      }
      assert_equal "If customerInfo customerCheckingAccount is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end

    def test_customerInfo_customerSavingAccount
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).customerSavingAccount)
      assert_equal("true", CustomerInfo.from_hash({'customerInfo'=>{'customerSavingAccount'=>'true'}}).customerSavingAccount)
      assert_equal("false", CustomerInfo.from_hash({'customerInfo'=>{'customerSavingAccount'=>'false'}}).customerSavingAccount)
      assert_equal("1", CustomerInfo.from_hash({'customerInfo'=>{'customerSavingAccount'=>'1'}}).customerSavingAccount)
      assert_equal("0", CustomerInfo.from_hash({'customerInfo'=>{'customerSavingAccount'=>'0'}}).customerSavingAccount)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerSavingAccount'=>'vrai' }}) #French true
      }
      assert_equal "If customerInfo customerSavingAccount is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end

    def test_contact_employerName
      assert_equal(nil, CustomerInfo.from_hash({ 'customerInfo'=>{}}).employerName)
      assert_equal("abc", CustomerInfo.from_hash({ 'customerInfo'=>{'employerName'=>'abc' }}).employerName)
      assert_equal("12345678901234567890", CustomerInfo.from_hash({ 'customerInfo'=>{'employerName'=>'12345678901234567890' }}).employerName)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'employerName'=>'123456789012345678901' }})
      }
      assert_equal "If customerInfo employerName is specified, it must be between 1 and 20 characters long", exception.message
    end
    
    def test_contact_customerWorkTelephone
      assert_equal(nil, CustomerInfo.from_hash({ 'customerInfo'=>{}}).customerWorkTelephone)
      assert_equal("abc", CustomerInfo.from_hash({ 'customerInfo'=>{'customerWorkTelephone'=>'abc' }}).customerWorkTelephone)
      assert_equal("12345678901234567890", CustomerInfo.from_hash({ 'customerInfo'=>{'customerWorkTelephone'=>'12345678901234567890' }}).customerWorkTelephone)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'customerWorkTelephone'=>'123456789012345678901' }})
      }
      assert_equal "If customerInfo customerWorkTelephone is specified, it must be between 1 and 20 characters long", exception.message
    end

    def test_customerInfo_residenceStatus
      assert_equal(nil, CustomerInfo.from_hash({'customerInfo'=>{}}).residenceStatus)
      assert_equal("Own", CustomerInfo.from_hash({'customerInfo'=>{'residenceStatus'=>'Own'}}).residenceStatus)
      assert_equal("Rent", CustomerInfo.from_hash({'customerInfo'=>{'residenceStatus'=>'Rent'}}).residenceStatus)
      assert_equal("Other", CustomerInfo.from_hash({'customerInfo'=>{'residenceStatus'=>'Other'}}).residenceStatus)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'residenceStatus'=>'Lease' }})
      }
      assert_equal "If customerInfo residenceStatus is specified, it must be in [\"Own\", \"Rent\", \"Other\"]", exception.message
    end

    def test_contact_yearsAtResidence
      assert_equal(nil, CustomerInfo.from_hash({ 'customerInfo'=>{}}).yearsAtResidence)
      assert_equal("0", CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtResidence'=>'0' }}).yearsAtResidence)
      assert_equal("1", CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtResidence'=>'1' }}).yearsAtResidence)
      assert_equal("99", CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtResidence'=>'99' }}).yearsAtResidence)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtResidence'=>'100' }})
      }
      assert_equal "If customerInfo yearsAtResidence is specified, it must be between 0 and 99", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtResidence'=>'abc' }})
      }
      assert_equal "If customerInfo yearsAtResidence is specified, it must be between 0 and 99", exception.message
    end
        
    def test_contact_yearsAtEmployer
      assert_equal(nil, CustomerInfo.from_hash({ 'customerInfo'=>{}}).yearsAtEmployer)
      assert_equal("0", CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtEmployer'=>'0' }}).yearsAtEmployer)
      assert_equal("1", CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtEmployer'=>'1' }}).yearsAtEmployer)
      assert_equal("99", CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtEmployer'=>'99' }}).yearsAtEmployer)
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtEmployer'=>'100' }})
      }
      assert_equal "If customerInfo yearsAtEmployer is specified, it must be between 0 and 99", exception.message
      exception = assert_raise(RuntimeError){
        CustomerInfo.from_hash({ 'customerInfo'=>{'yearsAtEmployer'=>'abc' }})
      }
      assert_equal "If customerInfo yearsAtEmployer is specified, it must be between 0 and 99", exception.message
    end
    
    def test_billMeLaterRequest_bmlMerchantId
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).bmlMerchantId)
      assert_equal("41235", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'bmlMerchantId'=>'41235'}}).bmlMerchantId)
      assert_equal("-9223372036854775808", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'bmlMerchantId'=>'-9223372036854775808'}}).bmlMerchantId)
      assert_equal("9223372036854775807", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'bmlMerchantId'=>'9223372036854775807'}}).bmlMerchantId)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'bmlMerchantId'=>'14.2' }})
      }
      assert_equal "If billMeLaterRequest bmlMerchantId is specified, it must be between -9223372036854775808 and 9223372036854775807", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'bmlMerchantId'=>'-9223372036854775809' }})
      }
      assert_equal "If billMeLaterRequest bmlMerchantId is specified, it must be between -9223372036854775808 and 9223372036854775807", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'bmlMerchantId'=>'9223372036854775808' }})
      }
      assert_equal "If billMeLaterRequest bmlMerchantId is specified, it must be between -9223372036854775808 and 9223372036854775807", exception.message
    end
    
    def test_billMeLaterRequest_bmlProductType
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).bmlProductType)
      assert_equal("a", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'bmlProductType'=>'a' }}).bmlProductType)
      assert_equal("12", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'bmlProductType'=>'12' }}).bmlProductType)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'bmlProductType'=>'123' }})
      }
      assert_equal "If billMeLaterRequest bmlProductType is specified, it must be between 1 and 2 characters long", exception.message
    end
    
    def test_billMeLaterRequest_termsAndConditions
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).termsAndConditions)
      assert_equal("99999", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'termsAndConditions'=>'99999'}}).termsAndConditions)
      assert_equal("-99999", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'termsAndConditions'=>'-99999'}}).termsAndConditions)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'termsAndConditions'=>'14.2' }})
      }
      assert_equal "If billMeLaterRequest termsAndConditions is specified, it must be between -99999 and 99999", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'termsAndConditions'=>'-100000' }})
      }
      assert_equal "If billMeLaterRequest termsAndConditions is specified, it must be between -99999 and 99999", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'termsAndConditions'=>'100000' }})
      }
      assert_equal "If billMeLaterRequest termsAndConditions is specified, it must be between -99999 and 99999", exception.message
    end
    
    def test_billMeLaterRequest_preapprovalNumber
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).preapprovalNumber)
      assert_equal("abcdefghijklmn", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'preapprovalNumber'=>'abcdefghijklmn' }}).preapprovalNumber)
      assert_equal("1234567890123", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'preapprovalNumber'=>'1234567890123' }}).preapprovalNumber)
      assert_equal("1234567890123456789012345", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'preapprovalNumber'=>'1234567890123456789012345' }}).preapprovalNumber)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'preapprovalNumber'=>'12345678901234567890123456' }})
      }
      assert_equal "If billMeLaterRequest preapprovalNumber is specified, it must be between 13 and 25 characters long", exception.message      
    end
    
    def test_billMeLaterRequest_merchantPromotionalCode
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).merchantPromotionalCode)
      assert_equal("9999", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'merchantPromotionalCode'=>'9999'}}).merchantPromotionalCode)
      assert_equal("-9999", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'merchantPromotionalCode'=>'-9999'}}).merchantPromotionalCode)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'merchantPromotionalCode'=>'14.2' }})
      }
      assert_equal "If billMeLaterRequest merchantPromotionalCode is specified, it must be between -9999 and 9999", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'merchantPromotionalCode'=>'-10000' }})
      }
      assert_equal "If billMeLaterRequest merchantPromotionalCode is specified, it must be between -9999 and 9999", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'merchantPromotionalCode'=>'10000' }})
      }
      assert_equal "If billMeLaterRequest merchantPromotionalCode is specified, it must be between -9999 and 9999", exception.message
    end
    
    def test_billMeLaterRequest_customerPasswordChanged
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).customerPasswordChanged)
      assert_equal("true", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPasswordChanged'=>'true'}}).customerPasswordChanged)
      assert_equal("false", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPasswordChanged'=>'false'}}).customerPasswordChanged)
      assert_equal("1", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPasswordChanged'=>'1'}}).customerPasswordChanged)
      assert_equal("0", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPasswordChanged'=>'0'}}).customerPasswordChanged)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'customerPasswordChanged'=>'vrai' }}) #French true
      }
      assert_equal "If billMeLaterRequest customerPasswordChanged is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_billMeLaterRequest_customerBillingAddressChanged
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).customerBillingAddressChanged)
      assert_equal("true", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerBillingAddressChanged'=>'true'}}).customerBillingAddressChanged)
      assert_equal("false", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerBillingAddressChanged'=>'false'}}).customerBillingAddressChanged)
      assert_equal("1", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerBillingAddressChanged'=>'1'}}).customerBillingAddressChanged)
      assert_equal("0", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerBillingAddressChanged'=>'0'}}).customerBillingAddressChanged)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'customerBillingAddressChanged'=>'vrai' }}) #French true
      }
      assert_equal "If billMeLaterRequest customerBillingAddressChanged is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_billMeLaterRequest_customerEmailChanged
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).customerEmailChanged)
      assert_equal("true", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerEmailChanged'=>'true'}}).customerEmailChanged)
      assert_equal("false", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerEmailChanged'=>'false'}}).customerEmailChanged)
      assert_equal("1", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerEmailChanged'=>'1'}}).customerEmailChanged)
      assert_equal("0", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerEmailChanged'=>'0'}}).customerEmailChanged)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'customerEmailChanged'=>'vrai' }}) #French true
      }
      assert_equal "If billMeLaterRequest customerEmailChanged is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_billMeLaterRequest_customerPhoneChanged
      assert_equal(nil, BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{}}).customerPhoneChanged)
      assert_equal("true", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPhoneChanged'=>'true'}}).customerPhoneChanged)
      assert_equal("false", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPhoneChanged'=>'false'}}).customerPhoneChanged)
      assert_equal("1", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPhoneChanged'=>'1'}}).customerPhoneChanged)
      assert_equal("0", BillMeLaterRequest.from_hash({'billMeLaterRequest'=>{'customerPhoneChanged'=>'0'}}).customerPhoneChanged)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'customerPhoneChanged'=>'vrai' }}) #French true
      }
      assert_equal "If billMeLaterRequest customerPhoneChanged is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_billMeLaterRequest_secretQuestionCode
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).secretQuestionCode)
      assert_equal("a", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'secretQuestionCode'=>'a' }}).secretQuestionCode)
      assert_equal("12", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'secretQuestionCode'=>'12' }}).secretQuestionCode)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'secretQuestionCode'=>'123' }})
      }
      assert_equal "If billMeLaterRequest secretQuestionCode is specified, it must be between 1 and 2 characters long", exception.message
    end
    
    def test_billMeLaterRequest_secretQuestionAnswer
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).secretQuestionAnswer)
      assert_equal("abc", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'secretQuestionAnswer'=>'abc' }}).secretQuestionAnswer)
      assert_equal("1234567890123456789012345", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'secretQuestionAnswer'=>'1234567890123456789012345' }}).secretQuestionAnswer)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'secretQuestionAnswer'=>'12345678901234567890123456' }})
      }
      assert_equal "If billMeLaterRequest secretQuestionAnswer is specified, it must be between 1 and 25 characters long", exception.message
    end
    
    def test_billMeLaterRequest_virtualAuthenticationKeyPresenceIndicator
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).virtualAuthenticationKeyPresenceIndicator)
      assert_equal("a", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'virtualAuthenticationKeyPresenceIndicator'=>'a' }}).virtualAuthenticationKeyPresenceIndicator)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'virtualAuthenticationKeyPresenceIndicator'=>'12' }})
      }
      assert_equal "If billMeLaterRequest virtualAuthenticationKeyPresenceIndicator is specified, it must be between 1 and 1 characters long", exception.message
    end
    
    def test_billMeLaterRequest_virtualAuthenticationKeyData
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).virtualAuthenticationKeyData)
      assert_equal("a", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'virtualAuthenticationKeyData'=>'a' }}).virtualAuthenticationKeyData)
      assert_equal("abcd", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'virtualAuthenticationKeyData'=>'abcd' }}).virtualAuthenticationKeyData)
      assert_equal("1234", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'virtualAuthenticationKeyData'=>'1234' }}).virtualAuthenticationKeyData)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'virtualAuthenticationKeyData'=>'12345' }})
      }
      assert_equal "If billMeLaterRequest virtualAuthenticationKeyData is specified, it must be between 1 and 4 characters long", exception.message
    end
    
    def test_billMeLaterRequest_itemCategoryCode
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).itemCategoryCode)
      assert_equal("1", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'itemCategoryCode'=>'1' }}).itemCategoryCode)
      assert_equal("1234", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'itemCategoryCode'=>'1234' }}).itemCategoryCode)
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'itemCategoryCode'=>'12345' }})
      }
      assert_equal "If billMeLaterRequest itemCategoryCode is specified, it must be between -9999 and 9999", exception.message
      exception = assert_raise(RuntimeError){
        BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'itemCategoryCode'=>'a' }})
      }
      assert_equal "If billMeLaterRequest itemCategoryCode is specified, it must be between -9999 and 9999", exception.message
    end
    
    def test_billMeLaterRequest_authorizationSourcePlatform
      assert_equal("a", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'authorizationSourcePlatform'=>'a' }}).authorizationSourcePlatform)
      assert_equal(nil, BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{}}).authorizationSourcePlatform)
      assert_equal("abcd", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'authorizationSourcePlatform'=>'abcd' }}).authorizationSourcePlatform)
      assert_equal("1234", BillMeLaterRequest.from_hash({ 'billMeLaterRequest'=>{'authorizationSourcePlatform'=>'1234' }}).authorizationSourcePlatform)
    end
    
    def test_fraudCheck_authenticationValue
      assert_equal("abc", FraudCheck.from_hash({ 'fraudCheck'=>{'authenticationValue'=>'abc' }}).authenticationValue)
      assert_equal(nil, FraudCheck.from_hash({ 'fraudCheck'=>{}}).authenticationValue)
      assert_equal("12345678901234567890123456789012", FraudCheck.from_hash({ 'fraudCheck'=>{'authenticationValue'=>'12345678901234567890123456789012' }}).authenticationValue)
      exception = assert_raise(RuntimeError){
        FraudCheck.from_hash({ 'fraudCheck'=>{'authenticationValue'=>'123456789012345678901234567890123456789012345678901234567' }})
      }
      assert_equal "If fraudCheck authenticationValue is specified, it must be between 1 and 56 characters long", exception.message
    end
    
    def test_fraudCheck_authenticationTransactionId
      assert_equal("abc", FraudCheck.from_hash({ 'fraudCheck'=>{'authenticationTransactionId'=>'abc' }}).authenticationTransactionId)
      assert_equal(nil, FraudCheck.from_hash({ 'fraudCheck'=>{}}).authenticationTransactionId)
      assert_equal("1234567890123456789012345678", FraudCheck.from_hash({ 'fraudCheck'=>{'authenticationTransactionId'=>'1234567890123456789012345678' }}).authenticationTransactionId)
      exception = assert_raise(RuntimeError){
        FraudCheck.from_hash({ 'fraudCheck'=>{'authenticationTransactionId'=>'12345678901234567890123456789' }})
      }
      assert_equal "If fraudCheck authenticationTransactionId is specified, it must be between 1 and 28 characters long", exception.message
    end
    
    def test_fraudCheck_customerIpAddress
      assert_equal("123.123.123.123", FraudCheck.from_hash({ 'fraudCheck'=>{'customerIpAddress'=>'123.123.123.123' }}).customerIpAddress)
      assert_equal("1.1.1.1", FraudCheck.from_hash({ 'fraudCheck'=>{'customerIpAddress'=>'1.1.1.1' }}).customerIpAddress)
      assert_equal(nil, FraudCheck.from_hash({ 'fraudCheck'=>{}}).customerIpAddress)
      assert_equal("123123123123", FraudCheck.from_hash({ 'fraudCheck'=>{'customerIpAddress'=>'123123123123' }}).customerIpAddress) #Our schema doesn't stop this
      exception = assert_raise(RuntimeError){
        FraudCheck.from_hash({ 'fraudCheck'=>{'customerIpAddress'=>'1.1.1.1.' }})
      }
      assert_equal "If fraudCheck customerIpAddress is specified, it must match the regular expression /\\A(\\d{1,3}.){3}\\d{1,3}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        FraudCheck.from_hash({ 'fraudCheck'=>{'customerIpAddress'=>'a.b.c.d' }})
      }
      assert_equal "If fraudCheck customerIpAddress is specified, it must match the regular expression /\\A(\\d{1,3}.){3}\\d{1,3}\\Z/", exception.message
    end
    
    def test_fraudCheck_authenticatedByMerchant
      assert_equal(nil, FraudCheck.from_hash({'fraudCheck'=>{}}).authenticatedByMerchant)
      assert_equal("true", FraudCheck.from_hash({'fraudCheck'=>{'authenticatedByMerchant'=>'true'}}).authenticatedByMerchant)
      assert_equal("false", FraudCheck.from_hash({'fraudCheck'=>{'authenticatedByMerchant'=>'false'}}).authenticatedByMerchant)
      assert_equal("1", FraudCheck.from_hash({'fraudCheck'=>{'authenticatedByMerchant'=>'1'}}).authenticatedByMerchant)
      assert_equal("0", FraudCheck.from_hash({'fraudCheck'=>{'authenticatedByMerchant'=>'0'}}).authenticatedByMerchant)
      exception = assert_raise(RuntimeError){
        FraudCheck.from_hash({ 'fraudCheck'=>{'authenticatedByMerchant'=>'vrai' }}) #French true
      }
      assert_equal "If fraudCheck authenticatedByMerchant is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_fraudResult_avsResult
      assert_equal("a", FraudResult.from_hash({ 'fraudResult'=>{'avsResult'=>'a' }}).avsResult)
      assert_equal(nil, FraudResult.from_hash({ 'fraudResult'=>{}}).avsResult)
      assert_equal("ab", FraudResult.from_hash({ 'fraudResult'=>{'avsResult'=>'ab' }}).avsResult)
      assert_equal("12", FraudResult.from_hash({ 'fraudResult'=>{'avsResult'=>'12' }}).avsResult)
      exception = assert_raise(RuntimeError){
        FraudResult.from_hash({ 'fraudResult'=>{'avsResult'=>'123' }})
      }
      assert_equal "If fraudResult avsResult is specified, it must be between 1 and 2 characters long", exception.message
    end
    
    def test_fraudResult_cardValidationResult
      assert_equal("a", FraudResult.from_hash({ 'fraudResult'=>{'cardValidationResult'=>'a' }}).cardValidationResult)
      assert_equal("", FraudResult.from_hash({ 'fraudResult'=>{'cardValidationResult'=>'' }}).cardValidationResult)
      assert_equal(nil, FraudResult.from_hash({ 'fraudResult'=>{}}).cardValidationResult)
      assert_equal("ab", FraudResult.from_hash({ 'fraudResult'=>{'cardValidationResult'=>'ab' }}).cardValidationResult)
      assert_equal("12", FraudResult.from_hash({ 'fraudResult'=>{'cardValidationResult'=>'12' }}).cardValidationResult)
    end
    
    def test_fraudResult_authenticationResult
      assert_equal("a", FraudResult.from_hash({ 'fraudResult'=>{'authenticationResult'=>'a' }}).authenticationResult)
      assert_equal(nil, FraudResult.from_hash({ 'fraudResult'=>{}}).authenticationResult)
      assert_equal("1", FraudResult.from_hash({ 'fraudResult'=>{'authenticationResult'=>'1' }}).authenticationResult)
      exception = assert_raise(RuntimeError){
        FraudResult.from_hash({ 'fraudResult'=>{'authenticationResult'=>'12' }})
      }
      assert_equal "If fraudResult authenticationResult is specified, it must be between 1 and 1 characters long", exception.message      
    end
    
    def test_fraudResult_advancedAVSResult
      assert_equal("a", FraudResult.from_hash({ 'fraudResult'=>{'advancedAVSResult'=>'a' }}).advancedAVSResult)
      assert_equal("1", FraudResult.from_hash({ 'fraudResult'=>{'advancedAVSResult'=>'1' }}).advancedAVSResult)
      assert_equal(nil, FraudResult.from_hash({ 'fraudResult'=>{}}).advancedAVSResult)
      assert_equal("abc", FraudResult.from_hash({ 'fraudResult'=>{'advancedAVSResult'=>'abc' }}).advancedAVSResult)
      assert_equal("123", FraudResult.from_hash({ 'fraudResult'=>{'advancedAVSResult'=>'123' }}).advancedAVSResult)
      exception = assert_raise(RuntimeError){
        FraudResult.from_hash({ 'fraudResult'=>{'advancedAVSResult'=>'1234' }})
      }
      assert_equal "If fraudResult advancedAVSResult is specified, it must be between 1 and 3 characters long", exception.message
    end
    
    def test_authInformation_authDate
      assert_equal(nil, AuthInformation.from_hash({'authInformation'=>{}}).authDate)
      assert_equal("2012-04-11", AuthInformation.from_hash({'authInformation'=>{'authDate'=>'2012-04-11'}}).authDate)
      assert_equal("2012-11-04", AuthInformation.from_hash({'authInformation'=>{'authDate'=>'2012-11-04'}}).authDate)
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authDate'=>'04-11-2012' }})
      }
      assert_equal "If authInformation authDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authDate'=>'11-04-2012' }})
      }
      assert_equal "If authInformation authDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authDate'=>'2012-4-11' }})
      }
      assert_equal "If authInformation authDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authDate'=>'2012-11-4' }})
      }
      assert_equal "If authInformation authDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authDate'=>'12-11-04' }})
      }
      assert_equal "If authInformation authDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authDate'=>'aaaa-mm-dd' }})
      }
      assert_equal "If authInformation authDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message      
    end
    
    def test_authInformation_authCode
      assert_equal(nil, AuthInformation.from_hash({ 'authInformation'=>{}}).authCode)
      assert_equal("a", AuthInformation.from_hash({ 'authInformation'=>{'authCode'=>'a' }}).authCode)
      assert_equal("1", AuthInformation.from_hash({ 'authInformation'=>{'authCode'=>'1' }}).authCode)
      assert_equal("abcdef", AuthInformation.from_hash({ 'authInformation'=>{'authCode'=>'abcdef' }}).authCode)
      assert_equal("123456", AuthInformation.from_hash({ 'authInformation'=>{'authCode'=>'123456' }}).authCode)
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authCode'=>'1234567' }})
      }
      assert_equal "If authInformation authCode is specified, it must be between 1 and 6 characters long", exception.message
    end
    
    def test_authInformation_authAmount
      assert_equal(nil, AuthInformation.from_hash({ 'authInformation'=>{}}).authAmount)
      assert_equal("1", AuthInformation.from_hash({ 'authInformation'=>{'authAmount'=>'1' }}).authAmount)
      assert_equal("123456789012", AuthInformation.from_hash({ 'authInformation'=>{'authAmount'=>'123456789012' }}).authAmount)
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authAmount'=>'1234567890123' }})
      }
      assert_equal "If authInformation authAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authAmount'=>'14.2' }})
      }
      assert_equal "If authInformation authAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        AuthInformation.from_hash({ 'authInformation'=>{'authAmount'=>'a' }})
      }
      assert_equal "If authInformation authAmount is specified, it must be between -999999999999 and 999999999999", exception.message
    end
    
    def test_healthcareAmounts_totalHealthcareAmount
      assert_equal("1", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'1' }}).totalHealthcareAmount)
      assert_equal("123456789012", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'123456789012' }}).totalHealthcareAmount)
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'1234567890123' }})
      }
      assert_equal "If healthcareAmounts totalHealthcareAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'14.2' }})
      }
      assert_equal "If healthcareAmounts totalHealthcareAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'a' }})
      }
      assert_equal "If healthcareAmounts totalHealthcareAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'' }})
      }
      assert_equal "If healthcareAmounts totalHealthcareAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{}})
      }
      assert_equal "If healthcareAmounts is specified, it must have a totalHealthcareAmount", exception.message
    end
    
    def test_healthcareAmounts_rxAmount
      assert_equal("1", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'RxAmount'=>'1','totalHealthcareAmount'=>'1' }}).rxAmount)
      assert_equal(nil, HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'1' }}).rxAmount)
      assert_equal("123456789012", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'RxAmount'=>'123456789012','totalHealthcareAmount'=>'1' }}).rxAmount)
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'RxAmount'=>'1234567890123','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts RxAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'RxAmount'=>'14.2','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts RxAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'RxAmount'=>'a','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts RxAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
    end
    
    def test_healthcareAmounts_visionAmount
      assert_equal(nil, HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'1' }}).visionAmount)
      assert_equal("1", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'visionAmount'=>'1','totalHealthcareAmount'=>'1' }}).visionAmount)
      assert_equal("123456789012", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'visionAmount'=>'123456789012','totalHealthcareAmount'=>'1' }}).visionAmount)
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'visionAmount'=>'1234567890123','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts visionAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'visionAmount'=>'14.2','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts visionAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'visionAmount'=>'a','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts visionAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
    end
    
    def test_healthcareAmounts_clinicOtherAmount
      assert_equal(nil, HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'1' }}).clinicOtherAmount)
      assert_equal("1", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'clinicOtherAmount'=>'1','totalHealthcareAmount'=>'1' }}).clinicOtherAmount)
      assert_equal("123456789012", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'clinicOtherAmount'=>'123456789012','totalHealthcareAmount'=>'1' }}).clinicOtherAmount)
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'clinicOtherAmount'=>'1234567890123','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts clinicOtherAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'clinicOtherAmount'=>'14.2','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts clinicOtherAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'clinicOtherAmount'=>'a','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts clinicOtherAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
    end
    
    def test_healthcareAmounts_dentalAmount
      assert_equal("1", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'dentalAmount'=>'1','totalHealthcareAmount'=>'1' }}).dentalAmount)
      assert_equal(nil, HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'totalHealthcareAmount'=>'1' }}).dentalAmount)
      assert_equal("123456789012", HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'dentalAmount'=>'123456789012','totalHealthcareAmount'=>'1' }}).dentalAmount)
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'dentalAmount'=>'1234567890123','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts dentalAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'dentalAmount'=>'14.2','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts dentalAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        HealthcareAmounts.from_hash({ 'healthcareAmounts'=>{'dentalAmount'=>'a','totalHealthcareAmount'=>'1' }})
      }
      assert_equal "If healthcareAmounts dentalAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
    end
    
    def test_healthcareIIAS_IIASFlag
      assert_equal("Y", HealthcareIIAS.from_hash({'healthcareIIAS'=>{'IIASFlag'=>'Y'}}).iiasFlag)
      exception = assert_raise(RuntimeError){
        HealthcareIIAS.from_hash({ 'healthcareIIAS'=>{'IIASFlag'=>'N' }})
      }
      assert_equal "If healthcareIIAS IIASFlag is specified, it must be in [\"Y\"]", exception.message      
      exception = assert_raise(RuntimeError){
        HealthcareIIAS.from_hash({ 'healthcareIIAS'=>{'IIASFlag'=>'' }})
      }
      assert_equal "If healthcareIIAS IIASFlag is specified, it must be in [\"Y\"]", exception.message      
      exception = assert_raise(RuntimeError){
        HealthcareIIAS.from_hash({ 'healthcareIIAS'=>{}})
      }
      assert_equal "If healthcareIIAS is specified, it must have a IIASFlag", exception.message      
    end
    
    def test_pos_capability
      assert_equal("notused", Pos.from_hash({'pos'=>{'capability'=>'notused','entryMode'=>'notused','cardholderId'=>'pin'}}).capability)
      assert_equal("magstripe", Pos.from_hash({'pos'=>{'capability'=>'magstripe','entryMode'=>'notused','cardholderId'=>'pin'}}).capability)
      assert_equal("keyedonly", Pos.from_hash({'pos'=>{'capability'=>'keyedonly','entryMode'=>'notused','cardholderId'=>'pin'}}).capability)
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'capability'=>'something','entryMode'=>'notused','cardholderId'=>'pin' }})
      }
      assert_equal "If pos capability is specified, it must be in [\"notused\", \"magstripe\", \"keyedonly\"]", exception.message      
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'capability'=>'','entryMode'=>'notused','cardholderId'=>'pin' }})
      }
      assert_equal "If pos capability is specified, it must be in [\"notused\", \"magstripe\", \"keyedonly\"]", exception.message      
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'entryMode'=>'notused','cardholderId'=>'pin' }})
      }
      assert_equal "If pos is specified, it must have a capability", exception.message      
    end

    def test_pos_entryMode
      assert_equal("notused", Pos.from_hash({'pos'=>{'entryMode'=>'notused','capability'=>'notused','cardholderId'=>'pin'}}).entryMode)
      assert_equal("keyed", Pos.from_hash({'pos'=>{'entryMode'=>'keyed','capability'=>'notused','cardholderId'=>'pin'}}).entryMode)
      assert_equal("track1", Pos.from_hash({'pos'=>{'entryMode'=>'track1','capability'=>'notused','cardholderId'=>'pin'}}).entryMode)
      assert_equal("track2", Pos.from_hash({'pos'=>{'entryMode'=>'track2','capability'=>'notused','cardholderId'=>'pin'}}).entryMode)
      assert_equal("completeread", Pos.from_hash({'pos'=>{'entryMode'=>'completeread','capability'=>'notused','cardholderId'=>'pin'}}).entryMode)
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'entryMode'=>'something','capability'=>'notused','cardholderId'=>'pin' }})
      }
      assert_equal "If pos entryMode is specified, it must be in [\"notused\", \"keyed\", \"track1\", \"track2\", \"completeread\"]", exception.message      
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'entryMode'=>'','capability'=>'notused','cardholderId'=>'pin' }})
      }
      assert_equal "If pos entryMode is specified, it must be in [\"notused\", \"keyed\", \"track1\", \"track2\", \"completeread\"]", exception.message      
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'capability'=>'notused','cardholderId'=>'pin' }})
      }
      assert_equal "If pos is specified, it must have a entryMode", exception.message      
    end

    def test_pos_cardholderId
      assert_equal("signature", Pos.from_hash({'pos'=>{'cardholderId'=>'signature','entryMode'=>'notused','capability'=>'notused'}}).cardholderId)
      assert_equal("pin", Pos.from_hash({'pos'=>{'cardholderId'=>'pin','entryMode'=>'keyed','capability'=>'notused'}}).cardholderId)
      assert_equal("nopin", Pos.from_hash({'pos'=>{'cardholderId'=>'nopin','entryMode'=>'track1','capability'=>'notused'}}).cardholderId)
      assert_equal("directmarket", Pos.from_hash({'pos'=>{'cardholderId'=>'directmarket','entryMode'=>'track2','capability'=>'notused'}}).cardholderId)
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'cardholderId'=>'notused','entryMode'=>'notused','capability'=>'notused' }})
      }
      assert_equal "If pos cardholderId is specified, it must be in [\"signature\", \"pin\", \"nopin\", \"directmarket\"]", exception.message      
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'cardholderId'=>'','entryMode'=>'notused','capability'=>'notused' }})
      }
      assert_equal "If pos cardholderId is specified, it must be in [\"signature\", \"pin\", \"nopin\", \"directmarket\"]", exception.message      
      exception = assert_raise(RuntimeError){
        Pos.from_hash({ 'pos'=>{'entryMode'=>'notused','capability'=>'notused' }})
      }
      assert_equal "If pos is specified, it must have a cardholderId", exception.message      
    end
    
    def test_detailTax_taxIncludedInTotal
      assert_equal(nil, DetailTax.from_hash({'detailTax'=>[{'taxAmount'=>'1'}]},0).taxIncludedInTotal)
      assert_equal("true", DetailTax.from_hash({'detailTax'=>[{'taxIncludedInTotal'=>'true','taxAmount'=>'1'}]},0).taxIncludedInTotal)
      assert_equal("false", DetailTax.from_hash({'detailTax'=>[{'taxIncludedInTotal'=>'false','taxAmount'=>'1'}]},0).taxIncludedInTotal)
      assert_equal("1", DetailTax.from_hash({'detailTax'=>[{'taxIncludedInTotal'=>'1','taxAmount'=>'1'}]},0).taxIncludedInTotal)
      assert_equal("0", DetailTax.from_hash({'detailTax'=>[{'taxIncludedInTotal'=>'0','taxAmount'=>'1'}]},0).taxIncludedInTotal)
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxIncludedInTotal'=>'vrai','taxAmount'=>'1' }]},0) #French true
      }
      assert_equal "If detailTax taxIncludedInTotal is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message      
    end
    
    def test_detailTax_taxAmount
      assert_equal("1", DetailTax.from_hash({ 'detailTax'=>[{'taxAmount'=>'1' }]},0).taxAmount)
      assert_equal("123456789012", DetailTax.from_hash({ 'detailTax'=>[{'taxAmount'=>'123456789012' }]},0).taxAmount)
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxAmount'=>'1234567890123' }]},0)
      }
      assert_equal "If detailTax taxAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxAmount'=>'14.2' }]},0)
      }
      assert_equal "If detailTax taxAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxAmount'=>'a' }]},0)
      }
      assert_equal "If detailTax taxAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxAmount'=>'' }]},0)
      }
      assert_equal "If detailTax taxAmount is specified, it must be between -999999999999 and 999999999999", exception.message      
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{}]},0)
      }
      assert_equal "If detailTax is specified, it must have a taxAmount", exception.message
    end
    
    def test_detailTax_taxRate
      assert_equal("123.45", DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'123.45','taxAmount'=>'1' }]},0).taxRate)
      assert_equal("+123.45", DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'+123.45','taxAmount'=>'1' }]},0).taxRate)
      assert_equal("-123.45", DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'-123.45','taxAmount'=>'1' }]},0).taxRate)
      assert_equal("-.456", DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'-.456','taxAmount'=>'1' }]},0).taxRate)
      assert_equal("-456", DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'-456','taxAmount'=>'1' }]},0).taxRate)
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'1 234.5','taxAmount'=>'1' }]},0)
      }
      assert_equal "If detailTax taxRate is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'12.45E+2','taxAmount'=>'1' }]},0)
      }
      assert_equal "If detailTax taxRate is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'+ 123.45','taxAmount'=>'1' }]},0)
      }
      assert_equal "If detailTax taxRate is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxRate'=>'1,234.5','taxAmount'=>'1' }]},0)
      }
      assert_equal "If detailTax taxRate is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
    end
    
    def test_detailTax_taxTypeIdentifier
      assert_equal(nil,   DetailTax.from_hash({'detailTax'=>[{'taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("00", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'00','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("01", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'01','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("02", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'02','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("03", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'03','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("04", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'04','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("05", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'05','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("06", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'06','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("10", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'10','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("11", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'11','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("12", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'12','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("13", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'13','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("14", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'14','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("20", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'20','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("21", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'21','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      assert_equal("22", DetailTax.from_hash({'detailTax'=>[{'taxTypeIdentifier'=>'22','taxAmount'=>'1'}]},0).taxTypeIdentifier)
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'taxTypeIdentifier'=>'07','taxAmount'=>'1' }]},0)
      }
      assert_equal "If detailTax taxTypeIdentifier is specified, it must be in [\"00\", \"01\", \"02\", \"03\", \"04\", \"05\", \"06\", \"10\", \"11\", \"12\", \"13\", \"14\", \"20\", \"21\", \"22\"]", exception.message      
    end

    def test_detailTax_cardAcceptorTaxId
      assert_equal(nil, DetailTax.from_hash({'detailTax'=>[{'taxAmount'=>'1'}]},0).cardAcceptorTaxId)
      assert_equal("a", DetailTax.from_hash({'detailTax'=>[{'cardAcceptorTaxId'=>'a','taxAmount'=>'1'}]},0).cardAcceptorTaxId)
      assert_equal("1", DetailTax.from_hash({'detailTax'=>[{'cardAcceptorTaxId'=>'1','taxAmount'=>'1'}]},0).cardAcceptorTaxId)
      assert_equal("12345678901234567890", DetailTax.from_hash({'detailTax'=>[{'cardAcceptorTaxId'=>'12345678901234567890','taxAmount'=>'1'}]},0).cardAcceptorTaxId)
      exception = assert_raise(RuntimeError){
        DetailTax.from_hash({ 'detailTax'=>[{'cardAcceptorTaxId'=>'123456789012345678901','taxAmount'=>'1' }]},0)
      }
      assert_equal "If detailTax cardAcceptorTaxId is specified, it must be between 1 and 20 characters long", exception.message      
    end

    def test_lineItemData_itemSequenceNumber
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).itemSequenceNumber)
      assert_equal("1", LineItemData.from_hash({'lineItemData'=>[{'itemSequenceNumber'=>'1','itemDescription'=>'desc'}]},0).itemSequenceNumber)
      assert_equal("99", LineItemData.from_hash({'lineItemData'=>[{'itemSequenceNumber'=>'99','itemDescription'=>'desc'}]},0).itemSequenceNumber)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'itemSequenceNumber'=>'a','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData itemSequenceNumber is specified, it must be between 1 and 99", exception.message      
    end
    
    def test_lineItemData_itemDescription
      assert_equal("a", LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'a'}]},0).itemDescription)
      assert_equal("1", LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'1'}]},0).itemDescription)
      assert_equal("12345678901234567890123456", LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'12345678901234567890123456'}]},0).itemDescription)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'itemDescription'=>'123456789012345678901234567'}]},0)
      }
      assert_equal "If lineItemData itemDescription is specified, it must be between 1 and 26 characters long", exception.message      
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'itemDescription'=>''}]},0)
      }
      assert_equal "If lineItemData itemDescription is specified, it must be between 1 and 26 characters long", exception.message      
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{}]},0)
      }
      assert_equal "If lineItemData is specified, it must have a itemDescription", exception.message      
    end
    
    def test_lineItemData_productCode
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).productCode)
      assert_equal("a", LineItemData.from_hash({'lineItemData'=>[{'productCode'=>'a','itemDescription'=>'desc'}]},0).productCode)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'productCode'=>'123456789012','itemDescription'=>'desc'}]},0).productCode)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'productCode'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData productCode is specified, it must be between 1 and 12 characters long", exception.message      
    end
    
    def test_lineItemData_quantity
      assert_equal("123.45", LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'123.45','itemDescription'=>'1' }]},0).quantity)
      assert_equal("+123.45", LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'+123.45','itemDescription'=>'1' }]},0).quantity)
      assert_equal("-123.45", LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'-123.45','itemDescription'=>'1' }]},0).quantity)
      assert_equal("-.456", LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'-.456','itemDescription'=>'1' }]},0).quantity)
      assert_equal("-456", LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'-456','itemDescription'=>'1' }]},0).quantity)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'1 234.5','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData quantity is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'12.45E+2','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData quantity is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'+ 123.45','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData quantity is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'quantity'=>'1,234.5','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData quantity is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
    end
    
    def test_lineItemData_unitOfMeasure
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).unitOfMeasure)
      assert_equal("a", LineItemData.from_hash({'lineItemData'=>[{'unitOfMeasure'=>'a','itemDescription'=>'desc'}]},0).unitOfMeasure)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'unitOfMeasure'=>'123456789012','itemDescription'=>'desc'}]},0).unitOfMeasure)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'unitOfMeasure'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData unitOfMeasure is specified, it must be between 1 and 12 characters long", exception.message            
    end
    
    def test_lineItemData_taxAmount
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).taxAmount)
      assert_equal("-123456789012", LineItemData.from_hash({'lineItemData'=>[{'taxAmount'=>'-123456789012','itemDescription'=>'desc'}]},0).taxAmount)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'taxAmount'=>'123456789012','itemDescription'=>'desc'}]},0).taxAmount)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'taxAmount'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData taxAmount is specified, it must be between -999999999999 and 999999999999", exception.message                  
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'taxAmount'=>'a','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData taxAmount is specified, it must be between -999999999999 and 999999999999", exception.message                  
    end
    
    def test_lineItemData_lineItemTotal
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).lineItemTotal)
      assert_equal("-123456789012", LineItemData.from_hash({'lineItemData'=>[{'lineItemTotal'=>'-123456789012','itemDescription'=>'desc'}]},0).lineItemTotal)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'lineItemTotal'=>'123456789012','itemDescription'=>'desc'}]},0).lineItemTotal)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'lineItemTotal'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData lineItemTotal is specified, it must be between -999999999999 and 999999999999", exception.message                  
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'lineItemTotal'=>'a','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData lineItemTotal is specified, it must be between -999999999999 and 999999999999", exception.message                  
    end
    
    def test_lineItemData_lineItemTotalWithTax
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).lineItemTotalWithTax)
      assert_equal("-123456789012", LineItemData.from_hash({'lineItemData'=>[{'lineItemTotalWithTax'=>'-123456789012','itemDescription'=>'desc'}]},0).lineItemTotalWithTax)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'lineItemTotalWithTax'=>'123456789012','itemDescription'=>'desc'}]},0).lineItemTotalWithTax)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'lineItemTotalWithTax'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData lineItemTotalWithTax is specified, it must be between -999999999999 and 999999999999", exception.message                  
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'lineItemTotalWithTax'=>'a','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData lineItemTotalWithTax is specified, it must be between -999999999999 and 999999999999", exception.message                  
    end
    
    def test_lineItemData_itemDiscountAmount
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).itemDiscountAmount)
      assert_equal("-123456789012", LineItemData.from_hash({'lineItemData'=>[{'itemDiscountAmount'=>'-123456789012','itemDescription'=>'desc'}]},0).itemDiscountAmount)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'itemDiscountAmount'=>'123456789012','itemDescription'=>'desc'}]},0).itemDiscountAmount)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'itemDiscountAmount'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData itemDiscountAmount is specified, it must be between -999999999999 and 999999999999", exception.message                  
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'itemDiscountAmount'=>'a','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData itemDiscountAmount is specified, it must be between -999999999999 and 999999999999", exception.message                  
    end
    
    def test_lineItemData_commodityCode
      assert_equal(nil, LineItemData.from_hash({'lineItemData'=>[{'itemDescription'=>'desc'}]},0).commodityCode)
      assert_equal("a", LineItemData.from_hash({'lineItemData'=>[{'commodityCode'=>'a','itemDescription'=>'desc'}]},0).commodityCode)
      assert_equal("123456789012", LineItemData.from_hash({'lineItemData'=>[{'commodityCode'=>'123456789012','itemDescription'=>'desc'}]},0).commodityCode)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'commodityCode'=>'1234567890123','itemDescription'=>'desc'}]},0)
      }
      assert_equal "If lineItemData commodityCode is specified, it must be between 1 and 12 characters long", exception.message            
    end
    
    def test_lineItemData_unitCost
      assert_equal("123.45", LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'123.45','itemDescription'=>'1' }]},0).unitCost)
      assert_equal("+123.45", LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'+123.45','itemDescription'=>'1' }]},0).unitCost)
      assert_equal("-123.45", LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'-123.45','itemDescription'=>'1' }]},0).unitCost)
      assert_equal("-.456", LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'-.456','itemDescription'=>'1' }]},0).unitCost)
      assert_equal("-456", LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'-456','itemDescription'=>'1' }]},0).unitCost)
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'1 234.5','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData unitCost is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'12.45E+2','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData unitCost is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'+ 123.45','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData unitCost is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        LineItemData.from_hash({ 'lineItemData'=>[{'unitCost'=>'1,234.5','itemDescription'=>'1' }]},0)
      }
      assert_equal "If lineItemData unitCost is specified, it must match the regular expression /\\A(\\+|\\-)?\\d*\\.?\\d*\\Z/", exception.message
    end
    
    def test_enhancedData_customerReference
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).customerReference)
      assert_equal("a", EnhancedData.from_hash({'enhancedData'=>{'customerReference'=>'a'}}).customerReference)
      assert_equal("12345678901234567", EnhancedData.from_hash({'enhancedData'=>{'customerReference'=>'12345678901234567'}}).customerReference)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'customerReference'=>'123456789012345678'}})
      }
      assert_equal "If enhancedData customerReference is specified, it must be between 1 and 17 characters long", exception.message            
    end

    def test_enhancedData_salesTax
      assert_equal(nil, EnhancedData.from_hash({ 'enhancedData'=>{}}).salesTax)
      assert_equal("1", EnhancedData.from_hash({ 'enhancedData'=>{'salesTax'=>'1' }}).salesTax)
      assert_equal("123456789012", EnhancedData.from_hash({ 'enhancedData'=>{'salesTax'=>'123456789012' }}).salesTax)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'salesTax'=>'1234567890123' }})
      }
      assert_equal "If enhancedData salesTax is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'salesTax'=>'14.2' }})
      }
      assert_equal "If enhancedData salesTax is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'salesTax'=>'a' }})
      }
      assert_equal "If enhancedData salesTax is specified, it must be between -999999999999 and 999999999999", exception.message
    end
    
    def test_enhancedData_deliveryType
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).deliveryType)
      assert_equal("CNC", EnhancedData.from_hash({'enhancedData'=>{'deliveryType'=>'CNC'}}).deliveryType)
      assert_equal("DIG", EnhancedData.from_hash({'enhancedData'=>{'deliveryType'=>'DIG'}}).deliveryType)
      assert_equal("PHY", EnhancedData.from_hash({'enhancedData'=>{'deliveryType'=>'PHY'}}).deliveryType)
      assert_equal("SVC", EnhancedData.from_hash({'enhancedData'=>{'deliveryType'=>'SVC'}}).deliveryType)
      assert_equal("TBD", EnhancedData.from_hash({'enhancedData'=>{'deliveryType'=>'TBD'}}).deliveryType)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'deliveryType'=>'GAD' }})
      }
      assert_equal "If enhancedData deliveryType is specified, it must be in [\"CNC\", \"DIG\", \"PHY\", \"SVC\", \"TBD\"]", exception.message
    end
    
    def test_enhancedData_taxExempt
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).taxExempt)
      assert_equal("true", EnhancedData.from_hash({'enhancedData'=>{'taxExempt'=>'true'}}).taxExempt)
      assert_equal("false", EnhancedData.from_hash({'enhancedData'=>{'taxExempt'=>'false'}}).taxExempt)
      assert_equal("1", EnhancedData.from_hash({'enhancedData'=>{'taxExempt'=>'1'}}).taxExempt)
      assert_equal("0", EnhancedData.from_hash({'enhancedData'=>{'taxExempt'=>'0'}}).taxExempt)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'taxExempt'=>'vrai' }}) #French true
      }
      assert_equal "If enhancedData taxExempt is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_enhancedData_discountAmount
      assert_equal(nil, EnhancedData.from_hash({ 'enhancedData'=>{}}).discountAmount)
      assert_equal("1", EnhancedData.from_hash({ 'enhancedData'=>{'discountAmount'=>'1' }}).discountAmount)
      assert_equal("123456789012", EnhancedData.from_hash({ 'enhancedData'=>{'discountAmount'=>'123456789012' }}).discountAmount)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'discountAmount'=>'1234567890123' }})
      }
      assert_equal "If enhancedData discountAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'discountAmount'=>'14.2' }})
      }
      assert_equal "If enhancedData discountAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'discountAmount'=>'a' }})
      }
      assert_equal "If enhancedData discountAmount is specified, it must be between -999999999999 and 999999999999", exception.message
    end
    
    def test_enhancedData_shippingAmount
      assert_equal(nil, EnhancedData.from_hash({ 'enhancedData'=>{}}).shippingAmount)
      assert_equal("1", EnhancedData.from_hash({ 'enhancedData'=>{'shippingAmount'=>'1' }}).shippingAmount)
      assert_equal("123456789012", EnhancedData.from_hash({ 'enhancedData'=>{'shippingAmount'=>'123456789012' }}).shippingAmount)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'shippingAmount'=>'1234567890123' }})
      }
      assert_equal "If enhancedData shippingAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'shippingAmount'=>'14.2' }})
      }
      assert_equal "If enhancedData shippingAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'shippingAmount'=>'a' }})
      }
      assert_equal "If enhancedData shippingAmount is specified, it must be between -999999999999 and 999999999999", exception.message
    end
    
    def test_enhancedData_dutyAmount
      assert_equal(nil, EnhancedData.from_hash({ 'enhancedData'=>{}}).dutyAmount)
      assert_equal("1", EnhancedData.from_hash({ 'enhancedData'=>{'dutyAmount'=>'1' }}).dutyAmount)
      assert_equal("123456789012", EnhancedData.from_hash({ 'enhancedData'=>{'dutyAmount'=>'123456789012' }}).dutyAmount)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'dutyAmount'=>'1234567890123' }})
      }
      assert_equal "If enhancedData dutyAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'dutyAmount'=>'14.2' }})
      }
      assert_equal "If enhancedData dutyAmount is specified, it must be between -999999999999 and 999999999999", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'dutyAmount'=>'a' }})
      }
      assert_equal "If enhancedData dutyAmount is specified, it must be between -999999999999 and 999999999999", exception.message
    end
    
    def test_enhancedData_shipFromPostalCode
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).shipFromPostalCode)
      assert_equal("a", EnhancedData.from_hash({'enhancedData'=>{'shipFromPostalCode'=>'a'}}).shipFromPostalCode)
      assert_equal("12345678901234567890", EnhancedData.from_hash({'enhancedData'=>{'shipFromPostalCode'=>'12345678901234567890'}}).shipFromPostalCode)      
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'shipFromPostalCode'=>'123456789012345678901'}})
      }
      assert_equal "If enhancedData shipFromPostalCode is specified, it must be between 1 and 20 characters long", exception.message            
    end
    
    def test_enhancedData_destinationPostalCode
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).destinationPostalCode)
      assert_equal("a", EnhancedData.from_hash({'enhancedData'=>{'destinationPostalCode'=>'a'}}).destinationPostalCode)
      assert_equal("12345678901234567890", EnhancedData.from_hash({'enhancedData'=>{'destinationPostalCode'=>'12345678901234567890'}}).destinationPostalCode)      
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'destinationPostalCode'=>'123456789012345678901'}})
      }
      assert_equal "If enhancedData destinationPostalCode is specified, it must be between 1 and 20 characters long", exception.message            
    end
    
    def test_enhancedData_destinationCountryCode
      assert_equal("USA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'USA' }}).destinationCountryCode)
      assert_equal(nil, EnhancedData.from_hash({ 'enhancedData'=>{}}).destinationCountryCode)
      assert_equal("AF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AF' }}).destinationCountryCode)
      assert_equal("AX", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AX' }}).destinationCountryCode)
      assert_equal("AL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AL' }}).destinationCountryCode)
      assert_equal("DZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'DZ' }}).destinationCountryCode)
      assert_equal("AS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AS' }}).destinationCountryCode)
      assert_equal("AD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AD' }}).destinationCountryCode)
      assert_equal("AO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AO' }}).destinationCountryCode)
      assert_equal("AI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AI' }}).destinationCountryCode)
      assert_equal("AQ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AQ' }}).destinationCountryCode)
      assert_equal("AG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AG' }}).destinationCountryCode)
      assert_equal("AR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AR' }}).destinationCountryCode)
      assert_equal("AM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AM' }}).destinationCountryCode)
      assert_equal("AW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AW' }}).destinationCountryCode)
      assert_equal("AU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AU' }}).destinationCountryCode)
      assert_equal("AZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AZ' }}).destinationCountryCode)
      assert_equal("BS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BS' }}).destinationCountryCode)
      assert_equal("BH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BH' }}).destinationCountryCode)
      assert_equal("BD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BD' }}).destinationCountryCode)
      assert_equal("BB", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BB' }}).destinationCountryCode)
      assert_equal("BY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BY' }}).destinationCountryCode)
      assert_equal("BE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BE' }}).destinationCountryCode)
      assert_equal("BZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BZ' }}).destinationCountryCode)
      assert_equal("BJ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BJ' }}).destinationCountryCode)
      assert_equal("BM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BM' }}).destinationCountryCode)
      assert_equal("BT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BT' }}).destinationCountryCode)
      assert_equal("BO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BO' }}).destinationCountryCode)
      assert_equal("BQ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BQ' }}).destinationCountryCode)
      assert_equal("BA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BA' }}).destinationCountryCode)
      assert_equal("BW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BW' }}).destinationCountryCode)
      assert_equal("BV", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BV' }}).destinationCountryCode)
      assert_equal("BR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BR' }}).destinationCountryCode)
      assert_equal("IO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IO' }}).destinationCountryCode)
      assert_equal("BN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BN' }}).destinationCountryCode)
      assert_equal("BG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BG' }}).destinationCountryCode)
      assert_equal("BF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BF' }}).destinationCountryCode)
      assert_equal("BI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BI' }}).destinationCountryCode)
      assert_equal("KH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KH' }}).destinationCountryCode)
      assert_equal("CM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CM' }}).destinationCountryCode)
      assert_equal("CA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CA' }}).destinationCountryCode)
      assert_equal("CV", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CV' }}).destinationCountryCode)
      assert_equal("KY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KY' }}).destinationCountryCode)
      assert_equal("CF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CF' }}).destinationCountryCode)
      assert_equal("TD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TD' }}).destinationCountryCode)
      assert_equal("CL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CL' }}).destinationCountryCode)
      assert_equal("CN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CN' }}).destinationCountryCode)
      assert_equal("CX", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CX' }}).destinationCountryCode)
      assert_equal("CC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CC' }}).destinationCountryCode)
      assert_equal("CO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CO' }}).destinationCountryCode)
      assert_equal("KM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KM' }}).destinationCountryCode)
      assert_equal("CG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CG' }}).destinationCountryCode)
      assert_equal("CD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CD' }}).destinationCountryCode)
      assert_equal("CK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CK' }}).destinationCountryCode)
      assert_equal("CR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CR' }}).destinationCountryCode)
      assert_equal("CI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CI' }}).destinationCountryCode)
      assert_equal("HR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'HR' }}).destinationCountryCode)
      assert_equal("CU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CU' }}).destinationCountryCode)
      assert_equal("CW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CW' }}).destinationCountryCode)
      assert_equal("CY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CY' }}).destinationCountryCode)
      assert_equal("CZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CZ' }}).destinationCountryCode)
      assert_equal("DK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'DK' }}).destinationCountryCode)
      assert_equal("DJ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'DJ' }}).destinationCountryCode)
      assert_equal("DM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'DM' }}).destinationCountryCode)
      assert_equal("DO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'DO' }}).destinationCountryCode)
      assert_equal("TL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TL' }}).destinationCountryCode)
      assert_equal("EC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'EC' }}).destinationCountryCode)
      assert_equal("EG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'EG' }}).destinationCountryCode)
      assert_equal("SV", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SV' }}).destinationCountryCode)
      assert_equal("GQ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GQ' }}).destinationCountryCode)
      assert_equal("ER", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ER' }}).destinationCountryCode)
      assert_equal("EE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'EE' }}).destinationCountryCode)
      assert_equal("ET", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ET' }}).destinationCountryCode)
      assert_equal("FK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'FK' }}).destinationCountryCode)
      assert_equal("FO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'FO' }}).destinationCountryCode)
      assert_equal("FJ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'FJ' }}).destinationCountryCode)
      assert_equal("FI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'FI' }}).destinationCountryCode)
      assert_equal("FR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'FR' }}).destinationCountryCode)
      assert_equal("GF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GF' }}).destinationCountryCode)
      assert_equal("PF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PF' }}).destinationCountryCode)
      assert_equal("TF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TF' }}).destinationCountryCode)
      assert_equal("GA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GA' }}).destinationCountryCode)
      assert_equal("GM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GM' }}).destinationCountryCode)
      assert_equal("GE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GE' }}).destinationCountryCode)
      assert_equal("DE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'DE' }}).destinationCountryCode)
      assert_equal("GH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GH' }}).destinationCountryCode)
      assert_equal("GI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GI' }}).destinationCountryCode)
      assert_equal("GR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GR' }}).destinationCountryCode)
      assert_equal("GL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GL' }}).destinationCountryCode)
      assert_equal("GD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GD' }}).destinationCountryCode)
      assert_equal("GP", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GP' }}).destinationCountryCode)
      assert_equal("GU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GU' }}).destinationCountryCode)
      assert_equal("GT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GT' }}).destinationCountryCode)
      assert_equal("GG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GG' }}).destinationCountryCode)
      assert_equal("GN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GN' }}).destinationCountryCode)
      assert_equal("GW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GW' }}).destinationCountryCode)
      assert_equal("GY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GY' }}).destinationCountryCode)
      assert_equal("HT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'HT' }}).destinationCountryCode)
      assert_equal("HM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'HM' }}).destinationCountryCode)
      assert_equal("HN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'HN' }}).destinationCountryCode)
      assert_equal("HK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'HK' }}).destinationCountryCode)
      assert_equal("HU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'HU' }}).destinationCountryCode)
      assert_equal("IS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IS' }}).destinationCountryCode)
      assert_equal("IN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IN' }}).destinationCountryCode)
      assert_equal("ID", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ID' }}).destinationCountryCode)
      assert_equal("IR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IR' }}).destinationCountryCode)
      assert_equal("IQ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IQ' }}).destinationCountryCode)
      assert_equal("IE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IE' }}).destinationCountryCode)
      assert_equal("IM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IM' }}).destinationCountryCode)
      assert_equal("IL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IL' }}).destinationCountryCode)
      assert_equal("IT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'IT' }}).destinationCountryCode)
      assert_equal("JM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'JM' }}).destinationCountryCode)
      assert_equal("JP", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'JP' }}).destinationCountryCode)
      assert_equal("JE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'JE' }}).destinationCountryCode)
      assert_equal("JO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'JO' }}).destinationCountryCode)
      assert_equal("KZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KZ' }}).destinationCountryCode)
      assert_equal("KE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KE' }}).destinationCountryCode)
      assert_equal("KI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KI' }}).destinationCountryCode)
      assert_equal("KP", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KP' }}).destinationCountryCode)
      assert_equal("KR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KR' }}).destinationCountryCode)
      assert_equal("KW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KW' }}).destinationCountryCode)
      assert_equal("KG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KG' }}).destinationCountryCode)
      assert_equal("LA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LA' }}).destinationCountryCode)
      assert_equal("LV", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LV' }}).destinationCountryCode)
      assert_equal("LB", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LB' }}).destinationCountryCode)
      assert_equal("LS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LS' }}).destinationCountryCode)
      assert_equal("LR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LR' }}).destinationCountryCode)
      assert_equal("LY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LY' }}).destinationCountryCode)
      assert_equal("LI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LI' }}).destinationCountryCode)
      assert_equal("LT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LT' }}).destinationCountryCode)
      assert_equal("LU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LU' }}).destinationCountryCode)
      assert_equal("MO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MO' }}).destinationCountryCode)
      assert_equal("MK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MK' }}).destinationCountryCode)
      assert_equal("MG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MG' }}).destinationCountryCode)
      assert_equal("MW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MW' }}).destinationCountryCode)
      assert_equal("MY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MY' }}).destinationCountryCode)
      assert_equal("MV", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MV' }}).destinationCountryCode)
      assert_equal("ML", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ML' }}).destinationCountryCode)
      assert_equal("MT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MT' }}).destinationCountryCode)
      assert_equal("MH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MH' }}).destinationCountryCode)
      assert_equal("MQ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MQ' }}).destinationCountryCode)
      assert_equal("MR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MR' }}).destinationCountryCode)
      assert_equal("MU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MU' }}).destinationCountryCode)
      assert_equal("YT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'YT' }}).destinationCountryCode)
      assert_equal("MX", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MX' }}).destinationCountryCode)
      assert_equal("FM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'FM' }}).destinationCountryCode)
      assert_equal("MD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MD' }}).destinationCountryCode)
      assert_equal("MC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MC' }}).destinationCountryCode)
      assert_equal("MN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MN' }}).destinationCountryCode)
      assert_equal("MS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MS' }}).destinationCountryCode)
      assert_equal("MA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MA' }}).destinationCountryCode)
      assert_equal("MZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MZ' }}).destinationCountryCode)
      assert_equal("MM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MM' }}).destinationCountryCode)
      assert_equal("NA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NA' }}).destinationCountryCode)
      assert_equal("NR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NR' }}).destinationCountryCode)
      assert_equal("NP", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NP' }}).destinationCountryCode)
      assert_equal("NL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NL' }}).destinationCountryCode)
      assert_equal("AN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AN' }}).destinationCountryCode)
      assert_equal("NC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NC' }}).destinationCountryCode)
      assert_equal("NZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NZ' }}).destinationCountryCode)
      assert_equal("NI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NI' }}).destinationCountryCode)
      assert_equal("NE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NE' }}).destinationCountryCode)
      assert_equal("NG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NG' }}).destinationCountryCode)
      assert_equal("NU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NU' }}).destinationCountryCode)
      assert_equal("NF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NF' }}).destinationCountryCode)
      assert_equal("MP", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MP' }}).destinationCountryCode)
      assert_equal("NO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'NO' }}).destinationCountryCode)
      assert_equal("OM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'OM' }}).destinationCountryCode)
      assert_equal("PK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PK' }}).destinationCountryCode)
      assert_equal("PW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PW' }}).destinationCountryCode)
      assert_equal("PS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PS' }}).destinationCountryCode)
      assert_equal("PA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PA' }}).destinationCountryCode)
      assert_equal("PG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PG' }}).destinationCountryCode)
      assert_equal("PY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PY' }}).destinationCountryCode)
      assert_equal("PE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PE' }}).destinationCountryCode)
      assert_equal("PH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PH' }}).destinationCountryCode)
      assert_equal("PN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PN' }}).destinationCountryCode)
      assert_equal("PL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PL' }}).destinationCountryCode)
      assert_equal("PT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PT' }}).destinationCountryCode)
      assert_equal("PR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PR' }}).destinationCountryCode)
      assert_equal("QA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'QA' }}).destinationCountryCode)
      assert_equal("RE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'RE' }}).destinationCountryCode)
      assert_equal("RO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'RO' }}).destinationCountryCode)
      assert_equal("RU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'RU' }}).destinationCountryCode)
      assert_equal("RW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'RW' }}).destinationCountryCode)
      assert_equal("BL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'BL' }}).destinationCountryCode)
      assert_equal("KN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'KN' }}).destinationCountryCode)
      assert_equal("LC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LC' }}).destinationCountryCode)
      assert_equal("MF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'MF' }}).destinationCountryCode)
      assert_equal("VC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VC' }}).destinationCountryCode)
      assert_equal("WS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'WS' }}).destinationCountryCode)
      assert_equal("SM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SM' }}).destinationCountryCode)
      assert_equal("ST", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ST' }}).destinationCountryCode)
      assert_equal("SA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SA' }}).destinationCountryCode)
      assert_equal("SN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SN' }}).destinationCountryCode)
      assert_equal("SC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SC' }}).destinationCountryCode)
      assert_equal("SL", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SL' }}).destinationCountryCode)
      assert_equal("SG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SG' }}).destinationCountryCode)
      assert_equal("SX", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SX' }}).destinationCountryCode)
      assert_equal("SK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SK' }}).destinationCountryCode)
      assert_equal("SI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SI' }}).destinationCountryCode)
      assert_equal("SB", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SB' }}).destinationCountryCode)
      assert_equal("SO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SO' }}).destinationCountryCode)
      assert_equal("ZA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ZA' }}).destinationCountryCode)
      assert_equal("GS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GS' }}).destinationCountryCode)
      assert_equal("ES", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ES' }}).destinationCountryCode)
      assert_equal("LK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'LK' }}).destinationCountryCode)
      assert_equal("SH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SH' }}).destinationCountryCode)
      assert_equal("PM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'PM' }}).destinationCountryCode)
      assert_equal("SD", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SD' }}).destinationCountryCode)
      assert_equal("SR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SR' }}).destinationCountryCode)
      assert_equal("SJ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SJ' }}).destinationCountryCode)
      assert_equal("SZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SZ' }}).destinationCountryCode)
      assert_equal("SE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SE' }}).destinationCountryCode)
      assert_equal("CH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'CH' }}).destinationCountryCode)
      assert_equal("SY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'SY' }}).destinationCountryCode)
      assert_equal("TW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TW' }}).destinationCountryCode)
      assert_equal("TJ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TJ' }}).destinationCountryCode)
      assert_equal("TZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TZ' }}).destinationCountryCode)
      assert_equal("TH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TH' }}).destinationCountryCode)
      assert_equal("TG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TG' }}).destinationCountryCode)
      assert_equal("TK", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TK' }}).destinationCountryCode)
      assert_equal("TO", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TO' }}).destinationCountryCode)
      assert_equal("TT", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TT' }}).destinationCountryCode)
      assert_equal("TN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TN' }}).destinationCountryCode)
      assert_equal("TR", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TR' }}).destinationCountryCode)
      assert_equal("TM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TM' }}).destinationCountryCode)
      assert_equal("TC", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TC' }}).destinationCountryCode)
      assert_equal("TV", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'TV' }}).destinationCountryCode)
      assert_equal("UG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'UG' }}).destinationCountryCode)
      assert_equal("UA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'UA' }}).destinationCountryCode)
      assert_equal("AE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'AE' }}).destinationCountryCode)
      assert_equal("GB", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'GB' }}).destinationCountryCode)
      assert_equal("US", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'US' }}).destinationCountryCode)
      assert_equal("UM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'UM' }}).destinationCountryCode)
      assert_equal("UY", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'UY' }}).destinationCountryCode)
      assert_equal("UZ", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'UZ' }}).destinationCountryCode)
      assert_equal("VU", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VU' }}).destinationCountryCode)
      assert_equal("VA", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VA' }}).destinationCountryCode)
      assert_equal("VE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VE' }}).destinationCountryCode)
      assert_equal("VN", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VN' }}).destinationCountryCode)
      assert_equal("VG", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VG' }}).destinationCountryCode)
      assert_equal("VI", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'VI' }}).destinationCountryCode)
      assert_equal("WF", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'WF' }}).destinationCountryCode)
      assert_equal("EH", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'EH' }}).destinationCountryCode)
      assert_equal("YE", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'YE' }}).destinationCountryCode)
      assert_equal("ZM", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ZM' }}).destinationCountryCode)
      assert_equal("ZW", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ZW' }}).destinationCountryCode)
      assert_equal("RS", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'RS' }}).destinationCountryCode)
      assert_equal("ME", EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ME' }}).destinationCountryCode)

      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'destinationCountryCode'=>'ABC' }})
      }
      assert_equal "If enhancedData destinationCountryCode is specified, it must be valid.  You specified ABC", exception.message    
    end
    
    def test_enhancedData_invoiceReferenceNumber
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).invoiceReferenceNumber)
      assert_equal("a", EnhancedData.from_hash({'enhancedData'=>{'invoiceReferenceNumber'=>'a'}}).invoiceReferenceNumber)
      assert_equal("123456789012345", EnhancedData.from_hash({'enhancedData'=>{'invoiceReferenceNumber'=>'123456789012345'}}).invoiceReferenceNumber)      
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'invoiceReferenceNumber'=>'1234567890123456'}})
      }
      assert_equal "If enhancedData invoiceReferenceNumber is specified, it must be between 1 and 15 characters long", exception.message            
    end
    
    def test_enhancedData_orderDate
      assert_equal(nil, EnhancedData.from_hash({'enhancedData'=>{}}).orderDate)
      assert_equal("2012-04-11", EnhancedData.from_hash({'enhancedData'=>{'orderDate'=>'2012-04-11'}}).orderDate)
      assert_equal("2012-11-04", EnhancedData.from_hash({'enhancedData'=>{'orderDate'=>'2012-11-04'}}).orderDate)
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'orderDate'=>'04-11-2012' }})
      }
      assert_equal "If enhancedData orderDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'orderDate'=>'11-04-2012' }})
      }
      assert_equal "If enhancedData orderDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'orderDate'=>'2012-4-11' }})
      }
      assert_equal "If enhancedData orderDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'orderDate'=>'2012-11-4' }})
      }
      assert_equal "If enhancedData orderDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'orderDate'=>'12-11-04' }})
      }
      assert_equal "If enhancedData orderDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message
      exception = assert_raise(RuntimeError){
        EnhancedData.from_hash({ 'enhancedData'=>{'orderDate'=>'aaaa-mm-dd' }})
      }
      assert_equal "If enhancedData orderDate is specified, it must match the regular expression /\\A\\d{4}-\\d{2}-\\d{2}\\Z/", exception.message      
    end
    
    def test_amexAggregatorData_sellerId
      assert_equal(nil, AmexAggregatorData.from_hash({'amexAggregatorData'=>{}}).sellerId)
      assert_equal("a", AmexAggregatorData.from_hash({'amexAggregatorData'=>{'sellerId'=>'a'}}).sellerId)
      assert_equal("1234567890123456", AmexAggregatorData.from_hash({'amexAggregatorData'=>{'sellerId'=>'1234567890123456'}}).sellerId)      
      exception = assert_raise(RuntimeError){
        AmexAggregatorData.from_hash({ 'amexAggregatorData'=>{'sellerId'=>'12345678901234567'}})
      }
      assert_equal "If amexAggregatorData sellerId is specified, it must be between 1 and 16 characters long", exception.message            
    end

    def test_amexAggregatorData_sellerMerchantCategoryCode
      assert_equal(nil, AmexAggregatorData.from_hash({'amexAggregatorData'=>{}}).sellerMerchantCategoryCode)
      assert_equal("a", AmexAggregatorData.from_hash({'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'a'}}).sellerMerchantCategoryCode)
      assert_equal("1234", AmexAggregatorData.from_hash({'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'1234'}}).sellerMerchantCategoryCode)      
      exception = assert_raise(RuntimeError){
        AmexAggregatorData.from_hash({ 'amexAggregatorData'=>{'sellerMerchantCategoryCode'=>'12345'}})
      }
      assert_equal "If amexAggregatorData sellerMerchantCategoryCode is specified, it must be between 1 and 4 characters long", exception.message            
    end
    
    def test_card_mop
      assert_equal(nil, Card.from_hash({'card'=>{}}).mop)
      assert_equal("", Card.from_hash({'card'=>{'type'=>''}}).mop)
      assert_equal("MC", Card.from_hash({'card'=>{'type'=>'MC'}}).mop)
      assert_equal("VI", Card.from_hash({'card'=>{'type'=>'VI'}}).mop)
      assert_equal("AX", Card.from_hash({'card'=>{'type'=>'AX'}}).mop)
      assert_equal("DC", Card.from_hash({'card'=>{'type'=>'DC'}}).mop)
      assert_equal("DI", Card.from_hash({'card'=>{'type'=>'DI'}}).mop)
      assert_equal("PP", Card.from_hash({'card'=>{'type'=>'PP'}}).mop)
      assert_equal("JC", Card.from_hash({'card'=>{'type'=>'JC'}}).mop)
      assert_equal("BL", Card.from_hash({'card'=>{'type'=>'BL'}}).mop)
      assert_equal("EC", Card.from_hash({'card'=>{'type'=>'EC'}}).mop)
      exception = assert_raise(RuntimeError){
        Card.from_hash({ 'card'=>{'type'=>'ZZ' }})
      }
      assert_equal "If card type is specified, it must be in [\"\", \"MC\", \"VI\", \"AX\", \"DC\", \"DI\", \"PP\", \"JC\", \"BL\", \"EC\", \"GC\"]", exception.message
    end
    
    def test_card_track
      assert_equal(nil, Card.from_hash({'card'=>{}}).track)
      assert_equal("a", Card.from_hash({'card'=>{'track'=>'a'}}).track)
      assert_equal("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456", Card.from_hash({'card'=>{'track'=>'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'}}).track)      
      exception = assert_raise(RuntimeError){
        Card.from_hash({ 'card'=>{'track'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567'}})
      }
      assert_equal "If card track is specified, it must be between 1 and 256 characters long", exception.message            
    end
    
    def test_card_number
      assert_equal(nil, Card.from_hash({'card'=>{}}).number)
      assert_equal("abcdefghijklm", Card.from_hash({'card'=>{'number'=>'abcdefghijklm'}}).number)
      assert_equal("1234567890123", Card.from_hash({'card'=>{'number'=>'1234567890123'}}).number)
      assert_equal("1234567890123456789012345", Card.from_hash({'card'=>{'number'=>'1234567890123456789012345'}}).number)
      exception = assert_raise(RuntimeError){
        Card.from_hash({ 'card'=>{'number'=>'12345678901234567890123456'}})
      }
      assert_equal "If card number is specified, it must be between 13 and 25 characters long", exception.message            
    end
    
    def test_card_expDate
      assert_equal(nil, Card.from_hash({'card'=>{}}).expDate)
      assert_equal("abcd", Card.from_hash({'card'=>{'expDate'=>'abcd'}}).expDate)
      assert_equal("1234", Card.from_hash({'card'=>{'expDate'=>'1234'}}).expDate)
      exception = assert_raise(RuntimeError){
        Card.from_hash({ 'card'=>{'expDate'=>'123'}})
      }
      assert_equal "If card expDate is specified, it must be between 4 and 4 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        Card.from_hash({ 'card'=>{'expDate'=>'12345'}})
      }
      assert_equal "If card expDate is specified, it must be between 4 and 4 characters long", exception.message            
    end
    
    def test_card_cardValidationNum
      assert_equal(nil, Card.from_hash({'card'=>{}}).cardValidationNum)
      assert_equal("a", Card.from_hash({'card'=>{'cardValidationNum'=>'a'}}).cardValidationNum)
      assert_equal("1234", Card.from_hash({'card'=>{'cardValidationNum'=>'1234'}}).cardValidationNum)      
      exception = assert_raise(RuntimeError){
        Card.from_hash({ 'card'=>{'cardValidationNum'=>'12345'}})
      }
      assert_equal "If card cardValidationNum is specified, it must be between 1 and 4 characters long", exception.message                  
    end
    
    def test_cardToken_litleToken
      assert_equal("abcdefghijklm", CardToken.from_hash({'cardToken'=>{'litleToken'=>'abcdefghijklm'}}).litleToken)
      assert_equal("1234567890123", CardToken.from_hash({'cardToken'=>{'litleToken'=>'1234567890123'}}).litleToken)
      assert_equal("1234567890123456789012345", CardToken.from_hash({'cardToken'=>{'litleToken'=>'1234567890123456789012345'}}).litleToken)
      exception = assert_raise(RuntimeError){
        CardToken.from_hash({ 'cardToken'=>{'litleToken'=>'12345678901234567890123456'}})
      }
      assert_equal "If cardToken litleToken is specified, it must be between 13 and 25 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        CardToken.from_hash({ 'cardToken'=>{}})
      }
      assert_equal "If cardToken is specified, it must have a litleToken", exception.message            
    end
    
    def test_cardToken_expDate
      assert_equal(nil, CardToken.from_hash({'cardToken'=>{'litleToken'=>'1234567890123'}}).expDate)
      assert_equal("abcd", CardToken.from_hash({'cardToken'=>{'expDate'=>'abcd','litleToken'=>'1234567890123'}}).expDate)
      assert_equal("1234", CardToken.from_hash({'cardToken'=>{'expDate'=>'1234','litleToken'=>'1234567890123'}}).expDate)
      exception = assert_raise(RuntimeError){
        CardToken.from_hash({ 'cardToken'=>{'expDate'=>'123','litleToken'=>'1234567890123'}})
      }
      assert_equal "If cardToken expDate is specified, it must be between 4 and 4 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        CardToken.from_hash({ 'cardToken'=>{'expDate'=>'12345','litleToken'=>'1234567890123'}})
      }
      assert_equal "If cardToken expDate is specified, it must be between 4 and 4 characters long", exception.message            
    end
    
    def test_cardToken_cardValidationNum
      assert_equal(nil, CardToken.from_hash({'cardToken'=>{'litleToken'=>'1234567890123'}}).cardValidationNum)
      assert_equal("a", CardToken.from_hash({'cardToken'=>{'cardValidationNum'=>'a','litleToken'=>'1234567890123'}}).cardValidationNum)
      assert_equal("1234", CardToken.from_hash({'cardToken'=>{'cardValidationNum'=>'1234','litleToken'=>'1234567890123'}}).cardValidationNum)      
      exception = assert_raise(RuntimeError){
        CardToken.from_hash({ 'cardToken'=>{'cardValidationNum'=>'12345','litleToken'=>'1234567890123'}})
      }
      assert_equal "If cardToken cardValidationNum is specified, it must be between 1 and 4 characters long", exception.message                  
    end
    
    def test_cardToken_mop
      assert_equal(nil, CardToken.from_hash({'cardToken'=>{'litleToken'=>'1234567890123'}}).mop)
      assert_equal("", CardToken.from_hash({'cardToken'=>{'type'=>'','litleToken'=>'1234567890123'}}).mop)
      assert_equal("MC", CardToken.from_hash({'cardToken'=>{'type'=>'MC','litleToken'=>'1234567890123'}}).mop)
      assert_equal("VI", CardToken.from_hash({'cardToken'=>{'type'=>'VI','litleToken'=>'1234567890123'}}).mop)
      assert_equal("AX", CardToken.from_hash({'cardToken'=>{'type'=>'AX','litleToken'=>'1234567890123'}}).mop)
      assert_equal("DC", CardToken.from_hash({'cardToken'=>{'type'=>'DC','litleToken'=>'1234567890123'}}).mop)
      assert_equal("DI", CardToken.from_hash({'cardToken'=>{'type'=>'DI','litleToken'=>'1234567890123'}}).mop)
      assert_equal("PP", CardToken.from_hash({'cardToken'=>{'type'=>'PP','litleToken'=>'1234567890123'}}).mop)
      assert_equal("JC", CardToken.from_hash({'cardToken'=>{'type'=>'JC','litleToken'=>'1234567890123'}}).mop)
      assert_equal("BL", CardToken.from_hash({'cardToken'=>{'type'=>'BL','litleToken'=>'1234567890123'}}).mop)
      assert_equal("EC", CardToken.from_hash({'cardToken'=>{'type'=>'EC','litleToken'=>'1234567890123'}}).mop)
      exception = assert_raise(RuntimeError){
        CardToken.from_hash({ 'cardToken'=>{'type'=>'ZZ','litleToken'=>'1234567890123'}})
      }
      assert_equal "If cardToken type is specified, it must be in [\"\", \"MC\", \"VI\", \"AX\", \"DC\", \"DI\", \"PP\", \"JC\", \"BL\", \"EC\"]", exception.message
    end
    
    def test_cardPaypage_paypageRegistrationId
      assert_equal("a", CardPaypage.from_hash({'cardPaypage'=>{'paypageRegistrationId'=>'a'}}).paypageRegistrationId)
      assert_equal("1234567890123", CardPaypage.from_hash({'cardPaypage'=>{'paypageRegistrationId'=>'1234567890123'}}).paypageRegistrationId)
      assert_equal("12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012", CardPaypage.from_hash({'cardPaypage'=>{'paypageRegistrationId'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012'}}).paypageRegistrationId)
      exception = assert_raise(RuntimeError){
        CardPaypage.from_hash({ 'cardPaypage'=>{'paypageRegistrationId'=>'123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123'}})
      }
      assert_equal "If cardPaypage paypageRegistrationId is specified, it must be between 1 and 512 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        CardPaypage.from_hash({ 'cardPaypage'=>{}})
      }
      assert_equal "If cardPaypage is specified, it must have a paypageRegistrationId", exception.message            
    end

    def test_cardPaypage_expDate
      assert_equal(nil, CardPaypage.from_hash({'cardPaypage'=>{'paypageRegistrationId'=>'1'}}).expDate)
      assert_equal("abcd", CardPaypage.from_hash({'cardPaypage'=>{'expDate'=>'abcd','paypageRegistrationId'=>'1'}}).expDate)
      assert_equal("1234", CardPaypage.from_hash({'cardPaypage'=>{'expDate'=>'1234','paypageRegistrationId'=>'1'}}).expDate)
      exception = assert_raise(RuntimeError){
        CardPaypage.from_hash({ 'cardPaypage'=>{'expDate'=>'123','paypageRegistrationId'=>'1'}})
      }
      assert_equal "If cardPaypage expDate is specified, it must be between 4 and 4 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        CardPaypage.from_hash({ 'cardPaypage'=>{'expDate'=>'12345','paypageRegistrationId'=>'1'}})
      }
      assert_equal "If cardPaypage expDate is specified, it must be between 4 and 4 characters long", exception.message            
    end
    
    def test_cardPaypage_cardValidationNum
      assert_equal(nil, CardPaypage.from_hash({'cardPaypage'=>{'paypageRegistrationId'=>'1234567890123'}}).cardValidationNum)
      assert_equal("a", CardPaypage.from_hash({'cardPaypage'=>{'cardValidationNum'=>'a','paypageRegistrationId'=>'1234567890123'}}).cardValidationNum)
      assert_equal("1234", CardPaypage.from_hash({'cardPaypage'=>{'cardValidationNum'=>'1234','paypageRegistrationId'=>'1234567890123'}}).cardValidationNum)      
      exception = assert_raise(RuntimeError){
        CardPaypage.from_hash({ 'cardPaypage'=>{'cardValidationNum'=>'12345','paypageRegistrationId'=>'1234567890123'}})
      }
      assert_equal "If cardPaypage cardValidationNum is specified, it must be between 1 and 4 characters long", exception.message                  
    end
    
    def test_cardPaypage_mop
      assert_equal(nil, CardPaypage.from_hash({'cardPaypage'=>{'paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("MC", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'MC','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("VI", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'VI','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("AX", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'AX','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("DC", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'DC','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("DI", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'DI','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("PP", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'PP','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("JC", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'JC','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("BL", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'BL','paypageRegistrationId'=>'1234567890123'}}).mop)
      assert_equal("EC", CardPaypage.from_hash({'cardPaypage'=>{'type'=>'EC','paypageRegistrationId'=>'1234567890123'}}).mop)
      exception = assert_raise(RuntimeError){
        CardPaypage.from_hash({ 'cardPaypage'=>{'type'=>'ZZ','paypageRegistrationId'=>'1234567890123'}})
      }
      assert_equal "If cardPaypage type is specified, it must be in [\"\", \"MC\", \"VI\", \"AX\", \"DC\", \"DI\", \"PP\", \"JC\", \"BL\", \"EC\"]", exception.message
    end
    
    def test_payPal_payerId
      assert_equal("a", PayPal.from_hash({'payPal'=>{'payerId'=>'a','transactionId'=>'b'}}).payerId)
      assert_equal("1234567890123", PayPal.from_hash({'payPal'=>{'payerId'=>'1234567890123','transactionId'=>'b'}}).payerId)
      assert_equal("123", PayPal.from_hash({'payPal'=>{'payerId'=>'123','transactionId'=>'b'}}).payerId)
      exception = assert_raise(RuntimeError){
        PayPal.from_hash({ 'payPal'=>{'transactionId'=>'b'}})
      }
      assert_equal "If payPal is specified, it must have a payerId", exception.message            
    end
    
    def test_payPal_token
      assert_equal(nil, PayPal.from_hash({'payPal'=>{'payerId'=>'1','transactionId'=>'b'}}).token)
      assert_equal("a", PayPal.from_hash({'payPal'=>{'payerId'=>'1','transactionId'=>'b','token'=>'a'}}).token)
      assert_equal("1234567890123", PayPal.from_hash({'payPal'=>{'payerId'=>'1','transactionId'=>'b','token'=>'1234567890123'}}).token)
      assert_equal("123", PayPal.from_hash({'payPal'=>{'payerId'=>'1','transactionId'=>'b','token'=>'123'}}).token)
    end
    
    def test_payPal_transactionId
      assert_equal("b", PayPal.from_hash({'payPal'=>{'payerId'=>'a','transactionId'=>'b'}}).transactionId)
      exception = assert_raise(RuntimeError){
        PayPal.from_hash({ 'payPal'=>{'payerId'=>'a'}})
      }
      assert_equal "If payPal is specified, it must have a transactionId", exception.message            
    end

    def test_creditPaypal_payerId
      assert_equal(nil, CreditPayPal.from_hash({'creditPaypal'=>{'payerEmail'=>'b'}}).payerId)
      assert_equal("a", CreditPayPal.from_hash({'creditPaypal'=>{'payerId'=>'a','payerEmail'=>'b'}}).payerId)
      assert_equal("12345678901234567", CreditPayPal.from_hash({'creditPaypal'=>{'payerId'=>'12345678901234567','payerEmail'=>'b'}}).payerId)
      assert_equal("123", CreditPayPal.from_hash({'creditPaypal'=>{'payerId'=>'123','payerEmail'=>'b'}}).payerId)
      exception = assert_raise(RuntimeError){
        CreditPayPal.from_hash({ 'creditPaypal'=>{'payerId'=>'123456789012345678','payerEmail'=>'b'}})
      }
      assert_equal "If creditPaypal payerId is specified, it must be between 1 and 17 characters long", exception.message                  
    end
    
    def test_creditPaypal_payerEmail
      assert_equal(nil, CreditPayPal.from_hash({'creditPaypal'=>{'payerId'=>'a'}}).payerEmail)
      assert_equal("b", CreditPayPal.from_hash({'creditPaypal'=>{'payerId'=>'a','payerEmail'=>'b'}}).payerEmail)
      assert_equal("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567", CreditPayPal.from_hash({'creditPaypal'=>{'payerId'=>'12345678901234567','payerEmail'=>'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567'}}).payerEmail)
      exception = assert_raise(RuntimeError){
        CreditPayPal.from_hash({ 'creditPaypal'=>{'payerId'=>'1','payerEmail'=>'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678'}})
      }
      assert_equal "If creditPaypal payerEmail is specified, it must be between 1 and 127 characters long", exception.message                  
    end

    def test_customBilling_phone
      assert_equal(nil, CustomBilling.from_hash({'customBilling'=>{}}).phone)
      assert_equal("1", CustomBilling.from_hash({'customBilling'=>{'phone'=>'1'}}).phone)
      assert_equal("1234567890123", CustomBilling.from_hash({'customBilling'=>{'phone'=>'1234567890123'}}).phone)      
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'phone'=>'12345678901234'}})
      }
      assert_equal "If customBilling phone is specified, it must match the regular expression /\\A\\d{1,13}\\Z/", exception.message                  
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'phone'=>'abc'}})
      }
      assert_equal "If customBilling phone is specified, it must match the regular expression /\\A\\d{1,13}\\Z/", exception.message                  
    end

    def test_customBilling_city
      assert_equal(nil, CustomBilling.from_hash({'customBilling'=>{}}).city)
      assert_equal("a", CustomBilling.from_hash({'customBilling'=>{'city'=>'a'}}).city)
      assert_equal("12345678901234567890123456789012345", CustomBilling.from_hash({'customBilling'=>{'city'=>'12345678901234567890123456789012345'}}).city)      
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'city'=>'123456789012345678901234567890123456'}})
      }
      assert_equal "If customBilling city is specified, it must be between 1 and 35 characters long", exception.message
    end
    
    def test_customBilling_url
      assert_equal(nil, CustomBilling.from_hash({'customBilling'=>{}}).url)
      assert_equal("1", CustomBilling.from_hash({'customBilling'=>{'url'=>'1'}}).url)
      assert_equal("1234567890123", CustomBilling.from_hash({'customBilling'=>{'url'=>'1234567890123'}}).url)      
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'url'=>'12345678901234'}})
      }
      assert_equal "If customBilling url is specified, it must match the regular expression /\\A([A-Z,a-z,0-9,\\/,\\-,_,.]){1,13}\\Z/", exception.message                  
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'url'=>'^&*(%$#@'}})
      }
      assert_equal "If customBilling url is specified, it must match the regular expression /\\A([A-Z,a-z,0-9,\\/,\\-,_,.]){1,13}\\Z/", exception.message                  
    end
    
    def test_customBilling_descriptor
      assert_equal(nil, CustomBilling.from_hash({'customBilling'=>{}}).descriptor)
      assert_equal("abcd", CustomBilling.from_hash({'customBilling'=>{'descriptor'=>'abcd'}}).descriptor)
      assert_equal("1234567890123456789012345", CustomBilling.from_hash({'customBilling'=>{'descriptor'=>'1234567890123456789012345'}}).descriptor)      
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'descriptor'=>'12345678901234567890123456'}})
      }
      assert_equal "If customBilling descriptor is specified, it must match the regular expression /\\A([A-Z,a-z,0-9, ,\\*,,,\\-,',#,&,.]){4,25}\\Z/", exception.message                  
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'descriptor'=>'123'}})
      }
      assert_equal "If customBilling descriptor is specified, it must match the regular expression /\\A([A-Z,a-z,0-9, ,\\*,,,\\-,',#,&,.]){4,25}\\Z/", exception.message                  
      exception = assert_raise(RuntimeError){
        CustomBilling.from_hash({ 'customBilling'=>{'descriptor'=>'^&*(%$#@'}})
      }
      assert_equal "If customBilling descriptor is specified, it must match the regular expression /\\A([A-Z,a-z,0-9, ,\\*,,,\\-,',#,&,.]){4,25}\\Z/", exception.message                  
    end
    
    def test_processingInstructions_bypassVelocityCheck
      assert_equal(nil, ProcessingInstructions.from_hash({'processingInstructions'=>{}}).bypassVelocityCheck)
      assert_equal("true", ProcessingInstructions.from_hash({'processingInstructions'=>{'bypassVelocityCheck'=>'true'}}).bypassVelocityCheck)
      assert_equal("false", ProcessingInstructions.from_hash({'processingInstructions'=>{'bypassVelocityCheck'=>'false'}}).bypassVelocityCheck)
      assert_equal("1", ProcessingInstructions.from_hash({'processingInstructions'=>{'bypassVelocityCheck'=>'1'}}).bypassVelocityCheck)
      assert_equal("0", ProcessingInstructions.from_hash({'processingInstructions'=>{'bypassVelocityCheck'=>'0'}}).bypassVelocityCheck)
      exception = assert_raise(RuntimeError){
        ProcessingInstructions.from_hash({ 'processingInstructions'=>{'bypassVelocityCheck'=>'vrai' }}) #French true
      }
      assert_equal "If processingInstructions bypassVelocityCheck is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_echeckForToken_accNum
      assert_equal("a", EcheckForToken.from_hash({'echeckForToken'=>{'accNum'=>'a','routingNum'=>'123456789'}}).accNum)
      assert_equal("12345678901234567", EcheckForToken.from_hash({'echeckForToken'=>{'accNum'=>'12345678901234567','routingNum'=>'123456789'}}).accNum)
      exception = assert_raise(RuntimeError){
        EcheckForToken.from_hash({ 'echeckForToken'=>{'accNum'=>'123456789012345678','routingNum'=>'123456789'}})
      }
      assert_equal "If echeckForToken accNum is specified, it must be between 1 and 17 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckForToken.from_hash({ 'echeckForToken'=>{'routingNum'=>'123456789'}})
      }
      assert_equal "If echeckForToken is specified, it must have a accNum", exception.message            
    end
    
    def test_echeckForToken_routingNum
      assert_equal("123456789", EcheckForToken.from_hash({'echeckForToken'=>{'accNum'=>'1','routingNum'=>'123456789'}}).routingNum)
      assert_equal("abcdefghi", EcheckForToken.from_hash({'echeckForToken'=>{'accNum'=>'1','routingNum'=>'abcdefghi'}}).routingNum)
      exception = assert_raise(RuntimeError){
        EcheckForToken.from_hash({ 'echeckForToken'=>{'accNum'=>'1','routingNum'=>'12345678'}})
      }
      assert_equal "If echeckForToken routingNum is specified, it must be between 9 and 9 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckForToken.from_hash({ 'echeckForToken'=>{'accNum'=>'1','routingNum'=>'1234567890'}})
      }
      assert_equal "If echeckForToken routingNum is specified, it must be between 9 and 9 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckForToken.from_hash({ 'echeckForToken'=>{'accNum'=>'1'}})
      }
      assert_equal "If echeckForToken is specified, it must have a routingNum", exception.message            
    end
    
    def test_filtering_prepaid
      assert_equal(nil, Filtering.from_hash({'filtering'=>{}}).prepaid)
      assert_equal("true", Filtering.from_hash({'filtering'=>{'prepaid'=>'true'}}).prepaid)
      assert_equal("false", Filtering.from_hash({'filtering'=>{'prepaid'=>'false'}}).prepaid)
      assert_equal("1", Filtering.from_hash({'filtering'=>{'prepaid'=>'1'}}).prepaid)
      assert_equal("0", Filtering.from_hash({'filtering'=>{'prepaid'=>'0'}}).prepaid)
      exception = assert_raise(RuntimeError){
        Filtering.from_hash({ 'filtering'=>{'prepaid'=>'vrai' }}) #French true
      }
      assert_equal "If filtering prepaid is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_filtering_international
      assert_equal(nil, Filtering.from_hash({'filtering'=>{}}).international)
      assert_equal("true", Filtering.from_hash({'filtering'=>{'international'=>'true'}}).international)
      assert_equal("false", Filtering.from_hash({'filtering'=>{'international'=>'false'}}).international)
      assert_equal("1", Filtering.from_hash({'filtering'=>{'international'=>'1'}}).international)
      assert_equal("0", Filtering.from_hash({'filtering'=>{'international'=>'0'}}).international)
      exception = assert_raise(RuntimeError){
        Filtering.from_hash({ 'filtering'=>{'international'=>'vrai' }}) #French true
      }
      assert_equal "If filtering international is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_filtering_chargeback
      assert_equal(nil, Filtering.from_hash({'filtering'=>{}}).chargeback)
      assert_equal("true", Filtering.from_hash({'filtering'=>{'chargeback'=>'true'}}).chargeback)
      assert_equal("false", Filtering.from_hash({'filtering'=>{'chargeback'=>'false'}}).chargeback)
      assert_equal("1", Filtering.from_hash({'filtering'=>{'chargeback'=>'1'}}).chargeback)
      assert_equal("0", Filtering.from_hash({'filtering'=>{'chargeback'=>'0'}}).chargeback)
      exception = assert_raise(RuntimeError){
        Filtering.from_hash({ 'filtering'=>{'chargeback'=>'vrai' }}) #French true
      }
      assert_equal "If filtering chargeback is specified, it must be in [\"true\", \"false\", \"1\", \"0\"]", exception.message
    end
    
    def test_merchantData_campaign
      assert_equal(nil, MerchantData.from_hash({'merchantData'=>{}}).campaign)
      assert_equal("a", MerchantData.from_hash({'merchantData'=>{'campaign'=>'a'}}).campaign)
      assert_equal("1234567890123456789012345", MerchantData.from_hash({'merchantData'=>{'campaign'=>'1234567890123456789012345'}}).campaign)      
      exception = assert_raise(RuntimeError){
        MerchantData.from_hash({ 'merchantData'=>{'campaign'=>'12345678901234567890123456'}})
      }
      assert_equal "If merchantData campaign is specified, it must be between 1 and 25 characters long", exception.message
    end
    
    def test_merchantData_affiliate
      assert_equal(nil, MerchantData.from_hash({'merchantData'=>{}}).affiliate)
      assert_equal("a", MerchantData.from_hash({'merchantData'=>{'affiliate'=>'a'}}).affiliate)
      assert_equal("1234567890123456789012345", MerchantData.from_hash({'merchantData'=>{'affiliate'=>'1234567890123456789012345'}}).affiliate)      
      exception = assert_raise(RuntimeError){
        MerchantData.from_hash({ 'merchantData'=>{'affiliate'=>'12345678901234567890123456'}})
      }
      assert_equal "If merchantData affiliate is specified, it must be between 1 and 25 characters long", exception.message
    end
    
    def test_merchantData_merchantGroupingId
      assert_equal(nil, MerchantData.from_hash({'merchantData'=>{}}).merchantGroupingId)
      assert_equal("a", MerchantData.from_hash({'merchantData'=>{'merchantGroupingId'=>'a'}}).merchantGroupingId)
      assert_equal("1234567890123456789012345", MerchantData.from_hash({'merchantData'=>{'merchantGroupingId'=>'1234567890123456789012345'}}).merchantGroupingId)      
      exception = assert_raise(RuntimeError){
        MerchantData.from_hash({ 'merchantData'=>{'merchantGroupingId'=>'12345678901234567890123456'}})
      }
      assert_equal "If merchantData merchantGroupingId is specified, it must be between 1 and 25 characters long", exception.message
    end
    
    def test_echeck_accType
      assert_equal("Checking", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'2','routingNum'=>'123456789'}}).accType)
      assert_equal("Savings", Echeck.from_hash({'echeck'=>{'accType'=>'Savings','accNum'=>'2','routingNum'=>'123456789'}}).accType)
      assert_equal("Corporate", Echeck.from_hash({'echeck'=>{'accType'=>'Corporate','accNum'=>'2','routingNum'=>'123456789'}}).accType)
      assert_equal("Corp Savings", Echeck.from_hash({'echeck'=>{'accType'=>'Corp Savings','accNum'=>'2','routingNum'=>'123456789'}}).accType)
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'1','routingNum'=>'123456789'}})
      }
      assert_equal "If echeck is specified, it must have a accType", exception.message            
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'1','routingNum'=>'123456789','accType'=>'Other'}})
      }
      assert_equal "If echeck accType is specified, it must be in [\"Checking\", \"Savings\", \"Corporate\", \"Corp Savings\"]", exception.message            
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'1','routingNum'=>'123456789'}})
      }
      assert_equal "If echeck is specified, it must have a accType", exception.message            
    end
    
    def test_echeck_accNum
      assert_equal("a", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'a','routingNum'=>'123456789'}}).accNum)
      assert_equal("12345678901234567", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'12345678901234567','routingNum'=>'123456789'}}).accNum)
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'123456789012345678','routingNum'=>'123456789','accType'=>'Checking'}})
      }
      assert_equal "If echeck accNum is specified, it must be between 1 and 17 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'routingNum'=>'123456789','accType'=>'Checking'}})
      }
      assert_equal "If echeck is specified, it must have a accNum", exception.message            
    end
    
    def test_echeck_routingNum
      assert_equal("abcdefghi", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'a','routingNum'=>'abcdefghi'}}).routingNum)
      assert_equal("123456789", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'12345678901234567','routingNum'=>'123456789'}}).routingNum)
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'123','routingNum'=>'1234567890','accType'=>'Checking'}})
      }
      assert_equal "If echeck routingNum is specified, it must be between 9 and 9 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'123','routingNum'=>'12345678','accType'=>'Checking'}})
      }
      assert_equal "If echeck routingNum is specified, it must be between 9 and 9 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'123','accType'=>'Checking'}})
      }
      assert_equal "If echeck is specified, it must have a routingNum", exception.message            
    end
    
    def test_echeck_checkNum
      assert_equal(nil, Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'b','routingNum'=>'abcdefghi'}}).checkNum)
      assert_equal("a", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'b','routingNum'=>'abcdefghi','checkNum'=>'a'}}).checkNum)
      assert_equal("123456789012345", Echeck.from_hash({'echeck'=>{'accType'=>'Checking','accNum'=>'12345678901234567','routingNum'=>'123456789','checkNum'=>'123456789012345'}}).checkNum)
      exception = assert_raise(RuntimeError){
        Echeck.from_hash({ 'echeck'=>{'accNum'=>'123','routingNum'=>'123456789','accType'=>'Checking','checkNum'=>'1234567890123456'}})
      }
      assert_equal "If echeck checkNum is specified, it must be between 1 and 15 characters long", exception.message            
    end
    
    def test_echeckToken_litleToken
      assert_equal("abcdefhijklmn", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'abcdefhijklmn','routingNum'=>'123456789'}}).litleToken)
      assert_equal("1234567890123456789012345", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123456789012345','routingNum'=>'123456789'}}).litleToken)
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'123456789012','routingNum'=>'123456789','accType'=>'Checking'}})
      }
      assert_equal "If echeckToken litleToken is specified, it must be between 13 and 25 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'12345678901234567890123456','routingNum'=>'123456789','accType'=>'Checking'}})
      }
      assert_equal "If echeckToken litleToken is specified, it must be between 13 and 25 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'routingNum'=>'123456789','accType'=>'Checking'}})
      }
      assert_equal "If echeckToken is specified, it must have a litleToken", exception.message            
    end
    
    def test_echeckToken_routingNum
      assert_equal("abcdefghi", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123','routingNum'=>'abcdefghi'}}).routingNum)
      assert_equal("123456789", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123','routingNum'=>'123456789'}}).routingNum)
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'1234567890123','routingNum'=>'1234567890','accType'=>'Checking'}})
      }
      assert_equal "If echeckToken routingNum is specified, it must be between 9 and 9 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'1234567890123','routingNum'=>'12345678','accType'=>'Checking'}})
      }
      assert_equal "If echeckToken routingNum is specified, it must be between 9 and 9 characters long", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'1234567890123','accType'=>'Checking'}})
      }
      assert_equal "If echeckToken is specified, it must have a routingNum", exception.message            
    end
    
    def test_echeckToken_accType
      assert_equal("Checking", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123','routingNum'=>'123456789'}}).accType)
      assert_equal("Savings", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Savings','litleToken'=>'1234567890123','routingNum'=>'123456789'}}).accType)
      assert_equal("Corporate", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Corporate','litleToken'=>'1234567890123','routingNum'=>'123456789'}}).accType)
      assert_equal("Corp Savings", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Corp Savings','litleToken'=>'1234567890123','routingNum'=>'123456789'}}).accType)
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'1234567890123','routingNum'=>'123456789','accType'=>'Other'}})
      }
      assert_equal "If echeckToken accType is specified, it must be in [\"Checking\", \"Savings\", \"Corporate\", \"Corp Savings\"]", exception.message            
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'1234567890123','routingNum'=>'123456789'}})
      }
      assert_equal "If echeckToken is specified, it must have a accType", exception.message            
    end
    
    def test_echeckToken_checkNum
      assert_equal(nil, EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123','routingNum'=>'abcdefghi'}}).checkNum)
      assert_equal("a", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123','routingNum'=>'abcdefghi','checkNum'=>'a'}}).checkNum)
      assert_equal("123456789012345", EcheckToken.from_hash({'echeckToken'=>{'accType'=>'Checking','litleToken'=>'1234567890123','routingNum'=>'123456789','checkNum'=>'123456789012345'}}).checkNum)
      exception = assert_raise(RuntimeError){
        EcheckToken.from_hash({ 'echeckToken'=>{'litleToken'=>'1234567890123','routingNum'=>'123456789','accType'=>'Checking','checkNum'=>'1234567890123456'}})
      }
      assert_equal "If echeckToken checkNum is specified, it must be between 1 and 15 characters long", exception.message            
    end
    
    def test_recyclingRequest_recycleBy
      assert_equal(nil, RecyclingRequest.from_hash({'recyclingRequest'=>{}}).recycleBy)
      assert_equal("Merchant", RecyclingRequest.from_hash({'recyclingRequest'=>{'recycleBy'=>'Merchant'}}).recycleBy)
      assert_equal("Litle", RecyclingRequest.from_hash({'recyclingRequest'=>{'recycleBy'=>'Litle'}}).recycleBy)
      assert_equal("None", RecyclingRequest.from_hash({'recyclingRequest'=>{'recycleBy'=>'None'}}).recycleBy)
      exception = assert_raise(RuntimeError){
        RecyclingRequest.from_hash({ 'recyclingRequest'=>{'recycleBy'=>'Other' }})
      }
      assert_equal "If recyclingRequest recycleBy is specified, it must be in [\"Merchant\", \"Litle\", \"None\"]", exception.message
    end
    
    def test_recyclingRequest_recycleId
      assert_equal(nil, RecyclingRequest.from_hash({'recyclingRequest'=>{}}).recycleId)
      assert_equal("a", RecyclingRequest.from_hash({'recyclingRequest'=>{'recycleId'=>'a'}}).recycleId)
      assert_equal("1234567890123456789012345", RecyclingRequest.from_hash({'recyclingRequest'=>{'recycleId'=>'1234567890123456789012345'}}).recycleId)
      exception = assert_raise(RuntimeError){
        RecyclingRequest.from_hash({ 'recyclingRequest'=>{'recycleId'=>'12345678901234567890123456' }})
      }
      assert_equal "If recyclingRequest recycleId is specified, it must be between 1 and 25 characters long", exception.message
    end

    def test_subscription_type
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'recurringRequest'=> {
		'subscription'=>
		{
		'planCode'=>'planCodeString',
		'numberOfPayments'=>'10',
		'startDate'=>'2014-03-07',
		'amount'=>'100'
		}
           }
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<subscription>.*<planCode>planCodeString<\/planCode><numberOfPayments>10<\/numberOfPayments><startDate>2014-03-07<\/startDate><amount>100<\/amount><\/subscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end

    def test_subscription_type_discount_addOn
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'recurringRequest'=> {
		'subscription'=>
		{
		'planCode'=>'planCodeString',
		'numberOfPayments'=>'10',
		'startDate'=>'2014-03-07',
		'amount'=>'100',
                'createDiscount'=>[
             	 {
               'discountCode'=>'discCode1',
               'name'=>'name1',
               'amount'=>'500',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
             	 },
             	 {
               'discountCode'=>'discCode11',
               'name'=>'name11',
               'amount'=>'5000',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              	 }],
                'createAddOn'=>[
             	 {
               'addOnCode'=>'addOnCode1',
               'name'=>'name1',
               'amount'=>'500',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
             	 }]
	       }
           }
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<subscription>.*<planCode>planCodeString<\/planCode><numberOfPayments>10<\/numberOfPayments><startDate>2014-03-07<\/startDate><amount>100<\/amount><createDiscount><discountCode>discCode1<\/discountCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><createDiscount><discountCode>discCode11<\/discountCode><name>name11<\/name><amount>5000<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><createAddOn><addOnCode>addOnCode1<\/addOnCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createAddOn><\/subscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end
    
    def test_cancel_subscription
      hash = {
              'merchantId' => '101',
              'version'=>'8.8',
              'reportGroup'=>'Planets',
              'subscriptionId' => '1000'
             }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<cancelSubscription><subscriptionId>1000<\/subscriptionId><\/cancelSubscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.cancel_subscription(hash)
    end

    def test_update_subscription_card
      hash = {
              'merchantId' => '101',
              'version'=>'8.8',
              'reportGroup'=>'Planets',
              'subscriptionId' => '1000',
              'planCode' => 'planCodeString',
              'billToAddress' =>  
                {
                 'name' =>'nameString'               
                },
              'card'=>
                {  
                 'type'=>'VI',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                },
              'billingDate' =>'2014-03-11',
              'createDiscount'=>[
              {
               'discountCode'=>'discCode1',
               'name'=>'name1',
               'amount'=>'500',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              },
              {
               'discountCode'=>'discCode11',
               'name'=>'name11',
               'amount'=>'5000',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              }],
              'updateDiscount'=>[
              {
		'discountCode'=>'discCode2',
              }],
              'deleteDiscount'=>[{'discountCode'=>'discCode3'},{'discountCode'=>'discCode33'}],
              'createAddOn'=>[
              {
               'addOnCode'=>'addOnCode1',
               'name'=>'name1',
               'amount'=>'500',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              }],
              'updateAddOn'=>[
              {
		'addOnCode'=>'addOnCode2',
              }],
             }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<updateSubscription><subscriptionId>1000<\/subscriptionId><planCode>planCodeString<\/planCode><billToAddress><name>nameString<\/name><\/billToAddress><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><billingDate>2014-03-11<\/billingDate><createDiscount><discountCode>discCode1<\/discountCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><createDiscount><discountCode>discCode11<\/discountCode><name>name11<\/name><amount>5000<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><updateDiscount><discountCode>discCode2<\/discountCode><\/updateDiscount><deleteDiscount><discountCode>discCode3<\/discountCode><\/deleteDiscount><deleteDiscount><discountCode>discCode33<\/discountCode><\/deleteDiscount><createAddOn><addOnCode>addOnCode1<\/addOnCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createAddOn><updateAddOn><addOnCode>addOnCode2<\/addOnCode><\/updateAddOn><\/updateSubscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_subscription(hash)
    end

    def test_update_subscription_token
      hash = {
              'merchantId' => '101',
              'version'=>'8.8',
              'reportGroup'=>'Planets',
              'subscriptionId' => '1000',
              'planCode' => 'planCodeString',
              'billToAddress' =>  
                {
                 'name' =>'nameString'               
                },
              'token'=>
                {  
		'litleToken'=>'litleTokenString'
                },
              'billingDate' =>'2014-03-11',
              'createDiscount'=>[
              {
               'discountCode'=>'discCode1',
               'name'=>'name1',
               'amount'=>'500',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              },
              {
               'discountCode'=>'discCode11',
               'name'=>'name11',
               'amount'=>'5000',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              }],
              'updateDiscount'=>[
              {
		'discountCode'=>'discCode2',
              }],
              'createAddOn'=>[
              {
               'addOnCode'=>'addOnCode1',
               'name'=>'name1',
               'amount'=>'500',
               'startDate'=>'2014-03-12',
               'endDate'=>'2014-03-12',
              }],
              'updateAddOn'=>[
              {
		'addOnCode'=>'addOnCode2',
              }],
              'deleteAddOn'=>[{'addOnCode'=>'addOnCode3'}]
             }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<updateSubscription><subscriptionId>1000<\/subscriptionId><planCode>planCodeString<\/planCode><billToAddress><name>nameString<\/name><\/billToAddress><token><litleToken>litleTokenString<\/litleToken><\/token><billingDate>2014-03-11<\/billingDate><createDiscount><discountCode>discCode1<\/discountCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><createDiscount><discountCode>discCode11<\/discountCode><name>name11<\/name><amount>5000<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><updateDiscount><discountCode>discCode2<\/discountCode><\/updateDiscount><createAddOn><addOnCode>addOnCode1<\/addOnCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createAddOn><updateAddOn><addOnCode>addOnCode2<\/addOnCode><\/updateAddOn><deleteAddOn><addOnCode>addOnCode3<\/addOnCode><\/deleteAddOn><\/updateSubscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_subscription(hash)
    end

    def test_activate
       hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' => '11',
        'amount'  => '500',
        'orderSource'=>'ecommerce',
        'card'=>
                {  
                 'type'=>'VI',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                }
      }
      
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<activate reportGroup="Planets"><orderId>11<\/orderId><amount>500<\/amount><orderSource>ecommerce<\/orderSource><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><\/activate>.*/m), is_a(Hash))
      LitleOnlineRequest.new.activate(hash)
    end

    def test_deactivate
       hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' => '11',
        'orderSource'=>'ecommerce',
        'card'=>
                {  
                 'type'=>'VI',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                }
      }
      
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<deactivate reportGroup="Planets"><orderId>11<\/orderId><orderSource>ecommerce<\/orderSource><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><\/deactivate>.*/m), is_a(Hash))
      LitleOnlineRequest.new.deactivate(hash)
    end

    def test_load
       hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' => '11',
        'amount'  => '500',
        'orderSource'=>'ecommerce',
        'card'=>
                {  
                 'type'=>'VI',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                }
      }
      
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<load reportGroup="Planets"><orderId>11<\/orderId><amount>500<\/amount><orderSource>ecommerce<\/orderSource><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><\/load>.*/m), is_a(Hash))
      LitleOnlineRequest.new.load_request(hash)
    end

    def test_unload
       hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' => '11',
        'amount'  => '500',
        'orderSource'=>'ecommerce',
        'card'=>
                {  
                 'type'=>'VI',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                }
      }
      
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<unload reportGroup="Planets"><orderId>11<\/orderId><amount>500<\/amount><orderSource>ecommerce<\/orderSource><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><\/unload>.*/m), is_a(Hash))
      LitleOnlineRequest.new.unload_request(hash)
    end

    def test_balanceInquiry
       hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId' => '11',
        'orderSource'=>'ecommerce',
        'card'=>
                {  
                 'type'=>'VI',
                 'number' =>'4100000000000001',
                 'expDate' =>'1210'
                }
      }
      
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<balanceInquiry reportGroup="Planets"><orderId>11<\/orderId><orderSource>ecommerce<\/orderSource><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><\/balanceInquiry>.*/m), is_a(Hash))
      LitleOnlineRequest.new.balance_inquiry(hash)
    end

    def test_createPlan
      hash ={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'planCode'=>'planCodeString',
        'name'=>'nameString',
        'description'=>'descriptionString',
        'intervalType'=>'ANNUAL',
        'amount'=>'500',
        'numberOfPayments'=>'2',
        'trialNumberOfIntervals'=>'1',
        'trialIntervalType'=>'MONTH',
        'active'=>'true'  
            }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<createPlan><planCode>planCodeString<\/planCode><name>nameString<\/name><description>descriptionString<\/description><intervalType>ANNUAL<\/intervalType><amount>500<\/amount><numberOfPayments>2<\/numberOfPayments><trialNumberOfIntervals>1<\/trialNumberOfIntervals><trialIntervalType>MONTH<\/trialIntervalType><active>true<\/active><\/createPlan>.*/m), is_a(Hash))
      LitleOnlineRequest.new.create_plan(hash)
    end

    def test_updatePlan
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'planCode'=>'planCodeString',
        'active'=>'true'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<updatePlan><planCode>planCodeString<\/planCode><active>true<\/active><\/updatePlan>.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_plan(hash)
    end	

    def test_virtualGiftCard
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'accountNumberLength'=>'13',
        'giftCardBin'=>'giftCardBinString'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<virtualGiftCard><accountNumberLength>13<\/accountNumberLength><giftCardBin>giftCardBinString<\/giftCardBin><\/virtualGiftCard>.*/m), is_a(Hash))
      LitleOnlineRequest.new.virtual_giftcard(hash)
    end	

    def test_activateReversal
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'111'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<activateReversal reportGroup="Planets"><litleTxnId>111<\/litleTxnId><\/activateReversal>.*/m), is_a(Hash))
      LitleOnlineRequest.new.activate_reversal(hash)
    end

    def test_depositReversal
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'111'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<depositReversal reportGroup="Planets"><litleTxnId>111<\/litleTxnId><\/depositReversal>.*/m), is_a(Hash))
      LitleOnlineRequest.new.deposit_reversal(hash)
    end		

    def test_refundReversal
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'111'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<refundReversal reportGroup="Planets"><litleTxnId>111<\/litleTxnId><\/refundReversal>.*/m), is_a(Hash))
      LitleOnlineRequest.new.refund_reversal(hash)
    end		

    def test_deactivateReversal
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'111'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<deactivateReversal reportGroup="Planets"><litleTxnId>111<\/litleTxnId><\/deactivateReversal>.*/m), is_a(Hash))
      LitleOnlineRequest.new.deactivate_reversal(hash)
    end		

    def test_loadReversal
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'111'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<loadReversal reportGroup="Planets"><litleTxnId>111<\/litleTxnId><\/loadReversal>.*/m), is_a(Hash))
      LitleOnlineRequest.new.load_reversal(hash)
    end		

    def test_unloadReversal
      hash={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'111'
           }

      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<unloadReversal reportGroup="Planets"><litleTxnId>111<\/litleTxnId><\/unloadReversal>.*/m), is_a(Hash))
      LitleOnlineRequest.new.unload_reversal(hash)
    end	

    def test_mpos_type
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'mpos'=>
		{
		'ksn'=>'ksnString',
		'formatId'=>'30',
		'encryptedTrack'=>'encryptedTrackString',
		'track1Status'=>'0',
		'track2Status'=>'0'
		}
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<mpos><ksn>ksnString<\/ksn><formatId>30<\/formatId><encryptedTrack>encryptedTrackString<\/encryptedTrack><track1Status>0<\/track1Status><track2Status>0<\/track2Status><\/mpos>.*/m), is_a(Hash))
      LitleOnlineRequest.new.authorization(hash)
    end	
  end
end
