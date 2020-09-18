# frozen_string_literal: true

require 'specss/git/status'

module Specss
  module Git
    class ExecuteError < StandardError; end
    ##
    # Class that wraps all system calls for git commands
    class Lib
      attr_accessor :base

      def initialize(base = nil)
        @git_dir = nil
        @git_work_dir = nil
        @path = nil
        @base = base

        @git_work_dir = base.is_a?(Specss::Base) ? base.dir.path : base[:working_directory]
      end

      def status
        @status ||= Specss::Git::Status.new(base)
      end

      def ls_files(location=nil)
        location ||= '.'
        hsh = {}
        command_lines('ls-files', ['--stage', location]).each do |line|
          (info, file) = line.split("\t")
          (mode, sha, stage) = info.split
          file = eval(file) if file =~ /^\".*\"$/ # This takes care of quoted strings returned from git
          hsh[file] = {:path => file, :mode_index => mode, :sha_index => sha, :stage => stage}
        end
        hsh
      end

      def ignored_files
        command_lines('ls-files', ['--others', '-i', '--exclude-standard'])
      end

      ##
      # Compares the index and the working directory
      def diff_files
        diff_as_hash('diff-files')
      end

      ##
      # Compares the index and the repository
      def diff_index(treeish)
        diff_as_hash('diff-index', treeish)
      end

      private

      # Takes the diff command line output (as Array) and parse it into a Hash
      #
      # @param [String] diff_command the diff commadn to be used
      # @param [Array] opts the diff options to be used
      # @return [Hash] the diff as Hash
      def diff_as_hash(diff_command, opts=[])
        command_lines(diff_command, opts).inject({}) do |memo, line|
          info, file = line.split("\t")
          mode_src, mode_dest, sha_src, sha_dest, type = info.split

          memo[file] = {
            :mode_index => mode_dest,
            :mode_repo => mode_src.to_s[1, 7],
            :path => file,
            :sha_repo => sha_src,
            :sha_index => sha_dest,
            :type => type
          }

          memo
        end
      end

      def command_lines(cmd, opts = [], chdir = true, redirect = '')
        command(cmd, opts, chdir).lines.map(&:chomp)
      end

      def command(cmd, opts = [], chdir = true, redirect = '', &block)
        global_opts = []
        global_opts << "-C #{@git_work_dir}" if !@git_work_dir.nil?
        global_opts << ["-c", "color.ui=false"]

        opts = [opts].flatten.join(' ')
        global_opts = global_opts.flatten.join(' ')

        git_cmd = "git #{global_opts} #{cmd} #{opts} #{redirect} 2>&1"

        output = nil
        command_thread = nil;
        exitstatus = nil

        command_thread = Thread.new do
          output = run_command(git_cmd, &block)
          exitstatus = $?.exitstatus
        end
        command_thread.join

        if exitstatus > 1 || (exitstatus == 1 && output != '')
          raise Specss::Git::ExecuteError.new(git_cmd + ':' + output.to_s)
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
