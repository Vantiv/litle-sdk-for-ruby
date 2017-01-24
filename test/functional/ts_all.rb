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

require File.expand_path("../../../lib/LitleOnline",__FILE__) 


#test driver for running all tests
require_relative 'test_updateSubscription'
require_relative 'test_captureGivenAuth'
require_relative 'test_xmlfields'
require_relative 'test_sale'
require_relative 'test_captureGivenAuth'
require_relative 'test_authReversal'
require_relative 'test_credit'
require_relative 'test_auth'
require_relative 'test_token'
require_relative 'test_forceCapture'
require_relative 'test_capture'
require_relative 'test_echeckRedeposit'
require_relative 'test_echeckSale'
require_relative 'test_echeckCredit'
require_relative 'test_echeckVerification'
require_relative 'test_echeckVoid'
require_relative 'test_updateCardValidationNumOnToken'
require_relative 'test_wallet'
require_relative 'test_queryTransaction'
require_relative 'test_litle_requests'
require_relative 'test_batch'
require_relative 'test_cancelSubscription'
require_relative 'test_updateSubscription'
require_relative 'test_deactivate'
require_relative 'test_load'
require_relative 'test_unload'
require_relative 'test_balanceInquiry'
require_relative 'test_createPlan'
require_relative 'test_updatePlan'
require_relative 'test_batchStream'
require_relative 'test_activate'
require_relative 'test_activateReversal'
require_relative 'test_depositReversal'
require_relative 'test_refundReversal'
require_relative 'test_loadReversal'
require_relative 'test_unloadReversal'
require_relative 'test_deactivateReversal'
require_relative 'test_override'
require_relative 'test_configuration'
require_relative 'test_fraudCheck'
