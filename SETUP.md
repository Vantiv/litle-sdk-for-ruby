Setting up and Configuring the Vantiv eCommerce SDK
=========================================

Running the built in configuration file generator
-------------------------------------------------
The Ruby SDK ships with a built in program which can be used to generate your specific configuration.

This program runs as follows:
   
```
>Setup.rb 
Welcome to Vantiv eCommerce Ruby_SDK
please input your user name:
test_user
please input your password:
test_password
Please choose Vantiv eCommerce url from the following list (example: 'cert') or directly input another URL:
cert => https://cert.litle.com/vap/communicator/online
precert => https://precert.litle.com/vap/communicator/online
production1 => https://payments.litle.com/vap/communicator/online
production2 => https://payments2.litle.com/vap/communicator/online
cert
Please input the proxy address, if no proxy hit enter key: 

Please input the proxy port, if no proxy hit enter key: 

The Vantiv eCommerce configuration file has been generated, the file is located at: /<your-home-directory>/.litle_SDK_config.yml 
```

Modifying your configuration
----------------------------
You may change the configuration values at anytime by running Setup.rb again, or simpy opening the configuration file directly in the editor of your choice and changing the appropriate fields. 

Changing the location of the Litle configuration file:
------------------------------------------------------
NOTICE you can set the environment variable $LITLE_CONFIG_DIR to locate your configuration file in a location other than the $HOME Directory, the the file will reside in $LITLE_CONFIG_DIR/.litle_SDK_config.yml  

Sample configuration file contents
----------------------------------
```
user: test_user
password: test_password
url: https://www.testlitle.com/vap/communicator/online
proxy_addr: yourproxyserver
proxy_port: 8080
```