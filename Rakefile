require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# Auto load gem into ruby console
task :console do
  exec "irb -r specss -I ./lib"
end


