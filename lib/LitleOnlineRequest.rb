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
# This class handles sending the Litle online request
#
module LitleOnline

  class LitleOnlineRequest
    def initialize
      #load configuration data
      @config_hash = Configuration.new.config
      @litle_transaction = LitleTransaction.new
    end

    def virtual_giftcard(options)
       transaction =@litle_transaction.virtual_giftcard(options)

       commit(transaction, :virtualGiftCard, options)
    end

    def create_plan(options)
       transaction =@litle_transaction.create_plan(options)

       commit(transaction, :createPlan, options)
    end

    def update_plan(options)
       transaction =@litle_transaction.update_plan(options)

       commit(transaction, :updatePlan, options)
    end

    def cancel_subscription(options)
       transaction =@litle_transaction.cancel_subscription(options)

       commit(transaction, :cancelSubscription, options)
    end

    def update_subscription(options)
       transaction =@litle_transaction.update_subscription(options)

       commit(transaction, :updateSubscription, options)
    end

    def activate(options)
      transaction = @litle_transaction.activate(options)

      commit(transaction, :activate, options)
    end 
   
    def deactivate(options)
     transaction = @litle_transaction.deactivate(options)

      commit(transaction, :deactivate, options)
    end

    def load_request(options)
     transaction = @litle_transaction.load_request(options)

      commit(transaction, :load, options)
    end

    def unload_request(options)
     transaction = @litle_transaction.unload_request(options)

      commit(transaction, :unload, options)
    end

    def balance_inquiry(options)
      transaction = @litle_transaction.balance_inquiry(options)

      commit(transaction, :balanceInquiry, options)
    end

    def activate_reversal(options)
      transaction = @litle_transaction.activate_reversal(options)

      commit(transaction, :activateReversal, options)
    end

    def deposit_reversal(options)
      transaction = @litle_transaction.deposit_reversal(options)

      commit(transaction, :depositReversal, options)
    end

    def refund_reversal(options)
      transaction = @litle_transaction.refund_reversal(options)

      commit(transaction, :refundReversal, options)
    end

    def deactivate_reversal(options)
      transaction = @litle_transaction.deactivate_reversal(options)

      commit(transaction, :deactivateReversal, options)
    end

    def load_reversal(options)
      transaction = @litle_transaction.load_reversal(options)

      commit(transaction, :loadReversal, options)
    end

    def unload_reversal(options)
      transaction = @litle_transaction.unload_reversal(options)

      commit(transaction, :unloadReversal, options)
    end
    

    def authorization(options)
      transaction = @litle_transaction.authorization(options)

      commit(transaction, :authorization, options)
    end

    def sale(options)
      transaction = @litle_transaction.sale(options)

      commit(transaction, :sale, options)
    end

    def auth_reversal(options)
      transaction = @litle_transaction.auth_reversal(options)      

      commit(transaction, :authReversal, options)
    end

    def credit(options)
      transaction = @litle_transaction.credit(options)
      
      commit(transaction, :credit, options)
    end

    def register_token_request(options)
      transaction = @litle_transaction.register_token_request(options)

      commit(transaction, :registerTokenRequest, options)
    end
    
    def update_card_validation_num_on_token(options)
   	  transaction = @litle_transaction.update_card_validation_num_on_token(options)
    	
      commit(transaction, :updateCardValidationNumOnToken, options)
    end

    def force_capture(options)
      transaction = @litle_transaction.force_capture(options)
      
      commit(transaction, :forceCapture, options)
    end

    def capture(options)
      transaction = @litle_transaction.capture(options)
      
      commit(transaction, :captureTxn, options)
    end

    def capture_given_auth(options)
      transaction = @litle_transaction.capture_given_auth(options)
      
      commit(transaction, :captureGivenAuth, options)
    end

    def void(options)
      transaction = @litle_transaction.void(options)

      commit(transaction, :void, options)
    end

    def echeck_redeposit(options)
      transaction = @litle_transaction.echeck_redeposit(options)
      
      commit(transaction, :echeckRedeposit, options)
    end

    def echeck_sale(options)
      transaction = @litle_transaction.echeck_sale(options)

      commit(transaction, :echeckSale, options)
    end

    def echeck_credit(options)
      transaction = @litle_transaction.echeck_credit(options)

      begin
        commit(transaction, :echeckCredit, options)
      rescue XML::MappingError => e
        response = LitleOnlineResponse.new
        response.message = "The content of element 'echeckCredit' is not complete"
        return response
      end
    end

    def echeck_verification(options)
      transaction = @litle_transaction.echeck_verification(options)

      commit(transaction, :echeckVerification, options)
    end

    def echeck_void(options)
      transaction = @litle_transaction.echeck_void(options)
      
      commit(transaction, :echeckVoid, options)
    end
    
#    def fraud_check_request(options)
#      transaction = @litle_transaction.fraud_check_request(options)
#            
#      commit(transaction, :fraudCheck, options)
#    end

    private

    def add_account_info(transaction, options)
      if(transaction.respond_to?(:reportGroup))
          transaction.reportGroup   = get_report_group(options)
      end
      if(transaction.respond_to?(:transactionId))	
          transaction.transactionId = options['id']
      end
      if(transaction.respond_to?(:customerId))	
          transaction.customerId    = options['customerId']
      end
    end

    def build_request(options)
      request = OnlineRequest.new

      authentication = Authentication.new
      authentication.user     = get_config(:user, options)
      authentication.password = get_config(:password, options)

      request.authentication  = authentication
      request.merchantId      = get_merchant_id(options)
      request.version         = '9.3'
      request.loggedInUser    = get_logged_in_user(options)
      request.xmlns           = "http://www.litle.com/schema"
      request.merchantSdk     = get_merchant_sdk(options)

      request
    end

    def commit(transaction, type, options)
      configure_connection(options)

      request = build_request(options)

      add_account_info(transaction, options)
      request.send(:"#{type}=", transaction)

      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end

    def configure_connection(options={})
      @config_hash['proxy_addr'] = options['proxy_addr'] unless options['proxy_addr'].nil?
      @config_hash['proxy_port'] = options['proxy_port'] unless options['proxy_port'].nil?
      @config_hash['url']        = options['url']        unless options['url'].nil?
    end

    def get_merchant_id(options)
      options['merchantId'] || @config_hash['currency_merchant_map']['DEFAULT']
    end

    def get_merchant_sdk(options)
      options['merchantSdk'] || 'Ruby;9.3.2'
    end

    def get_report_group(options)
      options['reportGroup'] || @config_hash['default_report_group']
    end

    def get_config(field, options)
      options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
    end
    
    def get_logged_in_user(options)
      options['loggedInUser'] || nil
    end
  end
end
