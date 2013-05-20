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
require_relative 'Configuration'

#
# This class creates a new batch to which Litle XML transactions are added.
# The batch is stored in the local file system until it is ready to be sent
# to Litle.
#
module LitleOnline

  class LitleBatchRequest
    def initialize
      #load configuration data
      @config_hash = Configuration.new.config
      
      @txn_counts = { auth:{ authCount:0, authAmount:0 },
                      sale:{ saleCount:0, saleAmount:0 },
                      credit:{ creditCount:0, creditAmount:0 },
                      registerTokenRequest:0,
                      captGivenAuth:{ captGivenCount:0, captGivenAmount:0 },
                      forceCapture:{ forceCaptCount:0, forceCaptAmount:0 },
                      authReversal:{ authReversalCount:0, authReversalAmount:0 },
                      capture:{ captureCount:0, captureAmount:0 },
                      void:{ voidCount:0, voidAmount:0 },
                      echeckVoid:0,
                      echeckVerification:{ echeckVerificationCount:0, echeckVerificationAmount:0 },
                      echeckCredit:{ echeckCreditCount:0, echeckCreditAmount:0 },
                      echeckRedeposit:{ echeckRedepositCount:0, echeckRedepositAmount:0 },
                      echeckSale:{ echeckSaleCount:0, echeckSaleAmount:0 },
                      updateCCNumOnToken:{ updateCCNumOnTokenCount:0 }
      }
      @litle_request = LitleRequest.new
    end
    
    def create_new_batch(path)
      ts = Time::now.to_i.to_s
      File.open(path + 'batch_' + ts + '.lb', 'w') do |file|
        file.puts("<litleBatch ")
      end
      
    end
    
    def authorization(options)
      transaction = @litle_request.authorization(options)
      @txn_counts[:auth][:authCount] += 1
      @txn_counts[:auth][:authAmount] += options['amount'].to_i
        
      #TODO append transaction to file if a batch exists else create a new batch and add this transaction
    end
    
    def sale(options)
      transaction = @litle_request.sale(options)
      @txn_counts[:sale][:saleCount] += 1
      @txn_counts[:sale][:saleAmount] += options['amount'].to_i
      
      #TODO append transaction to file if a batch exists else create a new batch and add this transaction
    end
    
    # def add_txn_to_batch(transaction, options)
      # case transaction
      # when Authorization
        # add_transaction_info(transaction, options)
        # @txn_counts[:auth][:authCount] += 1
        # @txn_counts[:auth][:authAmount] += options['amount'].to_i
#       
      # when Sale
        # add_transaction_info(transaction, options)
        # @txn_counts[:sale][:saleCount] += 1
        # @txn_counts[:sale][:saleAmount] += options['amount'].to_i
#       
      # when Credit
        # add_transaction_info(transaction, options)
        # @txn_counts[:credit][:creditCount] += 1
        # @txn_counts[:credit][:creditAmount] += options['amount'].to_i
#         
      # when RegisterTokenRequest
        # add_transaction_info(transaction, options)
        # @txn_counts[:registerTokenRequest] += 1
#       
      # when CaptureGivenAuth
        # add_transaction_info(transaction, options)
        # @txn_counts[:captGivenAuth][:captGivenCount] += 1
        # @txn_counts[:captGivenAuth][:captGivenAmount] += options['amount'].to_i
#       
      # when ForceCapture
        # add_transaction_info(transaction, options)
        # @txn_counts[:forceCapture][:forceCaptureCount] += 1
        # @txn_counts[:forceCapture][:forceCaptureAmount] += options['amount'].to_i
#       
      # when AuthReversal
        # # add_transaction_info(transaction, options)
        # @txn_counts[:authReversal][:authReversalCount] += 1
        # @txn_counts[:authReversal][:authReversalAmount] += options['amount'].to_i
#       
      # when Capture
        # add_transaction_info(transaction, options)
        # @txn_counts[:capture][:captureCount] += 1
        # @txn_counts[:capture][:captureAmount] += options['amount'].to_i
#       
      # when Void
        # add_transaction_info(transaction, options)
        # @txn_counts[:void][:voidCount] += 1
        # @txn_counts[:void][:voidAmount] += options['amount'].to_i
#         
      # when EcheckVoid
        # add_transaction_info(transaction, options)
        # @txn_counts[:echeckVoid][:echeckVoidCount] += 1
#         
      # when EcheckVerification
        # add_transaction_info(transaction, options)
        # @txn_counts[:echeckVerification][:echeckVerificationCount] += 1
        # @txn_counts[:echeckVerification][:echeckVerificationAmount] += options['amount'].to_i
#       
      # else
        # puts 'no txn match'
      # end
#     
#     
#    end
    
    def get_counts_and_amounts
      return @txn_counts
    end
    
   
    
  end
end
