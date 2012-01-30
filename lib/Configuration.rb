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

class Configuration

	def Configuration.config()
		begin 
			if !(ENV['LITLE_CONFIG_DIR'].nil?) 
				config_file = ENV['LITLE_CONFIG_DIR'] + "/.litle_api_config.yml"
			else
				config_file = ENV['HOME'] + "/.litle_api_config.yml"
			end
			config = YAML.load_file(config_file)
		rescue
			raise 'Cannot find  the configuration file, ' + config_file + ', Please run Setup.rb first'
		end
		config_hash={
		'user'=> config['user'],
		'password'=> config['password'],
		'version' => config['version'],
		'url'=> config['url'],
		'proxy_port'=> config['proxy_port'],
		'proxy_addr'=> config['proxy_addr']
		}

		return config_hash
	end
end
