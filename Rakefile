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

require 'jeweler'
require './lib/passphrase/version.rb'
Jeweler::Tasks.new do |gem|
  gem.name        = "passphrase"
  gem.version     = Passphrase::Version::STRING
  gem.summary     = "Generate a passphrase using the Diceware method."
  gem.description = File.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
  gem.author      = "Edmund Sumbar"
  gem.email       = "esumbar@gmail.com"
  gem.files       = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*'].to_a
  gem.executables = [ 'passphrase' ]
end
Jeweler::RubygemsDotOrgTasks.new
