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
#contains all of the underlying XML fields and specifications needed to create the transaction set

class XMLFields
  def XMLFields.contact(hash_in)
    hash_out = {
      :name => hash_in['name'],
      :firstName =>hash_in['firstName'],
      :middleInitial=>hash_in['middleInitial'],
      :lastName=>hash_in['lastName'],
      :companyName=>hash_in['companyName'],
      :addressLine1=>hash_in['addressLine1'],
      :addressLine2=>hash_in['addressLine2'],
      :addressLine3=>hash_in['addressLine3'],
      :city=>hash_in['city'],
      :state=>hash_in['state'],
      :zip=>hash_in['zip'],
      :country=>hash_in['country'],
      :email=>hash_in['email'],
      :phone=>hash_in['phone']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.customerInfo(hash_in)
    hash_out={
      :ssn=>hash_in['ssn'],
      :dob=>hash_in['dob'],
      :customerRegistrationDate=>hash_in['customerRegistrationDate'],
      :customerType=>hash_in['customerType'],
      :incomeAmount=>hash_in['incomeAmount'],
      :incomeCurrency=>hash_in['incomeCurrency'],
      :customerCheckingAccount=>hash_in['customerCheckingAccount'],
      :customerSavingAccount=>hash_in['customerSavingAccount'],
      :customerWorkTelephone=>hash_in['customerWorkTelephone'],
      :residenceStatus=>hash_in['residenceStatus'],
      :yearsAtResidence=>hash_in['yearsAtResidence'],
      :yearsAtEmployer=>hash_in['yearsAtEmployer']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.billMeLaterRequest(hash_in)
    hash_out = {
      :bmlMerchantId=>hash_in['bmlMerchantId'],
      :termsAndConditions=>hash_in['termsAndConditions'],
      :preapprovalNumber=>hash_in['preapprovalNumber'],
      :merchantPromotionalCode=>hash_in['merchantPromotionalCode'],
      :customerPasswordChanged=>hash_in['customerPasswordChanged'],
      :customerEmailChanged=>hash_in['customerEmailChanged'],
      :customerPhoneChanged=>hash_in['customerPhoneChanged'],
      :secretQuestionCode=>hash_in['secretQuestionCode'],
      :secretQuestionAnswer=>hash_in['secretQuestionAnswer'] ,
      :virtualAuthenticationKeyPresenceIndicator=>hash_in['virtualAuthenticationKeyPresenceIndicator'] ,
      :virtualAuthenticationKeyData=>hash_in['virtualAuthenticationKeyData'],
      :itemCategoryCode=>hash_in['itemCategoryCode'] ,
      :authorizationSourcePlatform=>hash_in['authorizationSourcePlatform']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.fraudCheckType(hash_in)
    hash_out = {
      :authenticationValue=>hash_in['authenticationValue'],
      :authenticationTransactionId=>hash_in['authenticationTransactionId'],
      :customerIpAddress=>hash_in['customerIpAddress'],
      :authenticatedByMerchant=>hash_in['authenticatedByMerchant']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.authInformation(hash_in)
    hash_out = {
      :authDate=>(hash_in['authDate']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :authCode=>(hash_in['authCode']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :fraudResult=>fraudResult((hash_in['detailTax'] or ' ')),
      :authAmount=>hash_in['authAmount']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.fraudResult(hash_in)
    hash_out= {
      :avsResult=>hash_in['avsResult'],
      :cardValidationResult=>hash_in['cardValidationResult'],
      :authenticationResult=>hash_in['authenticationResult'],
      :advancedAVSResult=>hash_in['advancedAVSResult']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.healthcareAmounts(hash_in)
    hash_out = {
      :totalHealthcareAmount=>hash_in['totalHealthcareAmount'],
      :RxAmount=>hash_in['RxAmount'],
      :visionAmount=>hash_in['visionAmount'],
      :clinicOtherAmount=>hash_in['clinicOtherAmount'],
      :dentalAmount=>hash_in['dentalAmount']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.healthcareIIAS(hash_in)
    hash_out ={
      :healthcareAmounts=>healthcareAmounts((hash_in['healthcareAmounts'] or ' ')),
      :IIASFlag=>hash_in['IIASFlag']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.pos(hash_in)
    hash_out = {
      :capability=>(hash_in['capability']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :entryMode=>(hash_in['entryMode']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :cardholderId=>(hash_in['cardholderId']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag'))
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.detailTax(hash_in)
    hash_out ={
      :taxIncludedInTotal=>hash_in['taxIncludedInTotal'],
      :taxAmount=>hash_in['taxAmount'],
      :taxRate=>hash_in['taxRate'],
      :taxTypeIdentifier=>hash_in['taxTypeIdentifier'],
      :cardAcceptorTaxId=>hash_in['cardAcceptorTaxId']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.lineItemData(hash_in)
    hash_out = {
      :itemSequenceNumber=>hash_in['itemSequenceNumber'],
      :itemDescription=>hash_in['itemDescription'],
      :productCode=>hash_in['productCode'],
      :quantity=>hash_in['quantity'],
      :unitOfMeasure=>hash_in['unitOfMeasure'],
      :taxAmount=>hash_in['taxAmount'],
      :lineItemTotal=>hash_in['lineItemTotal'],
      :lineItemTotalWithTax=>hash_in['lineItemTotalWithTax'],
      :itemDiscountAmount=>hash_in['itemDiscountAmount'],
      :commodityCode=>hash_in['commodityCode'],
      :unitCost=>hash_in['unitCost'],
      :detailTax => detailTax((hash_in['detailTax'] or ' '))
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.enhancedData(hash_in)
    hash_out = {
      :customerReference=>hash_in['customerReference'],
      :salesTax=>hash_in['salesTax'],
      :deliveryType=>hash_in['deliveryType'],
      :taxExempt=>hash_in['taxExempt'],
      :discountAmount=>hash_in['discountAmount'],
      :shippingAmount=>hash_in['shippingAmount'],
      :dutyAmount=>hash_in['dutyAmount'],
      :shipFromPostalCode=>hash_in['shipFromPostalCode'],
      :destinationPostalCode=>hash_in['destinationPostalCode'],
      :destinationCountryCode=>hash_in['destinationCountryCode'],
      :invoiceReferenceNumber=>hash_in['invoiceReferenceNumber'],
      :orderDate=>hash_in['orderDate'],
      :detailTax=> detailTax((hash_in['detailTax'] or ' ')),
      :lineItemData=> lineItemData((hash_in['lineItemData'] or ' '))
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.amexAggregatorData(hash_in)
    hash_out ={
      :sellerId=>hash_in['sellerId'],
      :sellerMerchantCategoryCode=>hash_in['sellerMerchantCategoryCode']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.cardType(hash_in)
    hash_out= {
      :type=>hash_in['type'] ,
      :track=>hash_in['track'],
      :number=>hash_in['number'],
      :expDate=>hash_in['expDate'],
      :cardValidationNum=>hash_in['cardValidationNum']
    }
    Checker.purgeNull(hash_out)
    choice_hash={'1'=>hash_out[:type],'2'=>hash_out[:track]}
    Checker.choice(choice_hash)
    return hash_out
  end

  def XMLFields.cardTokenType(hash_in)
    hash_out = {
      :litleToken=>(hash_in['litleToken'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :expDate=>hash_in['expDate'],
      :cardValidationNum=>hash_in['cardValidationNumber'],
      :type=>hash_in['type']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.cardPaypageType(hash_in)
    hash_out = {
      :paypageRegistrationId=>(hash_in['paypageRegistrationId'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :expDate=>hash_in['expDate'] ,
      :cardValidationNum=>hash_in['cardValidationNumber'],
      :type=>hash_in['type']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.payPal(hash_in)
    hash_out = {
      :payerId=>(hash_in['payerId']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :token=>hash_in['token'],
      :transactionId=>(hash_in['transactionId']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag'))
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.credit_payPal(hash_in)
    hash_out = {
      :payerId=>(hash_in['payerId']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :payerEmail => (hash_in['payerEmail']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
    }
    Checker.purgeNull(hash_out)
    choice_hash={'1'=>hash_out[:payerId],'2'=>hash_out[:payerEmail]}
    Checker.choice(choice_hash)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.customBilling(hash_in)
    hash_out = {
      :phone=>hash_in['phone'],
      :city=>hash_in['city'],
      :url=>hash_in['url']
    }
    Checker.purgeNull(hash_out)
    Checker.choice(hash_out)
    hash_out[:descriptor] = hash_in['descriptor']
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out

  end

  def XMLFields.taxBilling(hash_in)
    hash_out = {
      :taxAuthority=>(hash_in['taxAuthority']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :state=>(hash_in['state']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :govtTxnType=>(hash_in['govtTxnType']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag'))
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.processingInstructions(hash_in)
    hash_out ={
      :bypassVelocityCheck=>hash_in['bypassVelocityCheck']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.echeckForTokenType(hash_in)
    hash_out = {
      :accNum=>(hash_in['accNum'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :routingNum=>(hash_in['routingNum']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag'))
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.filteringType(hash_in)
    hash_out = {
      :prepaid=>hash_in['prepaid'],
      :international=>hash_in['international'],
      :chargeback=>hash_in['chargeback']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.echeckType(hash_in)
    hash_out= {
      :accType=>(hash_in['accType'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :accNum=>(hash_in['accNum'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :routingNum=>(hash_in['routingNum']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :checkNum=>hash_in['checkNumberType']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.echeckTokenType(hash_in)
    hash_out= {
      :litleToken=>(hash_in['litleToken'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :routingNum=>(hash_in['routingNum']  or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :accType=>(hash_in['accType'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
      :checkNum=>hash_in['checkNum']
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end

  def XMLFields.recyclingRequestType(hash_in)
    hash_out= {
      :recyleBy=>(hash_in['recyleBy'] or (!(hash_in.length== 1) ? 'REQUIRED':'throwFlag')),
    }
    Checker.purgeNull(hash_out)
    Checker.requiredMissing(hash_out)
    return hash_out
  end
end

