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
    url = URI.parse(litle_url)
    http = Net::HTTP.new(url.host, url.port)
    # SSL is automatically detected based on the URL
    if (url.scheme == 'https')
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    #http.read_timeout= 60
    http_post = Net::HTTP::Post.new(url.request_uri)
    http_post.body = post_data

    # perform post
    begin
      # Proxy method automatically returns an HTTP object
      # when proxy_addr is nil, so we can have a single code path...neat!
      response_xml= Net::HTTP::Proxy(proxy_addr,proxy_port).start(url.host, url.port) {|https| http.request(http_post)}
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
