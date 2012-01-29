Setting up and Configuring the Litle SDK
=========================================

Running the built in configuration file generator
-------------------------------------------------
The Ruby SDK shops with a built in program which can be used to generate your specific configuration.

This program runs as follows:

>Setup.rb 
Welcome to Litle Ruby_SDK
please input your user name:
test_user
please input your password:
phi_phi_ffff
please input Litle schema version V8. choice from 1 to 10
4
Please input litle url (choice from given such as 'cert' or directly input other URL):
cert => https://cert.litle.com/vap/communicator/online
precert => https://precert.litle.com/vap/communicator/online
production1 => https://payments.litle.com/vap/communicator/online
production2 => https://payments2.litle.com/vap/communicator/online
cert
please input the proxy address, if no proxy hit enter key: 

please input the proxy port, if no proxy hit enter key: 

The Litle configuration file has been generated, the file is locate at /<your-home-directory>/.litle_SDK_config.yml 

Modifying your configuration
----------------------------
You may change the configuration values at anytime by running Setup.rb again, or simpy opening the configuration file directly in the editor of your choice and changing the appropriate fields. 

Changing the location of the Litle configuration file:
------------------------------------------------------
NOTICE you can set the environment variable $LITLE_CONFIG_DIR to locate your configuration file in a location other than the $HOME Directory, the the file will reside in $LITLE_CONFIG_DIR/.litle_SDK_config.yml  

Sample configuration file contents
----------------------------------
user: test_user
password: phi_phi_ffff
version: 8.4
url: https://precert.litle.com/vap/communicator/online
proxy_addr: yourproxyserver
poxy_port: 8080