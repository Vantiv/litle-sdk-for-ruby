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
require 'LitleOnline'

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
path = '/usr/local/YOUR PATH HERE'
      
request = LitleRequest.new({'sessionId'=>'8675309',
        'user'=>'john',
        'password'=>'tinkleberry'})
request.create_new_litle_request(path)

#create five batches, each with 10 sales
5.times{
  batch = LitleBatchRequest.new
  batch.create_new_batch(path)

  #add the same sale ten times
  10.times{
    batch.sale(saleHash)
  }

  #close the batch, indicating we plan to add no more transactions
  batch.close_batch()
  #add the batch to the LitleRequest
  request.commit_batch(batch)
}
#finish the Litle Request, indicating we plan to add no more batches
request.finish_request
#send the batch files at the given directory over sFTP
request.send_to_litle(path)
#grab the expected number of responses from the sFTP server and save them to the given path
request.get_responses_from_server(1, path)
#proces the responses from the server with a listener which applies the given block
request.process_responses(path, DefaultLitleListener.new) do |transaction|
  puts transaction.type
end

