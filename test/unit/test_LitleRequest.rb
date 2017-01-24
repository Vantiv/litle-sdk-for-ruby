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
      
      assert_equal "Entered a file not a path.",message
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
    
    def test_add_rfr_request_litle_session
      add_rfr = sequence('add_rfr')
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(1).in_sequence(add_rfr)
      
      File.expects(:file?).with('/usr/srv').returns(false).in_sequence(add_rfr)
      File.expects(:directory?).with('/usr/srv/').returns(true).in_sequence(add_rfr)
      File.expects(:open).with(regexp_matches(/request_\d+\z/), 'a+').in_sequence(add_rfr)
      File.expects(:rename).with(regexp_matches(/request_\d+\z/), regexp_matches(/request_\d+.complete\z/)).in_sequence(add_rfr)
      
      request = LitleRequest.new({'sessionId'=>'8675309', 
                                        'user'=>'john', 
                                        'password'=>'tinkleberry'})
 
      request.add_rfr_request({'litleSessionId' => '137813712'}, '/usr/srv')

    end
    
    def test_commit_batch_with_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(2)

      request = LitleRequest.new({'sessionId'=>'8675309',
        'user'=>'john',
        'password'=>'tinkleberry'})
      File.expects(:file?).returns(false).once
      File.expects(:file?).returns(false).twice #or's don't quit
      File.expects(:open).twice
      File.expects(:directory?).returns(true).once
      request.create_new_litle_request("/usr/srv/batches")

      batch = LitleBatchRequest.new
      File.expects(:open).twice
      File.expects(:file?).returns(false).twice
      File.expects(:directory?).returns(true).once
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
      File.expects(:directory?).returns(true).once
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
      assert_equal "You entered neither a path nor a batch. Game over :("  ,test 
    end
    
    def test_add_open_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(2)
      File.expects(:open).with(regexp_matches(/\/usr\/srv\/.*/), 'a+').times(2)
      
      Dir.expects(:mkdir).with('/usr/srv/batches/').once
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
      File.expects(:directory?).returns(true).once
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
    
    #TODO: see of we can get deeper with mocking the node returned
    def test_process_response_success
      xml = sequence("xml")
      LibXML::XML::Reader.expects(:file).once.returns(reader = LibXML::XML::Reader.new).in_sequence(xml)
      reader.expects(:read).once.in_sequence(xml)
      reader.expects(:get_attribute).with('response').returns("0").in_sequence(xml)
      reader.expects(:read).once.in_sequence(xml)
      reader.expects(:node).returns(node = LibXML::XML::Node.new("litleResponse")).twice.in_sequence(xml)
      
      request = LitleRequest.new({})
      request.process_response(Dir.pwd + '/responses/good_xml.xml' , 
      DefaultLitleListener.new{|txn| puts txn["type"]} ,
      DefaultLitleListener.new{|batch| } )
    end
    
    def test_process_response_xml_error
      LibXML::XML::Reader.expects(:file).once.returns(reader = LibXML::XML::Reader.new)
      reader.expects(:read).once
      reader.expects(:get_attribute).with('response').twice.returns(4)
      reader.expects(:get_attribute).with("message").returns("Error validating xml data against the schema")
      
      request = LitleRequest.new({})
      response = ''
      begin
        request.process_response(Dir.pwd + '/responses/bad_xml.xml' , 
        DefaultLitleListener.new{|txn| puts txn["type"]} ,
        DefaultLitleListener.new{|batch| } )
      rescue Exception => e
          response = e.message
      end
      assert_equal "Error parsing Litle Request: Error validating xml data against the schema", response.to_s
    end      

    def test_process_responses
      request = LitleRequest.new({})
      listener = DefaultLitleListener.new
      args = {:transaction_listener=>listener,:path_to_responses=>"fake/path/"}
      args.expects(:[]).with(:transaction_listener)
      args.expects(:[]).with(:batch_listener).returns(nil)
      args.expects(:[]).with(:path_to_responses).returns("fake/path/")
      Dir.expects(:foreach).with("fake/path/")      
      
      request.process_responses(args)
    end

    def test_get_responses_from_server
      request = LitleRequest.new({})
      resp_seq = sequence("resp_seq")
      args = {:responses_expected=>4, :response_path=>"new/path", :sftp_username=>"periwinkle",:sftp_password=>"password", :sftp_url=>"reddit.com"}
      
      File.expects(:directory?).with("new/path/").returns(false).once.in_sequence(resp_seq)
      Dir.expects(:mkdir).with("new/path/").once.in_sequence(resp_seq)
      Net::SFTP.expects(:start).twice.with("reddit.com", "periwinkle", :password=>"password")
      
      request.get_responses_from_server(args)
    end

    def test_send_over_stream
      request = LitleRequest.new({})
      req_seq = sequence('request')
      
      File.expects(:directory?).with(regexp_matches(/responses\//)).once.returns(false).in_sequence(req_seq)
      Dir.expects(:mkdir).with(regexp_matches(/responses\//)).once.in_sequence(req_seq)
      Dir.expects(:foreach).once.in_sequence(req_seq)
      
      request.send_to_litle_stream({:fast_url=>"www.redit.com", :fast_port=>"2313"}) 
    end
    
    def test_send_over_stream_bad_crds
      request = LitleRequest.new({})
      
      assert_raise ArgumentError do
        request.send_to_litle_stream({:fast_url=>"", :fast_port=>""})
      end 
    end
    #Outputs an example LitleRequest doc in the current directory
    # def test_finish_request_xml! #that's why the name has a bang
      # # see the bang up there ^^^ that means we ACTUALLY edit the file system
      # # make sure to clear this; otherwise, you're gonna have a bad time.      
      # path = Dir.pwd
#       
      # saleHash = {
        # 'reportGroup'=>'Planets',
        # 'id' => '006',
        # 'orderId'=>'12344',
        # 'amount'=>'6000',
        # 'orderSource'=>'ecommerce',
        # 'card'=>{
        # 'type'=>'VI',
        # 'number' =>'4100000000000001',
        # 'expDate' =>'1210'
      # }}
#       
      # request = LitleRequest.new({'sessionId'=>'8675309',
        # 'user'=>'john',
        # 'password'=>'tinkleberry'})
      # request.create_new_litle_request(path)
#       
#       
      # #5.times{
        # batch = LitleBatchRequest.new
        # batch.create_new_batch(path)
        # puts "Batch is at: " + batch.get_batch_name
#         
        # #10.times{
          # batch.sale(saleHash)
          # #batch.update_card_validation_num_on_token(options)
        # #}
#         
        # batch.close_batch()
        # request.commit_batch(batch)
      # #}
      # request.finish_request
    # end
   end
end