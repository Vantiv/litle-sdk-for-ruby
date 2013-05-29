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

#Sample Driver
require_relative '../lib/LitleOnline'

saleHash = {
        'reportGroup'=>'Planets',
        'id' => '006',
        'orderId'=>'12344',
        'amount'=>'6000',
        'orderSource'=>'ecommerce',
        'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1210'
      }}
      
updateCardHash = {
        'merchantId' => '101',
        'version'=>'8.8',
        'reportGroup'=>'Planets',
        'id'=>'12345',
        'customerId'=>'0987',
        'orderId'=>'12344',
        'litleToken'=>'1233456789103801',
        'cardValidationNum'=>'123'
      }      
      
path = Dir.pwd
      

request = LitleOnline::LitleRequest.new({'sessionId'=>'8675309'})
request.create_new_litle_request(path)
puts "Created new LitleRequest at location: " + path

#create five batches, each with 10 sales
2.times{
  batch = LitleOnline::LitleBatchRequest.new
  batch.create_new_batch(path)

  #add the same sale ten times
  3.times{
    batch.update_card_validation_num_on_token(updateCardHash)
  }

  #close the batch, indicating we plan to add no more transactions
  batch.close_batch()
  #add the batch to the LitleRequest
  request.commit_batch(batch)
}
puts "Finished adding batches to LitleRequest at " + request.get_path_to_batches
#finish the Litle Request, indicating we plan to add no more batches
request.finish_request
puts "Generated final XML markup of the LitleRequest"

#send the batch files at the given directory over sFTP
request.send_to_litle
puts "Dropped off the XML of the LitleRequest over FTP"
#grab the expected number of responses from the sFTP server and save them to the given path
request.get_responses_from_server(1)
puts "Received the LitleRequest responses from the server"
#process the responses from the server with a listener which applies the given block
request.process_responses({:transaction_listener => LitleOnline::DefaultLitleListener.new do |transaction|
  puts transaction["type"]
end})

