require 'LitleOnline'
include LitleOnline
 
# Visa $10 Sale
litleSaleTxn = {
    'merchantId' => '087900',
    'reportGroup'=>'rpt_grp',
    'orderId'=>'1234567',
    'card'=>{
        'type'=>'VI',
        'number' =>'4100000000000001',
        'expDate' =>'1212'},
        'orderSource'=>'ecommerce',
        'amount'=>'1000'
    }
 
# Peform the transaction on the Litle Platform
response = LitleOnlineRequest.new.sale(litleSaleTxn)
 
# display results
puts "Message: "+ response.message
puts "Litle Transaction ID: "+ response.saleResponse.litleTxnId    