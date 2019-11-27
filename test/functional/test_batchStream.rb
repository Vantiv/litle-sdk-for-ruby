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
require 'fileutils'

module LitleOnline
  class TestLitleBatchStream < Test::Unit::TestCase

    @@preliveStatus = ENV["preliveStatus"]

    def self.preliveStatus
      @@preliveStatus
    end

    def setup
      dir = '/tmp/litle-sdk-for-ruby-test'
      FileUtils.rm_rf dir
      Dir.mkdir dir
    end

    def test_full_flow
      omit_if(TestLitleBatchStream.preliveStatus.downcase == 'down')

      saleHash = {
        'reportGroup'=>'Planets',
        'id' => '006',
        'orderId'=>'12344',
        'amount'=>'6000',
        'orderSource'=>'ecommerce',
        'card'=>{
          'type'=>'VI',
          'number' =>'4100000000000001',
          'expDate' =>'1210'
        }}

      dir = '/tmp'

      request = LitleRequest.new()
      request.create_new_litle_request(dir + '/litle-sdk-for-ruby-test')

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!

      assert_equal 4,entries.size
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/

      #create five batches, each with 10 sales
   
        batch = LitleBatchRequest.new
        batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
        
        cancelSubscriptionHash = 
             {
              'subscriptionId'=>'100'
             }
        batch.cancel_subscription(cancelSubscriptionHash)

        updateSubscriptionHash = 
            {
              'subscriptionId'=>'1000' 
            }
        batch.update_subscription(updateSubscriptionHash)

        createPlanHash ={
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'planCode'=>'createPlanCodeString',
        'name'=>'nameString',
        'description'=>'descriptionString',
        'intervalType'=>'ANNUAL',
        'amount'=>'500',
        'numberOfPayments'=>'2',
        'trialNumberOfIntervals'=>'1',
        'trialIntervalType'=>'MONTH',
        'active'=>'true'  
            }
        batch.create_plan(createPlanHash)

        updatePlanHash ={
        'merchantId' => '101',
        'version'=>'8.8',

        'reportGroup'=>'Planets',
        'planCode'=>'updatePlanCodeString',
        'active'=>'true'
        }

        batch.update_plan(updatePlanHash)

        #close the batch, indicating we plan to add no more transactions
        batch.close_batch()
        
        
        #add the batch to the LitleRequest
        request.commit_batch(batch)
      
      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /request_\d+.complete\z/
      
      #send the batch files at the given directory over sFTP
      count = 1
      begin
        request.send_to_litle_stream
      rescue
        if (count < 3) then
          count = count + 1
          retry
        else
          raise
        end
      end
      request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
      type = transaction["type"]
    
      if(type == "cancelSubscriptionResponse") then
      assert_equal "100" ,transaction["subscriptionId"]
       end

      if(type == "updateSubscriptionResponse") then
      assert_equal "1000" ,transaction["subscriptionId"]
       end

      if(type == "createPlanResponse") then
      assert_equal "createPlanCodeString" ,transaction["planCode"]
       end

      if(type == "updatePlanResponse") then
      assert_equal "updatePlanCodeString" ,transaction["planCode"]
       end

      end})

    end
   end
end