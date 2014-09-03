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

require 'yaml'
#
# Loads the configuration from a file
#
module LitleOnline
  class Configuration
    class << self
      # External logger, if specified
      attr_accessor :logger
    end

    def config
      begin
        if !(ENV['LITLE_CONFIG_DIR'].nil?)
          config_file = ENV['LITLE_CONFIG_DIR'] + "/.litle_SDK_config.yml"
        else
          config_file = ENV['HOME'] + "/.litle_SDK_config.yml"        
        end
        #if Env variable exist, then just override the data from config file
         if (File.exists?(config_file))
          datas=YAML.load_file(config_file)  
         else         
          environments = EnvironmentVariables.new   
          datas={}
          environments.instance_variables.each {|var| datas[var.to_s.delete("@")] = environments.instance_variable_get(var) }          
         end
          datas.each {|key,value| setENV(key,datas)}                      
        return datas
      rescue   
        return {}
      end
  
    end
    def setENV(key,datas)
      if !(ENV['litle_'+key].nil?)
       datas[key]=ENV['litle_'+key]
      end
    end
    
  end

end
