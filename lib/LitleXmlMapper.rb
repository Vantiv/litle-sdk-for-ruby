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

require 'logger'

#
# Handles round trip of transactions
# Maps the request to Litle XML -> Sends XML payload to Litle via HTTP(S) -> formats XML response into a Ruby hash and returns it
#
module LitleOnline
  class LitleXmlMapper
    def LitleXmlMapper.request(request_xml, config_hash)
      logger = initialize_logger(config_hash)

      logger.debug request_xml
      # get the Litle Online Response from the API server over HTTP
      response_xml = Communications.http_post(request_xml,config_hash)
      logger.debug response_xml

      # create response object from xml returned form the Litle API
      response_object = XMLObject.new(response_xml)
      
      return response_object
    end

    private

    def self.initialize_logger(config_hash)
      # Sadly, this needs to be static (the alternative would be to change the LitleXmlMapper.request API
      # to accept a Configuration instance instead of the config_hash)
      Configuration.logger ||= default_logger config_hash['printxml'] ? Logger::DEBUG : Logger::INFO
    end

    def self.default_logger(level) # :nodoc:
      logger = Logger.new(STDOUT)
      logger.level = level
      # Backward compatible logging format for pre 8.16
      logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
      logger
    end
  end
end
