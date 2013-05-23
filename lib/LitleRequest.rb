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

#
# This class handles sending the Litle Request (which is actually a series of batches!)
#
 
 
 module LitleOnline
 
   class LitleRequest
      include XML::Mapping
      def initialize(options)
        #load configuration data
        @config_hash = Configuration.new.config
        @num_batch_requests = 0
        @path_to_request = ""
        @path_to_batches = ""
        @num_total_transactions = 0
        @MAX_NUM_TRANSACTIONS = 0
        @options = options
      end
      
      def create_new_litle_request(path, options)
        @options = options
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
      
      #commit the batch to the litle reqest
      def commit_batch(arg)
        path_to_batch = ""
        #they passed a batch
        if arg.kind_of?(LitleBatchRequest) then
          path_to_batch = arg.get_batch_name
        elsif arg.kind_of?(String) then
          path_to_batch = arg
        else
          raise RuntimeError, "You entered neither a path nor a batch. Game over :("
        end
        #the batch isn't closed. let's help a brother out
        if (ind = path_to_batch.index(/.*\.closed.*/)) == nil then
          if arg.kind_of?(String) then
            new_batch = LitleBatchRequest.new
            new_batch.open_existing_batch(path_to_batch)
            new_batch.close_batch()
            path_to_batch = new_batch.get_batch_name
          elsif arg.kind_of?(LitleBatchRequest) then
            arg.close_batch()
            path_to_batch = arg.get_batch_name  
          end
          ind = path_to_batch.index(/.*\.closed.*/)
        end 
        transactions_in_batch = path_to_batch[ind+8..path_to_batch.length].to_i
        
        #if the litle request would be too big, let's make another!
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
          File.rename(path_to_batch, path_to_batch.chomp('.closed') + '.sent')
        end
      end  
      
      #grabs all litle requests and sends them over SFTP
      def send_to_litle()
        #finish off what we're working on 
        finish_request()
        #SFTP EVERYTHING
      end
      
      
     
      private
      #writes the batches in the file at path_to_batches to an appropriately formatted .xml
      def finish_request
        # populate the header
        File.open(@path_to_request, 'w') do |f|
          f.puts(self.build_request_header)
        end
        
        #read into the request file from the batches file
        File.open(@path_to_request, 'a+') do |f|
          File.foreach(@path_to_batches, 'w') do |li|
            f.puts li
          end
        end
        
        #shove in the closing tag
        f.puts '<\litleRequest>'  
        
        #rename the requests file
        File.rename(@path_to_request, @path_to_request + '.complete')
        #we don't need the master batch file anymore
        File.delete(@path_to_batches)
      end
      
      def build_request_header(options = @options)
        litle_request = LitleRequest.new
        
        authentication = Authentication.new
        authentication.user = get_config(:user, options)
        authentication.password = get_config(:password, options)
        
        litle_request.authentication = authentication
        litle_request.version         = '8.16'
        litle_request.xmlns           = "http://www.litle.com/schema"
        litle_request.id              = options['sessionId']
        litle_request.numBatchRequests = num_batch_requests
        
        xml = litle_request.save_to_xml.to_s
        xml[/<\/litleRequest>/]=''
        return xml
        #request.version =       
      end
      
      def get_config(field, options)
        options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
      end
    end
  end