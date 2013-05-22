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

  class LitleRequest
    include XML::Mapping
    def initialize
      #load configuration data
      @config_hash = Configuration.new.config
      @numBatchRequests
    end
    
    def create_new_litle_request(path)
      ts = Time::now.to_i.to_s
      @path_to_batch = path + 'litle_request_' + ts
      File.open(@path_to_batch, 'a+') do |file|
        file.write("")
      end
    end  
    
    def send_litle_request(*batches)
      
    end

    private
    
    def build_request_header(options)
      header = LitleRequest.new
      
      authentication = Authentication.new
      authenticatio.user
      #request.version =       
    end
    
    def get_config(field, options)
      options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
    end
     
  end
  
  class LitleBatchRequest
    include XML::Mapping
    def initialize
      #load configuration data
      @config_hash = Configuration.new.config
      
      @txn_counts = { id:nil,
                      merchantId:nil,
                      auth:{ numAuths:0, authAmount:0 },
                      sale:{ numSales:0, saleAmount:0 },
                      credit:{ numCredits:0, creditAmount:0 },
                      numTokenReqistrations:0,
                      captureGivenAuth:{ numCaptureGivenAuths:0, captureGivenAmount:0 },
                      forceCapture:{ numForceCaptures:0, forceCaptureAmount:0 },
                      authReversal:{ numAuthReversals:0, authReversalAmount:0 },
                      capture:{ numCaptures:0, captureAmount:0 },
                      echeckVerification:{ numEcheckVerification:0, echeckVerificationAmount:0 },
                      echeckCredit:{ numEcheckCredit:0, echeckCreditAmount:0 },
                      numEcheckRedeposit:0,
                      echeckSale:{ numEcheckSales:0, echeckSaleAmount:0 },
                      numUpdateCardValidationNumOnTokens:0,
                      total:0
      }
      @litle_txn = LitleTransaction.new
      @path_to_batch = nil
      @txn_file = nil
      @MAX_TXNS_IN_BATCH = 500000
    end
    
    def create_new_batch(path)
      ts = Time::now.to_i.to_s
      ts += Time::now.nsec.to_s
      if(File.file?(path)) then
        raise RuntimeError, "Entered a file not a path."
      end
      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end  
      @path_to_batch = path + 'batch_' + ts      
      @txn_file = @path_to_batch + '_txns'
      if(File.file?(@path_to_batch)) then
        create_new_batch(path)
        return
      end
      File.open(@path_to_batch, 'a+') do |file|
        file.write("")
      end
      File.open(@txn_file, 'a+') do |file|
        file.write("")
      end
    end
    
    def open_existing_batch(pathToBatchFile)
      @txn_file = pathToBatchFile + '_txns'
      @path_to_batch = pathToBatchFile
      @txn_counts = File.open(@path_to_batch, "rb") { |f| Marshal.load(f) }
    end
    
    def close_batch(txn_location = @txn_file)
      header = build_batch_header(@txn_counts)
      File.rename(@path_to_batch, @path_to_batch + '.closed')
      File.open(@path_to_batch + '.closed', 'w') do |fo|
        fo.puts header
        File.foreach(txn_location) do |li|
          fo.puts li
        end
        fo.puts('</batchRequest>')
      end
      File.delete(txn_location)
    end
    
    def send_litle_request
      header = build_request_header(options)
        
    end
    
    def authorization(options)
      transaction = @litle_txn.authorization(options)
      @txn_counts[:auth][:numAuths] += 1
      @txn_counts[:auth][:authAmount] += options['amount'].to_i
      
      #TODO need to set the account info needed for each txn
        
      add_txn_to_batch(transaction, :authorization, options)
    end
    
    def sale(options)
      transaction = @litle_txn.sale(options)
      @txn_counts[:sale][:numSales] += 1
      @txn_counts[:sale][:saleAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :sale, options)
    end

    def credit(options)
      transaction = @litle_txn.sale(options)
      @txn_counts[:credit][:numCredits] += 1
      @txn_counts[:credit][:creditAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :credit, options)
    end
    
    def auth_reversal(options)
      transaction = @litle_txn.auth_reversal(options)
      @txn_counts[:authReversal][:numAuthReversals] += 1
      @txn_counts[:authReversal][:authReversalAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :authReversal, options)
    end
    
    def register_token_request(options)
      transaction = @litle_txn.register_token_request(options)
      @txn_counts[:numTokenReqistrations] += 1
      
      add_txn_to_batch(transaction, :numTokenReqistrations, options)
    end
    
    def update_card_validation_num_on_token(options)
      transaction = @litle_txn.update_card_validation_num_on_token(options)
      @txn_counts[:numUpdateCardValidationNumOnTokens] += 1
      
      add_txn_to_batch(transaction, :numUpdateCardValidationNumOnTokens, options)
    end
    
    def force_capture(options)
      transaction = @litle_txn.force_capture(options)
      @txn_counts[:forceCapture][:numForceCaptures] += 1
      @txn_counts[:forceCapture][:forceCaptureAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :forceCapture, options)
    end
    
    def capture(options)
      transaction = @litle_txn.capture(options)
      @txn_counts[:capture][:numCaptures] += 1
      @txn_counts[:capture][:captureAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :capture, options)
    end
    
    def capture_given_auth(options)
      transaction = @litle_txn.capture_given_auth(options)
      @txn_counts[:captureGivenAuth][:numCaptureGivenAuths] += 1
      @txn_counts[:captureGivenAuth][:captureGivenAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :captureGivenAuth, options)
    end
    
    def echeck_verification(options)
      transaction = @litle_txn.echeck_verification(options)
      @txn_counts[:echeckVerification][:numEcheckVerification] += 1
      @txn_counts[:echeckVerification][:echeckVerificationAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :echeckVerification, options)
    end
    
    def echeck_credit(options)
      transaction = @litle_txn.echeck_credit(options)
      @txn_counts[:echeckCredit][:numEcheckCredit] += 1
      @txn_counts[:echeckCredit][:echeckCreditAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :echeckCredit, options)
    end
    
    def echeck_redeposit(options)
      transaction = @litle_txn.echeck_redeposit(options)
      @txn_counts[:numEcheckRedeposit] += 1
      
      add_txn_to_batch(transaction, :echeckRedeposit, options)
    end
    
    def echeck_sale(options)
      transaction = @litle_txn.echeck_sale(options)
      @txn_counts[:echeckSale][:numEcheckSales] += 1
      @txn_counts[:echeckSale][:echeckSaleAmount] += options['amount'].to_i
      
      add_txn_to_batch(transaction, :echeckSale, options)
    end
    
    def get_counts_and_amounts
      return @txn_counts
    end
    def get_batch_name
      return @path_to_batch
    end
    
    private
    
    def add_txn_to_batch(transaction, type, options)
      @txn_counts[:total] += 1
      xml = transaction.save_to_xml
      
      File.open(@txn_file, 'a+') do |file|
        file.write(xml)
      end
      # save counts and amounts to batch file
      File.open(@path_to_batch, 'wb'){|f| Marshal.dump(@txn_counts, f)}
      if(@txn_counts[:total] >= @MAX_TXNS_IN_BATCH) then
        close_batch()
        path = File.dirname(@path_to_batch)
        initialize
        create_new_batch(path)
      end
    end
    
    def build_batch_header(options)
      request = BatchRequest.new
      
      @txn_counts.sort_by { |txn,val| txn }
      
      request.numAuths                 = @txn_counts[:auth][:numAuths]
      request.authAmount               = @txn_counts[:auth][:authAmount]
      request.numSales                 = @txn_counts[:sale][:numSales]
      request.saleAmount               = @txn_counts[:sale][:saleAmount]
      request.numCredits               = @txn_counts[:credit][:numCredits]
      request.creditAmount             = @txn_counts[:credit][:creditAmount]
      request.numTokenRegistrations    = @txn_counts[:numTokenRegistrations]
      request.numCaptureGivenAuths     = @txn_counts[:captureGivenAuth][:numCaptureGivenAuths]
      request.captureGivenAuthAmount   = @txn_counts[:captureGivenAuth][:captureGivenAuthAmount]
      request.numForceCaptures         = @txn_counts[:forceCapture][:numForceCaptures]
      request.forceCaptureAmount       = @txn_counts[:forceCapture][:forceCaptureAmount]
      request.numAuthReversals         = @txn_counts[:authReversal][:numAuthReversals]
      request.authReversalAmount       = @txn_counts[:authReversal][:authReversalAmount]
      request.numCaptures              = @txn_counts[:capture][:numCaptures]
      request.captureAmount            = @txn_counts[:capture][:captureAmount]
      request.numEcheckSales           = @txn_counts[:echeckSale][:numEcheckSale]
      request.echeckSaleAmount         = @txn_counts[:echeckSale][:echeckSaleAmount]
      request.numEcheckRedeposit       = @txn_counts[:numEcheckredeposit]
      request.numEcheckCredit          = @txn_counts[:echeckCredit][:numEcheckCredit]
      request.echeckCreditAmount       = @txn_counts[:echeckCredit][:echeckCreditAmount]
      request.numEcheckVerification    = @txn_counts[:echeckVerification][:numEcheckverification]
      request.echeckVerificationAmount = @txn_counts[:echeckVerification][:echeckVerificationAmount]
      request.numUpdateCardValidationNumOnTokens = @txn_counts[:numUpdateCardValidationNumOnTokens]
      request.merchantId             = @txn_counts[:merchantId]
      request.id                     = @txn_counts[:id]
      
      header = request.save_to_xml.to_s
      header['/>']= '>' 

      return header
    end
  end
end
