=begin
Copyright (c) 2012 Litle & Co.

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
require '../../lib/LitleOnline'
require 'test/unit'

#test Authorization Transaction
module LitleOnline
  class TestBatch < Test::Unit::TestCase
  
    def test_batch_file_creation
      dir = Dir.pwd
      Dir.mkdir(dir + '/temp')
      
      
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/temp')
      
      entries = Dir.entries(dir + '/temp')
      
      assert_equal entries.length, 4
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/ 
      
      File.delete(dir + '/temp/' + entries[3])
      File.delete(dir + '/temp/' + entries[2])
      Dir.delete(dir + '/temp')
    end
    
    def test_batch_file_creation_account_update
      dir = Dir.pwd
      Dir.mkdir(dir + '/temp')
      
      
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/temp')
      
      entries = Dir.entries(dir + '/temp')
      
      assert_equal entries.length, 4
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
      
      entries = Dir.entries(dir + '/temp')
      assert_equal entries.length, 6
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+\z/
      assert_not_nil entries[3] =~ /batch_\d+_txns\z/
      assert_not_nil entries[4] =~ /batch_\d+\z/
      assert_not_nil entries[5] =~ /batch_\d+_txns\z/ 
      
      File.delete(dir + '/temp/' + entries[3])
      File.delete(dir + '/temp/' + entries[2])
      File.delete(dir + '/temp/' + entries[4])
      File.delete(dir + '/temp/' + entries[5])
      Dir.delete(dir + '/temp')
    end
    
    def test_batch_file_creation_on_file
      dir = Dir.pwd
      
      File.open(dir + '/test', 'a+') do |file|
        file.puts("")
      end
      
      assert_raise ArgumentError do
        batch = LitleBatchRequest.new
        batch.create_new_batch(dir + '/test')
      end
      
      File.delete(dir+'/test')      
    end
    
    def test_batch_file_rename_and_remove
      dir = Dir.pwd
      Dir.mkdir(dir + '/temp')
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/temp')
      assert_equal Dir.entries(dir+'/temp').size, 4
      batch.close_batch
      entries = Dir.entries(dir + '/temp')
      assert_equal entries.size, 3
      entries.sort!
      assert_not_nil entries[2] =~ /batch_\d+.closed-\d+\z/
      
      File.delete(dir + '/temp/' + entries[2])
      Dir.delete(dir + '/temp')
    end
    
    def test_batch_file_create_new_dir
      dir = Dir.pwd
      batch = LitleBatchRequest.new
      assert !File.directory?(dir + '/temp')
      batch.create_new_batch(dir + '/temp')
      assert File.directory?(dir + '/temp')
      
      entries = Dir.entries(dir + '/temp')
      entries.sort!
      File.delete(dir + '/temp/' + entries[3])
      File.delete(dir + '/temp/' + entries[2])
      Dir.delete(dir + '/temp')
    end
    
    def test_batch_open_existing
      dir = Dir.pwd
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/temp')
      
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

      entries = Dir.entries(dir + '/temp')
      entries.sort!
      
      batch2 = LitleBatchRequest.new
      batch2.open_existing_batch(dir + '/temp/' + entries[2])
      assert_equal batch.get_counts_and_amounts, batch2.get_counts_and_amounts
      File.delete(dir + '/temp/' + entries[3])
      File.delete(dir + '/temp/' + entries[2])
      Dir.delete(dir + '/temp')  
    end
    
    def test_batch_open_existing_closed
      dir = Dir.pwd
      batch = LitleBatchRequest.new
      batch.create_new_batch(dir + '/temp')
      batch.close_batch

      entries = Dir.entries(dir + '/temp')
      entries.sort!
      
      batch2 = LitleBatchRequest.new
      assert_raise ArgumentError do
        batch2.open_existing_batch(dir + '/temp/' + entries[2])  
      end
      File.delete(dir + '/temp/' + entries[2])
      Dir.delete(dir + '/temp')    
    end 
  end
end 