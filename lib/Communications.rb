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
class Communications
  ##For http or https post with or without a proxy
  def Communications.http_post(post_data,config_hash)

    #setup optional proxy
    proxy_addr = (config_hash['proxy_addr'] or nil)
    proxy_port = ((config_hash['proxy_port']).to_i or nil)

    # setup https or http post
    litle_url = (config_hash['url'] or 'https://cert.litle.com/vap/communicator/online')
    uri = URI.parse(litle_url)

    http_post = Net::HTTP::Post.new(uri.request_uri)
    http_post.body = post_data
    http_post['content-type'] = 'text/xml'

    response_xml = ''
    begin
      proxy = Net::HTTP::Proxy(proxy_addr,proxy_port)
      # See notes below on recommended time outs
      proxy.start(uri.host, uri.port, :use_ssl => uri.scheme=='https', :read_timeout => config_hash['timeout']) do |http|
        response_xml = http.request(http_post)
      end
    end

    # validate response, only an HTTP 200 will work, redirects are not followed
    case response_xml
    when Net::HTTPOK
      return response_xml.body
    else
      raise("Error with http http_post_request, code:" + response_xml.header.code)
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
