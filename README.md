# Litle Online API

[Litle &amp; Co.](http://www.litle.com) powers the payment processing engines for leading companies that sell directly to consumers through  internet retail, direct response marketing (TV, radio and telephone), and online services. Litle & Co. is the leading, independent authority in card-not-present (CNP) commerce, transaction processing and merchant services.

The Litle Online API is a Ruby implementation of  the [Litle &amp; Co.](http://www.litle.com) XML API.
This API supports the HTTPS interface and requires coordination with the Litle team in order to be 
provided with credentials for accessing our systems.
  
This Ruby API supports all of the functionality present in Litle XML v8.  Please request a copy of the
XSD from your implementations coordinator at Litle.

This API is implemented to support the Ruby programming language and was created by Litle & Co. It is intended use is for online transactions processing on the Litle payments engine.  This API is currently in the alpha testing phase and is not generally available
or supported by Litle.

See LICENSE file for details on using this software.

See {file:sample_driver.rb} to see an example of using the Litle API.

Source Code available from : https://github.com/gformich/LitleOnline_XML_v8_Ruby

Please contact Litle & Co. to receive valid merchant credentials in order to run tests successfully.

Setup:

1) Install the Litle API gem from rubygems*,* this will install the latest API gem in your Ruby environment.  Our gem is available publicly from rubygems.org


>sudo gem install LitleOnline

2) Once the gem is installed run our setup program to generate a configuration file.  This file resides in $HOME/.litle_api_config.yml


    NOTICE you can setup $LITLE_CONFIG_DIR to locate your configuration file in a location other than the $HOME Directory, the the file will reside in $LITLE_CONFIG_DIR/.litle_api_config.yml


>Setup.rb 
Welcome to Litle Ruby_API
please input your user name:
test_user
please input your password:
phi_phi_ffff
please input Litle schema version V8. choice from 1 to 10
4
Please input litle url (choice from given such as 'cert' or directly input other URL):
cert => https://cert.litle.com/vap/communicator/online
precert => https://precert.litle.com/vap/communicator/online
production1 => https://payment.litle.com/vap/communicator/online
production2 => https://payment2.litle.com/vap/communicator/online
cert
please input the proxy address, if no proxy hit enter key: 

please input the proxy port, if no proxy hit enter key: 

The Litle configuration file has been generated, the file is locate at /usr/local/litle-home/gformich/.litle_api_config.yml

You may change the configuration values at anytime by running Setup.rb, or opening the configuration file directly in the editor of your choosing and changing the appropriate fields.


Sample Litle configuration file.  This file can optionally be edited as needed to make updates:


user: test_user
password: phi_phi_ffff
version: 8.4
url: https://cert.litle.com/vap/communicator/online
proxy_addr:
poxy_port:

3.) Create a sample ruby file similar to:


require 'LitleOnline'
creditTxn = {
    'merchantId' => '087900',
    'reportGroup'=>'rpt_grp',
    'orderId'=>'12344',
    'card'=>{
    'type'=>'VI',
    'number' =>'4100000000000001',
    'expDate' =>'1210'},
    'orderSource'=>'ecommerce',
    'amount'=>'106'
    }

# perform a test credit transaction
response= LitleOnlineRequest.credit(creditTxn)

#display results
puts "Message: "+response.message
puts "Litle Transaction ID: "+response.creditResponse.litleTxnId



3) Next run this file using ruby. You should see the following result provided you have connectivity to the Litle certification environment.  You will see an HTTP error if you don't have access to the Litle site



Message: Valid Format
Litle Transaction ID: 819795009551648291


Please contact Lilte & Co. with any further questions. 
