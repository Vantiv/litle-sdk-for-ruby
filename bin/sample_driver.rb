#!/usr/bin/env ruby

=begin
Copyright (c) 2017 Vantiv eCommerce

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
#require 'LitleOnline'
#include LitleOnline
require_relative '../lib/LitleOnline'
hash = {
  'reportGroup'=>'product1',
  'orderId'=>'12344',
  'card'=>{
    'type'=>'VI',
    'number' =>'4100000000000001',
    'expDate' =>'1210'
    },
  'orderSource'=>'ecommerce',
  'amount'=>'106'
}

#perform credit transaction
response= LitleOnline::LitleOnlineRequest.new.credit(hash)

#display results
puts "Message: "+response.message
puts "Litle Transaction ID: "+response.creditResponse.litleTxnId
