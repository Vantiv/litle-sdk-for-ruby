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
  class TestLitleRequest < Test::Unit::TestCase
  
    def setup
      dir = '/tmp/litle-sdk-for-ruby-test'
      FileUtils.rm_rf dir
      Dir.mkdir dir
    end
  
    def test_request_creation
      dir = '/tmp'

      request = LitleRequest.new()
      request.create_new_litle_request(dir + '/litle-sdk-for-ruby-test')

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!

      assert_equal 4, entries.size
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/
    end

    def test_commit_batch_with_path
      dir = '/tmp'

      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      batch.close_batch
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')

      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-0\z/

      request = LitleRequest.new
      request.create_new_litle_request(dir+ '/litle-sdk-for-ruby-test')
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-0\z/
      assert_not_nil entries[3] =~ /request_\d+\z/
      assert_not_nil entries[4] =~ /request_\d+_batches\z/

      request.commit_batch(batch.get_batch_name)
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_equal 4,entries.length
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/
    end

    def test_commit_batch_with_batch
      dir = '/tmp'

      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      batch.close_batch
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')

      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-0\z/

      request = LitleRequest.new
      request.create_new_litle_request(dir+ '/litle-sdk-for-ruby-test')
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_equal 5, entries.length
      assert_not_nil entries[2] =~ /batch_\d+.closed-0\z/
      assert_not_nil entries[3] =~ /request_\d+\z/
      assert_not_nil entries[4] =~ /request_\d+_batches\z/

      request.commit_batch(batch)
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_equal 4, entries.length
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/
    end
    
    def test_commit_batch_with_batch_and_au
      dir = '/tmp'

      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      batch.account_update(accountUpdateHash)
      batch.close_batch

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')

      assert_equal 4, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-0\z/
      assert_not_nil entries[3] =~ /batch_\d+.closed-1\z/

      request = LitleRequest.new
      request.create_new_litle_request(dir+ '/litle-sdk-for-ruby-test')
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_equal 6, entries.length
      assert_not_nil entries[2] =~ /batch_\d+.closed-0\z/
      assert_not_nil entries[3] =~ /batch_\d+.closed-1\z/
      assert_not_nil entries[4] =~ /request_\d+\z/
      assert_not_nil entries[5] =~ /request_\d+_batches\z/

      request.commit_batch(batch)
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_equal 4, entries.length
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/
    end

    def test_finish_request
      dir = '/tmp'

      request = LitleRequest.new()
      request.create_new_litle_request(dir + '/litle-sdk-for-ruby-test')

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!

      assert_equal 4, entries.size
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/

      request.finish_request

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!

      assert_equal 3, entries.size
      assert_not_nil entries[2] =~ /request_\d+.complete\z/
    end
    
    def test_add_rfr
      @config_hash = Configuration.new.config
      
      dir = '/tmp'
      temp = dir + '/litle-sdk-for-ruby-test/'
      
      request = LitleRequest.new()
      request.add_rfr_request({'litleSessionId' => '137813712'}, temp)
      
      entries = Dir.entries(temp)
      entries.sort!
      
      assert_equal 3, entries.size
      assert_not_nil entries[2] =~ /request_\d+.complete\z/
    end

    def test_send_to_litle
      @config_hash = Configuration.new.config

      dir = '/tmp'

      request = LitleRequest.new()
      request.create_new_litle_request(dir + '/litle-sdk-for-ruby-test')
      request.finish_request
      request.send_to_litle

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      assert_equal 3, entries.size
      assert_not_nil entries[2] =~ /request_\d+.complete.sent\z/

      uploaded_file = entries[2]
      
      options = {}
      username = get_config(:sftp_username, options)
      password = get_config(:sftp_password, options)
      url = get_config(:sftp_url, options)

      Net::SFTP.start(url, username, :password => password) do |sftp|
        # clear out the sFTP outbound dir prior to checking for new files, avoids leaving files on the server
        # if files are left behind we are not counting then towards the expected total
        ents = []
        handle = sftp.opendir!('/inbound/')
        files_on_srv = sftp.readdir!(handle)
        files_on_srv.each {|file|
          ents.push(file.name)
        }
        assert_equal 3,ents.size
        ents.sort!
        assert_equal ents[2], uploaded_file.gsub('sent', 'asc')
        sftp.remove('/inbound/' + ents[2])  
      end
    end

    def test_send_to_litle_stream
      @config_hash = Configuration.new.config

      dir = '/tmp'

      request = LitleRequest.new()
      request.create_new_litle_request(dir + '/litle-sdk-for-ruby-test')
      request.finish_request
      request.send_to_litle_stream

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!

      assert_equal 4, entries.size
      assert_not_nil entries[2] =~ /request_\d+.complete.sent\z/
      File.delete(dir + '/litle-sdk-for-ruby-test/' + entries[2])
   
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test/responses')
      entries.sort!
      
      assert_equal 3, entries.size
      assert_not_nil entries[2] =~ /response_\d+.complete.asc.received\z/
      
    end

    def test_full_flow
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

      assert_equal 4, entries.size
      assert_not_nil entries[2] =~ /request_\d+\z/
      assert_not_nil entries[3] =~ /request_\d+_batches\z/

      #create five batches, each with 10 sales
      5.times{
        batch = LitleBatchRequest.new
        batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
        
        entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
        
        assert_equal 6, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /batch_\d+\z/
        assert_not_nil entries[3] =~ /batch_\d+_txns\z/ 
        assert_not_nil entries[4] =~ /request_\d+\z/
        assert_not_nil entries[5] =~ /request_\d+_batches\z/
        #add the same sale ten times
        10.times{
        #batch.account_update(accountUpdateHash)
          saleHash['card']['number']= (saleHash['card']['number'].to_i + 1).to_s
          batch.sale(saleHash)
        }
         
        #close the batch, indicating we plan to add no more transactions
        batch.close_batch()
        entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
        
        assert_equal 5, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /batch_\d+.closed-\d+\z/
        assert_not_nil entries[3] =~ /request_\d+\z/
        assert_not_nil entries[4] =~ /request_\d+_batches\z/
        
        #add the batch to the LitleRequest
        request.commit_batch(batch)
        entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
        assert_equal 4, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /request_\d+\z/
        assert_not_nil entries[3] =~ /request_\d+_batches\z/
      }
      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /request_\d+.complete\z/
      
      #send the batch files at the given directory over sFTP
      request.send_to_litle
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      assert_equal entries.length, 3
      entries.sort!
      assert_not_nil entries[2] =~ /request_\d+.complete.sent\z/
      #grab the expected number of responses from the sFTP server and save them to the given path
      request.get_responses_from_server()
      #process the responses from the server with a listener which applies the given block
      request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction| end})
        
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      assert_equal 4, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /request_\d+.complete.sent\z/
      File.delete(dir + '/litle-sdk-for-ruby-test/' + entries[2])
      
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test/' + entries[3])
      entries.sort!
      assert_equal 3, entries.length
      assert_not_nil entries[2] =~ /response_\d+.complete.asc.received.processed\z/
    end

    def get_config(field, options)
      if options[field.to_s] == nil and options[field] == nil then
      return @config_hash[field.to_s]
      elsif options[field.to_s] != nil then
      return options[field.to_s]
      else
      return options[field]
      end
    end
  end
end