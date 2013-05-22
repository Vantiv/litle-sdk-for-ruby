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
require 'lib/LitleBatchRequest'
require 'test/unit'
require 'mocha/setup'

module LitleOnline

  class TestLitleBatchRequest < Test::Unit::TestCase
    def test_create_new_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').twice
      
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      #batch.create_new_batch('/usr/local/litle-home/barnold/Batches/')
    end
    
    def test_add_authorization
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').at_most(3)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').twice
      
      authHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
      batch = LitleBatchRequest.new
      #batch.create_new_batch('D:\Batches\\')
      batch.create_new_batch('/usr/local/litle-home/barnold/Batches/')
      
      2.times(){ batch.authorization(authHash) }
      counts = batch.get_counts_and_amounts
      
      assert_equal 2, counts[:auth][:numAuths]
      assert_equal 212, counts[:auth][:authAmount]
    end    
    
    def test_add_sale
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
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
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.sale(saleHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:sale][:numSales]
      assert_equal 6000, counts[:sale][:saleAmount]
    end
    
    def test_add_credit
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      creditHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.credit(creditHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:credit][:numCredits]
      assert_equal 106, counts[:credit][:creditAmount]
    end
    
    def test_add_auth_reversal
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      authReversalHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'12345678000',
        'amount'=>'106',
        'payPalNotes'=>'Notes'
        }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.auth_reversal(authReversalHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:authReversal][:numAuthReversals]
      assert_equal 106, counts[:authReversal][:authReversalAmount]
    end
    
    def test_add_register_token_request
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      registerTokenHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789103801'
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.register_token_request(registerTokenHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:numTokenReqistrations]
    end
    
    def test_add_update_card_validation_num_on_token
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      updateCardHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'litleToken'=>'1233456789103801',
        'cardValidationNum'=>'123'
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.update_card_validation_num_on_token(updateCardHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:numUpdateCardValidationNumOnTokens]
    end
    
    def test_add_force_capture
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      forceCaptHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.force_capture(forceCaptHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:forceCapture][:numForceCaptures]
      assert_equal 106, counts[:forceCapture][:forceCaptureAmount]
    end
    
    def test_add_capture
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      captHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.capture(captHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:capture][:numCaptures]
      assert_equal 106, counts[:capture][:captureAmount]
    end
    
    def test_add_capture_given_auth
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      captGivenAuthHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'authInformation' => {
        'authDate'=>'2002-10-09','authCode'=>'543216',
        'authAmount'=>'12345'
        },
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000000',
        'expDate' =>'1210'
        }}
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.capture_given_auth(captGivenAuthHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:captureGivenAuth][:numCaptureGivenAuths]
      assert_equal 106, counts[:captureGivenAuth][:captureGivenAmount]
    end
    
    def test_add_echeck_verification
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      echeckVerificationHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.echeck_verification(echeckVerificationHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:echeckVerification][:numEcheckVerification]
      assert_equal 123456, counts[:echeckVerification][:echeckVerificationAmount]
    end
    
    def test_add_echeck_credit
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      echeckCreditHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456789101112',
        'amount'=>'12'
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.echeck_credit(echeckCreditHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:echeckCredit][:numEcheckCredit]
      assert_equal 12, counts[:echeckCredit][:echeckCreditAmount]
    end
    
    def test_add_echeck_redeposit
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      echeckRedeopsitHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456'
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.echeck_redeposit(echeckRedeopsitHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:numEcheckRedeposit]
    end
    
    def test_add_echeck_sale
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      
      echeckSaleHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }
       
      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.echeck_sale(echeckSaleHash)
      
      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:echeckSale][:numEcheckSales]
      assert_equal 123456, counts[:echeckSale][:echeckSaleAmount]
    end
      
    def test_close_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:rename).once
      File.expects(:delete).once
      
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

      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')      

      batch.sale(saleHash)
      batch.close_batch()
    end  
  
    def test_open_existing_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').at_most(3)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'rb').returns(Hash.new)
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once
      
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
      
      batch1 = LitleBatchRequest.new
      batch2 = LitleBatchRequest.new
      batch2.expects(:build_batch_header).returns("foo")
      batch1.create_new_batch('/usr/local/litle-home/barnold/Batches/')
      2.times(){ batch1.sale(saleHash) }
      
      batch2.open_existing_batch(batch1.get_batch_name)
      batch2.close_batch()
    end
    
    def test_build_batch_header
      batch = LitleBatchRequest.new
      batch.get_counts_and_amounts.expects(:[]).returns(hash = Hash.new).at_least(25)
      hash.expects(:[]).returns('a').at_least(20)
      
      batch.create_new_batch('/usr/local/litle-home/barnold/Batches/')
      batch.close_batch()
    end
    
    def test_create_new_batch_missing_separator
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').once
      
      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/local')
      
      assert batch.get_batch_name.include?('/usr/local/')
    end
    
    def test_create_new_batch_name_collision
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      
      fileExists = sequence('fileExists')
      #mockFile = mock(File)
      File.expects(:file?).with(regexp_matches(/.*\/usr\/local\//)).returns(false).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*batch_.*\d.*/)).returns(true).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*\/usr\/local\//)).returns(false).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*batch_.*\d.*/)).returns(false).in_sequence(fileExists)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').in_sequence(fileExists)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(fileExists)
      
      
      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/local/')
    end
    
    def test_complete_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').at_most(9)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').at_most(7)
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once
      
      authHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
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
      
      batch = LitleBatchRequest.new
      #batch.create_new_batch('D:\Batches\\')
      batch.create_new_batch('/usr/local/litle-home/barnold/Batches/')
      
      5.times(){ batch.authorization(authHash) }
      2.times(){ batch.sale(saleHash) }
      #pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
      #puts "PID: " + pid.to_s + " size: " + size.to_s
      batch.close_batch()
      counts = batch.get_counts_and_amounts
      
      assert_equal 5, counts[:auth][:numAuths]
      #assert_equal 212, counts[:auth][:authAmount]
      assert_equal 2, counts[:sale][:numSales]
      #assert_equal 6000, counts[:sale][:saleAmount]
    end  
  
  end
end