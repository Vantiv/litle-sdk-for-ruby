Vantiv eCommerce Ruby SDK
=====================
#### Warning:
#### All version changes require recertification to the new version. Once certified for the use of a new version, Vantiv modifies your Merchant Profile, allowing you to submit transaction to the Production Environment using the new version. Updating your code without recertification and modification of your Merchant Profile will result in transaction declines. Please consult you Implementation Analyst for additional information about this process.
About Vantiv eCommerce
------------
[Vantiv eCommerce](http://www.vantiv.com) powers the payment processing engines for leading companies that sell directly to consumers through  internet retail, direct response marketing (TV, radio and telephone), and online services. Vantiv eCommerce is the leading authority in card-not-present (CNP) commerce, transaction processing and merchant services.


About this SDK
--------------
The Vantiv eCommerce Ruby SDK is a Ruby implementation of the [Vantiv eCommerce](http://www.vantiv.com). XML API. This SDK was created to make it as easy as possible to connect process your payments with Vantiv eCommerce.  This SDK utilizes  the HTTPS protocol to securely connect to Vantiv eCommerce.  Using the SDK requires coordination with the Vantiv eCommerce team in order to be provided with credentials for accessing our systems.

Each Ruby SDK release supports all of the functionality present in the associated Vantiv eCommerce XML version (e.g., SDK v9.3.2 supports Vantiv eCommerce XML v9.3). Please see the online copy of our XSD for Vantiv eCommerce XML to get more details on what the Vantiv eCommerce payments engine supports.

This SDK was implemented to support the Ruby programming language and was created by Vantiv eCommerce. Its intended use is for online transaction processing utilizing your account on the Vantiv eCommerce payments engine.

See LICENSE file for details on using this software.

Source Code available from : https://github.com/LitleCo/litle-sdk-for-ruby

Please contact [Vantiv eCommerce](http://www.vantiv.com) to receive valid merchant credentials in order to run tests successfully or if you require assistance in any way. We are reachable at sdksupport@vantiv.com

Setup
-----

1) Install the LitleOnline Ruby gem from rubygems.org, this will install the latest SDK gem in your Ruby environment.
Our gem is available publicly from rubygems.org.  Use the command below to install.

>sudo gem install LitleOnline

Note: If you get errors, you might have to configure your proxy.

2) Once the gem is installed run our setup program to generate a configuration file.  The configuration file resides in your home directory
$HOME/.litle_SDK_config.yml

For more details on setup see our instructions [here](https://github.com/LitleCo/litle-sdk-for-ruby/blob/master/SETUP.md)

3.) Create a ruby file similar to:  

```ruby
require 'LitleOnline'
include LitleOnline

# Visa $10 Sale
litleSaleTxn = {
    'reportGroup'=>'rpt_grp',
    'orderId'=>'1234567',
    'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1212'},
        'orderSource'=>'ecommerce',
        'amount'=>'1000'
    }

# Peform the transaction on the Litle Platform
response = LitleOnlineRequest.new.sale(litleSaleTxn)

# display result
puts "Message: "+ response.message
puts "Litle Transaction ID: "+ response.saleResponse.litleTxnId
```

3) Next run this file using ruby. You should see the following result provided you have connectivity to the Litle certification environment.  You will see an HTTP error if you don't have access to the Litle URL

    Message: Valid Format
    Litle Transaction ID: <your-numeric-litle-txn-id>
 
More examples (including batch processing with sFTP) can be found here [Ruby Gists](https://gist.github.com/litleSDK)

Please contact Vantiv eCommerce with any further questions. You can reach us at sdksupport@vantiv.com.
