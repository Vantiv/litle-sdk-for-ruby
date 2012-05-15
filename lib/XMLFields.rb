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
      this.customerWorkTelephone = base['customerWorkTelephone']
      this.residenceStatus = base['residenceStatus']
      this.yearsAtResidence = base['yearsAtResidence']
      this.yearsAtEmployer = base['yearsAtEmployer']
      this
    else
      nil
    end
  end
end

class BillMeLaterRequest
  include XML::Mapping
  text_node :bmlMerchantId, "bmlMerchantId", :default_value=>nil
  text_node :termsAndConditions, "termsAndConditions", :default_value=>nil
  text_node :preapprovalNumber, "preapprovalNumber", :default_value=>nil
  text_node :merchantPromotionalCode, "merchantPromotionalCode", :default_value=>nil
  text_node :customerPasswordChanged, "customerPasswordChanged", :default_value=>nil
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
      this.termsAndConditions = base['termsAndConditions']
      this.merchantPromotionalCode = base['merchantPromotionalCode']
      this.customerPasswordChanged = base['customerPasswordChanged']
      this.customerEmailChanged = base['customerEmailChanged']
      this.customerPhoneChanged = base['customerPhoneChanged']
      this.secretQuestionCode = base['secretQuestionCode']
      this.secretQuestionAnswer = base['secretQuestionAnswer']
      this.virtualAuthenticationKeyPresenceIndicator = base['virtualAuthenticationKeyPresenceIndicator']
      this.virtualAuthenticationKeyData = base['virtualAuthenticationKeyData']
      this.itemCategoryCode = base['itemCategoryCode']
      this.authorizationSourcePlatform = base['authorizationSourcePlatform']
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
  def self.from_hash(hash, name='pos')
    base = hash[name]
    if(base)
      this = Pos.new
      this.capability = base['capability']
      this.entryMode = base['entryMode']
      this.cardholderId = base['cardholderId']
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
      this
    else
      nil
    end
  end
end

class CustomBilling
  include XML::Mapping
  optional_choice_node :if,    'phone', :then, (text_node :phone, "phone", :default_value=>nil),
  :elsif, 'city',  :then, (text_node :city, "city", :default_vaule=>nil),
  :elsif, 'url',   :then, (text_node :url, "url", :default_vaule=>nil)
  text_node :descriptor, "descriptor", :default_value=>nil
  def self.from_hash(hash, name='customBilling')
    base = hash[name]
    if(base)
      this = CustomBilling.new
      this.phone = base['phone']
      this.city = base['city']
      this.url = base['url']
      this.descriptor = base['descriptor']
      this
    else
      nil
    end
  end
end

class TaxBilling
  include XML::Mapping
  text_node :taxAuthority, "taxAuthority", :default_value=>nil
  text_node :state, "state", :default_value=>nil
  text_node :govtTxnType, "govtTxnType", :default_value=>nil
  def self.from_hash(hash, name='taxBilling')
    base = hash[name]
    if(base)
      this = TaxBilling.new
      this.taxAuthority = base['taxAuthority']
      this.state = base['state']
      this.govtTxnType = base['govtTxnType']
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
      this
    else
      nil
    end
  end
end

class RecyclingRequest
  include XML::Mapping
  text_node :recyleBy, "recyleBy", :default_value=>nil
  def self.from_hash(hash, name='recyclingRequest')
    base = hash[name]
    if(base)
      this = RecyclingRequest.new
      this.recyleBy = base['recyleBy']
      this
    else
      nil
    end
  end
end

class Authorization
  include XML::Mapping
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  text_node :orderId, "orderId", :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
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
end

class Sale
  include XML::Mapping
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  text_node :orderId, "orderId", :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
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
end

class Credit
  include XML::Mapping
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  text_node :orderId, "orderId", :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
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
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :orderId, "orderId", :default_value=>nil
  object_node :authInformation, "authInformation", :class=>AuthInformation, :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
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
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :orderId, "orderId", :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
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
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil
  text_node :partial, "@partial", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
  text_node :payPalNotes, "payPalNotes", :default_value=>nil
  text_node :actionReason, "actionReason", :default_value=>nil
end

class Capture
  include XML::Mapping
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil
  text_node :partial, "@partial", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  text_node :amount, "amount", :default_value=>nil
  object_node :enhancedData, "enhancedData", :class=>EnhancedData, :default_value=>nil
  object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
  text_node :payPalOrderComplete, "payPalOrderComplete", :default_value=>nil
  text_node :payPalNotes, "payPalNotes", :default_value=>nil
end

class Void
  include XML::Mapping
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  object_node :processingInstructions, "processingInstructions", :class=>ProcessingInstructions, :default_value=>nil
end

class EcheckVoid
  include XML::Mapping
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
end

class EcheckVerification
  include XML::Mapping
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
end

class EcheckCredit
  include XML::Mapping
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
  text_node :reportGroup, "@reportGroup", :default_value=>nil
  text_node :transactionId, "@id", :default_value=>nil
  text_node :customerId, "@customerId", :default_value=>nil

  text_node :litleTxnId, "litleTxnId", :default_value=>nil
  optional_choice_node :if,    'echeck', :then, (object_node :echeck, "echeck", :class=>Echeck, :default_value=>nil),
  :elsif, 'echeckToken', :then, (object_node :echeckToken, "echeckToken", :class=>EcheckToken, :default_value=>nil)
end

class EcheckSale
  include XML::Mapping
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

class OnlineRequest
  include XML::Mapping
  root_element_name "litleOnlineRequest"
  text_node :merchantId, "@merchantId", :default_value=>nil
  text_node :version, "@version", :default_value=>nil
  text_node :xmlns, "@xmlns", :default_value=>nil
  text_node :merchantSdk, "@merchantSdk", :default_vaule=>nil
  object_node :authentication, "authentication", :class=>Authentication
  optional_choice_node   :if,    'authorization', :then, (object_node :authorization, "authorization", :class=>Authorization),
  :elsif, 'sale', :then, (object_node :sale, "sale", :class=>Sale),
  :elsif, 'captureGivenAuth', :then, (object_node :captureGivenAuth, "captureGivenAuth", :class=>CaptureGivenAuth),
  :elsif, 'capture', :then, (object_node :capture, "capture", :class=>Capture),
  :elsif, 'void', :then, (object_node :void, "void", :class=>Void),
  :elsif, 'forceCapture', :then, (object_node :forceCapture, "forceCapture", :class=>Capture),
  :elsif, 'credit', :then, (object_node :credit, "credit", :class=>Credit),
  :elsif, 'authReversal', :then, (object_node :authReversal, "authReversal", :class=>AuthReversal),
  :elsif, 'echeckCredit', :then, (object_node :echeckCredit, "echeckCredit", :class=>EcheckCredit),
  :elsif, 'echeckRedeposit', :then, (object_node :echeckRedeposit, "echeckRedeposit", :class=>EcheckRedeposit),
  :elsif, 'echeckSale', :then, (object_node :echeckSale, "echeckSale", :class=>EcheckSale),
  :elsif, 'echeckVoid', :then, (object_node :echeckVoid, "echeckVoid", :class=>EcheckVoid),
  :elsif, 'echeckVerification', :then, (object_node :echeckVerification, "echeckVerification", :class=>EcheckVerification),
  :elsif, 'registerTokenRequest', :then, (object_node :registerTokenRequest, "registerTokenRequest", :class=>RegisterTokenRequest)
end

class LitleOnlineResponse
  attr_accessor :message
end

class XMLFields

end
