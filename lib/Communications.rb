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

#
# Used for all transmission to Litle over HTTP or HTTPS
# works with or without an HTTP proxy
#
# URL and proxy server settings are derived from the configuration file
#
module LitleOnline
  class Communications
    ##For http or https post with or without a proxy
    def Communications.http_post(post_data,config_hash)
  
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      litle_url = config_hash['url']
  
      # setup https or http post
      url = URI.parse(litle_url)
  
      response_xml = nil
      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if(url.scheme == 'https') 
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end
      https.start { |http|
        response = http.request_post(url.path, post_data.to_s, {'Content-Type'=>'text/xml','Connection'=>'close'})
        response_xml = response
      }
  
      # validate response, only an HTTP 200 will work, redirects are not followed
      case response_xml
      when Net::HTTPOK
        return response_xml.body
      else
        raise("Error with http http_post_request, code:" + response_xml.header.code)
      end
    end
  end
end

=begin
 NOTES ON HTTP TIMEOUT

  Litle & Co. optimizes our systems to ensure the return of responses as quickly as possible, some portions of the process are beyond our control.
  The round-trip time of an Authorization can be broken down into three parts, as follows:
    1.  Transmission time (across the internet) to Litle & Co. and back to the merchant
    2.  Processing time by the authorization provider
    3.  Processing time by Litle 
  Under normal operating circumstances, the transmission time to and from Litle does not exceed 0.6 seconds 
  and processing overhead by Litle occurs in 0.1 seconds. 
  Typically, the processing time by the card association or authorization provider can take between 0.5 and 3 seconds,
  but some percentage of transactions may take significantly longer.
 
  Because the total processing time can vary due to a number of factors, Litle & Co. recommends using a minimum timeout setting of
  60 seconds to accomodate Sale transactions and 30 seconds if you are not utilizing Sale tranactions.

  These settings should ensure that you do not frequently disconnect prior to receiving a valid authorization causing dropped orders 
  and/or re-auths and duplicate auths.
=end
