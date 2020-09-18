# frozen_string_literal: true

require 'specss/p4/status'

module Specss
  module P4
    class ExecuteError < StandardError; end
    ##
    # Class that wraps all system calls for git commands
    class Lib
      attr_accessor :base

      def initialize(base = nil)
        @p4_work_dir = nil
        @path = nil
        @base = base

        @p4_work_dir = base.is_a?(Specss::Base) ? base.dir.path : base[:working_directory]
      end

      def status
        @status ||= Specss::P4::Status.new(base)
      end

      ##
      # Returns all files in P4 status
      def all_files
        status_as_hash
      end

      ##
      # Returns files currently open for add
      def added_files
        status_as_hash(['-a'])
      end

      ##
      # Returns files currently open for delete
      def deleted_files
        status_as_hash(['-d'])
      end

      ##
      # Returns files currently open for edit
      def edited_files
        status_as_hash(['-e'])
      end

      ##
      # Returns files currently open for delete
      def deleted_files
        status_as_hash(['-d'])
      end

      private

      # Takes the status command line output (as Array) and parse it into a Hash
      #
      # @param [Array] opts the diff options to be used
      # @return [Hash] the diff as Hash
      def status_as_hash(opts=[])
        hsh = {}
        command_lines('status', opts).each do |line|
          (file, info) = line.split(' - ')
          (action_statement, depot) = info.split('//')
          action = action_statement.gsub(/(submit change default to )|(reconcile to )/, '').sub(' ', '')
          hsh[file] = {:path => file, :action => action, :depot => depot}
        end
        hsh
      end

      def command_lines(cmd, opts = [], chdir = true, redirect = '')
        command(cmd, opts, chdir).lines.map(&:chomp)
      end

      def command(cmd, opts = [], chdir = true, redirect = '', &block)
        global_opts = []
        global_opts << "-d #{@p4_work_dir}" if !@p4_work_dir.nil?

        opts = [opts].flatten.join(' ')
        global_opts = global_opts.flatten.join(' ')

        p4_cmd = "p4 #{global_opts} #{cmd} #{opts} #{redirect} 2>&1"

        output = nil
        command_thread = nil;
        exitstatus = nil

        command_thread = Thread.new do
          output = run_command(p4_cmd, &block)
          exitstatus = $?.exitstatus
        end
        command_thread.join

        if exitstatus > 1 || (exitstatus == 1 && output != '')
          raise Specss::P4::ExecuteError.new(p4_cmd + ':' + output.to_s)
        end

        return output
      end

      def run_command(git_cmd, &block)
        return IO.popen(git_cmd, &block) if block_given?

        `#{git_cmd}`.chomp.lines.join
      end
    end
  end
end
