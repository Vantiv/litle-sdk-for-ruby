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
#
# Contains all of the underlying XML fields and specifications needed to create the transaction set
#

module LitleOnline
  class OptionalChoiceNode < XML::Mapping::ChoiceNode
    def obj_to_xml(obj,xml)
      count = 0
      @choices.each do |path,node|
        if node.is_present_in? obj
          count = count + 1
        end
      end
      if(count > 1)
        raise RuntimeError, "Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!"
      end
      @choices.each do |path,node|
        if node.is_present_in? obj
          node.obj_to_xml(obj,xml)
          path.first(xml, :ensure_created=>true)
          return true
        end
      end
    end
  end
  
  XML::Mapping.add_node_class OptionalChoiceNode
  
  class Authentication
    include XML::Mapping
    text_node :user, "user"
    text_node :password, "password"
  end
  
  class SchemaValidation
    
    def self.validate_required(value, required, class_name, field_name)
      if(required)
        if(value.nil?)
          raise "If #{class_name} is specified, it must have a #{field_name}"
        end
      end
    end
    
    def self.validate_length(value, required, min, max, class_name, field_name)
      validate_required(value, required, class_name, field_name)
      if(value.nil?)
        return
      end
      if(value.length < min || value.length > max)
        raise "If " + class_name + " " + field_name + " is specified, it must be between " + min.to_s + " and " + max.to_s + " characters long"
      end
    end
    
    def self.validate_size(value, required, min, max, class_name, field_name)
      validate_required(value, required, class_name, field_name)
      if(value.nil?)
        return
      end
      if(value.to_i < min || value.to_i > max || !(/\A\-?\d+\Z/ =~ value))
        raise "If " + class_name + " " + field_name + " is specified, it must be between " + min.to_s + " and " + max.to_s
      end
    end
    
    def self.validate_country(value, class_name, field_name)
      if(value.nil?)
        return
      end
      list = ["USA","AF","AX","AL","DZ","AS","AD","AO","AI","AQ","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO","BQ","BA","BW","BV","BR","IO","BN","BG","BF","BI","KH","CM","CA","CV","KY","CF","TD","CL","CN","CX","CC","CO","KM","CG","CD","CK","CR","CI","HR","CU","CW","CY","CZ","DK","DJ","DM","DO","TL","EC","EG","SV","GQ","ER","EE","ET","FK","FO","FJ","FI","FR","GF","PF","TF","GA","GM","GE","DE","GH","GI","GR","GL","GD","GP","GU","GT","GG","GN","GW","GY","HT","HM","HN","HK","HU","IS","IN","ID","IR","IQ","IE","IM","IL","IT","JM","JP","JE","JO","KZ","KE","KI","KP","KR","KW","KG","LA","LV","LB","LS","LR","LY","LI","LT","LU","MO","MK","MG","MW","MY","MV","ML","MT","MH","MQ","MR","MU","YT","MX","FM","MD","MC","MN","MS","MA","MZ","MM","NA","NR","NP","NL","AN","NC","NZ","NI","NE","NG","NU","NF","MP","NO","OM","PK","PW","PS","PA","PG","PY","PE","PH","PN","PL","PT","PR","QA","RE","RO","RU","RW","BL","KN","LC","MF","VC","WS","SM","ST","SA","SN","SC","SL","SG","SX","SK","SI","SB","SO","ZA","GS","ES","LK","SH","PM","SD","SR","SJ","SZ","SE","CH","SY","TW","TJ","TZ","TH","TG","TK","TO","TT","TN","TR","TM","TC","TV","UG","UA","AE","GB","US","UM","UY","UZ","VU","VA","VE","VN","VG","VI","WF","EH","YE","ZM","ZW","RS","ME"]
      if(!list.include? value)
        raise "If " + class_name + " " + field_name + " is specified, it must be valid.  You specified " + value
      end
    end
    
    def self.validate_regex(value, required,  regex, class_name, field_name)
      validate_required(value, required, class_name, field_name)
      if(value.nil?)
        return
      end
      if(!(regex =~ value))
        raise "If #{class_name} #{field_name} is specified, it must match the regular expression #{regex.inspect}"
      end
    end
    
    def self.validate_enum(value, required, list, class_name, field_name)
      validate_required(value, required, class_name, field_name)
      if(value.nil?)
        return
      end
      if(!list.include?(value))
        str = '["'+ list.join('", "') + '"]'
        raise "If #{class_name} #{field_name} is specified, it must be in #{str}"
      end
    end
    
    def self.validate_long(value, required, class_name, field_name)
      validate_size(value, required, -9223372036854775808, 9223372036854775807, class_name, field_name)
    end
    
    def self.validate_currency(value, required, class_name, field_name)
      validate_enum(value, required, ['AUD','CAD','CHF','DKK','EUR','GBP','HKD','JPY','NOK','NZD','SEK','SGD','USD'], class_name, field_name)
    end
    
    def self.validate_boolean(value, required, class_name, field_name)
      validate_enum(value, required, ['true','false','1','0'], class_name, field_name)
    end
    
    def self.validate_date(value, required, class_name, field_name)
      validate_regex(value, required, /\A\d{4}-\d{2}-\d{2}\Z/, class_name, field_name)
    end
    
  end
  
  class Contact
    include XML::Mapping
    text_node :name, "name", :default_value=>nil
    text_node :firstName, "firstName", :default_value=>nil
    text_node :middleInitial, "middleInitial", :default_value=>nil
    text_node :lastName, "lastName", :default_value=>nil
    text_node :companyName, "companyName", :default_value=>nil
    text_node :addressLine1, "addressLine1", :default_value=>nil
    text_node :addressLine2, "addressLine2", :default_value=>nil
    text_node :addressLine3, "addressLine3", :default_value=>nil
    text_node :city, "city", :default_value=>nil
    text_node :state, "state", :default_value=>nil
    text_node :zip, "zip", :default_value=>nil
    text_node :country, "country", :default_value=>nil
    text_node :email, "email", :default_value=>nil
    text_node :phone, "phone", :default_value=>nil
    def self.from_hash(hash, name='contact')
      base = hash[name]
      if(base)
        this = Contact.new
        this.name = base['name']
        this.firstName = base['firstName']
        this.middleInitial = base['middleInitial']
        this.lastName = base['lastName']
        this.companyName = base['companyName']
        this.addressLine1 = base['addressLine1']
        this.addressLine2 = base['addressLine2']
        this.addressLine3 = base['addressLine3']
        this.city = base['city']
        this.state = base['state']
        this.zip = base['zip']
        this.country = base['country']
        this.email = base['email']
        this.phone = base['phone']
        SchemaValidation.validate_length(this.name, false, 1, 100, name, "name")
        SchemaValidation.validate_length(this.firstName, false, 1, 25, name, "firstName")
        SchemaValidation.validate_length(this.middleInitial, false, 1, 1, name, "middleInitial")
        SchemaValidation.validate_length(this.lastName, false, 1, 25, name, "lastName")
        SchemaValidation.validate_length(this.companyName, false, 1, 40, name, "companyName")
        SchemaValidation.validate_length(this.addressLine1, false, 1, 35, name, "addressLine1")
        SchemaValidation.validate_length(this.addressLine2, false, 1, 35, name, "addressLine2")
        SchemaValidation.validate_length(this.addressLine3, false, 1, 35, name, "addressLine3")
        SchemaValidation.validate_length(this.city, false, 1, 35, name, "city")
        SchemaValidation.validate_length(this.state, false, 1, 30, name, "state")
        SchemaValidation.validate_length(this.zip, false, 1, 20, name, "zip")
        SchemaValidation.validate_length(this.country, false, 1, 3, name, "country")
        SchemaValidation.validate_country(this.country, name, "country")
        SchemaValidation.validate_length(this.email, false, 1, 100, name, "email")
        SchemaValidation.validate_length(this.phone, false, 1, 20, name, "phone")
        this
      else
        nil
      end
    end
  end
  
  class CustomerInfo
    include XML::Mapping
    text_node :ssn, "ssn", :default_value=>nil
    text_node :dob, "dob", :default_value=>nil
    text_node :customerRegistrationDate, "customerRegistrationDate", :default_value=>nil
    text_node :customerType, "customerType", :default_value=>nil
    text_node :incomeAmount, "incomeAmount", :default_value=>nil
    text_node :incomeCurrency, "incomeCurrency", :default_value=>nil
    text_node :customerCheckingAccount, "customerCheckingAccount", :default_value=>nil
    text_node :customerSavingAccount, "customerSavingAccount", :default_value=>nil
    text_node :employerName, "employerName", :default_value=>nil
    text_node :customerWorkTelephone, "customerWorkTelephone", :default_value=>nil
    text_node :residenceStatus, "residenceStatus", :default_value=>nil
    text_node :yearsAtResidence, "yearsAtResidence", :default_value=>nil
    text_node :yearsAtEmployer, "yearsAtEmployer", :default_value=>nil
    def self.from_hash(hash, name='customerInfo')
      base = hash[name]
      if(base)
        this = CustomerInfo.new
        this.ssn = base['ssn']
        this.dob = base['dob']
        this.customerRegistrationDate = base['customerRegistrationDate']
        this.customerType = base['customerType']
        this.incomeAmount = base['incomeAmount']
        this.incomeCurrency = base['incomeCurrency']
        this.customerCheckingAccount = base['customerCheckingAccount']
        this.customerSavingAccount = base['customerSavingAccount']
        this.employerName = base['employerName']
        this.customerWorkTelephone = base['customerWorkTelephone']
        this.residenceStatus = base['residenceStatus']
        this.yearsAtResidence = base['yearsAtResidence']
        this.yearsAtEmployer = base['yearsAtEmployer']
        SchemaValidation.validate_regex(this.ssn, false,  /\A\d{9}\Z/, name, 'ssn')
        SchemaValidation.validate_date(this.dob, false, name, 'dob')
        SchemaValidation.validate_regex(this.customerRegistrationDate, false, /\A\d{4}-\d{2}-\d{2}/, name, 'customerRegistrationDate')
        SchemaValidation.validate_enum(this.customerType, false, ['New','Existing'], name, 'customerType')
        SchemaValidation.validate_long(this.incomeAmount, false, name, 'incomeAmount')
        SchemaValidation.validate_currency(this.incomeCurrency, false, name, 'incomeCurrency')
        SchemaValidation.validate_boolean(this.customerCheckingAccount, false, name, 'customerCheckingAccount')
        SchemaValidation.validate_boolean(this.customerSavingAccount, false, name, 'customerSavingAccount')
        SchemaValidation.validate_length(this.employerName, false, 1, 20, name, "employerName")
        SchemaValidation.validate_length(this.customerWorkTelephone, false, 1, 20, name, "customerWorkTelephone")
        SchemaValidation.validate_enum(this.residenceStatus, false, ['Own','Rent','Other'], name, 'residenceStatus')
        SchemaValidation.validate_size(this.yearsAtResidence, false, 0, 99, name, 'yearsAtResidence')
        SchemaValidation.validate_size(this.yearsAtEmployer, false, 0, 99, name, 'yearsAtEmployer')
        this
      else
        nil
      end
    end
  end
  
  class BillMeLaterRequest
    include XML::Mapping
    text_node :bmlMerchantId, "bmlMerchantId", :default_value=>nil
    text_node :bmlProductType, "bmlProductType", :default_value=>nil
    text_node :termsAndConditions, "termsAndConditions", :default_value=>nil
    text_node :preapprovalNumber, "preapprovalNumber", :default_value=>nil
    text_node :merchantPromotionalCode, "merchantPromotionalCode", :default_value=>nil
    text_node :customerPasswordChanged, "customerPasswordChanged", :default_value=>nil
    text_node :customerBillingAddressChanged, "customerBillingAddressChanged", :default_value=>nil
    text_node :customerEmailChanged, "customerEmailChanged", :default_value=>nil
    text_node :customerPhoneChanged, "customerPhoneChanged", :default_value=>nil
    text_node :secretQuestionCode, "secretQuestionCode", :default_value=>nil
    text_node :secretQuestionAnswer, "secretQuestionAnswer", :default_value=>nil
    text_node :virtualAuthenticationKeyPresenceIndicator, "virtualAuthenticationKeyPresenceIndicator", :default_value=>nil
    text_node :virtualAuthenticationKeyData, "virtualAuthenticationKeyData", :default_value=>nil
    text_node :itemCategoryCode, "itemCategoryCode", :default_value=>nil
    text_node :authorizationSourcePlatform, "authorizationSourcePlatform", :default_value=>nil
    def self.from_hash(hash, name='billMeLaterRequest')
      base = hash[name]
      if(base)
        this = BillMeLaterRequest.new
        this.bmlMerchantId = base['bmlMerchantId']
        this.bmlProductType = base['bmlProductType']
        this.termsAndConditions = base['termsAndConditions']
        this.preapprovalNumber = base['preapprovalNumber']
        this.merchantPromotionalCode = base['merchantPromotionalCode']
        this.customerPasswordChanged = base['customerPasswordChanged']
        this.customerBillingAddressChanged = base['customerBillingAddressChanged']
        this.customerEmailChanged = base['customerEmailChanged']
        this.customerPhoneChanged = base['customerPhoneChanged']
        this.secretQuestionCode = base['secretQuestionCode']
        this.secretQuestionAnswer = base['secretQuestionAnswer']
        this.virtualAuthenticationKeyPresenceIndicator = base['virtualAuthenticationKeyPresenceIndicator']
        this.virtualAuthenticationKeyData = base['virtualAuthenticationKeyData']
        this.itemCategoryCode = base['itemCategoryCode']
        this.authorizationSourcePlatform = base['authorizationSourcePlatform']
        SchemaValidation.validate_long(this.bmlMerchantId, false, name, 'bmlMerchantId')
        SchemaValidation.validate_length(this.bmlProductType, false, 1, 2, name, "bmlProductType")
        SchemaValidation.validate_size(this.termsAndConditions, false, -99999, 99999, name, 'termsAndConditions')
        SchemaValidation.validate_length(this.preapprovalNumber, false, 13, 25, name, "preapprovalNumber")
        SchemaValidation.validate_size(this.merchantPromotionalCode, false, -9999, 9999, name, 'merchantPromotionalCode')
        SchemaValidation.validate_boolean(this.customerPasswordChanged, false, name, 'customerPasswordChanged')
        SchemaValidation.validate_boolean(this.customerBillingAddressChanged, false, name, 'customerBillingAddressChanged')
        SchemaValidation.validate_boolean(this.customerEmailChanged, false, name, 'customerEmailChanged')
        SchemaValidation.validate_boolean(this.customerPhoneChanged, false, name, 'customerPhoneChanged')
        SchemaValidation.validate_length(this.secretQuestionCode, false, 1, 2, name, "secretQuestionCode")
        SchemaValidation.validate_length(this.secretQuestionAnswer, false, 1, 25, name, "secretQuestionAnswer")
        SchemaValidation.validate_length(this.virtualAuthenticationKeyPresenceIndicator, false, 1, 1, name, "virtualAuthenticationKeyPresenceIndicator")
        SchemaValidation.validate_length(this.virtualAuthenticationKeyData, false, 1, 4, name, "virtualAuthenticationKeyData")
        SchemaValidation.validate_size(this.itemCategoryCode, false, -9999, 9999, name, 'itemCategoryCode')
        this
      else
        nil
      end
    end
  end
  
  class FraudCheck
    include XML::Mapping
    text_node :authenticationValue, "authenticationValue", :default_value=>nil
    text_node :authenticationTransactionId, "authenticationTransactionId", :default_value=>nil
    text_node :customerIpAddress, "customerIpAddress", :default_value=>nil
    text_node :authenticatedByMerchant, "authenticatedByMerchant", :default_value=>nil
    def self.from_hash(hash, name='fraudCheck')
      base = hash[name]
      if(base)
        this = FraudCheck.new
        this.authenticationValue = base['authenticationValue']
        this.authenticationTransactionId = base['authenticationTransactionId']
        this.customerIpAddress = base['customerIpAddress']
        this.authenticatedByMerchant = base['authenticatedByMerchant']
        SchemaValidation.validate_length(this.authenticationValue, false, 1, 32, name, "authenticationValue")
        SchemaValidation.validate_length(this.authenticationTransactionId, false, 1, 28, name, "authenticationTransactionId")
        SchemaValidation.validate_regex(this.customerIpAddress, false, /\A(\d{1,3}.){3}\d{1,3}\Z/, name, 'customerIpAddress')
        SchemaValidation.validate_boolean(this.authenticatedByMerchant, false, name, 'authenticatedByMerchant')
        this
      else
        nil
      end
    end
  end
  
  class FraudResult
    include XML::Mapping
    text_node :avsResult, "avsResult", :default_value=>nil
    text_node :cardValidationResult, "cardValidationResult", :default_value=>nil
    text_node :authenticationResult, "authenticationResult", :default_value=>nil
    text_node :advancedAVSResult, "advancedAVSResult", :default_value=>nil
    def self.from_hash(hash, name='fraudResult')
      base = hash[name]
      if(base)
        this = FraudResult.new
        this.avsResult = base['avsResult']
        this.cardValidationResult = base['cardValidationResult']
        this.authenticationResult = base['authenticationResult']
        this.advancedAVSResult = base['advancedAVSResult']
        SchemaValidation.validate_length(this.avsResult, false, 1, 2, name, "avsResult")
        SchemaValidation.validate_length(this.authenticationResult, false, 1, 1, name, "authenticationResult")
        SchemaValidation.validate_length(this.advancedAVSResult, false, 1, 3, name, "advancedAVSResult")
        this
      else
        nil
      end
    end
  end
  
  class AuthInformation
    include XML::Mapping
    text_node :authDate, "authDate", :default_value=>nil
    text_node :authCode, "authCode", :default_value=>nil
    object_node :fraudResult, "fraudResult", :class=>FraudResult, :default_value=>nil
    text_node :authAmount, "authAmount", :default_value=>nil
    def self.from_hash(hash, name='authInformation')
      base = hash[name]
      if(base)
        this = AuthInformation.new
        this.authDate = base['authDate']
        this.authCode = base['authCode']
        this.fraudResult = FraudResult.from_hash(base)
        this.authAmount = base['authAmount']
        SchemaValidation.validate_date(this.authDate, false, name, 'authDate')
        SchemaValidation.validate_length(this.authCode, false, 1, 6, name, "authCode")
        SchemaValidation.validate_size(this.authAmount, false, -999999999999, 999999999999, name, 'authAmount')
        this
      else
        nil
      end
    end
  end
  
  class HealthcareAmounts
    include XML::Mapping
    text_node :totalHealthcareAmount, "totalHealthcareAmount", :default_value=>nil
    text_node :rxAmount, "RxAmount", :default_value=>nil
    text_node :visionAmount, "visionAmount", :default_value=>nil
    text_node :clinicOtherAmount, "clinicOtherAmount", :default_value=>nil
    text_node :dentalAmount, "dentalAmount", :default_value=>nil
    def self.from_hash(hash, name='healthcareAmounts')
      base = hash[name]
      if(base)
        this = HealthcareAmounts.new
        this.totalHealthcareAmount = base['totalHealthcareAmount']
        this.rxAmount = base['RxAmount']
        this.visionAmount = base['visionAmount']
        this.clinicOtherAmount = base['clinicOtherAmount']
        this.dentalAmount = base['dentalAmount']
        SchemaValidation.validate_size(this.totalHealthcareAmount, true, -999999999999, 999999999999, name, 'totalHealthcareAmount')
        SchemaValidation.validate_size(this.rxAmount, false, -999999999999, 999999999999, name, 'RxAmount')
        SchemaValidation.validate_size(this.visionAmount, false, -999999999999, 999999999999, name, 'visionAmount')
        SchemaValidation.validate_size(this.clinicOtherAmount, false, -999999999999, 999999999999, name, 'clinicOtherAmount')
        SchemaValidation.validate_size(this.dentalAmount, false, -999999999999, 999999999999, name, 'dentalAmount')
        this
      else
        nil
      end
    end
  end
  
  class HealthcareIIAS
    include XML::Mapping
    object_node :healthcareAmounts, "healthcareAmounts", :class=>HealthcareAmounts, :default_value=>nil
    text_node :iiasFlag, "IIASFlag", :default_value=>nil
    def self.from_hash(hash, name='healthcareIIAS')
      base = hash[name]
      if(base)
        this = HealthcareIIAS.new
        this.healthcareAmounts = HealthcareAmounts.from_hash(base)
        this.iiasFlag = base['IIASFlag']
        SchemaValidation.validate_enum(this.iiasFlag, true, ['Y'], name, 'IIASFlag')
        this
      else
        nil
      end
    end
  end
  
  class Pos
    include XML::Mapping
    text_node :capability, "capability", :default_value=>nil
    text_node :entryMode, "entryMode", :default_value=>nil
    text_node :cardholderId, "cardholderId", :default_value=>nil
    text_node :terminalId, "terminalId", :default_value=>nil
    def self.from_hash(hash, name='pos')
      base = hash[name]
      if(base)
        this = Pos.new
        this.capability = base['capability']
        this.entryMode = base['entryMode']
        this.cardholderId = base['cardholderId']
        this.terminalId = base['terminalId']
        SchemaValidation.validate_enum(this.capability, true, ['notused','magstripe','keyedonly'], name, 'capability')
        SchemaValidation.validate_enum(this.entryMode, true, ['notused','keyed','track1','track2','completeread'], name, 'entryMode')
        SchemaValidation.validate_enum(this.cardholderId, true, ['signature','pin','nopin','directmarket'], name, 'cardholderId')
        this
      else
        nil
      end
    end
  end
  
  class DetailTax
    include XML::Mapping
    text_node :taxIncludedInTotal, "taxIncludedInTotal", :default_value=>nil
    text_node :taxAmount, "taxAmount", :default_value=>nil
    text_node :taxRate, "taxRate", :default_value=>nil
    text_node :taxTypeIdentifier, "taxTypeIdentifier", :default_value=>nil
    text_node :cardAcceptorTaxId, "cardAcceptorTaxId", :default_value=>nil
    def self.from_hash(hash, index=0, name='detailTax')
      base = hash[name][index]
      if(base)
        this = DetailTax.new
        this.taxIncludedInTotal = base['taxIncludedInTotal']
        this.taxAmount = base['taxAmount']
        this.taxRate = base['taxRate']
        this.taxTypeIdentifier = base['taxTypeIdentifier']
        this.cardAcceptorTaxId = base['cardAcceptorTaxId']
        SchemaValidation.validate_boolean(this.taxIncludedInTotal, false, name, 'taxIncludedInTotal')
        SchemaValidation.validate_size(this.taxAmount, true, -999999999999, 999999999999, name, 'taxAmount')
        SchemaValidation.validate_regex(this.taxRate, false, /\A(\+|\-)?\d*\.?\d*\Z/, name, 'taxRate')
        SchemaValidation.validate_enum(this.taxTypeIdentifier, false, ['00','01','02','03','04','05','06','10','11','12','13','14','20','21','22'], name, 'taxTypeIdentifier')
        SchemaValidation.validate_length(this.cardAcceptorTaxId, false, 1, 20, name, 'cardAcceptorTaxId')
        this
      else
        nil
      end
    end
  end
  
  class LineItemData
    include XML::Mapping
    text_node :itemSequenceNumber, "itemSequenceNumber", :default_value=>nil
    text_node :itemDescription, "itemDescription", :default_value=>nil
    text_node :productCode, "productCode", :default_value=>nil
    text_node :quantity, "quantity", :default_value=>nil
    text_node :unitOfMeasure, "unitOfMeasure", :default_value=>nil
    text_node :taxAmount, "taxAmount", :default_value=>nil
    text_node :lineItemTotal, "lineItemTotal", :default_value=>nil
    text_node :lineItemTotalWithTax, "lineItemTotalWithTax", :default_value=>nil
    text_node :itemDiscountAmount, "itemDiscountAmount", :default_value=>nil
    text_node :commodityCode, "commodityCode", :default_value=>nil
    text_node :unitCost, "unitCost", :default_value=>nil
    array_node :detailTax, "", "detailTax", :class=>DetailTax, :default_value=>[]
    def self.from_hash(hash, index=0, name='lineItemData')
      base = hash[name][index]
      if(base)
        this = LineItemData.new
        this.itemSequenceNumber = base['itemSequenceNumber']
        this.itemDescription = base['itemDescription']
        this.productCode = base['productCode']
        this.quantity = base['quantity']
        this.unitOfMeasure = base['unitOfMeasure']
        this.taxAmount = base['taxAmount']
        this.lineItemTotal = base['lineItemTotal']
        this.lineItemTotalWithTax = base['lineItemTotalWithTax']
        this.itemDiscountAmount = base['itemDiscountAmount']
        this.commodityCode = base['commodityCode']
        this.unitCost = base['unitCost']
        if(base['detailTax'])
          base['detailTax'].each_index {|index| this.detailTax << DetailTax.from_hash(base,index)}
        end
        SchemaValidation.validate_size(this.itemSequenceNumber, false, 1, 99, name, 'itemSequenceNumber')
        SchemaValidation.validate_length(this.itemDescription, true, 1, 26, name, 'itemDescription')
        SchemaValidation.validate_length(this.productCode, false, 1, 12, name, 'productCode')
        SchemaValidation.validate_regex(this.quantity, false, /\A(\+|\-)?\d*\.?\d*\Z/, name, 'quantity')
        SchemaValidation.validate_length(this.unitOfMeasure, false, 1, 12, name, 'unitOfMeasure')
        SchemaValidation.validate_size(this.taxAmount, false, -999999999999, 999999999999, name, 'taxAmount')
        SchemaValidation.validate_size(this.lineItemTotal, false, -999999999999, 999999999999, name, 'lineItemTotal')
        SchemaValidation.validate_size(this.lineItemTotalWithTax, false, -999999999999, 999999999999, name, 'lineItemTotalWithTax')
        SchemaValidation.validate_size(this.itemDiscountAmount, false, -999999999999, 999999999999, name, 'itemDiscountAmount')
        SchemaValidation.validate_length(this.commodityCode, false, 1, 12, name, 'commodityCode')
        SchemaValidation.validate_regex(this.unitCost, false, /\A(\+|\-)?\d*\.?\d*\Z/, name, 'unitCost')
        this
      else
        nil
      end
    end
  end
  
  class EnhancedData
    include XML::Mapping
    text_node :customerReference, "customerReference", :default_value=>nil
    text_node :salesTax, "salesTax", :default_value=>nil
    text_node :deliveryType, "deliveryType", :default_value=>nil
    text_node :taxExempt, "taxExempt", :default_value=>nil
    text_node :discountAmount, "discountAmount", :default_value=>nil
    text_node :shippingAmount, "shippingAmount", :default_value=>nil
    text_node :dutyAmount, "dutyAmount", :default_value=>nil
    text_node :shipFromPostalCode, "shipFromPostalCode", :default_value=>nil
    text_node :destinationPostalCode, "destinationPostalCode", :default_value=>nil
    text_node :destinationCountryCode, "destinationCountryCode", :default_value=>nil
    text_node :invoiceReferenceNumber, "invoiceReferenceNumber", :default_value=>nil
    text_node :orderDate, "orderDate", :default_value=>nil
    array_node :detailTax, "", "detailTax", :class=>DetailTax, :default_value=>[]
    array_node :lineItemData, "", "lineItemData", :class=>LineItemData, :default_value=>[]
    def self.from_hash(hash, name='enhancedData')
      base = hash[name]
      if(base)
        this = EnhancedData.new
        this.customerReference = base['customerReference']
        this.salesTax = base['salesTax']
        this.deliveryType = base['deliveryType']
        this.taxExempt = base['taxExempt']
        this.discountAmount = base['discountAmount']
        this.shippingAmount = base['shippingAmount']
        this.dutyAmount = base['dutyAmount']
        this.shipFromPostalCode = base['shipFromPostalCode']
        this.destinationPostalCode = base['destinationPostalCode']
        this.destinationCountryCode = base['destinationCountryCode']
        this.invoiceReferenceNumber = base['invoiceReferenceNumber']
        this.orderDate = base['orderDate']
        if(base['detailTax'])
          base['detailTax'].each_index {|index| this.detailTax << DetailTax.from_hash(base,index)}
        end
        if(base['lineItemData'])
          base['lineItemData'].each_index {|index| this.lineItemData << LineItemData.from_hash(base,index)}
        end
        SchemaValidation.validate_length(this.customerReference, false, 1, 17, name, 'customerReference')
        SchemaValidation.validate_size(this.salesTax, false, -999999999999, 999999999999, name, 'salesTax')
        SchemaValidation.validate_enum(this.deliveryType, false, ['CNC','DIG','PHY','SVC','TBD'], name, 'deliveryType')
        SchemaValidation.validate_boolean(this.taxExempt, false, name, 'taxExempt')
        SchemaValidation.validate_size(this.discountAmount, false, -999999999999, 999999999999, name, 'discountAmount')
        SchemaValidation.validate_size(this.shippingAmount, false, -999999999999, 999999999999, name, 'shippingAmount')
        SchemaValidation.validate_size(this.dutyAmount, false, -999999999999, 999999999999, name, 'dutyAmount')
        SchemaValidation.validate_length(this.shipFromPostalCode, false, 1, 20, name, 'shipFromPostalCode')
        SchemaValidation.validate_length(this.destinationPostalCode, false, 1, 20, name, 'destinationPostalCode')
        SchemaValidation.validate_country(this.destinationCountryCode, name, 'destinationCountryCode')
        SchemaValidation.validate_length(this.invoiceReferenceNumber, false, 1, 15, name, 'invoiceReferenceNumber')
        SchemaValidation.validate_date(this.orderDate, false, name, 'orderDate')
        this
      else
        nil
      end
    end
  end
  
  class AmexAggregatorData
    include XML::Mapping
    text_node :sellerId, "sellerId", :default_value=>nil
    text_node :sellerMerchantCategoryCode, "sellerMerchantCategoryCode", :default_value=>nil
    def self.from_hash(hash, name='amexAggregatorData')
      base = hash[name]
      if(base)
        this = AmexAggregatorData.new
        this.sellerId = base['sellerId']
        this.sellerMerchantCategoryCode = base['sellerMerchantCategoryCode']
        SchemaValidation.validate_length(this.sellerId, false, 1, 16, name, 'sellerId')
        SchemaValidation.validate_length(this.sellerMerchantCategoryCode, false, 1, 4, name, 'sellerMerchantCategoryCode')
        this
      else
        nil
      end
    end
  end
  
  class Card
    include XML::Mapping
    text_node :mop, "type", :default_value=>nil
    text_node :track, "track", :default_value=>nil
    text_node :number, "number", :default_value=>nil
    text_node :expDate, "expDate", :default_value=>nil
    text_node :cardValidationNum, "cardValidationNum", :default_value=>nil
      
    def self.from_hash(hash, name='card')
      base = hash[name]
      if(base)
        this = Card.new
        this.mop = base['type']
        this.track = base['track']
        this.number = base['number']
        this.expDate = base['expDate']
        this.cardValidationNum = base['cardValidationNum']
        SchemaValidation.validate_enum(this.mop, false, ['','MC','VI','AX','DC','DI','PP','JC','BL','EC'], name, 'type')
        SchemaValidation.validate_length(this.track, false, 1, 256, name, 'track')
        SchemaValidation.validate_length(this.number, false, 13, 25, name, 'number')
        SchemaValidation.validate_length(this.expDate, false, 4, 4, name, 'expDate')
        SchemaValidation.validate_length(this.cardValidationNum, false, 1, 4, name, 'cardValidationNum')
        this
      else
        nil
      end
    end
  end
  
  class CardToken
    include XML::Mapping
    text_node :litleToken, "litleToken", :default_value=>nil
    text_node :expDate, "expDate", :default_value=>nil
    text_node :cardValidationNum, "cardValidationNum", :default_value=>nil
    text_node :mop, "type", :default_value=>nil
    def self.from_hash(hash, name='cardToken')
      base = hash[name]
      if(base)
        this = CardToken.new
        this.litleToken = base['litleToken']
        this.expDate = base['expDate']
        this.cardValidationNum = base['cardValidationNum']
        this.mop = base['type']
        SchemaValidation.validate_length(this.litleToken, true, 13, 25, name, 'litleToken')
        SchemaValidation.validate_length(this.expDate, false, 4, 4, name, 'expDate')
        SchemaValidation.validate_length(this.cardValidationNum, false, 1, 4, name, 'cardValidationNum')
        SchemaValidation.validate_enum(this.mop, false, ['','MC','VI','AX','DC','DI','PP','JC','BL','EC'], name, 'type')
        this
      else
        nil
      end
    end
  end
  
  class CardPaypage
    include XML::Mapping
    text_node :paypageRegistrationId, "paypageRegistrationId", :default_value=>nil
    text_node :expDate, "expDate", :default_value=>nil
    text_node :cardValidationNum, "cardValidationNum", :default_value=>nil
    text_node :mop, "type", :default_value=>nil
    def self.from_hash(hash, name='cardPaypage')
      base = hash[name]
      if(base)
        this = CardPaypage.new
        this.paypageRegistrationId = base['paypageRegistrationId']
        this.expDate = base['expDate']
        this.cardValidationNum = base['cardValidationNum']
        this.mop = base['type']
        SchemaValidation.validate_length(this.paypageRegistrationId, true, 1, 512, name, 'paypageRegistrationId')
        SchemaValidation.validate_length(this.expDate, false, 4, 4, name, 'expDate')
        SchemaValidation.validate_length(this.cardValidationNum, false, 1, 4, name, 'cardValidationNum')
        SchemaValidation.validate_enum(this.mop, false, ['','MC','VI','AX','DC','DI','PP','JC','BL','EC'], name, 'type')
        this
      else
        nil
      end
    end
  end
  
  class PayPal
    include XML::Mapping
    text_node :payerId, "payerId", :default_value=>nil
    text_node :token, "token", :default_value=>nil
    text_node :transactionId, "transactionId", :default_value=>nil
    def self.from_hash(hash, name='payPal')
      base = hash[name]
      if(base)
        this = PayPal.new
        this.payerId = base['payerId']
        this.token = base['token']
        this.transactionId = base['transactionId']
        SchemaValidation.validate_required(this.payerId, true, name, 'payerId')
        SchemaValidation.validate_required(this.transactionId, true, name, 'transactionId')
        this
      else
        nil
      end
    end
  end
  
  class CreditPayPal
    include XML::Mapping
    text_node :payerId, "payerId", :default_value=>nil
    text_node :payerEmail, "payerEmail", :default_value=>nil
    def self.from_hash(hash, name='creditPaypal')
      base = hash[name]
      if(base)
        this = CreditPayPal.new
        this.payerId = base['payerId']
        this.payerEmail = base['payerEmail']
        SchemaValidation.validate_length(this.payerId, false, 1, 17, name, 'payerId')
        SchemaValidation.validate_length(this.payerEmail, false, 1, 127, name, 'payerEmail')
        this
      else
        nil
      end
    end
  end
  
  class CustomBilling
    include XML::Mapping
    optional_choice_node :if,    'phone', :then, (text_node :phone, "phone", :default_value=>nil),
    :elsif, 'city',  :then, (text_node :city, "city", :default_value=>nil),
    :elsif, 'url',   :then, (text_node :url, "url", :default_value=>nil)
    text_node :descriptor, "descriptor", :default_value=>nil
    def self.from_hash(hash, name='customBilling')
      base = hash[name]
      if(base)
        this = CustomBilling.new
        this.phone = base['phone']
        this.city = base['city']
        this.url = base['url']
        this.descriptor = base['descriptor']
        SchemaValidation.validate_regex(this.phone, false, /\A\d{1,13}\Z/, name, 'phone')
        SchemaValidation.validate_length(this.city, false, 1, 35, name, 'city')
        SchemaValidation.validate_regex(this.url, false, /\A([A-Z,a-z,0-9,\/,\-,_,.]){1,13}\Z/, name, 'url')
        SchemaValidation.validate_regex(this.descriptor, false, /\A([A-Z,a-z,0-9, ,\*,,,\-,',#,&,.]){4,25}\Z/, name, 'descriptor')
        this
      else
        nil
      end
    end
  end
  
  class ProcessingInstructions
    include XML::Mapping
    text_node :bypassVelocityCheck, "bypassVelocityCheck", :default_value=>nil
    def self.from_hash(hash, name='processingInstructions')
      base = hash[name]
      if(base)
        this = ProcessingInstructions.new
        this.bypassVelocityCheck = base['bypassVelocityCheck']
        SchemaValidation.validate_boolean(this.bypassVelocityCheck, false, name, 'bypassVelocityCheck')
        this
      else
        nil
      end
    end
  end
  
  class EcheckForToken
    include XML::Mapping
    text_node :accNum, "accNum", :default_value=>nil
    text_node :routingNum, "routingNum", :default_value=>nil
    def self.from_hash(hash, name='echeckForToken')
      base = hash[name]
      if(base)
        this = EcheckForToken.new
        this.accNum = base['accNum']
        this.routingNum = base['routingNum']
        SchemaValidation.validate_length(this.accNum, true, 1, 17, name, 'accNum')
        SchemaValidation.validate_length(this.routingNum, true, 9, 9, name, 'routingNum')
        this
      else
        nil
      end
    end
  end
  
  class Filtering
    include XML::Mapping
    text_node :prepaid, "prepaid", :default_value=>nil
    text_node :international, "international", :default_value=>nil
    text_node :chargeback, "chargeback", :default_value=>nil
    def self.from_hash(hash, name='filtering')
      base = hash[name]
      if(base)
        this = Filtering.new
        this.prepaid = base['prepaid']
        this.international = base['international']
        this.chargeback = base['chargeback']
        SchemaValidation.validate_boolean(this.prepaid, false, name, 'prepaid')
        SchemaValidation.validate_boolean(this.international, false, name, 'international')
        SchemaValidation.validate_boolean(this.chargeback, false, name, 'chargeback')
        this
      else
        nil
      end
    end
  end
  
  class MerchantData
    include XML::Mapping
    text_node :campaign, "campaign", :default_value=>nil
    text_node :affiliate, "affiliate", :default_value=>nil
    text_node :merchantGroupingId, "merchantGroupingId", :default_value=>nil
    def self.from_hash(hash, name='merchantData')
      base = hash[name]
      if(base)
        this = MerchantData.new
        this.campaign = base['campaign']
        this.affiliate = base['affiliate']
        this.merchantGroupingId = base['merchantGroupingId']
        SchemaValidation.validate_length(this.campaign, false, 1, 25, name, 'campaign')
        SchemaValidation.validate_length(this.affiliate, false, 1, 25, name, 'affiliate')
        SchemaValidation.validate_length(this.merchantGroupingId, false, 1, 25, name, 'merchantGroupingId')
        this
      else
        nil
      end
    end
  end
  
  class Echeck
    include XML::Mapping
    text_node :accType, "accType", :default_value=>nil
    text_node :accNum, "accNum", :default_value=>nil
    text_node :routingNum, "routingNum", :default_value=>nil
    text_node :checkNum, "checkNum", :default_value=>nil
    def self.from_hash(hash, name='echeck')
      base = hash[name]
      if(base)
        this = Echeck.new
        this.accType = base['accType']
        this.accNum = base['accNum']
        this.routingNum = base['routingNum']
        this.checkNum = base['checkNum']
        SchemaValidation.validate_enum(this.accType, true, ['Checking','Savings','Corporate','Corp Savings'], name, 'accType')
        SchemaValidation.validate_length(this.accNum, true, 1, 17, name, 'accNum')
        SchemaValidation.validate_length(this.routingNum, true, 9, 9, name, 'routingNum')
        SchemaValidation.validate_length(this.checkNum, false, 1, 15, name, 'checkNum')
        this
      else
        nil
      end
    end
  end
  
  class EcheckToken
    include XML::Mapping
    text_node :litleToken, "litleToken", :default_value=>nil
    text_node :routingNum, "routingNum", :default_value=>nil
    text_node :accType, "accType", :default_value=>nil
    text_node :checkNum, "checkNum", :default_value=>nil
    def self.from_hash(hash, name='echeckToken')
      base = hash[name]
      if(base)
        this = EcheckToken.new
        this.litleToken = base['litleToken']
        this.routingNum = base['routingNum']
        this.accType = base['accType']
        this.checkNum = base['checkNum']
        SchemaValidation.validate_length(this.litleToken, true, 13, 25, name, 'litleToken')
        SchemaValidation.validate_length(this.routingNum, true, 9, 9, name, 'routingNum')
        SchemaValidation.validate_enum(this.accType, true, ['Checking','Savings','Corporate','Corp Savings'], name, 'accType')
        SchemaValidation.validate_length(this.checkNum, false, 1, 15, name, 'checkNum')
        this
      else
        nil
      end
    end
  end
  
  class RecyclingRequest
    include XML::Mapping
    text_node :recycleBy, "recycleBy", :default_value=>nil
    text_node :recycleId, "recycleId", :default_value=>nil
    def self.from_hash(hash, name='recyclingRequest')
      base = hash[name]
      if(base)
        this = RecyclingRequest.new
        this.recycleBy = base['recycleBy']
        this.recycleId = base['recycleId']
        SchemaValidation.validate_enum(this.recycleBy, false, ['Merchant','Litle','None'], name, 'recycleBy')
        SchemaValidation.validate_length(this.recycleId, false, 1, 25, name, 'recycleId')
        this
      else
        nil
      end
    end
  end
  
  class Authorization
    include XML::Mapping
    root_element_name "authorization"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :orderId, "orderId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :customerInfo, "customerInfo", :class=>CustomerInfo, :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    object_node :shipToAddress, "shipToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'card', :then, (object_node :card, "card", :class=>Card),
    :elsif, 'paypal', :then, (object_node :paypal, "paypal", :class=>PayPal),
    :elsif, 'token', :then, (object_node :token, "token", :class=>CardToken),
    :elsif, 'paypage', :then, (object_node :paypage, "paypage", :class=>CardPaypage)
    object_node :billMeLaterRequest, "billMeLaterRequest", :class=>BillMeLaterRequest, :default_value=>nil
    object_node :cardholderAuthentication, "cardholderAuthentication", :class=>FraudCheck, :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
    object_node :pos, "pos", :class=>Pos, :default_value=>nil
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    text_node :taxType, "taxType", :default_value=>nil
    object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
    object_node :amexAggregatorData, "amexAggregatorData", :class=>AmexAggregatorData, :default_value=>nil
    text_node :allowPartialAuth, "allowPartialAuth", :default_value=>nil
    object_node :healthcareIIAS, "healthcareIIAS", :class=>HealthcareIIAS, :default_value=>nil
    object_node :filtering, "filtering", :class=>Filtering, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
    object_node :recyclingRequest, "recyclingRequest", :class=>RecyclingRequest, :default_value=>nil
    text_node :fraudFilterOverride, "fraudFilterOverride", :default_value=>nil
  end
  
  class Sale
    include XML::Mapping
    root_element_name "sale"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :orderId, "orderId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :customerInfo, "customerInfo", :class=>CustomerInfo, :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    object_node :shipToAddress, "shipToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'card', :then, (object_node :card, "card", :class=>Card),
    :elsif, 'paypal', :then, (object_node :paypal, "paypal", :class=>PayPal),
    :elsif, 'token', :then, (object_node :token, "token", :class=>CardToken),
    :elsif, 'paypage', :then, (object_node :paypage, "paypage", :class=>CardPaypage)
    object_node :billMeLaterRequest, "billMeLaterRequest", :class=>BillMeLaterRequest, :default_value=>nil
    optional_choice_node :if,    'fraudCheck',               :then, (object_node :fraudCheck,               "fraudCheck",               :class=>FraudCheck, :default_value=>nil),
                         :elsif, 'cardholderAuthentication', :then, (object_node :cardholderAuthentication, "cardholderAuthentication", :class=>FraudCheck, :default_value=>nil)
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    text_node :taxType, "taxType", :default_value=>nil
    object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
    object_node :pos, "pos", :class=>Pos, :default_value=>nil
    text_node :payPalOrderComplete, "payPalOrderComplete", :default_value=>nil
    text_node :payPalNotes, "payPalNotes", :default_value=>nil
    object_node :amexAggregatorData, "amexAggregatorData", :class=>AmexAggregatorData, :default_value=>nil
    text_node :allowPartialAuth, "allowPartialAuth", :default_value=>nil
    object_node :healthcareIIAS, "healthcareIIAS", :class=>HealthcareIIAS, :default_value=>nil
    object_node :filtering, "filtering", :class=>Filtering, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
    object_node :recyclingRequest, "recyclingRequest", :class=>RecyclingRequest, :default_value=>nil
    text_node :fraudFilterOverride, "fraudFilterOverride", :default_value=>nil
  end
  
  class Credit
    include XML::Mapping
    root_element_name "credit"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :orderId, "orderId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'card', :then, (object_node :card, "card", :class=>Card),
    :elsif, 'paypal', :then, (object_node :paypal, "paypal", :class=>CreditPayPal),
    :elsif, 'token', :then, (object_node :token, "token", :class=>CardToken),
    :elsif, 'paypage', :then, (object_node :paypage, "paypage", :class=>CardPaypage)
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    text_node :taxType, "taxType", :default_value=>nil
    object_node :billMeLaterRequest, "billMeLaterRequest", :class=>BillMeLaterRequest, :default_value=>nil
    object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
    object_node :pos, "pos", :class=>Pos, :default_value=>nil
    object_node :amexAggregatorData, "amexAggregatorData", :class=>AmexAggregatorData, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
    text_node :payPalNotes, "payPalNotes", :default_value=>nil
    text_node :actionReason, "actionReason", :default_value=>nil
  end
  
  class RegisterTokenRequest
    include XML::Mapping
    root_element_name "registerTokenRequest"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :orderId, "orderId", :default_value=>nil
    optional_choice_node :if,    'accountNumber', :then, (text_node :accountNumber, "accountNumber", :default_value=>nil),
    :elsif, 'echeckForToken', :then, (object_node :echeckForToken, "echeckForToken", :class=>EcheckForToken),
    :elsif, 'paypageRegistrationId', :then, (text_node :paypageRegistrationId, "paypageRegistrationId", :default_value=>nil)
  end
  
  class CaptureGivenAuth
    include XML::Mapping
    root_element_name "captureGivenAuth"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :orderId, "orderId", :default_value=>nil
    object_node :authInformation, "authInformation", :class=>AuthInformation, :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    object_node :shipToAddress, "shipToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'card', :then, (object_node :card, "card", :class=>Card),
    :elsif, 'token', :then, (object_node :token, "token", :class=>CardToken),
    :elsif, 'paypage', :then, (object_node :paypage, "paypage", :class=>CardPaypage)
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    text_node :taxType, "taxType", :default_value=>nil
    object_node :billMeLaterRequest, "billMeLaterRequest", :class=>BillMeLaterRequest, :default_value=>nil
    object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
    object_node :pos, "pos", :class=>Pos, :default_value=>nil
    object_node :amexAggregatorData, "amexAggregatorData", :class=>AmexAggregatorData, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
  end
  
  class ForceCapture
    include XML::Mapping
    root_element_name "forceCapture"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :orderId, "orderId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'card', :then, (object_node :card, "card", :class=>Card),
    :elsif, 'token', :then, (object_node :token, "token", :class=>CardToken),
    :elsif, 'paypage', :then, (object_node :paypage, "paypage", :class=>CardPaypage)
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    text_node :taxType, "taxType", :default_value=>nil
    object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
    object_node :pos, "pos", :class=>Pos, :default_value=>nil
    object_node :amexAggregatorData, "amexAggregatorData", :class=>AmexAggregatorData, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
  end
  
  class AuthReversal
    include XML::Mapping
    root_element_name "authReversal"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
    text_node :partial, "@partial", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    text_node :payPalNotes, "payPalNotes", :default_value=>nil
    text_node :actionReason, "actionReason", :default_value=>nil
  end
  
  class Capture
    include XML::Mapping
    root_element_name "capture"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
    text_node :partial, "@partial", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :surchargeAmount, "surchargeAmount", :default_value=>nil
    object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
    text_node :payPalOrderComplete, "payPalOrderComplete", :default_value=>nil
    text_node :payPalNotes, "payPalNotes", :default_value=>nil
  end
  
  class Void
    include XML::Mapping
    root_element_name "void"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
  end
  
  class EcheckVoid
    include XML::Mapping
    root_element_name "echeckVoid"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
  end
  
  class EcheckVerification
    include XML::Mapping
    root_element_name "echeckVerification"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :orderId, "orderId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    object_node :shipToAddress, "shipToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'echeck', :then, (object_node :echeck, "echeck", :class=>Echeck),
    :elsif, 'echeckToken', :then, (object_node :echeckToken, "echeckToken", :class=>EcheckToken)
	object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
  end
  
  class EcheckCredit
    include XML::Mapping
    root_element_name "echeckCredit"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :orderId, "orderId", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'echeck', :then, (object_node :echeck, "echeck", :class=>Echeck, :default_value=>nil),
    :elsif, 'echeckToken', :then, (object_node :echeckToken, "echeckToken", :class=>EcheckToken, :default_value=>nil)
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
  end
  
  class EcheckRedeposit
    include XML::Mapping
    root_element_name "echeckRedeposit"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    optional_choice_node :if,    'echeck', :then, (object_node :echeck, "echeck", :class=>Echeck, :default_value=>nil),
    :elsif, 'echeckToken', :then, (object_node :echeckToken, "echeckToken", :class=>EcheckToken, :default_value=>nil)
	object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
  end
  
  class EcheckSale
    include XML::Mapping
    root_element_name "echeckSale"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :litleTxnId, "litleTxnId", :default_value=>nil
    text_node :orderId, "orderId", :default_value=>nil
    text_node :verify, "verify", :default_value=>nil
    text_node :amount, "amount", :default_value=>nil
    text_node :orderSource, "orderSource", :default_value=>nil
    object_node :billToAddress, "billToAddress", :class=>Contact, :default_value=>nil
    object_node :shipToAddress, "shipToAddress", :class=>Contact, :default_value=>nil
    optional_choice_node :if,    'echeck', :then, (object_node :echeck, "echeck", :class=>Echeck, :default_value=>nil),
    :elsif, 'echeckToken', :then, (object_node :echeckToken, "echeckToken", :class=>EcheckToken, :default_value=>nil)
    object_node :customBilling, "customBilling", :class=>CustomBilling, :default_value=>nil
    object_node :merchantData, "merchantData", :class=>MerchantData, :default_value=>nil
  end
  
  class UpdateCardValidationNumOnToken
    include XML::Mapping
    root_element_name "updateCardValidationNumOnToken"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :orderId, "orderId", :default_value=>nil
    text_node :litleToken, "litleToken", :default_value=>nil
    text_node :cardValidationNum, "cardValidationNum", :default_value=>nil
  end
  
  class AccountUpdate
    include XML::Mapping
    root_element_name "accountUpdate"
    text_node :reportGroup, "@reportGroup", :default_value=>nil
    text_node :transactionId, "@id", :default_value=>nil
    text_node :customerId, "@customerId", :default_value=>nil
  
    text_node :orderId, "orderId", :default_value=>nil
    optional_choice_node :if,    'card', :then, (object_node :card, "card", :class=>Card),
    :else, (object_node :token, "token", :class=>CardToken)
  end
  
  class OnlineRequest
    include XML::Mapping
    root_element_name "litleOnlineRequest"
    text_node :merchantId, "@merchantId", :default_value=>nil
    text_node :version, "@version", :default_value=>nil
    text_node :xmlns, "@xmlns", :default_value=>nil
    text_node :merchantSdk, "@merchantSdk", :default_value=>nil
    text_node :loggedInUser, "@loggedInUser", :default_value=>nil
    object_node :authentication, "authentication", :class=>Authentication
    optional_choice_node   :if,    'authorization', :then, (object_node :authorization, "authorization", :class=>Authorization),
    :elsif, 'sale',    :then, (object_node :sale,    "sale",    :class=>Sale),
    :elsif, 'captureTxn', :then, (object_node :captureTxn, "captureTxn", :class=>Capture),
    :elsif, 'captureGivenAuth', :then, (object_node :captureGivenAuth, "captureGivenAuth", :class=>CaptureGivenAuth),
    :elsif, 'void', :then, (object_node :void, "void", :class=>Void),
    :elsif, 'forceCapture', :then, (object_node :forceCapture, "forceCapture", :class=>ForceCapture),
    :elsif, 'credit', :then, (object_node :credit, "credit", :class=>Credit),
    :elsif, 'authReversal', :then, (object_node :authReversal, "authReversal", :class=>AuthReversal),
    :elsif, 'echeckCredit', :then, (object_node :echeckCredit, "echeckCredit", :class=>EcheckCredit),
    :elsif, 'echeckRedeposit', :then, (object_node :echeckRedeposit, "echeckRedeposit", :class=>EcheckRedeposit),
    :elsif, 'echeckSale', :then, (object_node :echeckSale, "echeckSale", :class=>EcheckSale),
    :elsif, 'echeckVoid', :then, (object_node :echeckVoid, "echeckVoid", :class=>EcheckVoid),
    :elsif, 'echeckVerification', :then, (object_node :echeckVerification, "echeckVerification", :class=>EcheckVerification),
    :elsif, 'registerTokenRequest', :then, (object_node :registerTokenRequest, "registerTokenRequest", :class=>RegisterTokenRequest),
    :elsif, 'updateCardValidationNumOnToken', :then, (object_node :updateCardValidationNumOnToken, "updateCardValidationNumOnToken", :class=>UpdateCardValidationNumOnToken)
    def post_save(xml, options={:Mapping=>:_default})
      xml.each_element() {|el| 
        if(el.name == 'captureTxn')
          el.name = 'capture'
        end      
      }
    end
    
  end
  
  class BatchRequest
    include XML::Mapping
    root_element_name "batchRequest" 

    text_node :numAuths, "@numAuths", :default_value=>"0"
    text_node :authAmount, "@authAmount", :default_value=>"0"
    text_node :numSales, "@numSales", :default_value=>"0"
    text_node :saleAmount, "@saleAmount", :default_value=>"0"
    text_node :numCredits, "@numCredits", :default_value=>"0"
    text_node :creditAmount, "@creditAmount", :default_value=>"0"
    text_node :numTokenRegistrations, "@numTokenRegistrations", :default_value=>"0"
    text_node :numCaptureGivenAuths, "@numCaptureGivenAuths", :default_value=>"0"
    text_node :captureGivenAuthAmount, "@captureGivenAuthAmount", :default_value=>"0"
    text_node :numForceCaptures, "@numForceCaptures", :default_value=>"0"
    text_node :forceCaptureAmount, "@forceCaptureAmount", :default_value=>"0"
    text_node :numAuthReversals, "@numAuthReversals", :default_value=>"0"
    text_node :authReversalAmount, "@authReversalAmount", :default_value=>"0"
    text_node :numCaptures, "@numCaptures", :default_value=>"0"
    text_node :captureAmount, "@captureAmount", :default_value=>"0"
    text_node :numEcheckSales, "@numEcheckSales", :default_value=>"0"
    text_node :echeckSalesAmount, "@echeckSalesAmount", :default_value=>"0"
    text_node :numEcheckRedeposit, "@numEcheckRedeposit", :default_value=>"0"
    text_node :numEcheckCredit, "@numEcheckCredit", :default_value=>"0"
    text_node :echeckCreditAmount, "@echeckCreditAmount", :default_value=>"0"
    text_node :numEcheckVerification, "@numEcheckVerification", :default_value=>"0"
    text_node :echeckVerificationAmount, "@echeckVerificationAmount", :default_value=>"0"
    text_node :numUpdateCardValidationNumOnTokens, "@numUpdateCardValidationNumOnTokens", :default_value=>"0"
    text_node :numAccountUpdates, "@numAccountUpdates", :default_value=>"0"
    text_node :merchantId, "@merchantId", :default_value=>nil
    text_node :id, "@id", :default_value=>nil
  end
  
  class LitleRequest
    include XML::Mapping
    # version="6.0" xmlns="http://www.litle.com/schema" numBatchRequests = "1">
    # <authentication>
        # <user>XMLTESTV6ORG14</user>
        # <password>password</password>
    # </authentication>
    root_element_name "litleRequest"
    
    text_node :version, "@version", :default_value=>"0"
    text_node :xmlns, "@xmlns", :default_value=>nil
    #TODO: ask greg about sessionId
    #text_node :sessionId, "@id", default_vale:nil
    text_node :numBatchRequests, "@numBatchRequests", :default_value=>"0"
    object_node :authentication, "authentication", :class=>Authentication    
  end
  
  class AccountUpdateFileRequestData
    include XML::Mapping
    root_element_name "accountUpdateFileRequestData"
    
    text_node :merchantId, "merchantId", :default_value=>nil
    text_node :postDay, "postDay", :default_value=>nil
  end
  
  class LitleRFRRequest
    include XML::Mapping
    root_element_name "RFRRequest"
    optional_choice_node   :if,    'litleSessionId', :then, (text_node :litleSessionId, "litleSessionId"),
    :elsif, 'accountUpdateFileRequestData',    :then, (object_node :accountUpdateFileRequestData,    "accountUpdateFileRequestData",    :class=>AccountUpdateFileRequestData)
  end
  
  class LitleRequestForRFR
    include XML::Mapping
    root_element_name "litleRequest"
    text_node :version, "@version", :default_value=>"0"
    text_node :xmlns, "@xmlns", :default_value=>nil
    text_node :numBatchRequests, "@numBatchRequests", :default_value=>nil
    object_node :authentication, "authentication", :class=>Authentication    
    object_node :rfrRequest, 'RFRRequest', :class=>LitleRFRRequest
  end
# begin   
  # class LitleOnlineResponse
    # attr_accessor :message
  # end
#   
  # class XMLFields
#   
  # end
end
