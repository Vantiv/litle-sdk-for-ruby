Litle Online Ruby SDK
=====================

About Litle
------------
[Litle &amp; Co.](http://www.litle.com) powers the payment processing engines for leading companies that sell directly to consumers through  internet retail, direct response marketing (TV, radio and telephone), and online services. Litle & Co. is the leading, independent authority in card-not-present (CNP) commerce, transaction processing and merchant services.


About this SDK
--------------
The Litle Ruby SDK is a Ruby implementation of the [Litle &amp; Co.](http://www.litle.com). XML API. This SDK was created to make it as easy as possible to connect process your payments with Litle.  This SDK utilizes  the HTTPS protocol to securely connect to Litle.  Using the SDK requires coordination with the Litle team in order to be provided with credentials for accessing our systems.

Our Ruby SDK supports all of the functionality present in Litle XML v8. Please see the online copy of our XSD for Litle XML to get more details on what is supported by the Litle payments engine.

This SDK is implemented to support the Ruby programming language and was created by Litle & Co. It is intended use is for online transactions processing utilizing your account on the Litle payments engine.

See LICENSE file for details on using this software.

Source Code available from : https://github.com/LitleCo/litle-sdk-for-ruby

Please contact [Litle &amp; Co.](http://www.litle.com) to receive valid merchant credentials in order to run tests successfully or if you require assistance in any way.  We are reachable at sdksupport@litle.com

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

Please contact Litle & Co. with any further questions. You can reach us at sdksupport@litle.com.
