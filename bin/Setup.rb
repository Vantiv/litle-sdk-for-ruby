#!/usr/bin/env ruby

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

# make setup file executable

#
# Configuration generation for URL and credentials
#
class Setup
  attr_reader :handle, :path
  def initialize(filename)
    @handle = File.new(filename, File::CREAT|File::TRUNC|File::RDWR, 0600)
    File.open(filename, "w") do |f|
      puts "Welcome to Litle Ruby_SDK"
      puts "Please input your user name:"
      f.puts  "user: "+ gets
      puts "Please input your password:"
      f.puts	"password: " + gets
      puts "Please input your merchantId:"
      f.puts "currency_merchant_map:"
      f.puts "  DEFAULT: " + gets
      f.puts "default_report_group: 'Default Report Group'"
      f.puts	"version: '8.10'"
      puts "Please choose Litle url from the following list (example: 'cert') or directly input another URL: \nsandbox => https://www.testlitle.com/sandbox/communicator/online \ncert => https://cert.litle.com/vap/communicator/online \nprecert => https://precert.litle.com/vap/communicator/online \nproduction1 => https://payments.litle.com/vap/communicator/online \nproduction2 => https://payments2.litle.com/vap/communicator/online"
      f.puts "url: " + Setup.choice(gets)
      puts "Please input the proxy address, if no proxy hit enter key: "
      f.puts	"proxy_addr: " + gets
      puts "Please input the proxy port, if no proxy hit enter key: "
      f.puts	"proxy_port: " + gets
      f.puts "printxml: false"
      f.puts "timeout: 65"
    end
  end

  def finished
    @handle.close
  end

  def Setup.choice(litle_env)
    litle_online_ctx = 'vap/communicator/online'
    if litle_env == "sandbox\n"
      return 'https://www.testlitle.com/sandbox/' + litle_online_ctx
    elsif litle_env == "cert\n"
      return 'https://cert.litle.com/' + litle_online_ctx
    elsif litle_env == "precert\n"
      return 'https://precert.litle.com/' + litle_online_ctx
    elsif litle_env == "production1\n"
      return 'https://payments.litle.com/' + litle_online_ctx
    else
      return 'https://www.testlitle.com/sandbox/' + litle_online_ctx
    end
  end
end

#
#
# Optionally enable the configuration to reside in a custom location
# if the $LITLE_CONFIG_DIR directory is set
#

# make the config.yml file in the LITLE_CONFIG_DIR directory or HOME directory
if !(ENV['LITLE_CONFIG_DIR'].nil?)
  path = ENV['LITLE_CONFIG_DIR']
else
  path = ENV['HOME']
end

# make the config.yml file hidden
# create a config file contain all the configuration data
config_file = path + "/.litle_SDK_config.yml"
f = Setup.new(config_file)

# return the path of the config file and the path file
@path = File.expand_path(config_file)
puts "The Litle configuration file has been generated, the file is located at: " + @path
f.finished

