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

  class TestLitleAUBatch < Test::Unit::TestCase
    def test_create_new_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').twice
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once
      
      batch = LitleAUBatch.new
      batch.create_new_batch('/usr/local/Batches/')
    end
    
    def test_account_update
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:directory?).returns(true).once
      
      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      batch = LitleAUBatch.new
      batch.create_new_batch('D:\Batches\\')
      batch.account_update(accountUpdateHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:numAccountUpdates]
      assert_equal 1, counts[:total]
    end
    
    def test_close_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:rename).once
      File.expects(:delete).once
      File.expects(:directory?).returns(true).once

      batch = LitleAUBatch.new
      batch.create_new_batch('D:\Batches\\')      

      batch.close_batch()
    end  
  
    def test_open_existing_batch
      open = sequence('open')
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(2).in_sequence(open)
      
      File.expects(:file?).returns(false).once.in_sequence(open)
      File.expects(:directory?).returns(true).in_sequence(open)
      File.expects(:file?).returns(false).in_sequence(open)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').in_sequence(open)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(open)
      File.expects(:file?).returns(true).in_sequence(open)
      
      
      
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'rb').returns({:numAccountUpdates => 0}).once.in_sequence(open)
      File.expects(:rename).once.in_sequence(open)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once.in_sequence(open)
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once.in_sequence(open)
      batch1 = LitleAUBatch.new
      batch2 = LitleAUBatch.new
      batch1.create_new_batch('/usr/local/Batches/')
      
      batch2.open_existing_batch(batch1.get_batch_name)
      batch2.close_batch()
    end
    
    def test_build_batch_header
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').once
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'w').once
      File.expects(:delete).once
      File.expects(:directory?).returns(true).once
      
      batch = LitleAUBatch.new
      batch.get_counts_and_amounts.expects(:[]).returns(hash = Hash.new).at_least(5)
      
      batch.create_new_batch('/usr/local/batches')
      batch.close_batch()
    end
    
    def test_create_new_batch_missing_separator
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').once
      
      batch = LitleAUBatch.new
      batch.create_new_batch('/usr/local')
      
      assert batch.get_batch_name.include?('/usr/local/')
    end
    
    def test_create_new_batch_name_collision
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      
      fileExists = sequence('fileExists')
      File.expects(:file?).with(regexp_matches(/.*\/usr\/local\//)).returns(false).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*batch_.*\d.*/)).returns(true).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*\/usr\/local\//)).returns(false).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*batch_.*\d.*/)).returns(false).in_sequence(fileExists)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').in_sequence(fileExists)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(fileExists)
      
      
      batch = LitleAUBatch.new
      batch.create_new_batch('/usr/local/')
    end
    
    def test_create_new_batch_when_full
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      
      batch = LitleAUBatch.new
      addTxn = sequence('addTxn')
      
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').in_sequence(addTxn)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(addTxn)
      batch.create_new_batch('/usr/local')
      
      batch.get_counts_and_amounts.expects(:[]).with(:numAccountUpdates).returns(499999).in_sequence(addTxn)
      batch.get_counts_and_amounts.expects(:[]).with(:total).returns(30000).in_sequence(addTxn)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(addTxn)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').in_sequence(addTxn)
      batch.get_counts_and_amounts.expects(:[]).with(:total).returns(100000).in_sequence(addTxn)
      batch.expects(:close_batch).once.in_sequence(addTxn)
      batch.expects(:initialize).once.in_sequence(addTxn)
      batch.expects(:create_new_batch).once.in_sequence(addTxn)
      
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
    end
    
    def test_complete_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').at_most(7)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').at_most(5)
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once      
      
      batch = LitleAUBatch.new
      batch.create_new_batch('/usr/local/Batches/')
      
      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      5.times(){ batch.account_update(accountUpdateHash ) }

      #pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
      #puts "PID: " + pid.to_s + " size: " + size.to_s
      batch.close_batch()
      counts = batch.get_counts_and_amounts
      
      assert_equal 5, counts[:numAccountUpdates]
    end
    
    def test_AU_batch_with_token
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').at_most(7)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').at_most(5)
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once      
      
      batch = LitleAUBatch.new
      batch.create_new_batch('/usr/local/Batches/')
      
      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'token'=>{'litleToken'=>'1234567890123'
      }}
      
      5.times(){ batch.account_update(accountUpdateHash ) }

      batch.close_batch()
      counts = batch.get_counts_and_amounts
      
      assert_equal 5, counts[:numAccountUpdates]
    end
  end
end