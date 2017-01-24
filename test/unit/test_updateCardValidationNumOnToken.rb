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
  class TestUpdateCardValidationNumOnToken < Test::Unit::TestCase
    def test_simple
      hash = {
        'orderId'=>'12344',
        'litleToken'=>'1233456789101112',
        'cardValidationNum'=>'123'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<orderId>1.*<litleToken>1233456789101112.*<cardValidationNum>123.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_card_validation_num_on_token(hash)
    end
    
    def test_order_id_is_optional
      hash = {
        'litleToken'=>'1233456789101112',
        'cardValidationNum'=>'123'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<litleToken>1233456789101112.*<cardValidationNum>123.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_card_validation_num_on_token(hash)
    end
    
    def test_litle_token_is_required
      hash = {
        'orderId'=>'12344',
        'cardValidationNum'=>'123'
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.update_card_validation_num_on_token(hash)}
      assert_match /If updateCardValidationNumOnToken is specified, it must have a litleToken/, exception.message
    end
    
    def test_card_validation_num_is_required
      hash = {
        'orderId'=>'12344',
        'litleToken'=>'1233456789101112'
      }
      exception = assert_raise(RuntimeError){LitleOnlineRequest.new.update_card_validation_num_on_token(hash)}
      assert_match /If updateCardValidationNumOnToken is specified, it must have a cardValidationNum/, exception.message
    end

    def test_logged_in_user
      hash = {
      	'loggedInUser' => 'gdake',
      	'merchantSdk' => 'Ruby;8.14.0',
        'orderId'=>'12344',
        'litleToken'=>'1233456789101112',
        'cardValidationNum'=>'123'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      LitleOnlineRequest.new.update_card_validation_num_on_token(hash)
    end
  end

end