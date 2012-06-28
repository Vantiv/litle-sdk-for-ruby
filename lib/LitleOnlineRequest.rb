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
  
    def authorization(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      authorization = Authorization.new
      authorization.reportGroup = get_report_group(hash_in)
      authorization.transactionId = hash_in['id']
      authorization.customerId = hash_in['customerId']
      
      authorization.litleTxnId = hash_in['litleTxnId']
      authorization.orderId = hash_in['orderId']
      authorization.amount = hash_in['amount']
      authorization.orderSource = hash_in['orderSource']
      authorization.customerInfo = CustomerInfo.from_hash(hash_in)
      authorization.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      authorization.shipToAddress = Contact.from_hash(hash_in,'shipToAddress')
      authorization.card = Card.from_hash(hash_in)
      authorization.paypal = PayPal.from_hash(hash_in,'paypal')
      authorization.token = CardToken.from_hash(hash_in,'token')
      authorization.paypage = CardPaypage.from_hash(hash_in,'paypage')
      authorization.billMeLaterRequest = BillMeLaterRequest.from_hash(hash_in)
      authorization.cardholderAuthentication = FraudCheck.from_hash(hash_in)
      authorization.processingInstructions = ProcessingInstructions.from_hash(hash_in)
      authorization.pos = Pos.from_hash(hash_in)
      authorization.customBilling = CustomBilling.from_hash(hash_in)
      authorization.taxType = hash_in['taxType']
      authorization.enhancedData = EnhancedData.from_hash(hash_in)
      authorization.amexAggregatorData = AmexAggregatorData.from_hash(hash_in)
      authorization.allowPartialAuth = hash_in['allowPartialAuth']
      authorization.healthcareIIAS = HealthcareIIAS.from_hash(hash_in)
      authorization.filtering = Filtering.from_hash(hash_in)
      authorization.merchantData = MerchantData.from_hash(hash_in)
      authorization.recyclingRequest = RecyclingRequest.from_hash(hash_in)
      authorization.fraudFilterOverride = hash_in['fraudFilterOverride']
      
      request.authorization = authorization
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def sale(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      sale = Sale.new
      sale.reportGroup = get_report_group(hash_in)
      sale.transactionId = hash_in['id']
      sale.customerId = hash_in['customerId']
      
      sale.litleTxnId = hash_in['litleTxnId']
      sale.orderId = hash_in['orderId']
      sale.amount = hash_in['amount']
      sale.orderSource = hash_in['orderSource']
      sale.customerInfo = CustomerInfo.from_hash(hash_in)
      sale.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      sale.shipToAddress = Contact.from_hash(hash_in,'shipToAddress')
      sale.card = Card.from_hash(hash_in)
      sale.paypal = PayPal.from_hash(hash_in,'paypal')
      sale.token = CardToken.from_hash(hash_in,'token')
      sale.paypage = CardPaypage.from_hash(hash_in,'paypage')
      sale.billMeLaterRequest = BillMeLaterRequest.from_hash(hash_in)
      sale.fraudCheck = FraudCheck.from_hash(hash_in,'fraudCheck')
      sale.cardholderAuthentication = FraudCheck.from_hash(hash_in,'cardholderAuthentication')
      sale.customBilling = CustomBilling.from_hash(hash_in)
      sale.taxType = hash_in['taxType']
      sale.enhancedData = EnhancedData.from_hash(hash_in)
      sale.processingInstructions = ProcessingInstructions.from_hash(hash_in)
      sale.pos = Pos.from_hash(hash_in)
      sale.payPalOrderComplete = hash_in['paPpalOrderComplete']
      sale.payPalNotes = hash_in['payPalNotes']
      sale.amexAggregatorData = AmexAggregatorData.from_hash(hash_in)
      sale.allowPartialAuth = hash_in['allowPartialAuth']
      sale.healthcareIIAS = HealthcareIIAS.from_hash(hash_in)
      sale.filtering = Filtering.from_hash(hash_in)
      sale.merchantData = MerchantData.from_hash(hash_in)
      sale.recyclingRequest = RecyclingRequest.from_hash(hash_in)
      sale.fraudFilterOverride = hash_in['fraudFilterOverride']
      
      request.sale = sale
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def auth_reversal(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      auth_reversal = AuthReversal.new
      auth_reversal.reportGroup = get_report_group(hash_in)
      auth_reversal.transactionId = hash_in['id']
      auth_reversal.customerId = hash_in['customerId']
        
      auth_reversal.litleTxnId = hash_in['litleTxnId']
      auth_reversal.amount = hash_in['amount']
      auth_reversal.payPalNotes = hash_in['payPalNotes']
      auth_reversal.actionReason = hash_in['actionReason']
  
      request.authReversal = auth_reversal
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def credit(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      credit = Credit.new
      credit.reportGroup = get_report_group(hash_in)
      credit.transactionId = hash_in['id']
      credit.customerId = hash_in['customerId']
        
      credit.litleTxnId = hash_in['litleTxnId']
      credit.orderId = hash_in['orderId']
      credit.amount = hash_in['amount']
      credit.orderSource = hash_in['orderSource']
      credit.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      credit.card = Card.from_hash(hash_in)
      credit.paypal = CreditPayPal.from_hash(hash_in,'paypal')
      credit.token = CardToken.from_hash(hash_in,'token')
      credit.paypage = CardPaypage.from_hash(hash_in,'paypage')
      credit.customBilling = CustomBilling.from_hash(hash_in)
      credit.taxType = hash_in['taxType']
      credit.billMeLaterRequest = BillMeLaterRequest.from_hash(hash_in)
      credit.enhancedData = EnhancedData.from_hash(hash_in)
      credit.processingInstructions = ProcessingInstructions.from_hash(hash_in)
      credit.pos = Pos.from_hash(hash_in)
      credit.amexAggregatorData = AmexAggregatorData.from_hash(hash_in)
      credit.payPalNotes = hash_in['payPalNotes']
      credit.actionReason = hash_in['actionReason']
  
      request.credit = credit
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def register_token_request(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      token_request = RegisterTokenRequest.new
      token_request.reportGroup = get_report_group(hash_in)
      token_request.transactionId = hash_in['id']
      token_request.customerId = hash_in['customerId']
  
      token_request.orderId = hash_in['orderId']
      token_request.accountNumber = hash_in['accountNumber']
      token_request.echeckForToken = EcheckForToken.from_hash(hash_in)
      token_request.paypageRegistrationId = hash_in['paypageRegistrationId']
      
      request.registerTokenRequest = token_request
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def force_capture(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      force_capture = ForceCapture.new
      force_capture.reportGroup = get_report_group(hash_in)
      force_capture.transactionId = hash_in['id']
      force_capture.customerId = hash_in['customerId']
  
      force_capture.orderId = hash_in['orderId']
      force_capture.amount = hash_in['amount']
      force_capture.orderSource = hash_in['orderSource']
      force_capture.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      force_capture.card = Card.from_hash(hash_in)
      force_capture.token = CardToken.from_hash(hash_in,'token')
      force_capture.paypage = CardPaypage.from_hash(hash_in,'paypage')
      force_capture.customBilling = CustomBilling.from_hash(hash_in)
      force_capture.taxType = hash_in['taxType']
      force_capture.enhancedData = EnhancedData.from_hash(hash_in)
      force_capture.processingInstructions = ProcessingInstructions.from_hash(hash_in)
      force_capture.pos = Pos.from_hash(hash_in)
      force_capture.amexAggregatorData = AmexAggregatorData.from_hash(hash_in)
  
      request.forceCapture = force_capture
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)    
    end
  
    def capture(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      capture = Capture.new
      capture.reportGroup = get_report_group(hash_in)
      capture.transactionId = hash_in['id']
      capture.customerId = hash_in['customerId']
  
      capture.partial = hash_in['partial']
      capture.litleTxnId = hash_in['litleTxnId']
      capture.amount = hash_in['amount']
      capture.enhancedData = EnhancedData.from_hash(hash_in)
      capture.processingInstructions = ProcessingInstructions.from_hash(hash_in)
      capture.payPalOrderComplete = hash_in['payPalOrderComplete']
      capture.payPalNotes = hash_in['payPalNotes']
  
      request.captureTxn = capture
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)    
    end
  
    def capture_given_auth(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      capture_given_auth = CaptureGivenAuth.new
      capture_given_auth.reportGroup = get_report_group(hash_in)
      capture_given_auth.transactionId = hash_in['id']
      capture_given_auth.customerId = hash_in['customerId']
  
      capture_given_auth.orderId = hash_in['orderId']
      capture_given_auth.authInformation = AuthInformation.from_hash(hash_in)
      capture_given_auth.amount = hash_in['amount']
      capture_given_auth.orderSource = hash_in['orderSource']
      capture_given_auth.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      capture_given_auth.shipToAddress = Contact.from_hash(hash_in,'shipToAddress')
      capture_given_auth.card = Card.from_hash(hash_in)
      capture_given_auth.token = CardToken.from_hash(hash_in,'token')
      capture_given_auth.paypage = CardPaypage.from_hash(hash_in,'paypage')
      capture_given_auth.customBilling = CustomBilling.from_hash(hash_in)
      capture_given_auth.taxType = hash_in['taxType']
      capture_given_auth.billMeLaterRequest = BillMeLaterRequest.from_hash(hash_in)
      capture_given_auth.enhancedData = EnhancedData.from_hash(hash_in)
      capture_given_auth.processingInstructions = ProcessingInstructions.from_hash(hash_in)
      capture_given_auth.pos = Pos.from_hash(hash_in)
      capture_given_auth.amexAggregatorData = AmexAggregatorData.from_hash(hash_in)
  
      request.captureGivenAuth = capture_given_auth
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)    
    end
  
    def echeck_redeposit(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      echeck_redeposit = EcheckRedeposit.new
      echeck_redeposit.reportGroup = get_report_group(hash_in)
      echeck_redeposit.transactionId = hash_in['id']
      echeck_redeposit.customerId = hash_in['customerId']
  
      echeck_redeposit.litleTxnId = hash_in['litleTxnId']
      echeck_redeposit.echeck = Echeck.from_hash(hash_in)
      echeck_redeposit.echeckToken = EcheckToken.from_hash(hash_in)
  
      request.echeckRedeposit = echeck_redeposit
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)    
    end
  
    def echeck_sale(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      echeck_sale = EcheckSale.new
      echeck_sale.reportGroup = get_report_group(hash_in)
      echeck_sale.transactionId = hash_in['id']
      echeck_sale.customerId = hash_in['customerId']
  
      echeck_sale.litleTxnId = hash_in['litleTxnId']
      echeck_sale.orderId = hash_in['orderId']
      echeck_sale.verify = hash_in['verify']
      echeck_sale.amount = hash_in['amount']
      echeck_sale.orderSource = hash_in['orderSource']
      echeck_sale.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      echeck_sale.shipToAddress = Contact.from_hash(hash_in,'shipToAddress')
      echeck_sale.echeck = Echeck.from_hash(hash_in)
      echeck_sale.echeckToken = EcheckToken.from_hash(hash_in)
      echeck_sale.customBilling = CustomBilling.from_hash(hash_in)
  
      request.echeckSale = echeck_sale
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def echeck_credit(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      echeck_credit = EcheckCredit.new
      echeck_credit.reportGroup = get_report_group(hash_in)
      echeck_credit.transactionId = hash_in['id']
      echeck_credit.customerId = hash_in['customerId']
  
      echeck_credit.litleTxnId = hash_in['litleTxnId']
      echeck_credit.orderId = hash_in['orderId']
      echeck_credit.amount = hash_in['amount']
      echeck_credit.orderSource = hash_in['orderSource']
      echeck_credit.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      echeck_credit.echeck = Echeck.from_hash(hash_in)
      echeck_credit.echeckToken = EcheckToken.from_hash(hash_in)
      echeck_credit.customBilling = CustomBilling.from_hash(hash_in)
  
      request.echeckCredit = echeck_credit
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      begin
        xml = request.save_to_xml.to_s
      rescue XML::MappingError => e
        puts e
        response = LitleOnlineResponse.new
        response.message = "The content of element 'echeckCredit' is not complete" 
        return response
      end
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def echeck_verification(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      echeck_verification = EcheckVerification.new
      echeck_verification.reportGroup = get_report_group(hash_in)
      echeck_verification.transactionId = hash_in['id']
      echeck_verification.customerId = hash_in['customerId']
  
      echeck_verification.litleTxnId = hash_in['litleTxnId']
      echeck_verification.orderId = hash_in['orderId']
      echeck_verification.amount = hash_in['amount']
      echeck_verification.orderSource = hash_in['orderSource']
      echeck_verification.billToAddress = Contact.from_hash(hash_in,'billToAddress')
      echeck_verification.echeck = Echeck.from_hash(hash_in)
      echeck_verification.echeckToken = EcheckToken.from_hash(hash_in)
  
      request.echeckVerification = echeck_verification
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
  
    def void(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      void = Void.new
      void.reportGroup = get_report_group(hash_in)
      void.transactionId = hash_in['id']
      void.customerId = hash_in['customerId']
  
      void.litleTxnId = hash_in['litleTxnId']
      void.processingInstructions = ProcessingInstructions.from_hash(hash_in)
  
      request.void = void
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end
    
    def echeck_void(hash_in)
      @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
      @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
      @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
  
      request = OnlineRequest.new
      void = EcheckVoid.new
      void.reportGroup = get_report_group(hash_in)
      void.transactionId = hash_in['id']
      void.customerId = hash_in['customerId']
  
      void.litleTxnId = hash_in['litleTxnId']
  
      request.echeckVoid = void
      
      authentication = Authentication.new
      authentication.user = get_user(hash_in)
      authentication.password = get_password(hash_in)
      request.authentication = authentication
      
      request.merchantId = get_merchant_id(hash_in)
      request.version = get_version(hash_in)
      request.xmlns = "http://www.litle.com/schema"
      request.merchantSdk = get_merchant_sdk(hash_in)
  
      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end

  
    private
  
    def get_merchant_id(hash_in)
      if (hash_in['merchantId'] == nil)
        return @config_hash['currency_merchant_map']['DEFAULT']
      else
        return hash_in['merchantId']
      end
    end
    
    def get_version(hash_in)
      if (hash_in['version'] == nil)
        return @config_hash['version']
      else
        return hash_in['version']
      end
    end
    
    def get_merchant_sdk(hash_in)
      if(!hash_in['merchantSdk'])
        return 'Ruby;8.13.2'
      else
        return hash_in['merchantSdk']
      end    
    end
  
    def get_report_group(hash_in)
      if (!hash_in['reportGroup'])
        return @config_hash['default_report_group']
      else
        return hash_in['reportGroup']
      end
    end
    
    def get_user(hash_in)
      if (hash_in['user'] == nil)
        return @config_hash['user']
      else
        return hash_in['user']
      end
    end
    
    def get_password(hash_in)
      if (hash_in['password'] == nil)
        return @config_hash['password']
      else
        return hash_in['password']
      end
    end
  end
end