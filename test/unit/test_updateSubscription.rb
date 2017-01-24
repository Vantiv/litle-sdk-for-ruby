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
  class TestUpdateSubscription < Test::Unit::TestCase

    def test_simple
      hash = {
	'subscriptionId' =>'100',
        'merchantId' => '101',
        'version'=>'8.8',
      }
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<updateSubscription><subscriptionId>100<\/subscriptionId><\/updateSubscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_subscription(hash)
    end

    def test_allFields
      hash = {
	'subscriptionId' =>'100',
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
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
        'billingDate' =>'2014-03-11'        
            } 
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<updateSubscription><subscriptionId>100<\/subscriptionId><planCode>planCodeString<\/planCode><billToAddress><name>nameString<\/name><\/billToAddress><card><type>VI<\/type><number>4100000000000001<\/number><expDate>1210<\/expDate><\/card><billingDate>2014-03-11<\/billingDate><\/updateSubscription>.*/m), is_a(Hash))
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

     def test_update_subscription_paypage
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
              'paypage'=>
                {  
		'paypageRegistrationId'=>'paypageString'
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
      LitleXmlMapper.expects(:request).with(regexp_matches(/.*<updateSubscription><subscriptionId>1000<\/subscriptionId><planCode>planCodeString<\/planCode><billToAddress><name>nameString<\/name><\/billToAddress><paypage><paypageRegistrationId>paypageString<\/paypageRegistrationId><\/paypage><billingDate>2014-03-11<\/billingDate><createDiscount><discountCode>discCode1<\/discountCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><createDiscount><discountCode>discCode11<\/discountCode><name>name11<\/name><amount>5000<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createDiscount><updateDiscount><discountCode>discCode2<\/discountCode><\/updateDiscount><deleteDiscount><discountCode>discCode3<\/discountCode><\/deleteDiscount><deleteDiscount><discountCode>discCode33<\/discountCode><\/deleteDiscount><createAddOn><addOnCode>addOnCode1<\/addOnCode><name>name1<\/name><amount>500<\/amount><startDate>2014-03-12<\/startDate><endDate>2014-03-12<\/endDate><\/createAddOn><updateAddOn><addOnCode>addOnCode2<\/addOnCode><\/updateAddOn><\/updateSubscription>.*/m), is_a(Hash))
      LitleOnlineRequest.new.update_subscription(hash)
    end    
   end

end
