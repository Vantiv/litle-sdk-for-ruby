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
require_relative 'Configuration'
require 'net/sftp'
require 'libxml'
require 'crack/xml'
require 'socket'

include Socket::Constants
#
# This class handles sending the Litle Request (which is actually a series of batches!)
#

module LitleOnline
  class LitleRequest
    include XML::Mapping
    def initialize(options = {})
      #load configuration data
      @config_hash = Configuration.new.config
      @num_batch_requests = 0
      @path_to_request = ""
      @path_to_batches = ""
      @num_total_transactions = 0
      @MAX_NUM_TRANSACTIONS = 500000
      @options = options
      # current time out set to 2 mins
      # this value is in seconds
      @RESPONSE_TIME_OUT = 360
      @POLL_DELAY = 0
      @responses_expected = 0
    end

    # Creates the necessary files for the LitleRequest at the path specified. path/request_(TIMESTAMP) will be
    # the final XML markup and path/request_(TIMESTAMP) will hold intermediary XML markup
    # Params:
    # +path+:: A +String+ containing the path to the folder on disc to write the files to
    def create_new_litle_request(path)
      ts = Time::now.to_i.to_s
      begin
        ts += Time::now.nsec.to_s
      rescue NoMethodError # ruby 1.8.7 fix
        ts += Time::now.usec.to_s
      end 
      
      if(File.file?(path)) then
        raise RuntimeError, "Entered a file not a path."
      end

      if(path[-1,1] != '/' and path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end

      if !File.directory?(path) then
        Dir.mkdir(path)
      end
      
      @path_to_request = path + 'request_' + ts
      @path_to_batches = @path_to_request + '_batches'

      if File.file?(@path_to_request) or File.file?(@path_to_batches) then
        create_new_litle_request(path)
        return
      end

      File.open(@path_to_request, 'a+') do |file|
        file.write("")
      end
      File.open(@path_to_batches, 'a+') do |file|
        file.write("")
      end
    end

    # Adds a batch to the LitleRequest. If the batch is open when passed, it will be closed prior to being added.
    # Params:
    # +arg+:: a +LitleBatchRequest+ containing the transactions you wish to send or a +String+ specifying the
    # path to the batch file
    def commit_batch(arg)
      path_to_batch = ""
      #they passed a batch
      if arg.kind_of?(LitleBatchRequest) then
        path_to_batch = arg.get_batch_name
        if((au = arg.get_au_batch) != nil) then 
          # also commit the account updater batch
          commit_batch(au)
        end
      elsif arg.kind_of?(LitleAUBatch) then
        path_to_batch = arg.get_batch_name
      elsif arg.kind_of?(String) then
        path_to_batch = arg
      else
        raise RuntimeError, "You entered neither a path nor a batch. Game over :("
      end
      #the batch isn't closed. let's help a brother out
      if (ind = path_to_batch.index(/\.closed/)) == nil then
        if arg.kind_of?(String) then
          new_batch = LitleBatchRequest.new
          new_batch.open_existing_batch(path_to_batch)
          new_batch.close_batch()
          path_to_batch = new_batch.get_batch_name
          # if we passed a path to an AU batch, then new_batch will be a new, empty batch and the batch we passed
          # will be in the AU batch variable. thus, we wanna grab that file name and remove the empty batch.
          if(new_batch.get_au_batch != nil) then
            File.remove(path_to_batch)
            path_to_batch = new_batch.get_au_batch.get_batch_name
          end 
        elsif arg.kind_of?(LitleBatchRequest) then
          arg.close_batch()
          path_to_batch = arg.get_batch_name
        elsif arg.kind_of?(LitleAUBatch) then
          arg.close_batch()
          path_to_batch = arg.get_batch_name 
        end
        ind = path_to_batch.index(/\.closed/)
      end
      transactions_in_batch = path_to_batch[ind+8..path_to_batch.length].to_i

      # if the litle request would be too big, let's make another!
      if (@num_total_transactions + transactions_in_batch) > @MAX_NUM_TRANSACTIONS then
        finish_request
        initialize(@options)
        create_new_litle_request
      else #otherwise, let's add it line by line to the request doc
       # @num_batch_requests += 1
        #how long we wnat to wait around for the FTP server to get us a response
        @RESPONSE_TIME_OUT += 90 + (transactions_in_batch * 0.25)
        #don't start looking until there could possibly be a response
        @POLL_DELAY += 30 +(transactions_in_batch  * 0.02)
        @num_total_transactions += transactions_in_batch
         # Don't add empty batches
       @num_batch_requests += 1 unless transactions_in_batch.eql?(0)
        File.open(@path_to_batches, 'a+') do |fo|
          File.foreach(path_to_batch) do |li|
            fo.puts li
          end
        end
        
        File.delete(path_to_batch)
      end
    end

    # Adds an RFRRequest to the LitleRequest.
    # params: 
    # +options+:: a required +Hash+ containing configuration info for the RFRRequest. If the RFRRequest is for a batch, then the 
    # litleSessionId is required as a key/val pair. If the RFRRequest is for account updater, then merchantId and postDay are required
    # as key/val pairs.
    # +path+:: optional path to save the new litle request containing the RFRRequest at
    def add_rfr_request(options, path = (File.dirname(@path_to_batches)))
     
      rfrrequest = LitleRFRRequest.new
      if(options['litleSessionId']) then
        rfrrequest.litleSessionId = options['litleSessionId']
      elsif(options['merchantId'] and options['postDay']) then
        accountUpdate = AccountUpdateFileRequestData.new
        accountUpdate.merchantId = options['merchantId']
        accountUpdate.postDay = options['postDay']
        rfrrequest.accountUpdateFileRequestData = accountUpdate
      else
        raise ArgumentError, "For an RFR Request, you must specify either a litleSessionId for an RFRRequest for batch or a merchantId 
        and a postDay for an RFRRequest for account updater."
      end 
      
      litleRequest = LitleRequestForRFR.new
      litleRequest.rfrRequest = rfrrequest
      
      authentication = Authentication.new
      authentication.user = get_config(:user, options)
      authentication.password = get_config(:password, options)

      litleRequest.authentication = authentication
      litleRequest.numBatchRequests = "0"
      
      litleRequest.version         = '9.3'
      litleRequest.xmlns           = "http://www.litle.com/schema"
      
      
      xml = litleRequest.save_to_xml.to_s
      
      ts = Time::now.to_i.to_s
      begin
        ts += Time::now.nsec.to_s
      rescue NoMethodError # ruby 1.8.7 fix
        ts += Time::now.usec.to_s
      end 
      if(File.file?(path)) then
        raise RuntimeError, "Entered a file not a path."
      end

      if(path[-1,1] != '/' and path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end

      if !File.directory?(path) then
        Dir.mkdir(path)
      end
      
      path_to_request = path + 'request_' + ts

      File.open(path_to_request, 'a+') do |file|
        file.write xml
      end
      File.rename(path_to_request, path_to_request + '.complete')
      @RESPONSE_TIME_OUT += 90   
    end

    # FTPs all previously unsent LitleRequests located in the folder denoted by path to the server
    # Params:
    # +path+:: A +String+ containing the path to the folder on disc where LitleRequests are located.
    # This should be the same location where the LitleRequests were written to. If no path is explicitly
    # provided, then we use the directory where the current working batches file is stored.
    # +options+:: An (option) +Hash+ containing the username, password, and URL to attempt to sFTP to.
    # If not provided, the values will be populated from the configuration file.
    def send_to_litle(path = (File.dirname(@path_to_batches)), options = {})
      username = get_config(:sftp_username, options)
      password = get_config(:sftp_password, options)
    
      url = get_config(:sftp_url, options)
    
      if(username == nil or password == nil or url == nil) then
        raise ArgumentError, "You are not configured to use sFTP for batch processing. Please run /bin/Setup.rb again!"
      end
      
      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end
      
      begin 
        Net::SFTP.start(url, username, :password => password) do |sftp|
         
          # our folder is /SHORTNAME/SHORTNAME/INBOUND
          Dir.foreach(path) do |filename|
            #we have a complete report according to filename regex
            if((filename =~ /request_\d+.complete\z/) != nil) then
              # adding .prg extension per the XML 
              File.rename(path + filename, path + filename + '.prg')
            end
          end
          
          @responses_expected = 0
          Dir.foreach(path) do |filename|
            if((filename =~ /request_\d+.complete.prg\z/) != nil) then
              # upload the file
              sftp.upload!(path + filename, '/inbound/' + filename)
              @responses_expected += 1
              # rename now that we're done
              sftp.rename!('/inbound/'+ filename, '/inbound/' + filename.gsub('prg', 'asc'))
              File.rename(path + filename, path + filename.gsub('prg','sent'))
            end
          end
        end
      rescue Net::SSH::AuthenticationFailed
        raise ArgumentError, "The sFTP credentials provided were incorrect. Try again!"
      end
    end
    
    # Sends all previously unsent LitleRequests in the specified directory to the Litle server
    # by use of fast batch. All results will be written to disk as we get them. Note that use
    # of fastbatch is strongly discouraged!
    def send_to_litle_stream(options = {}, path = (File.dirname(@path_to_batches)))
      url = get_config(:fast_url, options)
      port = get_config(:fast_port, options)
      
      if(url == nil or url == "") then
        raise ArgumentError, "A URL for fastbatch was not specified in the config file or passed options. Reconfigure and try again."
      end 
        
      if(port == "" or port == nil) then
        raise ArgumentError, "A port number for fastbatch was not specified in the config file or passed options. Reconfigure and try again."
      end        
      
      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end
      
      if (!File.directory?(path + 'responses/')) then
        Dir.mkdir(path + 'responses/')
      end
          
      Dir.foreach(path) do |filename|
        if((filename =~ /request_\d+.complete\z/) != nil) then
          begin 
            socket = TCPSocket.open(url,port.to_i)
            ssl_context = OpenSSL::SSL::SSLContext.new()
            ssl_context.ssl_version = :SSLv23
            ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
            ssl_socket.sync_close = true
            ssl_socket.connect
           rescue => e 
            raise "A connection couldn't be established. Are you sure you have the correct credentials? Exception: " + e.message
           end 
            
            File.foreach(path + filename) do |li|
              ssl_socket.puts li
            end
            File.rename(path + filename, path + filename + '.sent')
            File.open(path + 'responses/' + (filename + '.asc.received').gsub("request", "response"), 'a+') do |fo|
            while line = ssl_socket.gets
                 fo.puts(line)
             end
            end
               
        end
      end    
    end
    
    
    # Grabs response files over SFTP from Litle.
    # Params:
    # +args+:: An (optional) +Hash+ containing values for the number of responses expected, the
    # path to the folder on disk to write the responses from the Litle server to, the username and
    # password with which to connect ot the sFTP server, and the URL to connect over sFTP. Values not
    # provided in the hash will be populate automatically based on our best guess
    def get_responses_from_server(args = {})
      @responses_expected = args[:responses_expected] ||= @responses_expected
      response_path = args[:response_path] ||= (File.dirname(@path_to_batches) + '/responses/')
      username = get_config(:sftp_username, args)
      password = get_config(:sftp_password, args)
      url = get_config(:sftp_url, args)

      if(username == nil or password == nil or url == nil) then
        raise ConfigurationException, "You are not configured to use sFTP for batch processing. Please run /bin/Setup.rb again!"
      end

      if(response_path[-1,1] != '/' && response_path[-1,1] != '\\') then
        response_path = response_path + File::SEPARATOR
      end

      if(!File.directory?(response_path)) then
        Dir.mkdir(response_path)
      end
      begin
        responses_grabbed = 0
        Net::SFTP.start(url, username, :password => password) do |sftp|
          # clear out the sFTP outbound dir prior to checking for new files, avoids leaving files on the server
          # if files are left behind we are not counting then towards the expected total
          sftp.dir.foreach('/outbound/') do |entry|
            if((entry.name =~ /request_\d+.complete.asc\z/) != nil) then
              sftp.download!('/outbound/' + entry.name, response_path + entry.name.gsub('request', 'response') + '.received')
              3.times{
                begin
                  sftp.remove!('/outbound/' + entry.name)
                  break
                rescue Net::SFTP::StatusException
                #try, try, try again
                  puts "We couldn't remove it! Try again"
                end
              }
            end
          end
        end
        #wait until a response has a possibility of being there
        sleep(@POLL_DELAY)
        time_begin = Time.now
        Net::SFTP.start(url, username, :password => password) do |sftp|
          while((Time.now - time_begin) < @RESPONSE_TIME_OUT && responses_grabbed < @responses_expected)
            #sleep for 60 seconds, ¿no es bueno?
            sleep(60)
            sftp.dir.foreach('/outbound/') do |entry|
              if((entry.name =~ /request_\d+.complete.asc\z/) != nil) then
                sftp.download!('/outbound/' + entry.name, response_path + entry.name.gsub('request', 'response') + '.received')
                responses_grabbed += 1
                3.times{
                  begin
                    sftp.remove!('/outbound/' + entry.name)
                    break
                  rescue Net::SFTP::StatusException
                  #try, try, try again
                    puts "We couldn't remove it! Try again"
                  end
                }
              end
            end
          end
          #if our timeout timed out, we're having problems
          if responses_grabbed < @responses_expected then
            raise RuntimeError, "We timed out in waiting for a response from the server. :("
          end
        end
      rescue Net::SSH::AuthenticationFailed
        raise ArgumentError, "The sFTP credentials provided were incorrect. Try again!"
      end
    end
    
    # Params:
    # +args+:: A +Hash+ containing arguments for the processing process. This hash MUST contain an entry
    # for a transaction listener (see +DefaultLitleListener+). It may also include a batch listener and a
    # custom path where response files from the server are located (if it is not provided, we'll guess the position)
    def process_responses(args)
      #the transaction listener is required
      if(!args.has_key?(:transaction_listener)) then
        raise ArgumentError, "The arguments hash must contain an entry for transaction listener!"
      end
      
      transaction_listener = args[:transaction_listener]
      batch_listener = args[:batch_listener] ||= nil
      path_to_responses = args[:path_to_responses] ||= (File.dirname(@path_to_batches) + '/responses/')
      
      Dir.foreach(path_to_responses) do |filename|
        if ((filename =~ /response_\d+.complete.asc.received\z/) != nil) then
          process_response(path_to_responses + filename, transaction_listener, batch_listener)
          File.rename(path_to_responses + filename, path_to_responses + filename + '.processed')
        end 
      end
    end
    
    # Params:
    # +path_to_response+:: The path to a specific .asc file to process
    # +transaction_listener+:: A listener to be applied to the hash of each transaction 
    # (see +DefaultLitleListener+)
    # +batch_listener+:: An (optional) listener to be applied to the hash of each batch. 
    # Note that this will om-nom-nom quite a bit of memory    
    def process_response(path_to_response, transaction_listener, batch_listener = nil)
      reader = LibXML::XML::Reader.file(path_to_response)
      reader.read # read into the root node
      #if the response attribute is nil, we're dealing with an RFR and everything is a-okay
      if reader.get_attribute('response') != "0" and reader.get_attribute('response') != nil then
        raise RuntimeError,  "Error parsing Litle Request: " + reader.get_attribute("message")
      end
      
      reader.read
      count = 0
      while true and count < 500001 do
        
        count += 1
        if(reader.node == nil) then
          return false
        end 
        
        case reader.node.name.to_s
        when "batchResponse"
          reader.read
        when "litleResponse"
          return false
        when "text"
          reader.read
        else
          xml = reader.read_outer_xml
          duck = Crack::XML.parse(xml)
          duck[duck.keys[0]]["type"] = duck.keys[0]
          duck = duck[duck.keys[0]]
          transaction_listener.apply(duck)
          reader.next
        end
      end
    end
  
    def get_path_to_batches
      return @path_to_batches
    end

    # Called when you wish to finish adding batches to your request, this method rewrites the aggregate
    # batch file to the final LitleRequest xml doc with the appropos LitleRequest tags.
    def finish_request
      File.open(@path_to_request, 'w') do |f|
        #jam dat header in there
        f.puts(build_request_header())
        #read into the request file from the batches file
        File.foreach(@path_to_batches) do |li|
          f.puts li
        end
        #finally, let's poot in a header, for old time's sake
        f.puts '</litleRequest>'
      end

      #rename the requests file
      File.rename(@path_to_request, @path_to_request + '.complete')
      #we don't need the master batch file anymore
      File.delete(@path_to_batches)
    end

    private

    def build_request_header(options = @options)
      litle_request = self

      authentication = Authentication.new
      authentication.user = get_config(:user, options)
      authentication.password = get_config(:password, options)

      litle_request.authentication = authentication
      litle_request.version         = '9.3'
      litle_request.xmlns           = "http://www.litle.com/schema"
      # litle_request.id              = options['sessionId'] #grab from options; okay if nil
      litle_request.numBatchRequests = @num_batch_requests

      xml = litle_request.save_to_xml.to_s
      xml[/<\/litleRequest>/]=''
      return xml
    end

    def get_config(field, options)
      if options[field.to_s] == nil and options[field] == nil then
        return @config_hash[field.to_s]
      elsif options[field.to_s] != nil then
        return options[field.to_s]
      else
        return options[field]
      end
    end
  end
end
