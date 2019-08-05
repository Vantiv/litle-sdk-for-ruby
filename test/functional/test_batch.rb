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

#test Authorization Transaction
module LitleOnline
  class TestBatch < Test::Unit::TestCase

    @@preliveStatus = ENV['preliveStatus']

    def self.preliveStatus
      @@preliveStatus
    end

    def setup
      dir = '/tmp/litle-sdk-for-ruby-test'
      FileUtils.rm_rf dir
      Dir.mkdir dir
    end
  
    def test_batch_file_creation
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'
      
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      
      assert_equal 4,entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/ 
    end
    
    def test_batch_file_creation_account_update
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'
      
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      
      assert_equal 4,entries.length
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/ 
      
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
      
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      assert_equal entries.length, 6
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/
      assert_not_nil entries[4] =~ /batch_\d+\z/
      assert_not_nil entries[5] =~ /batch_\d+_txns\z/ 
    end
    
    def test_batch_file_creation_on_file
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'
      
      File.open(dir + '/litle-sdk-for-ruby-test/test_batch_file_creation_on_file', 'a+') do |file|
        file.puts("")
      end
      
      assert_raise ArgumentError do
        batch = LitleBatchRequest.new
        batch.create_new_batch(dir + '/litle-sdk-for-ruby-test/test_batch_file_creation_on_file')
      end
    end
    
    def test_batch_file_rename_and_remove
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'

      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      assert_equal Dir.entries(dir+'/litle-sdk-for-ruby-test').size, 4
      batch.close_batch
      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      assert_equal entries.size, 3
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-\d+\z/
    end
    
    def test_batch_file_create_new_dir
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'
      batch = LitleBatchRequest.new
      assert !File.directory?(dir + '/litle-sdk-for-ruby-test/test_batch_file_create_new_dir')
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test/test_batch_file_create_new_dir')
      assert File.directory?(dir + '/litle-sdk-for-ruby-test/test_batch_file_create_new_dir')
    end
    
    def test_batch_open_existing
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      
      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000002',
        'expDate' =>'1210'
        }}
      
      batch.sale(hash)

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      
      batch2 = LitleBatchRequest.new
      batch2.open_existing_batch(dir + '/litle-sdk-for-ruby-test/' + entries[2])
      assert_equal batch.get_counts_and_amounts, batch2.get_counts_and_amounts
    end
    
    def test_batch_open_existing_closed
      omit_if(TestBatch.preliveStatus.downcase == 'down')

      dir = '/tmp'
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/litle-sdk-for-ruby-test')
      batch.close_batch

      entries = Dir.entries(dir + '/litle-sdk-for-ruby-test')
      entries.sort!
      
      batch2 = LitleBatchRequest.new
      assert_raise ArgumentError do
        batch2.open_existing_batch(dir + '/litle-sdk-for-ruby-test/' + entries[2])  
      end
    end 
  end
end 