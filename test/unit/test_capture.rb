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
  class Test_capture < Test::Unit::TestCase
    def test_success_capture
      hash = {
        'litleTxnId'=>'123456'
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<litleTxnId>123456<\/litleTxnId>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
    def test_logged_in_user
      hash = {
      	'merchantSdk' => 'Ruby;8.14.0',
        'litleTxnId'=>'123456',
        'loggedInUser'=>'gdake'
      }
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*(loggedInUser="gdake".*merchantSdk="Ruby;8.14.0")|(merchantSdk="Ruby;8.14.0".*loggedInUser="gdake").*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
    def test_surcharge_amount
      hash = {
        'litleTxnId' => '3',
        'amount' => '2',
        'surchargeAmount' => '1',
        'payPalNotes' => 'note',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><surchargeAmount>1<\/surchargeAmount><payPalNotes>note<\/payPalNotes>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
    
    def test_surcharge_amount_optional
      hash = {
        'litleTxnId' => '3',
        'amount' => '2',
        'payPalNotes' => 'note',
        'reportGroup' => 'Planets'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<amount>2<\/amount><payPalNotes>note<\/payPalNotes>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
    
     def test_pin
      hash = {
        'litleTxnId' => '123456000',
        'amount' => '2',
        'payPalNotes' => 'note',
        'pin' => '1234'
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<pin>1234<\/pin>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
    
    def test_custom_billing
      hash = {
        'payPalNotes'=>'Notes',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
        'customBilling'=>{
        'city' =>'boston',
        'descriptor' => 'card was present',
        }
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<customBilling><city>boston<\/city><descriptor>card was present<\/descriptor><\/customBilling>.*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
    
  end
end

