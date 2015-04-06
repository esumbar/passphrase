helpers = File.expand_path('../helpers', __FILE__)
$LOAD_PATH.unshift(helpers) unless $LOAD_PATH.include?(helpers)

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

require "passphrase/rake_helper"
