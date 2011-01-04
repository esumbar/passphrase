require 'rake/testtask'
require 'rake/gempackagetask'

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << "lib/passphrase"
  test.test_files = FileList['test/test*.rb']
end

spec = Gem::Specification.new do |s|
  s.name         = "analyze"
  s.version      = File.exist?('VERSION') ? File.read('VERSION') : ""
  s.summary      = "Report statistics from the Torque and qsub logs."
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
  s.author       = "Edmund Sumbar"
  s.email        = "esumbar@ualberta.ca"
  s.platform     = Gem::Platform::RUBY
  s.files        = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*'].to_a
  s.executables  = [ 'analyze' ]
  s.has_rdoc     = false
  s.required_ruby_version = '>=1.9'
end
Rake::GemPackageTask.new(spec).define
