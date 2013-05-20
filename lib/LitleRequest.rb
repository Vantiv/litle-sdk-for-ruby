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

  class LitleRequest
    def authorization(options)
      transaction = Authorization.new
      add_transaction_info(transaction, options)
      
      return transaction
    end
    
    def sale(options)
      transaction = Sale.new
      add_transaction_info(transaction, options)

      transaction.fraudCheck          = FraudCheck.from_hash(options,'fraudCheck')
      transaction.payPalOrderComplete = options['payPalOrderComplete']
      transaction.payPalNotes         = options['payPalNotes']

      return transaction
    end
    
    def auth_reversal(options)
      transaction = AuthReversal.new

      transaction.litleTxnId    = options['litleTxnId']
      transaction.amount        = options['amount']
      transaction.payPalNotes   = options['payPalNotes']
      transaction.actionReason  = options['actionReason']

      return transaction
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
    
  end    
end