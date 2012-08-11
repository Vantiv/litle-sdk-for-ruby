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
# This class does all the heavy lifting of mapping the Ruby hash into Litle XML format
# It also handles validation looking for missing or incorrect fields
#contains the methods to properly create each transaction type
#
module LitleOnline

  class LitleOnlineRequest
    def initialize
      #load configuration data
      @config_hash = Configuration.new.config
    end

    def authorization(options)
      transaction = Authorization.new
      add_transaction_info(transaction, options)

      commit(transaction, :authorization, options)
    end

    def sale(options)
      transaction = Sale.new
      add_transaction_info(transaction, options)

      transaction.fraudCheck          = FraudCheck.from_hash(options,'fraudCheck')
      transaction.payPalOrderComplete = options['paPpalOrderComplete']
      transaction.payPalNotes         = options['payPalNotes']

      commit(transaction, :sale, options)
    end

    def auth_reversal(options)
      transaction = AuthReversal.new

      transaction.litleTxnId    = options['litleTxnId']
      transaction.amount        = options['amount']
      transaction.payPalNotes   = options['payPalNotes']
      transaction.actionReason  = options['actionReason']

      commit(transaction, :authReversal, options)
    end

    def credit(options)
      transaction = Credit.new
      add_order_info(transaction, options)

      transaction.litleTxnId          = options['litleTxnId']
      transaction.customBilling       = CustomBilling.from_hash(options)
      transaction.billMeLaterRequest  = BillMeLaterRequest.from_hash(options)
      transaction.payPalNotes         = options['payPalNotes']
      transaction.actionReason        = options['actionReason']
      transaction.paypal              = CreditPayPal.from_hash(options,'paypal')

      commit(transaction, :credit, options)
    end

    def register_token_request(options)
      transaction = RegisterTokenRequest.new

      transaction.orderId               = options['orderId']
      transaction.accountNumber         = options['accountNumber']
      transaction.echeckForToken        = EcheckForToken.from_hash(options)
      transaction.paypageRegistrationId = options['paypageRegistrationId']

      commit(transaction, :registerTokenRequest, options)
    end

    def force_capture(options)
      transaction = ForceCapture.new
      transaction.customBilling = CustomBilling.from_hash(options)

      add_order_info(transaction, options)

      commit(transaction, :forceCapture, options)
    end

    def capture(options)
      transaction = Capture.new

      transaction.partial                 = options['partial']
      transaction.litleTxnId              = options['litleTxnId']
      transaction.amount                  = options['amount']
      transaction.enhancedData            = EnhancedData.from_hash(options)
      transaction.processingInstructions  = ProcessingInstructions.from_hash(options)
      transaction.payPalOrderComplete     = options['payPalOrderComplete']
      transaction.payPalNotes             = options['payPalNotes']

      commit(transaction, :captureTxn, options)
    end

    def capture_given_auth(options)
      transaction = CaptureGivenAuth.new
      add_order_info(transaction, options)

      transaction.authInformation    = AuthInformation.from_hash(options)
      transaction.shipToAddress      = Contact.from_hash(options,'shipToAddress')
      transaction.customBilling      = CustomBilling.from_hash(options)
      transaction.billMeLaterRequest = BillMeLaterRequest.from_hash(options)

      commit(transaction, :captureGivenAuth, options)
    end

    def void(options)
      transaction = Void.new

      transaction.litleTxnId             = options['litleTxnId']
      transaction.processingInstructions = ProcessingInstructions.from_hash(options)

      commit(transaction, :void, options)
    end

    def echeck_redeposit(options)
      transaction = EcheckRedeposit.new
      add_echeck(transaction, options)

      transaction.litleTxnId = options['litleTxnId']

      commit(transaction, :echeckRedeposit, options)
    end

    def echeck_sale(options)
      transaction = EcheckSale.new
      add_echeck(transaction, options)
      add_echeck_order_info(transaction, options)

      transaction.verify        = options['verify']
      transaction.shipToAddress = Contact.from_hash(options,'shipToAddress')
      transaction.customBilling = CustomBilling.from_hash(options)

      commit(transaction, :echeckSale, options)
    end

    def echeck_credit(options)
      transaction = EcheckCredit.new
      transaction.customBilling = CustomBilling.from_hash(options)

      add_echeck_order_info(transaction, options)
      add_echeck(transaction, options)

      begin
        commit(transaction, :echeckCredit, options)
      rescue XML::MappingError => e
        puts e
        response = LitleOnlineResponse.new
        response.message = "The content of element 'echeckCredit' is not complete"
        return response
      end
    end

    def echeck_verification(options)
      transaction = EcheckVerification.new

      add_echeck_order_info(transaction, options)
      add_echeck(transaction, options)

      commit(transaction, :echeckVerification, options)
    end

    def echeck_void(options)
      transaction = EcheckVoid.new
      transaction.litleTxnId = options['litleTxnId']

      commit(transaction, :echeckVoid, options)
    end

    private

    def add_account_info(transaction, options)
      transaction.reportGroup   = get_report_group(options)
      transaction.transactionId = options['id']
      transaction.customerId    = options['customerId']
    end

    def add_transaction_info(transaction, options)
      transaction.litleTxnId                = options['litleTxnId']
      transaction.customerInfo              = CustomerInfo.from_hash(options)
      transaction.shipToAddress             = Contact.from_hash(options,'shipToAddress')
      transaction.billMeLaterRequest        = BillMeLaterRequest.from_hash(options)
      transaction.cardholderAuthentication  = FraudCheck.from_hash(options)
      transaction.allowPartialAuth          = options['allowPartialAuth']
      transaction.healthcareIIAS            = HealthcareIIAS.from_hash(options)
      transaction.filtering                 = Filtering.from_hash(options)
      transaction.merchantData              = MerchantData.from_hash(options)
      transaction.recyclingRequest          = RecyclingRequest.from_hash(options)
      transaction.fraudFilterOverride       = options['fraudFilterOverride']
      transaction.customBilling             = CustomBilling.from_hash(options)
      transaction.paypal                    = PayPal.from_hash(options,'paypal')

      add_order_info(transaction, options)
    end

    def add_order_info(transaction, options)
      transaction.amount                  = options['amount']
      transaction.orderId                 = options['orderId']
      transaction.orderSource             = options['orderSource']
      transaction.taxType                 = options['taxType']
      transaction.billToAddress           = Contact.from_hash(options,'billToAddress')
      transaction.enhancedData            = EnhancedData.from_hash(options)
      transaction.processingInstructions  = ProcessingInstructions.from_hash(options)
      transaction.pos                     = Pos.from_hash(options)
      transaction.amexAggregatorData      = AmexAggregatorData.from_hash(options)
      transaction.card                    = Card.from_hash(options)
      transaction.token                   = CardToken.from_hash(options,'token')
      transaction.paypage                 = CardPaypage.from_hash(options,'paypage')
    end

    def add_echeck_order_info(transaction, options)
      transaction.litleTxnId    = options['litleTxnId']
      transaction.orderId       = options['orderId']
      transaction.amount        = options['amount']
      transaction.orderSource   = options['orderSource']
      transaction.billToAddress = Contact.from_hash(options,'billToAddress')
    end

    def add_echeck(transaction, options)
      transaction.echeck      = Echeck.from_hash(options)
      transaction.echeckToken = EcheckToken.from_hash(options)
    end

    def build_request(options)
      request = OnlineRequest.new

      authentication = Authentication.new
      authentication.user     = get_config(:user, options)
      authentication.password = get_config(:password, options)

      request.authentication  = authentication
      request.merchantId      = get_merchant_id(options)
      request.version         = get_config(:version, options)
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
      options['merchantSdk'] || 'Ruby;8.13.2'
    end

    def get_report_group(options)
      options['reportGroup'] || @config_hash['default_report_group']
    end

    def get_config(field, options)
      options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
    end
  end
end
