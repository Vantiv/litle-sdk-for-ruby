require File.expand_path("../../../lib/LitleOnline",__FILE__)
require 'test/unit'
require 'fileutils'

LITLE_SDK_TEST_FOLDER = '/litle-sdk-for-ruby-test'

module LitleOnline
  class TestPgpLitleRequest < Test::Unit::TestCase

    def setup
      dir = '/tmp/litle-sdk-for-ruby-test'
      FileUtils.rm_rf dir
      Dir.mkdir dir

    end

    def test_send_to_litle
      ENV['litle_deleteBatchFiles'] = 'false'
      config_dir = ENV['LITLE_CONFIG_DIR']
      ENV['LITLE_CONFIG_DIR'] = '/tmp/pgp_ruby'

      @config_hash = Configuration.new.config

      dir = '/tmp'

      request = LitleRequest.new()
      ENV['LITLE_CONFIG_DIR'] = config_dir
      request.create_new_litle_request(dir + LITLE_SDK_TEST_FOLDER)
      request.finish_request



      request.send_to_litle()

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      encrypted_entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + ENCRYPTED_PATH_DIR)
      entries.sort!
      assert_equal 4, entries.size
      assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}#{SENT_FILE_SUFFIX}\z/
      encrypted_entries.sort!
      assert_equal 3, encrypted_entries.size
      assert_not_nil encrypted_entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}#{ENCRYPTED_FILE_SUFFIX}#{SENT_FILE_SUFFIX}\z/

      uploaded_file = encrypted_entries[2]

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
        assert_equal ents[2], uploaded_file.gsub(SENT_FILE_SUFFIX, '.asc')
        sftp.remove('/inbound/' + ents[2])
      end
    end

    def test_full_flow
      ENV['litle_deleteBatchFiles'] = 'false'
      config_dir = ENV['LITLE_CONFIG_DIR']
      ENV['LITLE_CONFIG_DIR'] = '/tmp/pgp_ruby'

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
      ENV['LITLE_CONFIG_DIR'] = config_dir
      request.create_new_litle_request(dir + LITLE_SDK_TEST_FOLDER)

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      entries.sort!

      assert_equal 4, entries.size
      assert_not_nil entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
      assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/

      #create five batches, each with 10 sales
      5.times{
        batch = LitleBatchRequest.new
        batch.create_new_batch(dir + LITLE_SDK_TEST_FOLDER)

        entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)

        assert_equal 6, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /batch_\d+\z/
        assert_not_nil entries[3] =~ /batch_\d+_txns\z/
        assert_not_nil entries[4] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
        assert_not_nil entries[5] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/
        #add the same sale ten times
        10.times{
          #batch.account_update(accountUpdateHash)
          saleHash['card']['number']= (saleHash['card']['number'].to_i + 1).to_s
          batch.sale(saleHash)
        }

        #close the batch, indicating we plan to add no more transactions
        batch.close_batch()
        entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)

        assert_equal 5, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /batch_\d+.closed-\d+\z/
        assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
        assert_not_nil entries[4] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/

        #add the batch to the LitleRequest
        request.commit_batch(batch)
        entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
        assert_equal 4, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
        assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/
      }
      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request
      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+.complete\z/

      #send the batch files at the given directory over sFTP

      request.send_to_litle()
      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      encrypted_entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + ENCRYPTED_PATH_DIR)

      assert_equal entries.length, 4
      entries.sort!
      assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}#{SENT_FILE_SUFFIX}\z/
      encrypted_entries.sort!
      assert_not_nil encrypted_entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}#{ENCRYPTED_FILE_SUFFIX}#{SENT_FILE_SUFFIX}\z/



      #grab the expected number of responses from the sFTP server and save them to the given path
      request.get_responses_from_server()
      #process the responses from the server with a listener which applies the given block
      request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction| end})

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)

      assert_equal 5, entries.length
      entries.sort!
      assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}#{SENT_FILE_SUFFIX}\z/
      File.delete(dir + LITLE_SDK_TEST_FOLDER + '/' + entries[3])

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + entries[4])
      entries.sort!
      assert_equal 4, entries.length
      assert_not_nil entries[3] =~ /#{RESPONSE_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}.asc#{RECEIVED_FILE_SUFFIX}.processed\z/
    end


    def test_full_flow_with_deleteBatchFiles
      ENV['litle_deleteBatchFiles'] = 'true'
      config_dir = ENV['LITLE_CONFIG_DIR']
      ENV['LITLE_CONFIG_DIR'] = '/tmp/pgp_ruby'

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
      ENV['LITLE_CONFIG_DIR'] = config_dir
      ENV['litle_deleteBatchFiles'] = 'false'
      request.create_new_litle_request(dir + LITLE_SDK_TEST_FOLDER)

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      entries.sort!

      assert_equal 4, entries.size
      assert_not_nil entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
      assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/

      #create five batches, each with 10 sales
      5.times{
        batch = LitleBatchRequest.new
        batch.create_new_batch(dir + LITLE_SDK_TEST_FOLDER)

        entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)

        assert_equal 6, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /batch_\d+\z/
        assert_not_nil entries[3] =~ /batch_\d+_txns\z/
        assert_not_nil entries[4] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
        assert_not_nil entries[5] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/
        #add the same sale ten times
        10.times{
          #batch.account_update(accountUpdateHash)
          saleHash['card']['number']= (saleHash['card']['number'].to_i + 1).to_s
          batch.sale(saleHash)
        }

        #close the batch, indicating we plan to add no more transactions
        batch.close_batch()
        entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)

        assert_equal 5, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /batch_\d+.closed-\d+\z/
        assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
        assert_not_nil entries[4] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/

        #add the batch to the LitleRequest
        request.commit_batch(batch)
        entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
        assert_equal 4, entries.length
        entries.sort!
        assert_not_nil entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+\z/
        assert_not_nil entries[3] =~ /#{REQUEST_FILE_PREFIX}\d+_batches\z/
      }
      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request
      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /#{REQUEST_FILE_PREFIX}\d+.complete\z/

      #send the batch files at the given directory over sFTP

      request.send_to_litle()
      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER)
      encrypted_entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + ENCRYPTED_PATH_DIR)

      assert_equal 3, entries.length
      entries.sort!
      puts entries[2]
      assert_not_nil entries[2] =~ /encrypted/
      assert_equal 2, encrypted_entries.length


      #grab the expected number of responses from the sFTP server and save them to the given path
      request.get_responses_from_server()

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + RESPONSE_PATH_DIR)
      encrypted_entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + RESPONSE_PATH_DIR + ENCRYPTED_PATH_DIR)
      assert_equal 4, entries.length
      entries.sort!
      assert_not_nil entries[3] =~ /#{RESPONSE_FILE_PREFIX}\d+#{COMPLETE_FILE_SUFFIX}.asc#{RECEIVED_FILE_SUFFIX}\z/
      assert_equal 2, encrypted_entries.length

      #process the responses from the server with a listener which applies the given block
      request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction| end})

      entries = Dir.entries(dir + LITLE_SDK_TEST_FOLDER + '/' + RESPONSE_PATH_DIR)
      assert_equal 3, entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /encrypted/
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
