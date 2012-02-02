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

#
# Used to Handle verification of Ruby Hash data
#
class Checker
  #checks for empty,flagged and null hashes and deletes them
  def Checker.purgeNull(hash)
    hash.each_key do |i|
      if (hash[i] == nil or hash[i] =={} or hash[i] == 'throwFlag')
        hash.delete(i)
      end
    end
  end

  #checks if Required Fileds are missing and raises and error
  def Checker.requiredMissing(hash)
    hash.each_key do |i|
      if hash[i] == 'REQUIRED'
        raise "Missing Required Field: #{i}!!!!"
      end
    end
  end

  #checks if one and only one field is filled out when given a choice between fields
  def Checker.choice(hash)
    hash = purgeNull(hash)
    if hash.length > 1
      raise 'Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!'
    end
  end

end
