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
require 'lib/LitleRequest'
require 'lib/LitleBatchRequest'
require 'test/unit'
require 'mocha/setup'

module LitleOnline
  
  class TestLitleRequest < Test::Unit::TestCase
    
    def test_create_with_file
      request = LitleRequest.new({'sessionId'=>'8675309', 
                                       'user'=>'john', 
                                       'password'=>'tinkleberry'}) 
      message = ""
      File.expects(:file?).with('/durrrrrr').returns(true).once
      request.create_new_litle_request('/durrrrrr')
      
      rescue RuntimeError=> e
        message = e.message
      
      assert_equal message, "Entered a file not a path."
    end
    
    def test_create_with_no_sep
      request = LitleRequest.new({'sessionId'=>'8675309', 
                                        'user'=>'john', 
                                        'password'=>'tinkleberry'})
      File.expects(:open).twice  
      request.create_new_litle_request('/usr/local')    
      assert request.get_path_to_batches.include?('/usr/local/')
    end
    
    def test_create_name_collision
      request = LitleRequest.new({'sessionId'=>'8675309', 
                                        'user'=>'john', 
                                        'password'=>'tinkleberry'})
                                        
      create_new = sequence('create_new')
      File.expects(:file?).returns(false).in_sequence(create_new)
      File.expects(:file?).returns(true).once.in_sequence(create_new) #yayay short circuiting
      File.expects(:file?).returns(false).once.in_sequence(create_new)
      File.expects(:file?).returns(false).twice.in_sequence(create_new) #or's don't quit
      File.expects(:open).twice.in_sequence(create_new)
      
      request.create_new_litle_request('/usr/local')                         
    end
    
    def test_create_normal
      request = LitleRequest.new({'sessionId'=>'8675309', 
                                        'user'=>'john', 
                                        'password'=>'tinkleberry'})
      
      create_new = sequence('create_new')
      File.expects(:file?).returns(false).once.in_sequence(create_new)
      File.expects(:file?).returns(false).twice.in_sequence(create_new)
      File.expects(:open).once.in_sequence(create_new)
      File.expects(:open).once.in_sequence(create_new)
      
      request.create_new_litle_request('/usr/local') 
    end
    
    def test_commit_batch_with_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(2)

      request = LitleRequest.new({'sessionId'=>'8675309',
        'user'=>'john',
        'password'=>'tinkleberry'})
      File.expects(:file?).returns(false).once
      File.expects(:file?).returns(false).twice #or's don't quit
      File.expects(:open).twice
      request.create_new_litle_request("/usr/srv/batches")

      batch = LitleBatchRequest.new
      File.expects(:open).twice
      File.expects(:file?).returns(false).twice
      batch.create_new_batch('/usr/srv/batches')
      File.expects(:rename).once
      File.expects(:open).once
      File.expects(:delete).once
      batch.close_batch()

      File.expects(:open).with(regexp_matches(/.*_batches.*/), 'a+')
      File.expects(:delete).with(regexp_matches(/.*\.closed.*/))
      request.commit_batch(batch)  
    end
    
    def test_commit_batch_with_path
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(1)

      request = LitleRequest.new({'sessionId'=>'8675309',
        'user'=>'john',
        'password'=>'tinkleberry'})
      File.expects(:file?).returns(false).once
      File.expects(:file?).returns(false).twice #or's don't quit
      File.expects(:open).twice
      request.create_new_litle_request("/usr/srv/batches")

      File.expects(:open).with(regexp_matches(/.*_batches.*/), 'a+')
      File.expects(:delete).with(regexp_matches(/.*\.closed.*/))
      request.commit_batch("/usr/srv/batches/batch_123123131231.closed-100000")
    end
    
    def test_add_bad_object
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      request = LitleRequest.new({})
      request.commit_batch({:apple => "pear"})
      test = ""
      rescue RuntimeError => e
        test = e.message
      assert_equal test, "You entered neither a path nor a batch. Game over :("  
    end
    
    def test_add_open_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(2)
      File.expects(:open).with(regexp_matches(/\/usr\/srv\/.*/), 'a+').times(2)
      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/srv/batches')  
      request = LitleRequest.new({'sessionId'=>'8675309', 
                                        'user'=>'john', 
                                        'password'=>'tinkleberry'})
      
      close_and_add = sequence('close_and_add')
      batch.expects(:get_batch_name).returns("/usr/srv/batches/batch_123123131231").once.in_sequence(close_and_add)
      batch.expects(:close_batch).once.in_sequence(close_and_add)
      batch.expects(:get_batch_name).returns(str = "/usr/srv/batches/batch_123123131231.closed-1000").once.in_sequence(close_and_add)
      str.expects(:index).returns(7).once.in_sequence(close_and_add)
      File.expects(:open).once.in_sequence(close_and_add)
      File.expects(:delete).once.in_sequence(close_and_add)
      request.commit_batch(batch)
    end
    
    def test_batch_too_big
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(1)

      request = LitleRequest.new({'sessionId'=>'8675309',
        'user'=>'john',
        'password'=>'tinkleberry'})
      File.expects(:file?).returns(false).once
      File.expects(:file?).returns(false).twice #or's don't quit
      File.expects(:open).twice
      request.create_new_litle_request("/usr/srv/batches")
      create_new = sequence('create_new')

      File.expects(:open).with(regexp_matches(/.*_batches.*/), 'a+').times(5)
      File.expects(:delete).with(regexp_matches(/.*\.closed.*/)).times(5)
      5.times {

        request.commit_batch("/usr/srv/batches/batch_123123131231.closed-100000")
      }

      request.expects(:finish_request).once
      request.expects(:initialize).once
      request.expects(:create_new_litle_request).once
      request.commit_batch("/usr/srv/batches/batch_123123131231.closed-100000")
    end

    #Outputs an example LitleRequest doc in the current directory
    def test_finish_request_xml! #that's why the name has a bang
      # see the bang up there ^^^ that means we ACTUALLY edit the file system
      # make sure to clear this; otherwise, you're gonna have a bad time.      
      path = Dir.pwd
      
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
      
      request = LitleRequest.new({'sessionId'=>'8675309',
        'user'=>'john',
        'password'=>'tinkleberry'})
      request.create_new_litle_request(path)
      
      
      5.times{
        batch = LitleBatchRequest.new
        batch.create_new_batch(path)
        puts "Batch is at: " + batch.get_batch_name
        
        10.times{
          batch.sale(saleHash)
        }
        
        batch.close_batch()
        request.commit_batch(batch, {})
      }
      request.finish_request
    end
    
    def test_process_response
      request = LitleRequest.new({})
      puts "STARTING A TEST WOOO"
      request.process_response('/usr/local/litle-home/ahammond/example.xml')
      puts "FINISHING A TEST WOOO"
    end
   end
end