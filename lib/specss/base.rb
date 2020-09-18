# frozen_string_literal: true

require 'specss/git/lib'
require 'specss/p4/lib'

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
      @working_directory = Specss::WorkingDirectory.new(options[:working_directory])
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

    # returns reference to the git repository directory
    #  @specss.dir.path
    def repo
      @repository
    end

    def status
      @status ||= lib.status
    end

    ##
    # This is a convenience method for accessing the class that wraps all the
    # actual system calls.
    def lib
      @lib ||= git_repo? ? Specss::Git::Lib.new(self) : Specss::P4::Lib.new(self)
    end

    private

    ##
    # Returns true if the working dir or the parent of the working dir has a .git
    # directory. False otherwise
    def git_dir?(working_dir)
      return true if File.exist?(File.join(working_dir, '.git'))
      return true if File.exist?(File.join(File.expand_path('..', working_dir), '.git'))
      false
    end
  end
end
