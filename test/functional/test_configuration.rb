=begin
Copyright (c) 2017 Vantiv eCommerce
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
require File.expand_path("../../../lib/LitleOnline",__FILE__) 
require 'test/unit'


module LitleOnline
  class TestConfiguration < Test::Unit::TestCase
    #the flag is to judge the data in config file exist or not
    @@flag=false
    def test_configuration_with_file
      @config_hash = Configuration.new.config
      @config_hash.each {|key,value| checkAttributes(key,@config_hash)}
      assert_equal(false, @@flag)
    end

    def checkAttributes(key,datas)
      if (datas[key].nil?)
      @@flag=true
      end
    end

    def test_configuration_mix_file_env
      #check the env variable override
      ENV['litle_timeout']='80'
      @config_hash = Configuration.new.config
      assert_equal('80',@config_hash['timeout'])
      ENV['litle_timeout']=nil
    end



    def test_configuration_without_file
      #set up Env variable
      ENV['litle_user']='isola'
      ENV['litle_password']='vinicius'
      ENV['litle_currency_merchant_map']='0180'
      ENV['litle_url']='basketball@gmail.com'
      ENV['litle_proxy_addr']='iwp1.lowell.litle.com'
      ENV['litle_proxy_port']='8080'
      ENV['litle_sftp_username']='sdkFire'
      ENV['litle_sftp_password']='fire is comming'
      ENV['litle_fast_url']='prelive.litle.com'
      ENV['litle_fast_port']='15000'
      @config_hash = Configuration.new.config
      assert_equal('isola',@config_hash['user'])
      assert_equal('vinicius',@config_hash['password'])
      assert_equal('0180',@config_hash['currency_merchant_map'])
      assert_equal('basketball@gmail.com',@config_hash['url'])
      assert_equal('iwp1.lowell.litle.com',@config_hash['proxy_addr'])
      assert_equal('8080',@config_hash['proxy_port'])
      assert_equal('sdkFire',@config_hash['sftp_username'])
      assert_equal('fire is comming',@config_hash['sftp_password'])
      assert_equal('prelive.litle.com',@config_hash['fast_url'])
      assert_equal('15000',@config_hash['fast_port'])
      ENV['litle_user']=nil
      ENV['litle_password']=nil
      ENV['litle_currency_merchant_map']=nil
      ENV['litle_url']=nil
      ENV['litle_proxy_addr']=nil
      ENV['litle_proxy_port']=nil
      ENV['litle_sftp_username']=nil
      ENV['litle_sftp_password']=nil
      ENV['litle_fast_url']=nil
      ENV['litle_fast_port']=nil
    end

  end
end