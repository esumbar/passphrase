require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << "lib/passphrase"
  test.test_files = FileList['test/test*.rb']
end

require 'rake/gempackagetask'
spec = Gem::Specification.new do |s|
  s.name         = "passphrase"
  s.version      = File.exist?('VERSION') ? File.read('VERSION') : ""
  s.summary      = "Generate a passphrase using the Diceware method."
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
  s.author       = "Edmund Sumbar"
  s.email        = "esumbar@gmail.com"
  s.platform     = Gem::Platform::RUBY
  s.files        = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*'].to_a
  s.executables  = [ 'passphrase' ]
  s.has_rdoc     = false
end
Rake::GemPackageTask.new(spec).define
