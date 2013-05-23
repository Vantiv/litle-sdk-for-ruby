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
require 'lib/LitleOnline'
require 'lib/LitleOnlineRequest'
require 'lib/LitleRequest'
require 'lib/LitleBatchRequest'
require 'test/unit'
require 'mocha/setup'

module LitleOnline
  
  class TestLitleRequest < Test::Unit::TestCase
    
    def test_create_with_file
      
    end
    
    def test_create_with_no_sep
      
    end
    
    def test_create_name_collision
      
    end
    
    def test_create_normal
      
    end
    
    def test_add_batch_request
      
    end
    
    def test_add_path_to_batch
      
    end
    
    def test_add_bad_object
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).once
      request = LitleRequest.new({})
      request.commit_batch({:apple => "pear"})
      test = ""
      rescue RuntimeError => e
        test = e.message
      assert_equal test, "You entered neither a path nor a batch. Game over :("  
    end
    
    def test_add_open_batch
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'}).times(2)
      File.expects(:open).with(regexp_matches(/\/usr\/srv\/.*/), 'a+').times(2)
      batch = LitleBatchRequest.new
      batch.create_new_batch('/usr/srv/batches')  
      request = LitleRequest.new({})
      
      close_and_add = sequence('close_and_add')
      batch.expects(:get_batch_name).returns("/usr/srv/batches/batch_123123131231").once.in_sequence(close_and_add)
      batch.expects(:close_batch).once.in_sequence(close_and_add)
      batch.expects(:get_batch_name).returns(str = "/usr/srv/batches/batch_123123131231").once.in_sequence(close_and_add)
      str.expects(:index).returns(7).once.in_sequence(close_and_add)
      File.expects(:open).once.in_sequence(close_and_add)
      File.expects(:rename).once.in_sequence(close_and_add)
      request.commit_batch(batch)
      
      
      
     
    end
    
    def test_batch_too_big
      
    end

    
    
    
  end
end