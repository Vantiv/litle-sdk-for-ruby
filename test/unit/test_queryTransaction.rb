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

# TESTING THE QUERY TRANSACTION FEATURE 


module LitleOnline
=begin
  Definition: Class Definition for the Testing Class TestQueryTransaction
  Created on: 01-29-2016
  Reason: To test the incorporation new features developed in Ruby SDK as per XML 10.1 schema. 
=end
  
class TestQueryTransaction < Test::Unit::TestCase 
  
=begin
      Name - test_queryTransaction
      Description - To validate request by providing valid query transaction fields
      Expected Response - Success 
=end
  def test_queryTransaction
    hash = 
    {
      'merchantId' => '101',
      'id' => 'test',
      'version'=>'10.0',
      'reportGroup'=>'Some RG',
      'customerId' => '038945',
      'origId' => '834262',
      'origActionType' => 'A',
      'transactionId'=>'123456',
      'orderId'=>'65347567',
      #'origAccountNumber' => '4000000000000001'      
     }  
         
     LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<queryTransaction.*?<origId>834262<\/origId><origActionType>A<\/origActionType>.*?<\/queryTransaction>.*?/m), is_a(Hash))
     LitleOnlineRequest.new.query_Transaction(hash)
   end
       
=begin
        Name - test_queryTransaction_no_optional_fields
        Description - To validate request by providing valid query transaction without providing optional fields
        Expected Response - Success 
=end       
  def test_queryTransaction_no_optional_fields
    hash = 
      {
        'merchantId' => '101',
        'id' => 'test',
        'version'=>'10.0',
        'reportGroup'=>'Some RG',
        'customerId' => '038945',
        'origId' => '834262',
        'origActionType' => 'A',
        'transactionId'=>'123456'
      }
      
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<queryTransaction.*?<origId>834262<\/origId><origActionType>A<\/origActionType>.*?<\/queryTransaction>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.query_Transaction(hash)
  end
        
   def test_queryTransaction_no_origId1
     hash = 
     {
       'merchantId' => '101',
       'id' => 'test',
       'version'=>'10.0',
       'reportGroup'=>'Some RG',
       'customerId' => '038945',
       'origActionType' => 'A',
       'transactionId'=>'123456'
     }  
              
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*?<litleOnlineRequest.*?<queryTransaction.*?<origActionType>A<\/origActionType>.*?<\/queryTransaction>.*?/m), is_a(Hash))
      LitleOnlineRequest.new.query_Transaction(hash)
  end   
 end
end