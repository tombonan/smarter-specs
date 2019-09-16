#!/usr/bin/env ruby
require 'optparse'
require_relative 'executor'

ARGV << '-l' if ARGV.empty?

Options = Struct.new(:name)

class Parser
  def self.parse(options)
    args = Options.new("world")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.on("-l", "--lite", "Run specs of modified files only") do |n|
        Executor.main('lite')
      end

      opts.on("-e", "--extended", "Run specs of modified files and dependents") do |n|
        Executor.main('extended')
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

# options = Parser.parse %w[--help]
options = Parser.parse(ARGV)
