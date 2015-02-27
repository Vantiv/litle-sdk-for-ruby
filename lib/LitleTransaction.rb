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
# contains the methods to properly create each transaction type
#
module LitleOnline
  class LitleTransaction
    def authorization(options)
      transaction = Authorization.new
      transaction.secondaryAmount = options['secondaryAmount']
      transaction.surchargeAmount    = options['surchargeAmount']
      transaction.recurringRequest   = RecurringRequest.from_hash(options,'recurringRequest')
      transaction.debtRepayment	     = options['debtRepayment']
      transaction.advancedFraudChecks = AdvancedFraudChecks.from_hash(options, 'advancedFraudChecks')
      add_transaction_info(transaction, options)

      return transaction
    end

    def cancel_subscription(options)
      transaction = CancelSubscription.new
      transaction.subscriptionId = options['subscriptionId']
      return transaction
    end

    def activate(options)
      transaction = Activate.new
      transaction.orderId = options['orderId']
      transaction.orderSource = options['orderSource']
      transaction.amount = options['amount']
      transaction.card = Card.from_hash(options,'card')
      transaction.virtualGiftCard = VirtualGiftCard.from_hash(options,'virtualGiftCard')
      return transaction
    end

    def deactivate(options)
      transaction = Deactivate.new
      transaction.orderId = options['orderId']
      transaction.orderSource = options['orderSource']
      transaction.card = Card.from_hash(options,'card')
      return transaction
    end

    def load_request(options)
      transaction = Load.new
      transaction.orderId = options['orderId']
      transaction.orderSource = options['orderSource']
      transaction.amount = options['amount']
      transaction.card = Card.from_hash(options,'card')
      return transaction
    end

    def unload_request(options)
      transaction = Unload.new
      transaction.orderId = options['orderId']
      transaction.orderSource = options['orderSource']
      transaction.amount = options['amount']
      transaction.card = Card.from_hash(options,'card')
      return transaction
    end

    def balance_inquiry(options)
      transaction = BalanceInquiry.new
      transaction.orderId = options['orderId']
      transaction.orderSource = options['orderSource']
      transaction.card = Card.from_hash(options,'card')
      return transaction
    end

    def update_subscription(options)
      transaction = UpdateSubscription.new
      transaction.subscriptionId = options['subscriptionId']
      transaction.planCode=options['planCode']
      transaction.billToAddress=Contact.from_hash(options,'billToAddress')
      transaction.card=Card.from_hash(options,'card')
      transaction.billingDate=options['billingDate']
      transaction.card                  = Card.from_hash(options)
      transaction.token                 = CardToken.from_hash(options,'token')
      transaction.paypage               = CardPaypage.from_hash(options,'paypage')
      if(options['createDiscount'])
        options['createDiscount'].each_index {| index | transaction.createDiscount << CreateDiscount.from_hash(options, index,'createDiscount')}
      end
      if(options['updateDiscount'])
        options['updateDiscount'].each_index {| index | transaction.updateDiscount << UpdateDiscount.from_hash(options, index,'updateDiscount')}
      end
      if(options['deleteDiscount'])
        options['deleteDiscount'].each_index {| index | transaction.deleteDiscount << DeleteDiscount.from_hash(options, index,'deleteDiscount')}
      end
      if(options['createAddOn'])
        options['createAddOn'].each_index {| index | transaction.createAddOn << CreateAddOn.from_hash(options, index,'createAddOn')}
      end
      if(options['updateAddOn'])
        options['updateAddOn'].each_index {| index | transaction.updateAddOn << UpdateAddOn.from_hash(options, index,'updateAddOn')}
      end
      if(options['deleteAddOn'])
        options['deleteAddOn'].each_index {| index | transaction.deleteAddOn << DeleteAddOn.from_hash(options, index,'deleteAddOn')}
      end

      return transaction
    end

    def create_plan(options)
      transaction = CreatePlan.new
      transaction.planCode = options['planCode']
      transaction.name=options['name']
      transaction.description=options['description']
      transaction.intervalType=options['intervalType']
      transaction.amount=options['amount']
      transaction.numberOfPayments=options['numberOfPayments']
      transaction.trialNumberOfIntervals=options['trialNumberOfIntervals']
      transaction.trialIntervalType=options['trialIntervalType']
      transaction.active=options['active']
      return transaction
    end

    def update_plan(options)
      transaction = UpdatePlan.new
      transaction.planCode = options['planCode']
      transaction.active=options['active']
      return transaction
    end

    def virtual_giftcard(options)
      transaction = VirtualGiftCard.new
      transaction.accountNumberLength = options['accountNumberLength']
      transaction.giftCardBin = options['giftCardBin']
      return transaction
    end

    def activate_reversal(options)
      transaction = ActivateReversal.new
      transaction.litleTxnId = options['litleTxnId']
      return transaction
    end

    def deposit_reversal(options)
      transaction = DepositReversal.new
      transaction.litleTxnId = options['litleTxnId']
      return transaction
    end

    def refund_reversal(options)
      transaction = RefundReversal.new
      transaction.litleTxnId = options['litleTxnId']
      return transaction
    end

    def deactivate_reversal(options)
      transaction = DeactivateReversal.new
      transaction.litleTxnId = options['litleTxnId']
      return transaction
    end

    def load_reversal(options)
      transaction = LoadReversal.new
      transaction.litleTxnId = options['litleTxnId']
      return transaction
    end

    def unload_reversal(options)
      transaction = UnloadReversal.new
      transaction.litleTxnId = options['litleTxnId']
      return transaction
    end

    def sale(options)
      transaction = Sale.new
      add_transaction_info(transaction, options)
      transaction.secondaryAmount     = options['secondaryAmount']
      transaction.surchargeAmount     = options['surchargeAmount']
      transaction.fraudCheck          = FraudCheck.from_hash(options,'fraudCheck')
      transaction.payPalOrderComplete = options['payPalOrderComplete']
      transaction.payPalNotes         = options['payPalNotes']
      transaction.recurringRequest    = RecurringRequest.from_hash(options,'recurringRequest')
      transaction.litleInternalRecurringRequest = LitleInternalRecurringRequest.from_hash(options,'litleInternalRecurringRequest')
      transaction.debtRepayment	     = options['debtRepayment']
      transaction.advancedFraudChecks = AdvancedFraudChecks.from_hash(options, 'advancedFraudChecks')
      return transaction
    end

    def credit(options)
      transaction = Credit.new
      transaction.litleTxnId              = options['litleTxnId']
      if(transaction.litleTxnId.nil?)
        transaction.orderId               = options['orderId']
        transaction.orderSource           = options['orderSource']
        transaction.taxType               = options['taxType']
        transaction.billToAddress         = Contact.from_hash(options,'billToAddress')
        transaction.amexAggregatorData    = AmexAggregatorData.from_hash(options)
        transaction.card                  = Card.from_hash(options)
        transaction.token                 = CardToken.from_hash(options,'token')
        transaction.paypage               = CardPaypage.from_hash(options,'paypage')
        transaction.mpos                  = Mpos.from_hash(options,'mpos')
      end
      transaction.amount                  = options['amount']
      transaction.secondaryAmount         = options['secondaryAmount']
      transaction.surchargeAmount         = options['surchargeAmount']
      transaction.customBilling           = CustomBilling.from_hash(options)
      transaction.enhancedData            = EnhancedData.from_hash(options)
      transaction.processingInstructions  = ProcessingInstructions.from_hash(options)
      transaction.pos                     = Pos.from_hash(options)
      transaction.billMeLaterRequest      = BillMeLaterRequest.from_hash(options)
      transaction.payPalNotes             = options['payPalNotes']
      transaction.actionReason            = options['actionReason']
      transaction.paypal                  = CreditPayPal.from_hash(options,'paypal')

      add_account_info(transaction, options)
      return transaction
    end

    def auth_reversal(options)
      transaction = AuthReversal.new

      transaction.litleTxnId      = options['litleTxnId']
      transaction.amount          = options['amount']
      transaction.surchargeAmount = options['surchargeAmount']
      transaction.payPalNotes     = options['payPalNotes']
      transaction.actionReason    = options['actionReason']

      add_account_info(transaction, options)
      return transaction
    end

    def register_token_request(options)
      transaction = RegisterTokenRequest.new

      transaction.orderId               = options['orderId']
      transaction.accountNumber         = options['accountNumber']
      transaction.echeckForToken        = EcheckForToken.from_hash(options)
      transaction.paypageRegistrationId = options['paypageRegistrationId']
      transaction.applepay              = Applepay.from_hash(options,'applepay')
      add_account_info(transaction, options)
      return transaction
    end

    def update_card_validation_num_on_token(options)
      transaction = UpdateCardValidationNumOnToken.new

      transaction.orderId               = options['orderId']
      transaction.litleToken            = options['litleToken']
      transaction.cardValidationNum     = options['cardValidationNum']

      SchemaValidation.validate_length(transaction.litleToken, true, 13, 25, "updateCardValidationNumOnToken", "litleToken")
      SchemaValidation.validate_length(transaction.cardValidationNum, true, 1, 4, "updateCardValidationNumOnToken", "cardValidationNum")

      add_account_info(transaction, options)
      return transaction
    end

    def force_capture(options)
      transaction = ForceCapture.new
      transaction.secondaryAmount = options['secondaryAmount']
      transaction.surchargeAmount    = options['surchargeAmount']
      transaction.customBilling      = CustomBilling.from_hash(options)
      transaction.debtRepayment	     = options['debtRepayment']
      add_order_info(transaction, options)

      return transaction
    end

    def capture(options)
      transaction = Capture.new

      transaction.partial                 = options['partial']
      transaction.litleTxnId              = options['litleTxnId']
      transaction.amount                  = options['amount']
      transaction.surchargeAmount         = options['surchargeAmount']
      transaction.enhancedData            = EnhancedData.from_hash(options)
      transaction.processingInstructions  = ProcessingInstructions.from_hash(options)
      transaction.payPalOrderComplete     = options['payPalOrderComplete']
      transaction.payPalNotes             = options['payPalNotes']

      add_account_info(transaction, options)
      return transaction
    end

    def capture_given_auth(options)
      transaction = CaptureGivenAuth.new
      add_order_info(transaction, options)
      transaction.secondaryAmount    = options['secondaryAmount']
      transaction.surchargeAmount    = options['surchargeAmount']
      transaction.authInformation    = AuthInformation.from_hash(options)
      transaction.shipToAddress      = Contact.from_hash(options,'shipToAddress')
      transaction.customBilling      = CustomBilling.from_hash(options)
      transaction.billMeLaterRequest = BillMeLaterRequest.from_hash(options)
      transaction.debtRepayment	     = options['debtRepayment']
      return transaction
    end

    def void(options)
      transaction = Void.new

      transaction.litleTxnId             = options['litleTxnId']
      transaction.processingInstructions = ProcessingInstructions.from_hash(options)

      add_account_info(transaction, options)
      return transaction
    end

    def echeck_redeposit(options)
      transaction = EcheckRedeposit.new
      add_echeck(transaction, options)

      transaction.litleTxnId = options['litleTxnId']
      transaction.merchantData              = MerchantData.from_hash(options)

      return transaction
    end

    def echeck_pre_note_sale(options)
      transaction = EcheckPreNoteSale.new
      transaction.echeck = Echeck.from_hash(options)
      transaction.orderId       = options['orderId']
      transaction.orderSource   = options['orderSource']
      transaction.billToAddress = Contact.from_hash(options,'billToAddress')
      add_account_info(transaction, options)
      transaction.merchantData              = MerchantData.from_hash(options)

      return transaction
    end

    def echeck_pre_note_credit(options)
      transaction = EcheckPreNoteCredit.new
      transaction.echeck = Echeck.from_hash(options)
      transaction.orderId       = options['orderId']
      transaction.orderSource   = options['orderSource']
      transaction.billToAddress = Contact.from_hash(options,'billToAddress')
      add_account_info(transaction, options)
      transaction.merchantData              = MerchantData.from_hash(options)

      return transaction
    end

    def submerchant_credit(options)
      transaction = SubmerchantCredit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.submerchantName       = options['submerchantName']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      transaction.accountInfo = Echeck.from_hash(options,'accountInfo')
      add_account_info(transaction, options)

      return transaction
    end

    def vendor_credit(options)
      transaction = VendorCredit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.vendorName       = options['vendorName']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      transaction.accountInfo = Echeck.from_hash(options,'accountInfo')
      add_account_info(transaction, options)

      return transaction
    end

    def payFac_credit(options)
      transaction = PayFacCredit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      add_account_info(transaction, options)

      return transaction
    end

    def reserve_credit(options)
      transaction = ReserveCredit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      add_account_info(transaction, options)

      return transaction
    end

    def physical_check_credit(options)
      transaction = PhysicalCheckCredit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      add_account_info(transaction, options)

      return transaction
    end

    def submerchant_debit(options)
      transaction = SubmerchantDebit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.submerchantName       = options['submerchantName']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      transaction.accountInfo = Echeck.from_hash(options,'accountInfo')
      add_account_info(transaction, options)

      return transaction
    end

    def vendor_debit(options)
      transaction = VendorDebit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.vendorName       = options['vendorName']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      transaction.accountInfo = Echeck.from_hash(options,'accountInfo')
      add_account_info(transaction, options)

      return transaction
    end

    def payFac_debit(options)
      transaction = PayFacDebit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      add_account_info(transaction, options)

      return transaction
    end

    def reserve_debit(options)
      transaction = ReserveDebit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      add_account_info(transaction, options)

      return transaction
    end

    def physical_check_debit(options)
      transaction = PhysicalCheckDebit.new
      transaction.fundingSubmerchantId       = options['fundingSubmerchantId']
      transaction.fundsTransferId   = options['fundsTransferId']
      transaction.amount   = options['amount']
      add_account_info(transaction, options)

      return transaction
    end

    def echeck_sale(options)
      transaction = EcheckSale.new
      add_echeck(transaction, options)
      add_echeck_order_info(transaction, options)
      transaction.secondaryAmount = options['secondaryAmount']
      transaction.verify        = options['verify']
      transaction.shipToAddress = Contact.from_hash(options,'shipToAddress')
      transaction.customBilling = CustomBilling.from_hash(options)

      return transaction
    end

    def echeck_credit(options)
      transaction = EcheckCredit.new
      transaction.customBilling = CustomBilling.from_hash(options)
      transaction.secondaryAmount = options['secondaryAmount']
      add_echeck_order_info(transaction, options)
      add_echeck(transaction, options)

      return transaction
    end

    def echeck_verification(options)
      transaction = EcheckVerification.new

      add_echeck_order_info(transaction, options)
      add_echeck(transaction, options)
      transaction.merchantData = MerchantData.from_hash(options)

      return transaction
    end

    def echeck_void(options)
      transaction = EcheckVoid.new
      transaction.litleTxnId = options['litleTxnId']

      add_account_info(transaction, options)
      return transaction
    end

    def account_update(options)
      transaction = AccountUpdate.new
      transaction.card = Card.from_hash(options)
      transaction.token = CardToken.from_hash(options,'token')
      transaction.orderId = options['orderId']

      add_account_info(transaction, options)

      return transaction
    end
    #
    #    def fraud_check_request(options)
    #      transaction = FraudCheckRequest.new
    #      transaction.advancedFraudChecks = AdvancedFraudChecks.from_hash(options,'advancedFraudChecks')
    #      transaction.billToAddress = Contact.from_hash(options,'billToAddress')
    #      transaction.shipToAddress = Contact.from_hash(options,'shipToAddress')
    #      transaction.amount = options['amount']
    #
    #      add_account_info(transaction, options)
    #
    #      return transaction
    #    end

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
      transaction.cardholderAuthentication  = FraudCheck.from_hash(options, 'cardholderAuthentication')
      transaction.allowPartialAuth          = options['allowPartialAuth']
      transaction.healthcareIIAS            = HealthcareIIAS.from_hash(options)
      transaction.filtering                 = Filtering.from_hash(options)
      transaction.merchantData              = MerchantData.from_hash(options)
      transaction.recyclingRequest          = RecyclingRequest.from_hash(options)
      transaction.fraudFilterOverride       = options['fraudFilterOverride']
      transaction.customBilling             = CustomBilling.from_hash(options)
      transaction.paypal                    = PayPal.from_hash(options,'paypal')
      transaction.applepay                  = Applepay.from_hash(options,'applepay')

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
      transaction.mpos                    = Mpos.from_hash(options,'mpos')
      add_account_info(transaction, options)
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

      add_account_info(transaction, options)
    end

    def get_report_group(options)
      #options['reportGroup'] || @config_hash['default_report_group']
      options['reportGroup']
    end
  end
end
