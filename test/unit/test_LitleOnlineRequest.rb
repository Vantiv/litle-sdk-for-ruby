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
require 'test/unit'
require 'mocha'

class Newtest < Test::Unit::TestCase
  def test_set_merchant_id
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}})
    litle = LitleOnlineRequest.new
    assert_equal '2', litle.send(:get_merchant_id, {'merchantId'=>'2'})
    assert_equal '1', litle.send(:get_merchant_id, {'NotMerchantId'=>'2'})
  end

  def test_simple
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash = {
      'reportGroup'=>'Planets',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}

    Communications.expects(:http_post).with(regexp_matches(/<litleOnlineRequest .*/m),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.authorization(hash)
  end

  def test_authorization_missing_attributes
    hash={
      'reportGroup'=>'Planets',
      'amount'=>'106',

      'orderSource'=>'ecommerce',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}

    exception = assert_raise(RuntimeError){LitleOnlineRequest.new.authorization(hash)}
    assert_match /Missing Required Field: orderId!!!!/, exception.message
  end

  def test_authorization_attributes
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'reportGroup'=>'Planets',
      'id' => '003',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}

    Communications.expects(:http_post).with(regexp_matches(/.*<authorization id="003" reportGroup="Planets".*/m),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.authorization(hash)
  end

  def test_authorization_elements
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'reportGroup'=>'Planets',
      'id' => '004',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}

    Communications.expects(:http_post).with(regexp_matches(/.*<authorization.*<orderId>12344.*<amount>106.*<orderSource>ecommerce.*/m),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.authorization(hash)
  end

  def test_authorization_card_field
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'reportGroup'=>'Planets',
      'id' => '005',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}

    Communications.expects(:http_post).with(regexp_matches(/.*<authorization.*<card>.*<number>4100000000000001.*<expDate>1210.*/m),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.authorization(hash)
  end

  def test_sale_card_field
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'reportGroup'=>'Planets',
      'id' => '006',
      'orderId'=>'12344',
      'amount'=>'106',
      'orderSource'=>'ecommerce',
      'card'=>{
      'type'=>'VI',
      'number' =>'4100000000000001',
      'expDate' =>'1210'
      }}

    Communications.expects(:http_post).with(regexp_matches(/<litleOnlineRequest.*<sale.*<card>.*<number>4100000000000001.*<expDate>1210.*/m),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.sale(hash)
  end

  def test_capture_amountUnsetShouldNotBeInXML
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'id' => '006',
      'reportGroup'=>'Planets',
      'litleTxnId'=>'123456789012345678',
    }

    Communications.expects(:http_post).with(Not(regexp_matches(/.*amount.*/m)),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.capture(hash)
  end

  def test_force_capture_amountUnsetShouldNotBeInXML
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'id' => '006',
      'orderId'=>'12344',
      'reportGroup'=>'Planets',
      'orderSource'=>'ecommerce',
      'litleTxnId'=>'123456789012345678',
    }

    Communications.expects(:http_post).with(Not(regexp_matches(/.*amount.*/m)),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.forceCapture(hash)
  end

  def test_amount_is_not_required_in_echeck_credit
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'id' => '006',
      'orderId'=>'12344',
      'reportGroup'=>'Planets',
      'orderSource'=>'ecommerce',
      'litleTxnId'=>'123456789012345678',
    }

    Communications.expects(:http_post).with(Not(regexp_matches(/.*amount.*/m)),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.echeckCredit(hash)
  end

  def test_amount_is_not_required_in_echeck_sale
    Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
    hash={
      'id' => '006',
      'orderId'=>'12344',
      'reportGroup'=>'Planets',
      'orderSource'=>'ecommerce',
      'litleTxnId'=>'123456789012345678',
    }

    Communications.expects(:http_post).with(Not(regexp_matches(/.*amount.*/m)),kind_of(Hash))
    XMLObject.expects(:new)

    response = LitleOnlineRequest.new.echeckSale(hash)
  end

  def test_choice_between_card_token
    start_hash = {
      'orderId'=>'12344',
      'merchantId'=>'101',
      'reportGroup'=>'Planets',
      'amount'=>'101',
      'orderSource'=>'ecommerce'
    }

    card_only = {
      'card' => {
      'type' => 'VI',
      'number' => '1111222233334444'
      }
    }
    token_only = {
      'token'=> {
      'litleToken' => '1111222233334444'
      }
    }

    XMLObject.expects(:new)
    Communications.expects(:http_post).with(regexp_matches(/.*card.*/m))
    Communications.expects(:http_post).with(Not(regexp_matches(/.*token.*/m)),kind_of(Hash))
    LitleOnlineRequest.new.authorization(start_hash.merge(card_only))

    XMLObject.expects(:new)
    Communications.expects(:http_post).with(regexp_matches(/.*token.*/m))
    Communications.expects(:http_post).with(Not(regexp_matches(/.*card.*/m)),kind_of(Hash))
    LitleOnlineRequest.new.authorization(start_hash.merge(token_only))
  end

  def test_orderId_required
    start_hash = {
      #'orderId'=>'12344',
      'merchantId'=>'101',
      'reportGroup'=>'Planets',
      'amount'=>'101',
      'orderSource'=>'ecommerce',
      'card' => {
      'type' => 'VI',
      'number' => '1111222233334444'
      }
    }
    exception = assert_raise(RuntimeError) {LitleOnlineRequest.new.authorization(start_hash)}
    assert_match /Missing Required Field: orderId!!!!/, exception.message

    XMLObject.expects(:new)
    Communications.expects(:http_post).with(regexp_matches(/.*orderId.*/m),kind_of(Hash))
    assert_nothing_raised {LitleOnlineRequest.new.authorization(start_hash.merge({'orderId'=>'1234'}))}
  end

  def test_ssn_optional
    start_hash = {
      'orderId'=>'12344',
      'merchantId'=>'101',
      'reportGroup'=>'Planets',
      'amount'=>'101',
      'orderSource'=>'ecommerce',
      'card' => {
      'type' => 'VI',
      'number' => '1111222233334444'
      },
    }
    XMLObject.expects(:new)
    Communications.expects(:http_post).with(Not(regexp_matches(/.*ssn.*/m)),kind_of(Hash))
    assert_nothing_raised {LitleOnlineRequest.new.authorization(start_hash)}

    XMLObject.expects(:new)
    Communications.expects(:http_post).with(regexp_matches(/.*ssn.*/m),kind_of(Hash))
    assert_nothing_raised {LitleOnlineRequest.new.authorization(start_hash.merge({'customerInfo'=>{'ssn'=>'000112222'} }))}
  end

end
