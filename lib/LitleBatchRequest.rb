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
    include XML::Mapping
    def initialize ()
      #load configuration data
      @config_hash = Configuration.new.config

      @txn_counts = { :id=>nil,
        :merchantId=>nil,
        :auth=>{ :numAuths=>0, :authAmount=>0 },
        :sale=>{ :numSales=>0, :saleAmount=>0 },
        :credit=>{ :numCredits=>0, :creditAmount=>0 },
        :numTokenRegistrations=>0,
        :captureGivenAuth=>{ :numCaptureGivenAuths=>0, :captureGivenAuthAmount=>0 },
        :forceCapture=>{ :numForceCaptures=>0, :forceCaptureAmount=>0 },
        :authReversal=>{ :numAuthReversals=>0, :authReversalAmount=>0 },
        :capture=>{ :numCaptures=>0, :captureAmount=>0 },
        :echeckVerification=>{ :numEcheckVerification=>0, :echeckVerificationAmount=>0 },
        :echeckCredit=>{ :numEcheckCredit=>0, :echeckCreditAmount=>0 },
        :numEcheckRedeposit=>0,
        :numEcheckPreNoteSale=>0,
        :numEcheckPreNoteCredit=>0,
        :payFacCredit=>{ :numPayFacCredit=>0, :payFacCreditAmount=>0 },
        :submerchantCredit=>{ :numSubmerchantCredit=>0, :submerchantCreditAmount=>0 },
        :reserveCredit=>{ :numReserveCredit=>0, :reserveCreditAmount=>0 },
        :vendorCredit=>{ :numVendorCredit=>0, :vendorCreditAmount=>0 },
        :physicalCheckCredit=>{ :numPhysicalCheckCredit=>0, :physicalCheckCreditAmount=>0 },
        :payFacDebit=>{ :numPayFacDebit=>0, :payFacDebitAmount=>0 },
        :submerchantDebit=>{ :numSubmerchantDebit=>0, :submerchantDebitAmount=>0 },
        :reserveDebit=>{ :numReserveDebit=>0, :reserveDebitAmount=>0 },
        :vendorDebit=>{ :numVendorDebit=>0, :vendorDebitAmount=>0 },
        :physicalCheckDebit=>{ :numPhysicalCheckDebit=>0, :physicalCheckDebitAmount=>0 },
        :echeckSale=>{ :numEcheckSales=>0, :echeckSalesAmount=>0 },
        :numUpdateCardValidationNumOnTokens=>0,
        :numAccountUpdates=>0,
        :total=>0,
        :numCancelSubscriptions=>0,
        :numUpdateSubscriptions=>0,
        :numCreatePlans=>0,
        :numUpdatePlans=>0,
        :activate=>{:numActivates=>0, :activateAmount=>0},
        :numDeactivates=>0,
        :load=>{:numLoads=>0, :loadAmount=>0},
        :unload=>{:numUnloads=>0, :unloadAmount=>0},
        :numBalanceInquirys=>0,
        :merchantSdk=>nil
      }
      @litle_txn = LitleTransaction.new
      @path_to_batch = nil
      @txn_file = nil
      @MAX_TXNS_IN_BATCH = 100000
      @au_batch = nil
    end
    #TODO:change this implementation
    def set_merchantId_for_txn_counts(merchantId)
      @txn_counts[:merchantId]=merchantId
    end
      
    def create_new_batch(path)
      ts = Time::now.to_i.to_s
      begin
        ts += Time::now.nsec.to_s
      rescue NoMethodError # ruby 1.8.7 fix
        ts += Time::now.usec.to_s
      end
      if(File.file?(path)) then
        raise ArgumentError, "Entered a file not a path."
      end

      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end
      if(!File.directory?(path)) then
        Dir.mkdir(path)
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

    def has_transactions?
      !@txn_counts[:total].eql?(0)
    end

    def open_existing_batch(pathToBatchFile)
      if(!File.file?(pathToBatchFile)) then
        raise ArgumentError, "No batch file exists at the passed location!"
      end

      if((pathToBatchFile =~ /batch_\d+.closed-\d+\z/) != nil) then
        raise ArgumentError, "The passed batch file is closed!"
      end

      @txn_file = pathToBatchFile + '_txns'
      @path_to_batch = pathToBatchFile
      temp_counts = File.open(@path_to_batch, "rb") { |f| Marshal.load(f) }
      # woops, they opened an AU batch
      if(temp_counts[:numAccountUpdates] != 0) then
        au_batch = LitleAUBatch.new
        au_batch.open_existing_batch(pathToBatchFile)
        initialize()
        create_new_batch(File.dirname(pathToBatchFile))
        @au_batch = au_batch
      elsif
      @txn_counts = temp_counts
      end
    end

    def au_batch?
      !@au_batch.nil?
    end

    def close_batch(txn_location = @txn_file)
      header = build_batch_header(@txn_counts)
      File.rename(@path_to_batch, @path_to_batch + '.closed-' + @txn_counts[:total].to_s)
      @path_to_batch = @path_to_batch + '.closed-' + @txn_counts[:total].to_s
      File.open(@path_to_batch, 'w') do |fo|
        # fo.puts header
        put_header = !au_batch? || has_transactions?
        fo.puts header if put_header
        File.foreach(txn_location) do |li|
          fo.puts li
        end
        # fo.puts('</batchRequest>')
        fo.puts('</batchRequest>')   if put_header
      end
      File.delete(txn_location)
      if(@au_batch != nil) then
        @au_batch.close_batch
      end

    end

    def authorization(options)
      transaction = @litle_txn.authorization(options)
      @txn_counts[:auth][:numAuths] += 1
      @txn_counts[:auth][:authAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :authorization, options)
    end

    def sale(options)
      transaction = @litle_txn.sale(options)
      @txn_counts[:sale][:numSales] += 1
      @txn_counts[:sale][:saleAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :sale, options)
    end

    def credit(options)
      transaction = @litle_txn.credit(options)
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

    def cancel_subscription(options)
      transaction = @litle_txn.cancel_subscription(options)
      @txn_counts[:numCancelSubscriptions] += 1

      add_txn_to_batch(transaction, :cancelSubscription, options)
    end

    def update_subscription(options)
      transaction = @litle_txn.update_subscription(options)
      @txn_counts[:numUpdateSubscriptions] += 1

      add_txn_to_batch(transaction, :updateSubscription, options)
    end

    def create_plan(options)
      transaction = @litle_txn.create_plan(options)
      @txn_counts[:numCreatePlans] += 1

      add_txn_to_batch(transaction, :createPlan, options)
    end

    def update_plan(options)
      transaction = @litle_txn.update_plan(options)
      @txn_counts[:numUpdatePlans] += 1

      add_txn_to_batch(transaction, :updatePlan, options)
    end

    def activate(options)
      transaction = @litle_txn.activate(options)
      @txn_counts[:numActivates] += 1

      add_txn_to_batch(transaction, :activate, options)
    end

    def deactivate(options)
      transaction = @litle_txn.deactivate(options)
      @txn_counts[:numDeactivates] += 1

      add_txn_to_batch(transaction, :deactivate, options)
    end

    def load_request(options)
      transaction = @litle_txn.load_request(options)
      @txn_counts[:numLoads] += 1

      add_txn_to_batch(transaction, :load, options)
    end

    def unload_request(options)
      transaction = @litle_txn.unload_request(options)
      @txn_counts[:numunLoads] += 1

      add_txn_to_batch(transaction, :unload, options)
    end

    def balance_inquiry(options)
      transaction = @litle_txn.balance_inquiry(options)
      @txn_counts[:numBalanceInquirys] += 1

      add_txn_to_batch(transaction, :balanceInquirys, options)
    end

    def register_token_request(options)
      transaction = @litle_txn.register_token_request(options)
      @txn_counts[:numTokenRegistrations] += 1

      add_txn_to_batch(transaction, :numTokenRegistrations, options)
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
      @txn_counts[:captureGivenAuth][:captureGivenAuthAmount] += options['amount'].to_i

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

    def echeck_pre_note_sale(options)
      transaction = @litle_txn.echeck_pre_note_sale(options)
      @txn_counts[:numEcheckPreNoteSale] += 1

      add_txn_to_batch(transaction, :echeckPreNoteSale, options)
    end

    def echeck_pre_note_credit(options)
      transaction = @litle_txn.echeck_pre_note_credit(options)
      @txn_counts[:numEcheckPreNoteCredit] += 1

      add_txn_to_batch(transaction, :echeckPreNoteCredit, options)
    end

    def payFac_credit(options)
      transaction = @litle_txn.payFac_credit(options)
      @txn_counts[:payFacCredit][:numPayFacCredit] += 1
      @txn_counts[:payFacCredit][:payFacCreditAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :payFacCredit, options)
    end

    def submerchant_credit(options)
      transaction = @litle_txn.submerchant_credit(options)
      @txn_counts[:submerchantCredit][:numSubmerchantCredit] += 1
      @txn_counts[:submerchantCredit][:submerchantCreditAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :submerchantCredit, options)
    end

    def reserve_credit(options)
      transaction = @litle_txn.reserve_credit(options)
      @txn_counts[:reserveCredit][:numReserveCredit] += 1
      @txn_counts[:reserveCredit][:reserveCreditAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :reserveCredit, options)
    end

    def vendor_credit(options)
      transaction = @litle_txn.vendor_credit(options)
      @txn_counts[:vendorCredit][:numVendorCredit] += 1
      @txn_counts[:vendorCredit][:vendorCreditAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :vendorCredit, options)
    end

    def physical_check_credit(options)
      transaction = @litle_txn.physical_check_credit(options)
      @txn_counts[:physicalCheckCredit][:numPhysicalCheckCredit] += 1
      @txn_counts[:physicalCheckCredit][:physicalCheckCreditAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :physicalCheckCredit, options)
    end

    def payFac_debit(options)
      transaction = @litle_txn.payFac_debit(options)
      @txn_counts[:payFacDebit][:numPayFacDebit] += 1
      @txn_counts[:payFacDebit][:payFacDebitAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :payFacDebit, options)
    end

    def submerchant_debit(options)
      transaction = @litle_txn.submerchant_debit(options)
      @txn_counts[:submerchantDebit][:numSubmerchantDebit] += 1
      @txn_counts[:submerchantDebit][:submerchantDebitAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :submerchantDebit, options)
    end

    def reserve_debit(options)
      transaction = @litle_txn.reserve_debit(options)
      @txn_counts[:reserveDebit][:numReserveDebit] += 1
      @txn_counts[:reserveDebit][:reserveDebitAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :reserveDebit, options)
    end

    def vendor_debit(options)
      transaction = @litle_txn.vendor_debit(options)
      @txn_counts[:vendorDebit][:numVendorDebit] += 1
      @txn_counts[:vendorDebit][:vendorDebitAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :vendorDebit, options)
    end

    def physical_check_debit(options)
      transaction = @litle_txn.physical_check_debit(options)
      @txn_counts[:physicalCheckDebit][:numPhysicalCheckDebit] += 1
      @txn_counts[:physicalCheckDebit][:physicalCheckDebitAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :physicalCheckDebit, options)
    end

    def echeck_sale(options)
      transaction = @litle_txn.echeck_sale(options)
      @txn_counts[:echeckSale][:numEcheckSales] += 1
      @txn_counts[:echeckSale][:echeckSalesAmount] += options['amount'].to_i

      add_txn_to_batch(transaction, :echeckSale, options)
    end

    def account_update(options)

      if(@au_batch == nil) then
        @au_batch = LitleAUBatch.new
        @au_batch.create_new_batch(File.dirname(@path_to_batch))
      end
      @au_batch.account_update(options)
    end

    def get_counts_and_amounts
      return @txn_counts
    end

    def get_batch_name
      return @path_to_batch
    end

    def get_au_batch
      return @au_batch
    end

    private

    def add_txn_to_batch(transaction, type, options)
      @txn_counts[:total] += 1
      xml = transaction.save_to_xml.to_s
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
      request.numEcheckSales           = @txn_counts[:echeckSale][:numEcheckSales]
      request.echeckSalesAmount        = @txn_counts[:echeckSale][:echeckSalesAmount]
      request.numEcheckRedeposit       = @txn_counts[:numEcheckRedeposit]
      request.numEcheckPreNoteSale     = @txn_counts[:numEcheckPreNoteSale]
      request.numEcheckPreNoteCredit   = @txn_counts[:numEcheckPreNoteCredit]

      request.numPayFacCredit        = @txn_counts[:payFacCredit][:numPayFacCredit]
      request.payFacCreditAmount        = @txn_counts[:payFacCredit][:payFacCreditAmount]
      request.numSubmerchantCredit        = @txn_counts[:submerchantCredit][:numSubmerchantCredit]
      request.submerchantCreditAmount        = @txn_counts[:submerchantCredit][:submerchantCreditAmount]
      request.numReserveCredit        = @txn_counts[:reserveCredit][:numReserveCredit]
      request.reserveCreditAmount        = @txn_counts[:reserveCredit][:reserveCreditAmount]
      request.numVendorCredit        = @txn_counts[:vendorCredit][:numVendorCredit]
      request.vendorCreditAmount        = @txn_counts[:vendorCredit][:vendorCreditAmount]
      request.numPhysicalCheckCredit        = @txn_counts[:physicalCheckCredit][:numPhysicalCheckCredit]
      request.physicalCheckCreditAmount        = @txn_counts[:physicalCheckCredit][:physicalCheckCreditAmount]

      request.numPayFacDebit        = @txn_counts[:payFacDebit][:numPayFacDebit]
      request.payFacDebitAmount        = @txn_counts[:payFacDebit][:payFacDebitAmount]
      request.numSubmerchantDebit        = @txn_counts[:submerchantDebit][:numSubmerchantDebit]
      request.submerchantDebitAmount        = @txn_counts[:submerchantDebit][:submerchantDebitAmount]
      request.numReserveDebit        = @txn_counts[:reserveDebit][:numReserveDebit]
      request.reserveDebitAmount        = @txn_counts[:reserveDebit][:reserveDebitAmount]
      request.numVendorDebit        = @txn_counts[:vendorDebit][:numVendorDebit]
      request.vendorDebitAmount        = @txn_counts[:vendorDebit][:vendorDebitAmount]
      request.numPhysicalCheckDebit        = @txn_counts[:physicalCheckDebit][:numPhysicalCheckDebit]
      request.physicalCheckDebitAmount        = @txn_counts[:physicalCheckDebit][:physicalCheckDebitAmount]

      request.numEcheckCredit          = @txn_counts[:echeckCredit][:numEcheckCredit]
      request.echeckCreditAmount       = @txn_counts[:echeckCredit][:echeckCreditAmount]
      request.numEcheckVerification    = @txn_counts[:echeckVerification][:numEcheckVerification]
      request.echeckVerificationAmount = @txn_counts[:echeckVerification][:echeckVerificationAmount]
      request.numAccountUpdates        = @txn_counts[:numAccountUpdates]
      request.merchantId               = get_merchant_id(options)
      request.id                       = @txn_counts[:id]
      request.numUpdateCardValidationNumOnTokens = @txn_counts[:numUpdateCardValidationNumOnTokens]
      request.numCancelSubscriptions =@txn_counts[:numCancelSubscriptions]
      request.numUpdateSubscriptions =@txn_counts[:numUpdateSubscriptions]
      request.numCreatePlans =@txn_counts[:numCreatePlans]
      request.numUpdatePlans =@txn_counts[:numUpdatePlans]
      request.numActivates =@txn_counts[:activate][:numActivates]
      request.numDeactivates =@txn_counts[:numDeactivates]
      request.activateAmount =@txn_counts[:activate][:activateAmount]
      request.numLoads =@txn_counts[:load][:numLoads]
      request.loadAmount =@txn_counts[:load][:loadAmount]
      request.numUnloads =@txn_counts[:unload][:numLoads]
      request.unloadAmount =@txn_counts[:unload][:unloadAmount]
      request.numBalanceInquirys =@txn_counts[:numBalanceInquirys]
      header = request.save_to_xml.to_s
      header['/>']= '>'

      return header
    end

    def get_config(field, options)
      options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
    end

    def get_merchant_id(options)
      options[:merchantId] || @config_hash['currency_merchant_map']['DEFAULT']
    end
  end

  private

  # IF YOU ARE A MERCHANT, DON'T LOOK HERE. IT'S SCARY!

  class LitleAUBatch
    include XML::Mapping
    def initialize
      #load configuration data
      @config_hash = Configuration.new.config

      @txn_counts = { :id=>nil,
        :merchantId=>nil,
        :numAccountUpdates=>0,
        :total=>0
      }
      @litle_txn = LitleTransaction.new
      @path_to_batch = nil
      @txn_file = nil
      @MAX_TXNS_IN_BATCH = 100000
    end

    def create_new_batch(path)
      ts = Time::now.to_i.to_s
      begin
        ts += Time::now.nsec.to_s
      rescue NoMethodError # ruby 1.8.7 fix
        ts += Time::now.usec.to_s
      end

      if(File.file?(path)) then
        raise ArgumentError, "Entered a file not a path."
      end

      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end
      if(!File.directory?(path)) then
        Dir.mkdir(path)
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
      if(!File.file?(pathToBatchFile)) then
        raise ArgumentError, "No batch file exists at the passed location!"
      end

      if((pathToBatchFile =~ /batch_\d+.closed-\d+\z/) != nil) then
        raise ArgumentError, "The passed batch file is closed!"
      end

      @txn_file = pathToBatchFile + '_txns'
      @path_to_batch = pathToBatchFile
      temp_counts = File.open(@path_to_batch, "rb") { |f| Marshal.load(f) }
      if(temp_counts.keys.size > 4) then
        raise RuntimeException, "Tried to open an AU batch with a non-AU batch file"
      end

      @txn_counts[:id] = temp_counts[:id]
      @txn_counts[:merchantId] = temp_counts[:merchantId]
      @txn_counts[:numAccountUpdates] = temp_counts[:numAccountUpdates]
      @txn_counts[:total] = temp_counts[:total]
    end

    def close_batch(txn_location = @txn_file)
      header = build_batch_header(@txn_counts)

      File.rename(@path_to_batch, @path_to_batch + '.closed-' + @txn_counts[:total].to_s)
      @path_to_batch = @path_to_batch + '.closed-' + @txn_counts[:total].to_s
      File.open(@path_to_batch, 'w') do |fo|
        fo.puts header
        File.foreach(txn_location) do |li|
          fo.puts li
        end
        fo.puts('</batchRequest>')
      end
      File.delete(txn_location)
    end

    def account_update(options)
      transaction = @litle_txn.account_update(options)
      @txn_counts[:numAccountUpdates] += 1

      add_txn_to_batch(transaction, :authorization, options)
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
      xml = transaction.save_to_xml.to_s
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

      request.numAccountUpdates        = @txn_counts[:numAccountUpdates]
      request.merchantId               = get_merchant_id(options)
      request.id                       = @txn_counts[:id]

      header = request.save_to_xml.to_s
      header['/>']= '>'

      return header
    end

    def get_config(field, options)
      options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
    end

    def get_merchant_id(options)
      options['merchantId'] || @config_hash['currency_merchant_map']['DEFAULT']
    end
  end
end
