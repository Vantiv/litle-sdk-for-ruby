require 'rake/gempackagetask'
spec = Gem::Specification.new do |s| 
  s.name         = "LitleOnline"
  s.summary      = "Ruby SDK produced by Litle & Co. for online transaction processing using Litle XML format v8.10"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'DESCRIPTION'))
  s.requirements = 
      [ 'Contact  ClientSDKSupport@litle.com for more information' ]
  s.version     = "1.8.10"
  s.author      = "Litle & Co"
  s.email       = "RubySupport@litle.com"
  s.homepage    = "http://www.litle.com"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9'
  s.files       = Dir['**/**']
  s.executables = [ 'sample_driver.rb', 'Setup.rb' ]
  s.test_files  = Dir["test/unit*.rb"]
  s.has_rdoc    = true
  s.add_dependency('i18n')
  s.add_dependency('xml-simple')
  s.add_dependency('activesupport')
  s.add_dependency('xml-object')
end
Rake::GemPackageTask.new(spec).define
