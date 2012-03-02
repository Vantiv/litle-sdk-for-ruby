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
class LitleOnlineRequest
  def initialize
    #load configuration data
    @config_hash = Configuration.new.config
  end

  def authorization(hash_in)
    is_litle_txn_id_provided = !hash_in['litleTxnId'].nil?
    if(is_litle_txn_id_provided)
      hash_out = {
        :litleTxnId => hash_in['litleTxnId']
      }
    else
      hash_out = {
        :orderId => required_field(hash_in['orderId']),
        :amount =>required_field(hash_in['amount']),
        :orderSource=>required_field(hash_in['orderSource']),
        :customerInfo=>XMLFields.customer_info(optional_field(hash_in['customerInfo'])),
        :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
        :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
        :card=> XMLFields.card_type(optional_field(hash_in['card'])),
        :paypal=>XMLFields.pay_pal(optional_field(hash_in['paypal'])),
        :token=>XMLFields.card_token_type(optional_field(hash_in['token'])),
        :paypage=>XMLFields.card_paypage_type(optional_field(hash_in['paypage'])),
        :billMeLaterRequest=>XMLFields.bill_me_later_request(optional_field(hash_in['billMeLaterRequest'])),
        :cardholderAuthentication=>XMLFields.fraud_check_type(optional_field(hash_in['cardholderAuthentication'])),
        :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions'])),
        :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
        :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
        :taxBilling=>XMLFields.tax_billing(optional_field(hash_in['taxBilling'])),
        :enhancedData=>XMLFields.enhanced_data(optional_field(hash_in['enhancedData'])),
        :amexAggregatorData=>XMLFields.amex_aggregator_data(optional_field(hash_in['amexAggregatorData'])),
        :allowPartialAuth=>hash_in['allowPartialAuth'],
        :healthcareIIAS=>XMLFields.healthcare_iias(optional_field(hash_in['healthcareIIAS'])),
        :filtering=>XMLFields.filtering_type(optional_field(hash_in['filtering'])),
        :merchantData=>XMLFields.filtering_type(optional_field(hash_in['merchantData'])),
        :recyclingRequest=>XMLFields.recycling_request_type(optional_field(hash_in['recyclingRequest']))
      }
    end

    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    if(!is_litle_txn_id_provided)
      choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
      Checker.choice(choice1)
    end
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:authorization => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def sale(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>required_field(hash_in['orderId']),
      :amount =>required_field(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :customerInfo=>XMLFields.customer_info(optional_field(hash_in['customerInfo'])),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :card=> XMLFields.card_type(optional_field(hash_in['card'])),
      :paypal=>XMLFields.pay_pal(optional_field(hash_in['paypal'])),
      :token=>XMLFields.card_token_type(optional_field(hash_in['token'])),
      :paypage=>XMLFields.card_paypage_type(optional_field(hash_in['paypage'])),
      :billMeLaterRequest=>XMLFields.bill_me_later_request(optional_field(hash_in['billMeLaterRequest'])),
      :fraudCheck=>XMLFields.fraud_check_type(optional_field(hash_in['fraudCheck'])),
      :cardholderAuthentication=>XMLFields.fraud_check_type(optional_field(hash_in['cardholderAuthentication'])),
      :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.tax_billing(optional_field(hash_in['taxBilling'])),
      :enhancedData=>XMLFields.enhanced_data(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :payPalOrderComplete=> hash_in['paypalOrderComplete'],
      :payPalNotes=> hash_in['paypalNotesType'],
      :amexAggregatorData=>XMLFields.amex_aggregator_data(optional_field(hash_in['amexAggregatorData'])),
      :allowPartialAuth=>hash_in['allowPartialAuth'],
      :healthcareIIAS=>XMLFields.healthcare_iias(optional_field(hash_in['healthcareIIAS'])),
      :filtering=>XMLFields.filtering_type(optional_field(hash_in['filtering'])),
      :merchantData=>XMLFields.filtering_type(optional_field(hash_in['merchantData'])),
      :recyclingRequest=>XMLFields.recycling_request_type(optional_field(hash_in['recyclingRequest']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    choice2= {'1'=>hash_out[:fraudCheck],'2'=>hash_out[:cardholderAuthentication]}
    Checker.choice(choice1)
    Checker.choice(choice2)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:sale => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def auth_reversal(hash_in)
    hash_out = {
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :amount =>hash_in['amount'],
      :payPalNotes=>hash_in['payPalNotes'],
      :actionReason=>hash_in['actionReason']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:authReversal => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def credit(hash_in)
    hash_out = {
      :litleTxnId => (hash_in['litleTxnId']),
      :orderId =>hash_in['orderId'],
      :amount =>hash_in['amount'],
      :orderSource=>hash_in['orderSource'],
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :card=> XMLFields.card_type(optional_field(hash_in['card'])),
      :paypal=>XMLFields.pay_pal(optional_field(hash_in['paypal'])),
      :token=>XMLFields.card_token_type(optional_field(hash_in['token'])),
      :paypage=>XMLFields.card_paypage_type(optional_field(hash_in['paypage'])),
      :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.tax_billing(optional_field(hash_in['taxBilling'])),
      :billMeLaterRequest=>XMLFields.bill_me_later_request(optional_field(hash_in['billMeLaterRequest'])),
      :enhancedData=>XMLFields.enhanced_data(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :amexAggregatorData=>XMLFields.amex_aggregator_data(optional_field(hash_in['amexAggregatorData'])),
      :payPalNotes =>hash_in['payPalNotes']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:credit => hash_out})
    Checker.purge_null(hash_out)
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def register_token_request(hash_in)
    hash_out = {
      :orderId =>optional_field(hash_in['orderId']),
      :accountNumber=>hash_in['accountNumber'],
      :echeckForToken=>XMLFields.echeck_for_token_type(optional_field(hash_in['echeckForToken'])),
      :paypageRegistrationId=>hash_in['paypageRegistrationId']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:accountNumber],'2' =>hash_out[:echeckForToken],'3'=>hash_out[:paypageRegistrationId]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:registerTokenRequest => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def force_capture(hash_in)
    hash_out = {
      :orderId =>required_field(hash_in['orderId']),
      :amount =>(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :card=> XMLFields.card_type(optional_field(hash_in['card'])),
      :token=>XMLFields.card_token_type(optional_field(hash_in['token'])),
      :paypage=>XMLFields.card_paypage_type(optional_field(hash_in['paypage'])),
      :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.tax_billing(optional_field(hash_in['taxBilling'])),
      :enhancedData=>XMLFields.enhanced_data(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :amexAggregatorData=>XMLFields.amex_aggregator_data(optional_field(hash_in['amexAggregatorData']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:forceCapture => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def capture(hash_in)
    ####TODO check partial
    hash_out = {
      '@partial'=>hash_in['partial'],
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :amount =>(hash_in['amount']),
      :enhancedData=>XMLFields.enhanced_data(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions'])),
      :payPalOrderComplete=>hash_in['payPalOrderComplete'],
      :payPalNotes =>hash_in['payPalNotes']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:capture => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def capture_given_auth(hash_in)
    hash_out = {
      :orderId =>required_field(hash_in['orderId']),
      :authInformation=>XMLFields.auth_information(optional_field(hash_in['authInformation'])),
      :amount =>required_field(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :card=> XMLFields.card_type(optional_field(hash_in['card'])),
      :token=>XMLFields.card_token_type(optional_field(hash_in['token'])),
      :paypage=>XMLFields.card_paypage_type(optional_field(hash_in['paypage'])),
      :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.tax_billing(optional_field(hash_in['taxBilling'])),
      :billMeLaterRequest=>XMLFields.bill_me_later_request(optional_field(hash_in['billMeLaterRequest'])),
      :enhancedData=>XMLFields.enhanced_data(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :amexAggregatorData=>XMLFields.amex_aggregator_data(optional_field(hash_in['amexAggregatorData']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:captureGivenAuth => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def echeck_redeposit(hash_in)
    hash_out = {
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :echeck=>XMLFields.echeck_type(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeck_token_type(optional_field(hash_in['echeckToken']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:echeckRedeposit => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def echeck_sale(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>hash_in['orderId'],
      :verify =>hash_in['verify'],
      :amount =>hash_in['amount'],
      :orderSource =>hash_in['orderSource'],
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :echeck=>XMLFields.echeck_type(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeck_token_type(optional_field(hash_in['echeckToken'])),
      :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:echeckSale => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def echeck_credit(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>hash_in['orderId'],
      :amount =>hash_in['amount'],
      :orderSource =>hash_in['orderSource'],
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :echeck=>XMLFields.echeck_type(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeck_token_type(optional_field(hash_in['echeckToken'])),
      :customBilling=>XMLFields.custom_billing(optional_field(hash_in['customBilling'])),
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:echeckCredit => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def echeck_verification(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>required_field(hash_in['orderId']),
      :amount =>required_field(hash_in['amount']),
      :orderSource =>required_field(hash_in['orderSource']),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :echeck=>XMLFields.echeck_type(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeck_token_type(optional_field(hash_in['echeckToken'])),
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:echeckVerification => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  def void(hash_in)
    hash_out = {
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :processingInstructions=>XMLFields.processing_instructions(optional_field(hash_in['processingInstructions']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    Checker.required_missing(hash_out)
    litle_online_hash = build_full_hash(hash_in, {:void => hash_out})
    Checker.required_missing(litle_online_hash)
    LitleXmlMapper.request(litle_online_hash,@config_hash)
  end

  private

  def get_merchant_id(hash_in)
    if (hash_in['merchantId'] == nil)
      return @config_hash['currency_merchant_map']['DEFAULT']
    else
      return hash_in['merchantId']
    end
  end

  def get_report_group(hash_in)
    if (hash_in['reportGroup'] == nil)
      return required_field(@config_hash['default_report_group'])
    else
      return hash_in['reportGroup']
    end
  end

  def authentication(hash_in)
    if(hash_in['user'] == nil)
      user = @config_hash['user']
    else
      user = hash_in['user']
    end
    
    if(hash_in['password'] == nil)
      password = @config_hash['password']
    else
      password = hash_in['password']
    end
    
    hash_out = {
      :user =>required_field(user),
      :password =>required_field(password)
    }
    Checker.required_missing(hash_out)
  end

  def required_field(value)
    return (value or 'REQUIRED')
  end

  def optional_field(value)
    return (value or ' ')
  end

  def build_full_hash(hash_in, merge_hash)
    if(hash_in['version'] == nil)
      version = @config_hash['version']
    else
      version = hash_in['version']
    end

    litle_online_hash = {
      "@version"=> required_field(version),
      "@xmlns"=> "http://www.litle.com/schema",
      "@merchantId"=> get_merchant_id(hash_in),
      :authentication => authentication(hash_in)
    }
    return litle_online_hash.merge(merge_hash)
  end

  def get_common_attributes(hash_in)
    @config_hash['proxy_addr'] = hash_in['proxy_addr'].nil? ? @config_hash['proxy_addr'] : hash_in['proxy_addr']
    @config_hash['proxy_port'] = hash_in['proxy_port'].nil? ? @config_hash['proxy_port'] : hash_in['proxy_port']
    @config_hash['url'] = hash_in['url'].nil? ? @config_hash['url'] : hash_in['url']
    
    return {
      '@id' => hash_in['id'],
      '@customerId' => hash_in['customerId'],
      '@reportGroup' => get_report_group(hash_in)
    }
  end

end
