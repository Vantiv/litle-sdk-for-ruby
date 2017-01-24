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
  class TestLitleBatchRequest < Test::Unit::TestCase
    def test_create_new_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').twice
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once

      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/local/Batches/')
    end

    def test_add_authorization
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').at_most(3)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').twice
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once
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
      batch.create_new_batch('/usr/local/Batches/')

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      assert_equal 1, counts[:numTokenRegistrations]
    end

    def test_cancel_subscription
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:directory?).returns(true).once

      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'subscriptionId'=>'100'
      }

      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.cancel_subscription(hash)

      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:numCancelSubscriptions]
    end

    def test_update_subscription
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:directory?).returns(true).once

      hash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'subscriptionId'=>'100',
        'planCode'=>'planCodeString',
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }

      batch = LitleBatchRequest.new
      batch.create_new_batch('D:\Batches\\')
      batch.update_subscription(hash)

      counts = batch.get_counts_and_amounts
      assert_equal 1, counts[:numUpdateSubscriptions]
    end

    def test_add_update_card_validation_num_on_token
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      assert_equal 106, counts[:captureGivenAuth][:captureGivenAuthAmount]
    end

    def test_add_echeck_verification
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      File.expects(:directory?).returns(true).once

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
      assert_equal 123456, counts[:echeckSale][:echeckSalesAmount]
    end

    def test_close_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').twice
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:rename).once
      File.expects(:delete).once
      File.expects(:directory?).returns(true).once

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
      batch1 = LitleBatchRequest.new
      batch2 = LitleBatchRequest.new
      batch2.expects(:build_batch_header).returns("foo")
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

      batch = LitleBatchRequest.new
      batch.get_counts_and_amounts.expects(:[]).returns(hash = Hash.new).at_least(25)
      hash.expects(:[]).returns('a').at_least(20)

      batch.create_new_batch('/usr/local/Batches')
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
      File.expects(:file?).with(regexp_matches(/.*\/usr\/local\//)).returns(false).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*batch_.*\d.*/)).returns(true).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*\/usr\/local\//)).returns(false).in_sequence(fileExists)
      File.expects(:file?).with(regexp_matches(/.*batch_.*\d.*/)).returns(false).in_sequence(fileExists)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').in_sequence(fileExists)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(fileExists)

      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/local/')
    end

    def test_create_new_batch_when_full
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once

      batch = LitleBatchRequest.new
      addTxn = sequence('addTxn')

      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').in_sequence(addTxn)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(addTxn)
      batch.create_new_batch('/usr/local')

      batch.get_counts_and_amounts.expects(:[]).with(:sale).returns({:numSales => 10, :saleAmount => 20}).twice.in_sequence(addTxn)
      batch.get_counts_and_amounts.expects(:[]).with(:total).returns(499999).in_sequence(addTxn)

      File.expects(:open).with(regexp_matches(/.*batch_.*\d_txns.*/), 'a+').in_sequence(addTxn)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').in_sequence(addTxn)
      batch.get_counts_and_amounts.expects(:[]).with(:total).returns(100000).in_sequence(addTxn)

      batch.expects(:close_batch).once.in_sequence(addTxn)
      batch.expects(:initialize).once.in_sequence(addTxn)
      batch.expects(:create_new_batch).once.in_sequence(addTxn)

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

      batch.sale(saleHash)

    end

    def test_complete_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').at_most(9)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').at_most(7)
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once

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

      updateCardHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'litleToken'=>'1233456789103801',
        'cardValidationNum'=>'123'
      }

      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/local/Batches/')

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

    def test_PFIF_instruction_txn
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'9.3'}).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'a+').at_most(12)
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.*/), 'wb').at_most(10)
      File.expects(:rename).once
      File.expects(:open).with(regexp_matches(/.*batch_.*\d.closed.*/), 'w').once
      File.expects(:delete).with(regexp_matches(/.*batch_.*\d_txns.*/)).once
      Dir.expects(:mkdir).with('/usr/local/Batches/').once
      File.expects(:directory?).returns(false).once

      submerchantCreditHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'submerchantName'=>'001',
        'fundsTransferId'=>'1234567',
        'amount'=>'106',
        'accountInfo' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'}
      }

      vendorCreditHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'vendorName'=>'001',
        'fundsTransferId'=>'1234567',
        'amount'=>'107',
        'accountInfo' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'}
      }

      payFacCreditHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'fundsTransferId'=>'1234567',
        'amount'=>'108',
      }

      reserveCreditHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'fundsTransferId'=>'1234567',
        'amount'=>'109',
      }

      physicalCheckCreditHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'fundsTransferId'=>'1234567',
        'amount'=>'110',
      }

      submerchantDebitHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'submerchantName'=>'001',
        'fundsTransferId'=>'1234567',
        'amount'=>'106',
        'accountInfo' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'}
      }

      vendorDebitHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'vendorName'=>'001',
        'fundsTransferId'=>'1234567',
        'amount'=>'107',
        'accountInfo' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'}
      }

      payFacDebitHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'fundsTransferId'=>'1234567',
        'amount'=>'108',
      }

      reserveDebitHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'fundsTransferId'=>'1234567',
        'amount'=>'109',
      }

      physicalCheckDebitHash = {
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'fundingSubmerchantId'=>'123456',
        'fundsTransferId'=>'1234567',
        'amount'=>'110',
      }
      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/local/Batches/')

      batch.submerchant_credit(submerchantCreditHash)
      batch.payFac_credit(payFacCreditHash)
      batch.vendor_credit(vendorCreditHash)
      batch.reserve_credit(reserveCreditHash)
      batch.physical_check_credit(physicalCheckCreditHash)
      batch.submerchant_debit(submerchantDebitHash)
      batch.payFac_debit(payFacDebitHash)
      batch.vendor_debit(vendorDebitHash)
      batch.reserve_debit(reserveDebitHash)
      batch.physical_check_debit(physicalCheckDebitHash)

      #pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
      #puts "PID: " + pid.to_s + " size: " + size.to_s
      batch.close_batch()
      counts = batch.get_counts_and_amounts

      assert_equal 1, counts[:submerchantCredit ][:numSubmerchantCredit ]
      assert_equal 1, counts[:payFacCredit ][:numPayFacCredit ]
      assert_equal 1, counts[:reserveCredit ][:numReserveCredit ]
      assert_equal 1, counts[:vendorCredit ][:numVendorCredit ]
      assert_equal 1, counts[:physicalCheckCredit ][:numPhysicalCheckCredit ]
      assert_equal 106, counts[:submerchantCredit ][:submerchantCreditAmount ]
      assert_equal 108, counts[:payFacCredit ][:payFacCreditAmount ]
      assert_equal 109, counts[:reserveCredit ][:reserveCreditAmount ]
      assert_equal 107, counts[:vendorCredit ][:vendorCreditAmount ]
      assert_equal 110, counts[:physicalCheckCredit ][:physicalCheckCreditAmount ]

      assert_equal 1, counts[:submerchantDebit ][:numSubmerchantDebit ]
      assert_equal 1, counts[:payFacDebit ][:numPayFacDebit ]
      assert_equal 1, counts[:reserveDebit ][:numReserveDebit ]
      assert_equal 1, counts[:vendorDebit ][:numVendorDebit ]
      assert_equal 1, counts[:physicalCheckDebit ][:numPhysicalCheckDebit ]
      assert_equal 106, counts[:submerchantDebit ][:submerchantDebitAmount ]
      assert_equal 108, counts[:payFacDebit ][:payFacDebitAmount ]
      assert_equal 109, counts[:reserveDebit ][:reserveDebitAmount ]
      assert_equal 107, counts[:vendorDebit ][:vendorDebitAmount ]
      assert_equal 110, counts[:physicalCheckDebit ][:physicalCheckDebitAmount ]
    end
  end
end
