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
require File.expand_path("../../../lib/LitleOnline",__FILE__)
require 'test/unit'

module LitleOnline
  class TestSale < Test::Unit::TestCase
    def test_simple_sale_with_paypal
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'paypal'=>{
        'payerId'=>'1234',
        'token'=>'1234',
        'transactionId'=>'123456'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal 'Valid Format', response.message
    end

    def test_simple_sale_with_applepay_and_secondaryAmount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'110',
        'secondaryAmount'=>'50',
        'orderSource'=>'ecommerce',
        'applepay'=>{
        'data'=>'1234',
        'header'=>{
        'applicationData'=>'454657413164',
        'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        'transactionId'=>'1234'
        },
        'signature' =>'1',
        'version'=>'1.0.0'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('Insufficient Funds', response.saleResponse.message)
      assert_equal('110', response.saleResponse.applepayResponse.transactionAmount)
    end

    def test_illegal_order_source
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecomerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end

    def test_no_report_group
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

    def test_fields_out_of_order
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'orderSource'=>'ecommerce',
        'litleTxnId'=>'123456',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        },
        'reportGroup'=>'Planets',
        'orderId'=>'12344'
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

    def test_invalid_field
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'NOexistantField' => 'ShouldNotCauseError',
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

    def test_simple_sale_with_card
      hash = {
        'merchantId'=>'101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

    def test_no_order_id
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end

    def test_no_amount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end

    def test_no_order_source
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      response= LitleOnlineRequest.new.sale(hash)
      assert(response.message =~ /Error validating xml data against the schema/)
    end

    def test_simple_sale_with_mpos
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'mpos'=>
        {
        'ksn'=>'ksnString',
        'formatId'=>'30',
        'encryptedTrack'=>'encryptedTrackString',
        'track1Status'=>'0',
        'track2Status'=>'0'
        }
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

    def test_simple_sale_with_processingType
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'MC',
        'number' =>'5400000000000000',
        'expDate' =>'1210'
        },
        'processingType'=>'initialInstallment'
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

    def test_simple_sale_with_originalNetworkTransactionId_originalTransactionAmount
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'MC',
        'number' =>'5400700000000000',
        'expDate' =>'1210'
        },
        'originalNetworkTransactionId'=>'98765432109876543210',
        'originalTransactionAmount'=>'7001'
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end
    
    def test_simple_sale_with_networkTxnId_response_cardSuffix_response
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'VI',
        'number' =>'4100700000000000',
        'expDate' =>'1210',
        'pin'=>'1111'
        },
        'originalNetworkTransactionId'=>'98765432109876543210',
        'originalTransactionAmount'=>'7001'
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
      assert_equal('123456', response.saleResponse.cardSuffix)
      assert_equal('63225578415568556365452427825', response.saleResponse.networkTransactionId)
    end
    
    def test_simple_sale_with_Wallet_Visa
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'VI',
        'number' =>'4100700000000000',
        'expDate' =>'1210',
        },
        'wallet'=>{
          'walletSourceType'=>'VisaCheckout',
          'walletSourceTypeId'=>'VCIND'
        }
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
      assert_equal('123456', response.saleResponse.cardSuffix)
      assert_equal('63225578415568556365452427825', response.saleResponse.networkTransactionId)
    end

    def test_simple_sale_with_Wallet_Mastercard
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>
        {
        'type'=>'MC',
        'number' =>'5400000000000000',
        'expDate' =>'1210',
        },
        'wallet'=>{
          'walletSourceType'=>'MasterPass',
          'walletSourceTypeId'=>'MasterPass'
        }
      }
      response= LitleOnlineRequest.new.sale(hash)
      assert_equal('000', response.saleResponse.response)
    end

  end
end
