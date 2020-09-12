require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Open an pry session preloaded with specss'
task :console do
  require 'pry'
  exec 'pry -I lib -r specss'
rescue LoadError => _e
  exec 'irb -I lib -r specss'
end
