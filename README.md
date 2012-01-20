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

## Installation

### From Git

You can check out the latest source from git:

    git clone git://github.com/gformich/LitleOnline_XML_v8_Ruby.git

### Building the gem from source

Use the command:

    rake gem

### From RubyGems

--NOTE - gemfile is not available yet!!

Installation from RubyGems

    gem install LitleOnline

Alternatively, add the following to your Gemfile

    gem 'LitleOnline', :require => 'LitleOnline'

## Setup

### Configuration

The Litle online API requires a configuration file in order to determine the URL for the Litle Site and your credentials for processing.  This file is located in the home directory of the user you are running as.  The file is called ".litle_conf.yml"

The following settings must be included in the file:

TODO GF - add setting explanation


We include a setup program you can use to simplify the generation of this configuration file, please run setupLitleOnline.rb if you'd like to take this approach.

Alternatively you can move the location of the configuration file to the directory of your choosing simply by defining the environment variable $LITLE_API_CONFIG_DIR
