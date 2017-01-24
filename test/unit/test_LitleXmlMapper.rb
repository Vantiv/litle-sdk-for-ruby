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
  class TestLitleXmlMapper < Test::Unit::TestCase
    
    def test_LitleXmlMapper_request_xml_response_0
      hash =
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
      }
      Communications.expects(:http_post).returns("<litleOnlineResponse version=\"1.0\" xmlns=\"http://www.litle.com/schema/online\" response=\"0\" message=\"Invalid credentials. Contact support@litle.com.\"></litleOnlineResponse>")
      response = LitleXmlMapper.request("","")
      assert_equal('0',response.response)
    end
    
    def test_LitleXmlMapper_request_xml_response_1
      hash =
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
      }
      Communications.expects(:http_post).returns("<litleOnlineResponse version=\"1.0\" xmlns=\"http://www.litle.com/schema/online\" response=\"1\" message=\"Invalid credentials. Contact support@litle.com.\"></litleOnlineResponse>")
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleXmlMapper.request("","")
        }
      #Test 
      assert(exception.message =~ /Error with http response, code: 1/)
    end
    
    def test_LitleXmlMapper_request_xml_response_2
      hash =
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
      }
      Communications.expects(:http_post).returns("<litleOnlineResponse version=\"1.0\" xmlns=\"http://www.litle.com/schema/online\" response=\"2\" message=\"Invalid credentials. Contact support@litle.com.\"></litleOnlineResponse>")
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleXmlMapper.request("","")
        }
      #Test 
      assert(exception.message =~ /Error with http response, code: 2/)
    end

    def test_LitleXmlMapper_request_xml_response_3
      hash =
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
      }
      Communications.expects(:http_post).returns("<litleOnlineResponse version=\"1.0\" xmlns=\"http://www.litle.com/schema/online\" response=\"3\" message=\"Invalid credentials. Contact support@litle.com.\"></litleOnlineResponse>")
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleXmlMapper.request("","")
        }
      #Test 
      assert(exception.message =~ /Error with http response, code: 3/)
    end

    def test_LitleXmlMapper_request_xml_response_4
      hash =
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
      }
      Communications.expects(:http_post).returns("<litleOnlineResponse version=\"1.0\" xmlns=\"http://www.litle.com/schema/online\" response=\"4\" message=\"Invalid credentials. Contact support@litle.com.\"></litleOnlineResponse>")
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleXmlMapper.request("","")
        }
      #Test 
      assert(exception.message =~ /Error with http response, code: 4/)
    end    

    def test_LitleXmlMapper_request_xml_response_5
      hash =
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
      }
      Communications.expects(:http_post).returns("<litleOnlineResponse version=\"1.0\" xmlns=\"http://www.litle.com/schema/online\" response=\"5\" message=\"Invalid credentials. Contact support@litle.com.\"></litleOnlineResponse>")
      #Get exceptions
      exception = assert_raise(RuntimeError){
        LitleXmlMapper.request("","")
        }
      #Test 
      assert(exception.message =~ /Error with http response, code: 5/)
    end
        
  end
end