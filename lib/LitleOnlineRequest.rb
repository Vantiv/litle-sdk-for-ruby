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

  def authorization(hash_in, run_checker = false)
    @run_checker = run_checker
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId => required_field(hash_in['orderId']),
      :amount =>required_field(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :customerInfo=>XMLFields.customerInfo(optional_field(hash_in['customerInfo'])),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :card=> XMLFields.cardType(optional_field(hash_in['card'])),
      :paypal=>XMLFields.payPal(optional_field(hash_in['paypal'])),
      :token=>XMLFields.cardTokenType(optional_field(hash_in['token'])),
      :paypage=>XMLFields.cardPaypageType(optional_field(hash_in['paypage'])),
      :billMeLaterRequest=>XMLFields.billMeLaterRequest(optional_field(hash_in['billMeLaterRequest'])),
      :cardholderAuthentication=>XMLFields.fraudCheckType(optional_field(hash_in['cardholderAuthentication'])),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.taxBilling(optional_field(hash_in['taxBilling'])),
      :enhancedData=>XMLFields.enhancedData(optional_field(hash_in['enhancedData'])),
      :amexAggregatorData=>XMLFields.amexAggregatorData(optional_field(hash_in['amexAggregatorData'])),
      :allowPartialAuth=>hash_in['allowPartialAuth'],
      :healthcareIIAS=>XMLFields.healthcareIIAS(optional_field(hash_in['healthcareIIAS'])),
      :filtering=>XMLFields.filteringType(optional_field(hash_in['filtering'])),
      :merchantData=>XMLFields.filteringType(optional_field(hash_in['merchantData'])),
      :recyclingRequest=>XMLFields.recyclingRequestType(optional_field(hash_in['recyclingRequest']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    if(run_checker)
      choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
      Checker.choice(choice1)
      Checker.required_missing(hash_out)
    end
    litleOnline_hash = build_full_hash(hash_in, {:authorization => hash_out})

    if(run_checker)
      Checker.required_missing(litleOnline_hash)
      response_object = LitleXmlMapper.request(litleOnline_hash,@config_hash, true)
    else
      response_object = LitleXmlMapper.request(litleOnline_hash,@config_hash)
    end

    if( response_object == nil )
      response_object = authorization(hash_in, true)
    end

    return response_object
  end

  def sale(hash_in, run_checker = false)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>required_field(hash_in['orderId']),
      :amount =>required_field(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :customerInfo=>XMLFields.customerInfo(optional_field(hash_in['customerInfo'])),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :card=> XMLFields.cardType(optional_field(hash_in['card'])),
      :paypal=>XMLFields.payPal(optional_field(hash_in['paypal'])),
      :token=>XMLFields.cardTokenType(optional_field(hash_in['token'])),
      :paypage=>XMLFields.cardPaypageType(optional_field(hash_in['paypage'])),
      :billMeLaterRequest=>XMLFields.billMeLaterRequest(optional_field(hash_in['billMeLaterRequest'])),
      :fraudCheck=>XMLFields.fraudCheckType(optional_field(hash_in['fraudCheck'])),
      :cardholderAuthentication=>XMLFields.fraudCheckType(optional_field(hash_in['cardholderAuthentication'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.taxBilling(optional_field(hash_in['taxBilling'])),
      :enhancedData=>XMLFields.enhancedData(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :payPalOrderComplete=> hash_in['paypalOrderComplete'],
      :payPalNotes=> hash_in['paypalNotesType'],
      :amexAggregatorData=>XMLFields.amexAggregatorData(optional_field(hash_in['amexAggregatorData'])),
      :allowPartialAuth=>hash_in['allowPartialAuth'],
      :healthcareIIAS=>XMLFields.healthcareIIAS(optional_field(hash_in['healthcareIIAS'])),
      :filtering=>XMLFields.filteringType(optional_field(hash_in['filtering'])),
      :merchantData=>XMLFields.filteringType(optional_field(hash_in['merchantData'])),
      :recyclingRequest=>XMLFields.recyclingRequestType(optional_field(hash_in['recyclingRequest']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    if(run_checker)
      choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
      choice2= {'1'=>hash_out[:fraudCheck],'2'=>hash_out[:cardholderAuthentication]}
      Checker.choice(choice1)
      Checker.choice(choice2)
      Checker.required_missing(hash_out)
    end
    litleOnline_hash = build_full_hash(hash_in, {:sale => hash_out})

    if(run_checker)
      Checker.required_missing(litleOnline_hash)
      response_object = LitleXmlMapper.request(litleOnline_hash,@config_hash, true)
    else
      response_object = LitleXmlMapper.request(litleOnline_hash,@config_hash)
    end
    if( response_object == nil )
      response_object = sale(hash_in, true)
    end
    return response_object
  end

  def authReversal(hash_in)
    hash_out = {
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :amount =>hash_in['amount'],
      :payPalNotes=>hash_in['payPalNotes'],
      :actionReason=>hash_in['actionReason']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:authReversal => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def credit(hash_in)
    hash_out = {
      :litleTxnId => (hash_in['litleTxnId']),
      :orderId =>hash_in['orderId'],
      :amount =>hash_in['amount'],
      :orderSource=>hash_in['orderSource'],
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :card=> XMLFields.cardType(optional_field(hash_in['card'])),
      :paypal=>XMLFields.payPal(optional_field(hash_in['paypal'])),
      :token=>XMLFields.cardTokenType(optional_field(hash_in['token'])),
      :paypage=>XMLFields.cardPaypageType(optional_field(hash_in['paypage'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.taxBilling(optional_field(hash_in['taxBilling'])),
      :billMeLaterRequest=>XMLFields.billMeLaterRequest(optional_field(hash_in['billMeLaterRequest'])),
      :enhancedData=>XMLFields.enhancedData(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :amexAggregatorData=>XMLFields.amexAggregatorData(optional_field(hash_in['amexAggregatorData'])),
      :payPalNotes =>hash_in['payPalNotes']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:credit => hash_out})
    Checker.purge_null(hash_out)
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def registerTokenRequest(hash_in)
    hash_out = {
      :orderId =>optional_field(hash_in['orderId']),
      :accountNumber=>hash_in['accountNumber'],
      :echeckForToken=>XMLFields.echeckForTokenType(optional_field(hash_in['echeckForToken'])),
      :paypageRegistrationId=>hash_in['paypageRegistrationId']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:accountNumber],'2' =>hash_out[:echeckForToken],'3'=>hash_out[:paypageRegistrationId]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:registerTokenRequest => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def forceCapture(hash_in)
    hash_out = {
      :orderId =>required_field(hash_in['orderId']),
      :amount =>(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :card=> XMLFields.cardType(optional_field(hash_in['card'])),
      :token=>XMLFields.cardTokenType(optional_field(hash_in['token'])),
      :paypage=>XMLFields.cardPaypageType(optional_field(hash_in['paypage'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.taxBilling(optional_field(hash_in['taxBilling'])),
      :enhancedData=>XMLFields.enhancedData(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :amexAggregatorData=>XMLFields.amexAggregatorData(optional_field(hash_in['amexAggregatorData']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:forceCapture => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def capture(hash_in)
    ####TODO check partial
    hash_out = {
      '@partial'=>hash_in['partial'],
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :amount =>(hash_in['amount']),
      :enhancedData=>XMLFields.enhancedData(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions'])),
      :payPalOrderComplete=>hash_in['payPalOrderComplete'],
      :payPalNotes =>hash_in['payPalNotes']
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:capture => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def captureGivenAuth(hash_in)
    hash_out = {
      :orderId =>required_field(hash_in['orderId']),
      :authInformation=>XMLFields.authInformation(optional_field(hash_in['authInformation'])),
      :amount =>required_field(hash_in['amount']),
      :orderSource=>required_field(hash_in['orderSource']),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :card=> XMLFields.cardType(optional_field(hash_in['card'])),
      :token=>XMLFields.cardTokenType(optional_field(hash_in['token'])),
      :paypage=>XMLFields.cardPaypageType(optional_field(hash_in['paypage'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
      :taxBilling=>XMLFields.taxBilling(optional_field(hash_in['taxBilling'])),
      :billMeLaterRequest=>XMLFields.billMeLaterRequest(optional_field(hash_in['billMeLaterRequest'])),
      :enhancedData=>XMLFields.enhancedData(optional_field(hash_in['enhancedData'])),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions'])),
      :pos=>XMLFields.pos(optional_field(hash_in['pos'])),
      :amexAggregatorData=>XMLFields.amexAggregatorData(optional_field(hash_in['amexAggregatorData']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:card],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:captureGivenAuth => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def echeckRedeposit(hash_in)
    hash_out = {
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :echeck=>XMLFields.echeckType(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeckTokenType(optional_field(hash_in['echeckToken']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:echeckRedeposit => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def echeckSale(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>hash_in['orderId'],
      :verify =>hash_in['verify'],
      :amount =>hash_in['amount'],
      :orderSource =>hash_in['orderSource'],
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :shipToAddress=>XMLFields.contact(optional_field(hash_in['shipToAddress'])),
      :echeck=>XMLFields.echeckType(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeckTokenType(optional_field(hash_in['echeckToken'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:echeckSale => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def echeckCredit(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>hash_in['orderId'],
      :amount =>hash_in['amount'],
      :orderSource =>hash_in['orderSource'],
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :echeck=>XMLFields.echeckType(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeckTokenType(optional_field(hash_in['echeckToken'])),
      :customBilling=>XMLFields.customBilling(optional_field(hash_in['customBilling'])),
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:echeckCredit => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def echeckVerification(hash_in)
    hash_out = {
      :litleTxnId => hash_in['litleTxnId'],
      :orderId =>required_field(hash_in['orderId']),
      :amount =>required_field(hash_in['amount']),
      :orderSource =>required_field(hash_in['orderSource']),
      :billToAddress=>XMLFields.contact(optional_field(hash_in['billToAddress'])),
      :echeck=>XMLFields.echeckType(optional_field(hash_in['echeck'])),
      :echeckToken=>XMLFields.echeckTokenType(optional_field(hash_in['echeckToken'])),
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
    Checker.choice(choice1)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:echeckVerification => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
  end

  def void(hash_in)
    hash_out = {
      :litleTxnId => required_field(hash_in['litleTxnId']),
      :processingInstructions=>XMLFields.processingInstructions(optional_field(hash_in['processingInstructions']))
    }
    hash_out.merge!(get_common_attributes(hash_in))
    Checker.purge_null(hash_out)
    Checker.required_missing(hash_out)
    litleOnline_hash = build_full_hash(hash_in, {:void => hash_out})
    Checker.required_missing(litleOnline_hash)
    LitleXmlMapper.request(litleOnline_hash,@config_hash)
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
    hash_out = {
      :user =>required_field(@config_hash['user']),
      :password =>required_field(@config_hash['password'])
    }
    Checker.required_missing(hash_out)
  end

  def required_field(value)
    if(@run_checker)
      return (value or 'REQUIRED')
    else
      return value
    end
  end

  def optional_field(value)
    return (value or ' ')
  end

  def build_full_hash(hash_in, merge_hash)
    litleOnline_hash = {
      "@version"=> required_field(@config_hash['version']),
      "@xmlns"=> "http://www.litle.com/schema",
      "@merchantId"=> get_merchant_id(hash_in),
      :authentication => authentication(hash_in)
    }
    return litleOnline_hash.merge(merge_hash)
  end

  def get_common_attributes(hash_in)
    return {
      '@id' => hash_in['id'],
      '@customerId' => hash_in['customerId'],
      '@reportGroup' => get_report_group(hash_in)
    }
  end

end
