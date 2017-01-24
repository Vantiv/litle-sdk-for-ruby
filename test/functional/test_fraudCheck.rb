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

#test FraudCheck Transaction
module LitleOnline
  class TestFraudCheck < Test::Unit::TestCase
    def test_fraud_check_happy_path
      hash = {
        'merchantId' => '101',
        'version'=>'10.1',
        'id' => '127',
        'reportGroup'=>'Planets',
        'advancedFraudChecks' => {
          'threatMetrixSessionId' => 'test1-BXXXXXX003',
          'customAttribute1' => 'pass',
          'customAttribute2' => '55',
          'customAttribute3' => '5'}
      }
      response = LitleOnlineRequest.new.fraud_check_request(hash)
      assert_equal('0', response.response)
      assert_equal('pass', response.fraudCheckResponse.advancedFraudResults.deviceReviewStatus)
      assert_equal('55', response.fraudCheckResponse.advancedFraudResults.deviceReputationScore)
      assert_equal('triggered_rule_1', response.fraudCheckResponse.advancedFraudResults.triggeredRule[0])
      assert_equal(5, response.fraudCheckResponse.advancedFraudResults.triggeredRule.size())
    end
    
    def test_fraud_check_session_id
      hash = {
        'merchantId' => '101',
        'version'=>'10.1',
        'id' => '127',
        'reportGroup'=>'Planets',
        'advancedFraudChecks' => {
          'threatMetrixSessionId' => 'test2-BXXXXXX003'
          }
      }
      response = LitleOnlineRequest.new.fraud_check_request(hash)
      assert_equal('0', response.response)
      assert_equal('pass', response.fraudCheckResponse.advancedFraudResults.deviceReviewStatus)
      assert_equal('42', response.fraudCheckResponse.advancedFraudResults.deviceReputationScore)
      # kind of a hack to get around the variable # of triggered rule elements. ie. 1 element is added as a string not
      # an Array. Fix is to write an unmarshaller or custom node class in XMLFields.rb 
      if(response.fraudCheckResponse.advancedFraudResults.triggeredRule.is_a?(Array))
        assert_equal('triggered_rule_default', response.fraudCheckResponse.advancedFraudResults.triggeredRule[0])
      elsif
        assert_equal('triggered_rule_default', response.fraudCheckResponse.advancedFraudResults.triggeredRule)
      end
    end
    
  end
end
