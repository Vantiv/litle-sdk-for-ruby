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
#
class LitleOnlineRequest	
	#contains the methods to properly create each transaction type
	#load configuration dat
	
		@config_hash = Configuration.config()
	
	def LitleOnlineRequest.authentication(hash_in)
		hash_out = {
		:user =>(@config_hash['user'] or 'REQUIRED'),
		:password =>(@config_hash['password'] or 'REQUIRED')
		}
		Checker.requiredMissing(hash_out)
	end 	

	def LitleOnlineRequest.authorization(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => hash_in['litleTxnId'],
		:orderId =>(hash_in['orderId'] or 'REQUIRED'),
		:amount =>(hash_in['amount'] or 'REQUIRED'),
		:orderSource=>(hash_in['orderSource'] or 'REQUIRED'),
		:customerInfo=>XMLFields.customerInfo((hash_in['customerInfo'] or ' ')),
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:shipToAddress=>XMLFields.contact((hash_in['shipToAddress'] or ' ')),
		:card=> XMLFields.cardType((hash_in['card'] or ' ')),
		:paypal=>XMLFields.payPal((hash_in['paypal'] or ' ')),
		:token=>XMLFields.cardTokenType((hash_in['token'] or ' ')),
		:paypage=>XMLFields.cardPaypageType((hash_in['paypage'] or ' ')),
		:billMeLaterRequest=>XMLFields.billMeLaterRequest((hash_in['billMeLaterRequest'] or ' ')),
		:cardholderAuthentication=>XMLFields.fraudCheckType((hash_in['cardholderAuthentication'] or ' ')),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' ')),
		:pos=>XMLFields.pos((hash_in['pos'] or ' ')),	
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		:taxBilling=>XMLFields.taxBilling((hash_in['taxBilling'] or ' ')),
		:enhancedData=>XMLFields.enhancedData((hash_in['enhancedData'] or ' ')),
		:amexAggregatorData=>XMLFields.amexAggregatorData((hash_in['amexAggregatorData'] or ' ')),
		:allowPartialAuth=>hash_in['allowPartialAuth'],
		:healthcareIIAS=>XMLFields.healthcareIIAS((hash_in['healthcareIIAS'] or ' ')),	
		:filtering=>XMLFields.filteringType((hash_in['filtering'] or ' ')),
		:merchantData=>XMLFields.filteringType((hash_in['merchantData'] or ' ')),
		:recyclingRequest=>XMLFields.recyclingRequestType((hash_in['recyclingRequest'] or ' '))
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
		 Checker.choice(choice1)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or 'REQUIRED'),
		:authentication => authentication(hash_in),
		:authorization=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.sale(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => hash_in['litleTxnId'],
		:orderId =>(hash_in['orderId'] or 'REQUIRED'),
		:amount =>(hash_in['amount'] or 'REQUIRED'),
		:orderSource=>(hash_in['orderSource'] or 'REQUIRED'),
		:customerInfo=>XMLFields.customerInfo((hash_in['customerInfo'] or ' ')),
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:shipToAddress=>XMLFields.contact((hash_in['shipToAddress'] or ' ')),
		:card=> XMLFields.cardType((hash_in['card'] or ' ')),
		:paypal=>XMLFields.payPal((hash_in['paypal'] or ' ')),
		:token=>XMLFields.cardTokenType((hash_in['token'] or ' ')),
		:paypage=>XMLFields.cardPaypageType((hash_in['paypage'] or ' ')),
		:billMeLaterRequest=>XMLFields.billMeLaterRequest((hash_in['billMeLaterRequest'] or ' ')),
		:fraudCheck=>XMLFields.fraudCheckType((hash_in['fraudCheck'] or ' ')),
		:cardholderAuthentication=>XMLFields.fraudCheckType((hash_in['cardholderAuthentication'] or ' ')),
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		:taxBilling=>XMLFields.taxBilling((hash_in['taxBilling'] or ' ')),
		:enhancedData=>XMLFields.enhancedData((hash_in['enhancedData'] or ' ')),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' ')),
		:pos=>XMLFields.pos((hash_in['pos'] or ' ')),	
		:payPalOrderComplete=> hash_in['paypalOrderComplete'],
		:payPalNotes=> hash_in['paypalNotesType'],
		:amexAggregatorData=>XMLFields.amexAggregatorData((hash_in['amexAggregatorData'] or ' ')),
		:allowPartialAuth=>hash_in['allowPartialAuth'],
		:healthcareIIAS=>XMLFields.healthcareIIAS((hash_in['healthcareIIAS'] or ' ')),	
		:filtering=>XMLFields.filteringType((hash_in['filtering'] or ' ')),
		:merchantData=>XMLFields.filteringType((hash_in['merchantData'] or ' ')),
		:recyclingRequest=>XMLFields.recyclingRequestType((hash_in['recyclingRequest'] or ' '))
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
		 choice2= {'1'=>hash_out[:fraudCheck],'2'=>hash_out[:cardholderAuthentication]}
		 Checker.choice(choice1)
		 Checker.choice(choice2)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:sale=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.authReversal(hash_in)
		 hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => (hash_in['litleTxnId']or 'REQUIRED'),
		:amount =>hash_in['amount'],
		:payPalNotes=>hash_in['payPalNotes'],
		:actionReason=>hash_in['actionReason']
		}
		 Checker.purgeNull(hash_out)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:authReversal=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end	
	def LitleOnlineRequest.credit(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => (hash_in['litleTxnId']),
		:orderId =>hash_in['orderId'],
		:amount =>hash_in['amount'],
		:orderSource=>hash_in['orderSource'],
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:card=> XMLFields.cardType((hash_in['card'] or ' ')),
		:paypal=>XMLFields.payPal((hash_in['paypal'] or ' ')),
		:token=>XMLFields.cardTokenType((hash_in['token'] or ' ')),
		:paypage=>XMLFields.cardPaypageType((hash_in['paypage'] or ' ')),
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		:taxBilling=>XMLFields.taxBilling((hash_in['taxBilling'] or ' ')),
		:billMeLaterRequest=>XMLFields.billMeLaterRequest((hash_in['billMeLaterRequest'] or ' ')),
		:enhancedData=>XMLFields.enhancedData((hash_in['enhancedData'] or ' ')),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' ')),
		:pos=>XMLFields.pos((hash_in['pos'] or ' ')),	
		:amexAggregatorData=>XMLFields.amexAggregatorData((hash_in['amexAggregatorData'] or ' ')),
		:payPalNotes =>hash_in['payPalNotes']
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:card],'2' =>hash_out[:paypal],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
		 Checker.choice(choice1)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:credit=>hash_out
		}
		Checker.purgeNull(hash_out)
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.registerTokenRequest(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:orderId =>(hash_in['orderId'] or ' '),
		:accountNumber=>hash_in['accountNumber'],
		:echeckForToken=>XMLFields.echeckForTokenType((hash_in['echeckForToken'] or ' ')),
		:paypageRegistrationId=>hash_in['paypageRegistrationId']
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:accountNumber],'2' =>hash_out[:echeckForToken],'3'=>hash_out[:paypageRegistrationId]}
		 Checker.choice(choice1)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:registerTokenRequest=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end	
	def LitleOnlineRequest.forceCapture(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:orderId =>(hash_in['orderId'] or 'REQUIRED'),
		:amount =>(hash_in['amount'] or ''),
		:orderSource=>(hash_in['orderSource'] or 'REQUIRED'),
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:card=> XMLFields.cardType((hash_in['card'] or ' ')),
		:token=>XMLFields.cardTokenType((hash_in['token'] or ' ')),
		:paypage=>XMLFields.cardPaypageType((hash_in['paypage'] or ' ')),
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		:taxBilling=>XMLFields.taxBilling((hash_in['taxBilling'] or ' ')),
		:enhancedData=>XMLFields.enhancedData((hash_in['enhancedData'] or ' ')),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' ')),
		:pos=>XMLFields.pos((hash_in['pos'] or ' ')),	
		:amexAggregatorData=>XMLFields.amexAggregatorData((hash_in['amexAggregatorData'] or ' '))
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:card],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
		 Checker.choice(choice1)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:forceCapture=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.capture(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		'@partial'=>hash_in['partial'],
		:litleTxnId => (hash_in['litleTxnId'] or 'REQUIRED'),
		:amount =>(hash_in['amount'] or ''),
		:enhancedData=>XMLFields.enhancedData((hash_in['enhancedData'] or ' ')),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' ')),
		:payPalOrderComplete=>hash_in['payPalOrderComplete'],
		:payPalNotes =>hash_in['payPalNotes']
		}
		 Checker.purgeNull(hash_out)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:capture=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.captureGivenAuth(hash_in)
	    	hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:orderId =>(hash_in['orderId'] or 'REQUIRED'),
		:authInformation=>XMLFields.authInformation((hash_in['authInformation'] or ' ')),
		:amount =>(hash_in['amount'] or 'REQUIRED'),
		:orderSource=>(hash_in['orderSource'] or 'REQUIRED'),
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:shipToAddress=>XMLFields.contact((hash_in['shipToAddress'] or ' ')),
		:card=> XMLFields.cardType((hash_in['card'] or ' ')),
		:token=>XMLFields.cardTokenType((hash_in['token'] or ' ')),
		:paypage=>XMLFields.cardPaypageType((hash_in['paypage'] or ' ')),
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		:taxBilling=>XMLFields.taxBilling((hash_in['taxBilling'] or ' ')),
		:billMeLaterRequest=>XMLFields.billMeLaterRequest((hash_in['billMeLaterRequest'] or ' ')),
		:enhancedData=>XMLFields.enhancedData((hash_in['enhancedData'] or ' ')),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' ')),
		:pos=>XMLFields.pos((hash_in['pos'] or ' ')),	
		:amexAggregatorData=>XMLFields.amexAggregatorData((hash_in['amexAggregatorData'] or ' '))
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:card],'3'=>hash_out[:token],'4'=>hash_out[:paypage]}
		 Checker.choice(choice1)
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {  
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:captureGivenAuth=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.echeckRedeposit(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => (hash_in['litleTxnId'] or 'REQUIRED'),
		:echeck=>XMLFields.echeckType((hash_in['echeck'] or ' ')),
		:echeckToken=>XMLFields.echeckTokenType((hash_in['echeckToken'] or ' '))
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
		 Checker.choice(choice1)		
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:echeckRedeposit=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.echeckSale(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => hash_in['litleTxnId'],
		:orderId =>hash_in['orderId'],
		:verify =>hash_in['verify'],
		:amount =>(hash_in['amount'] or 'REQUIRED'),
		:orderSource =>hash_in['orderSource'],
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:shipToAddress=>XMLFields.contact((hash_in['shipToAddress'] or ' ')),
		:echeck=>XMLFields.echeckType((hash_in['echeck'] or ' ')),
		:echeckToken=>XMLFields.echeckTokenType((hash_in['echeckToken'] or ' ')),
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		}
		 Checker.purgeNull(hash_out)	
		 choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
		 Checker.choice(choice1)			
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:echeckSale=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.echeckCredit(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => hash_in['litleTxnId'],
		:orderId =>hash_in['orderId'],
		:amount =>(hash_in['amount']or 'REQUIRED'),
		:orderSource =>hash_in['orderSource'],
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:echeck=>XMLFields.echeckType((hash_in['echeck'] or ' ')),
		:echeckToken=>XMLFields.echeckTokenType((hash_in['echeckToken'] or ' ')),
		:customBilling=>XMLFields.customBilling((hash_in['customBilling'] or ' ')),
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
		 Checker.choice(choice1)			
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:echeckCredit=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.echeckVerification(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => hash_in['litleTxnId'],
		:orderId =>(hash_in['orderId'] or 'REQUIRED'),
		:amount =>(hash_in['amount'] or 'REQUIRED'),
		:orderSource =>(hash_in['orderSource'] or 'REQUIRED'),
		:billToAddress=>XMLFields.contact((hash_in['billToAddress'] or ' ')),
		:echeck=>XMLFields.echeckType((hash_in['echeck'] or ' ')),
		:echeckToken=>XMLFields.echeckTokenType((hash_in['echeckToken'] or ' ')),
		}
		 Checker.purgeNull(hash_out)
		 choice1= {'1'=>hash_out[:echeck],'3'=>hash_out[:echeckToken]}
		 Checker.choice(choice1)					
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:echeckVerification=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
	def LitleOnlineRequest.void(hash_in)
		hash_out = {
		'@id' => hash_in['id'],
		'@customerId' => hash_in['customerId'],
		'@reportGroup' => (hash_in['reportGroup'] or 'REQUIRED'),
		:litleTxnId => (hash_in['litleTxnId'] or 'REQUIRED'),
		:processingInstructions=>XMLFields.processingInstructions((hash_in['processingInstructions'] or ' '))
		}
		 Checker.purgeNull(hash_out)					
		 Checker.requiredMissing(hash_out)
		 litleOnline_hash = {
		"@version"=> (@config_hash['version'] or 'REQUIRED'),
		"@xmlns"=> "http://www.litle.com/schema",
		"@merchantId"=> (hash_in['merchantId'] or @config_hash['merchantId'] or  'REQUIRED'),
		:authentication => authentication(hash_in),
		:void=>hash_out
		}
		Checker.requiredMissing(litleOnline_hash)
		LitleXmlMapper.request(litleOnline_hash)
	end
end
