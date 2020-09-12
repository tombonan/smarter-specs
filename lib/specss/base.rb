# frozen_string_literal: true

module Specss
  ##
  # Base class for intializing and configuring a project
  class Base
    #
    # Opens a new Specss project from a working directory
    def self.open(working_dir, opts={})
      self.new({:working_directory => working_dir}.merge(opts))
    end

    def initialize(options = {})
      @working_directory = options[:working_directory] ?
                             Specss::WorkingDirectory.new(options[:working_directory]) : nil

      # Boolean indicator of whether the project is a git repository or not
      @git_repo = git_dir?(options[:working_directory])
    end

    ##
    # Returns true if the repository uses git. False otherwise.
    def git_repo?
      @git_repo
    end

    ##
    # Returns a reference to the working directory
    #  @specss.dir.path
    #  @specss.dir.writeable?
    def dir
      @working_directory
    end

    ##
    # This is a convenience method for accessing the class that wraps all the
    # actual system calls.
    def lib
      @lib ||= Specss::Lib.new(self)
    end

    private

    ##
    # Attempts to create a Specss::Path with possible locations of the .git directory.
    # If any of those initializations raise, the path doesn't exist.
    def git_dir?(working_dir)
      return true unless Specss::Path.new(File.join(working_dir, '.git')).nil?
      return true unless Specss::Path.new(File.join(File.expand_path('..', working_dir), '.git')).nil?
      false
    rescue ArgumentError
      false
    end
  end
end
