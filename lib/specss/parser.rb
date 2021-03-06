require 'optparse'
require 'specss'
require 'specss/executor'

##
# Parse arguments that are passed when running specs
class Parser
  def self.parse(options)

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: specss [option]"

      opts.on("-c", "--condensed", "Run specs of files opened for edit only") do |n|
        Executor.main('condensed')
      end

      opts.on("-e", "--extended", "Run specs of files opened for edit and dependents") do |n|
        Executor.main('extended')
      end

      opts.on("-l", "--list", "Prints a list of specs for files opened for edit") do |n|
        Executor.main('list')
      end

      opts.on("-v", "--version", "Smarter Specs Version") do |n|
        puts "Specss #{Specss::VERSION}"
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
  end
end
