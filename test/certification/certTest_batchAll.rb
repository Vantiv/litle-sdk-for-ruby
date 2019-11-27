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
  class LitleBatchCertTest < Test::Unit::TestCase

    @@preliveStatus = ENV["preliveStatus"]

    def self.preliveStatus
      @@preliveStatus
    end

    def setup
      path = "/tmp/litle-sdk-for-ruby"
      FileUtils.rm_rf path
      if(!File.directory?(path))
        Dir.mkdir(path)
      end
      path = "/tmp/litle-sdk-for-ruby/cert/"
      if(!File.directory?(path))
        Dir.mkdir(path)
      end
    end

    def test_MEGA_batch
      omit_if(LitleBatchCertTest.preliveStatus.downcase == 'down')

      authHash = {
        'reportGroup'=>'Planets',
        'id' => '006',
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

      creditHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'amount'=>'106',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}

      authReversalHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'12345678000',
        'amount'=>'106',
        'payPalNotes'=>'Notes'
      }

      registerTokenHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'orderId'=>'12344',
        'accountNumber'=>'1233456789103801'
      }

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

      forceCaptHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
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

      captHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456000',
        'amount'=>'106',
      }

      captGivenAuthHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
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

      echeckVerificationHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }

      echeckCreditHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456789101112',
        'amount'=>'12'
      }

      echeckRedeopsitHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'litleTxnId'=>'123456'
      }

      echeckSaleHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }

      accountUpdateHash = {
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'1234',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
        }}

      path = "/tmp/litle-sdk-for-ruby/cert/"

      request = LitleRequest.new({'sessionId'=>'8675309'})

      request.create_new_litle_request(path)
      batch = LitleBatchRequest.new
      batch.create_new_batch(path)

      batch.account_update(accountUpdateHash)
      batch.auth_reversal(authReversalHash)
      batch.authorization(authHash)
      batch.capture(captHash)
      batch.capture_given_auth(captGivenAuthHash)
      batch.credit(creditHash)
      batch.echeck_credit(echeckCreditHash)
      batch.echeck_redeposit(echeckRedeopsitHash)
      batch.echeck_sale(echeckSaleHash)
      batch.echeck_verification(echeckVerificationHash)
      batch.force_capture(forceCaptHash)
      batch.register_token_request(registerTokenHash)
      batch.sale(saleHash)
      batch.update_card_validation_num_on_token(updateCardHash)

      #close the batch, indicating we plan to add no more transactions
      batch.close_batch()
      #add the batch to the LitleRequest
      request.commit_batch(batch)
      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request

      #send the batch files at the given directory over sFTP
      request.send_to_litle

      #grab the expected number of responses from the sFTP server and save them to the given path
      request.get_responses_from_server()

      count = 0
      #process the responses from the server with a listener which applies the given block
      request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
        assert_not_nil transaction["litleTxnId"] =~ /\d+/
        assert_not_nil transaction["response"] =~ /\d+/
        assert_not_nil transaction["message"]
        count+=1
        end})
      assert_equal 14,count 
    end

    def test_mini_batch_borked_counts
      omit_if(LitleBatchCertTest.preliveStatus.downcase == 'down')

      echeckSaleHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }

      path = "/tmp/litle-sdk-for-ruby/cert/"

      request = LitleRequest.new({'sessionId'=>'8675309'})

      request.create_new_litle_request(path)
      batch = LitleBatchRequest.new
      batch.create_new_batch(path)

      batch.echeck_sale(echeckSaleHash)

      #make this a bad batch
      batch.get_counts_and_amounts[:sale][:numSales] += 1
      #close the batch, indicating we plan to add no more transactions
      batch.close_batch()
      #add the batch to the LitleRequest
      request.commit_batch(batch)

      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request

      #send the batch files at the given directory over sFTP
      request.send_to_litle

      #grab the expected number of responses from the sFTP server and save them to the given path
      request.get_responses_from_server()

      assert_raise RuntimeError do
        #process the responses from the server with a listener which applies the given block
        request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
          end})
      end
    end

    def test_mini_batch_borked_amounts
      omit_if(LitleBatchCertTest.preliveStatus.downcase == 'down')

      echeckSaleHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'id' => '006',
        'reportGroup'=>'Planets',
        'amount'=>'123456',
        'verify'=>'true',
        'orderId'=>'12345',
        'orderSource'=>'ecommerce',
        'echeck' => {'accType'=>'Checking','accNum'=>'12345657890','routingNum'=>'123456789','checkNum'=>'123455'},
        'billToAddress'=>{'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}
      }

      path = "/tmp/litle-sdk-for-ruby/cert/"

      request = LitleRequest.new({'sessionId'=>'8675309'})

      request.create_new_litle_request(path)
      batch = LitleBatchRequest.new
      batch.create_new_batch(path)

      batch.echeck_sale(echeckSaleHash)

      #make this a bad batch
      batch.get_counts_and_amounts[:sale][:saleAmount] += 1
      #close the batch, indicating we plan to add no more transactions
      batch.close_batch()
      #add the batch to the LitleRequest
      request.commit_batch(batch)

      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request

      #send the batch files at the given directory over sFTP
      request.send_to_litle

      #grab the expected number of responses from the sFTP server and save them to the given path
      request.get_responses_from_server()

      # we are checking the litleResponse header for a filed response code and raising it as an error
      assert_raise RuntimeError do
        #process the responses from the server with a listener which applies the given block
        request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
          end})
      end
    end

    # def test_PFIF_instruction_txn
    #   submerchantCreditHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'submerchantName'=>'001',
    #     'fundsTransferId'=>'00003',
    #     'amount'=>'10000',
    #     'accountInfo' => {'accType'=>'Checking','accNum'=>'123456789012','routingNum'=>'114567895'}
    #   }
    #
    #   vendorCreditHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'vendorName'=>'001',
    #     'fundsTransferId'=>'00007',
    #     'amount'=>'7000',
    #
    #     'accountInfo' => {'accType'=>'Checking','accNum'=>'123456789012','routingNum'=>'114567895'}
    #   }
    #
    #   payFacCreditHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'fundsTransferId'=>'00001',
    #     'amount'=>'1000',
    #
    #   }
    #
    #   reserveCreditHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'fundsTransferId'=>'00005',
    #     'amount'=>'50000',
    #
    #   }
    #
    #   physicalCheckCreditHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'fundsTransferId'=>'00009',
    #     'amount'=>'9000',
    #
    #   }
    #
    #   submerchantDebitHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'submerchantName'=>'001',
    #     'fundsTransferId'=>'00003',
    #     'amount'=>'10000',
    #     'accountInfo' => {'accType'=>'Checking','accNum'=>'123456789012','routingNum'=>'114567895'}
    #   }
    #
    #   vendorDebitHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'vendorName'=>'001',
    #     'fundsTransferId'=>'00007',
    #     'amount'=>'7000',
    #
    #     'accountInfo' => {'accType'=>'Checking','accNum'=>'123456789012','routingNum'=>'114567895'}
    #   }
    #
    #   payFacDebitHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'fundsTransferId'=>'00001',
    #     'amount'=>'1000',
    #
    #   }
    #
    #   reserveDebitHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'fundsTransferId'=>'00005',
    #     'amount'=>'50000',
    #
    #   }
    #
    #   physicalCheckDebitHash = {
    #     'reportGroup'=>'Planets',
    #     'orderId'=>'12344',
    #     'id' => '006',
    #     'fundingSubmerchantId'=>'123456',
    #     'fundsTransferId'=>'00009',
    #     'amount'=>'9000',
    #
    #   }
    #
    #   path = "/tmp/litle-sdk-for-ruby/cert/"
    #
    #   request = LitleRequest.new({'sessionId'=>'8675309'})
    #   request.create_new_litle_request(path)
    #   batch = LitleBatchRequest.new
    #   batch.create_new_batch(path)
    #
    #   batch.submerchant_credit(submerchantCreditHash)
    #   batch.payFac_credit(payFacCreditHash)
    #   batch.vendor_credit(vendorCreditHash)
    #   batch.reserve_credit(reserveCreditHash)
    #   batch.physical_check_credit(physicalCheckCreditHash)
    #   batch.submerchant_debit(submerchantDebitHash)
    #   batch.payFac_debit(payFacDebitHash)
    #   batch.vendor_debit(vendorDebitHash)
    #   batch.reserve_debit(reserveDebitHash)
    #   batch.physical_check_debit(physicalCheckDebitHash)
    #
    #   #close the batch, indicating we plan to add no more transactions
    #   batch.close_batch()
    #   #add the batch to the LitleRequest
    #   request.commit_batch(batch)
    #   #finish the Litle Request, indicating we plan to add no more batches
    #   request.finish_request
    #
    #   #send the batch files at the given directory over sFTP
    #   request.send_to_litle
    #
    #   #grab the expected number of responses from the sFTP server and save them to the given path
    #   request.get_responses_from_server()
    #
    #   count = 0
    #   #process the responses from the server with a listener which applies the given block
    #   request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
    #     assert_not_nil transaction["litleTxnId"] =~ /\d+/
    #     assert_not_nil transaction["response"] =~ /\d+/
    #     assert_not_nil transaction["message"]
    #     count+=1
    #     end})
    #   assert_equal 10, count
    # end
    
    def test_echeck_pre_note_all
      omit_if(LitleBatchCertTest.preliveStatus.downcase == 'down')
      
      billToAddress = {'name'=>'Bob','city'=>'lowell','state'=>'MA','email'=>'litle.com'}        
      echeckSuccess = {'accType'=>'Corporate','accNum'=>'1092969901','routingNum'=>'011075150'}
      echeckRoutErr = {'accType'=>'Checking','accNum'=>'6099999992','routingNum'=>'053133052'}
      echeckAccErr = {'accType'=>'Corporate','accNum'=>'10@2969901','routingNum'=>'011100012'}
  
      echeckPreNoteSaleHashSuccess = {
        'merchantId' => '0180',
        'version'=>'9.3',
        'reportGroup'=>'Planets',
        'orderId'=>'000',
        'id' => '006',
        'orderSource'=>'ecommerce',
        'billToAddress'=> billToAddress,
        'echeck' => echeckSuccess
      }
      
      echeckPreNoteSaleHashErrRout = {
        'merchantId' => '0180',
        'version'=>'9.3',
        'reportGroup'=>'Planets',
        'orderId'=>'900',
        'id' => '006',
        'orderSource'=>'ecommerce',
        'billToAddress'=> billToAddress,
        'echeck' => echeckRoutErr
      }
            
      echeckPreNoteSaleHashErrAcc = {
        'merchantId' => '0180',
        'version'=>'9.3',
        'reportGroup'=>'Planets',
        'orderId'=>'301',
        'id' => '006',
        'orderSource'=>'ecommerce',
        'billToAddress'=> billToAddress,
        'echeck' => echeckAccErr
      }
  
      echeckPreNoteCreditHashSuccess = {
        'merchantId' => '0180',
        'version'=>'9.3',
        'reportGroup'=>'Planets',
        'orderId'=>'000',
        'id' => '006',
        'orderSource'=>'ecommerce',
        'billToAddress'=>  billToAddress,
        'echeck' => echeckSuccess
      }
      
      echeckPreNoteCreditHashErrRout = {
        'merchantId' => '0180',
        'version'=>'9.3',
        'reportGroup'=>'Planets',
        'orderId'=>'900',
        'id' => '006',
        'orderSource'=>'ecommerce',
        'billToAddress'=>  billToAddress,
        'echeck' => echeckRoutErr
      }
            
      echeckPreNoteCreditHashErrAcc = {
        'merchantId' => '101',
        'version'=>'9.3',
        'reportGroup'=>'Planets',
        'orderId'=>'301',
        'id' => '006',
        'orderSource'=>'ecommerce',
        'billToAddress'=>  billToAddress,
        'echeck' => echeckAccErr
      }
  
      path = "/tmp/litle-sdk-for-ruby/cert/"
  
      request = LitleRequest.new({'sessionId'=>'8675309'})
  
      request.create_new_litle_request(path)
      batch = LitleBatchRequest.new
      batch.create_new_batch(path)
  
      batch.echeck_pre_note_sale(echeckPreNoteSaleHashSuccess)
      batch.echeck_pre_note_sale(echeckPreNoteSaleHashErrRout)
      batch.echeck_pre_note_sale(echeckPreNoteSaleHashErrAcc)
      batch.echeck_pre_note_credit(echeckPreNoteSaleHashSuccess)
      batch.echeck_pre_note_credit(echeckPreNoteSaleHashErrRout)
      batch.echeck_pre_note_credit(echeckPreNoteSaleHashErrAcc)
  
      #close the batch, indicating we plan to add no more transactions
      batch.close_batch()
      #add the batch to the LitleRequest
      request.commit_batch(batch)
      #finish the Litle Request, indicating we plan to add no more batches
      request.finish_request
  
      #send the batch files at the given directory over sFTP
      request.send_to_litle
  
      request.get_responses_from_server()
  
      count = 0
      #process the responses from the server with a listener which applies the given block
      request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
        assert_not_nil transaction["litleTxnId"] =~ /\d+/
        assert_not_nil transaction["message"]
        assert_not_nil transaction["response"]
        count+=1
        end})
      assert_equal 6,count
    end

  end
end