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
  
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*loggedInUser="gdake".*merchantSdk="Ruby;8.14.0".*/m), is_a(Hash))
      LitleOnlineRequest.new.capture(hash)
    end
  end
end

