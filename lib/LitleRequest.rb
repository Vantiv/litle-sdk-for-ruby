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
      # current time out set to one hour
      # this value is in seconds
      @RESPONSE_TIME_OUT = 3600
      @responses_expected = 0
    end

    # Creates the necessary files for the LitleRequest at the path specified. path/request_(TIMESTAMP) will be
    # the final XML markup and path/request_(TIMESTAMP) will hold intermediary XML markup
    # Params:
    # +path+:: A +String+ containing the path to the folder on disc to write the files to
    def create_new_litle_request(path)
      ts = Time::now.to_i.to_s
      ts += Time::now.nsec.to_s
      if(File.file?(path)) then
        raise RuntimeError, "Entered a file not a path."
      end

      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
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
        @num_batch_requests += 1
        @num_total_transactions += transactions_in_batch

        File.open(@path_to_batches, 'a+') do |fo|
          File.foreach(path_to_batch) do |li|
            fo.puts li
          end
        end
        
        File.delete(path_to_batch)
      end
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
        raise ConfigurationException, "You are not configured to use sFTP for batch processing. Please run /bin/Setup.rb again!"
      end
      
      if(path[-1,1] != '/' && path[-1,1] != '\\') then
        path = path + File::SEPARATOR
      end
      
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
      Net::SFTP.start(url, username, :password => password) do |sftp|
        time_begin = Time.now
        responses_grabbed = 0
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
        while((Time.now - time_begin) < @RESPONSE_TIME_OUT && responses_grabbed < @responses_expected)
          #sleep for 30 seconds
          sleep(2)
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

      doc = LibXML::XML::Document.file(path_to_response)
      reader = LibXML::XML::Reader.document(doc)
      reader.read # read into the root node
      if reader.get_attribute('response') != "0" then
        raise RuntimeError,  "Error parsing Litle Request: " + reader.get_attribute("message")
      end
      reader.node.each do |batch_node|

        if(batch_node.node_type_name == "element") then
          if(batch_listener != nil) then
            batch_xml = batch_node.to_s
            duck = Crack::XML.parse(batch_xml)
            batch_listener.apply(duck)
          end

          batch_node.each do |trans_node|
            if(trans_node.node_type_name == "element") then
              xml = trans_node.to_s
              duck = Crack::XML.parse(xml)
              duck[duck.keys[0]]["type"] = duck.keys[0]
              duck = duck[duck.keys[0]]
              transaction_listener.apply(duck)
            end
          end
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
      litle_request.version         = '8.16'
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