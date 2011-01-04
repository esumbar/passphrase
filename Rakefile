require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << "lib/passphrase"
  test.test_files = FileList['test/test*.rb']
end
