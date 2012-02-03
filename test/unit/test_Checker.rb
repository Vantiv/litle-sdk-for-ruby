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
require 'test/unit'
require 'mocha'

class CheckerTest < Test::Unit::TestCase
  def test_purge_null
    hash = {'a'=>'one','b'=>nil,'c'=>{},'d'=>{'e'=>'two'},'f'=>'throwFlag'}
    Checker.purge_null(hash)
    assert_equal 2, hash.length
    assert_equal 'one', hash['a']
    assert_equal 'two', hash['d']['e']
  end

  def test_required_missing
    hash = {'a'=>'REQUIRED','b'=>'2'}
    exception = assert_raise(RuntimeError){Checker.required_missing(hash)}
    assert_match /Missing Required Field: a!!!!/, exception.message

    hash = {'a'=>'1','b'=>'2'}
    assert_nothing_raised {Checker.required_missing(hash)}
  end

  def test_choice
    assert_nothing_raised {Checker.choice({})}

    assert_nothing_raised {Checker.choice({'a'=>'1'})}
    assert_nothing_raised {Checker.choice({'a'=>'1','b'=>nil})}
      
    exception = assert_raise(RuntimeError) {Checker.choice({'a'=>'1','b'=>'2'})}
    assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
  end

end
