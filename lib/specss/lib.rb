# frozen_string_literal: true

module Specss
  ##
  # Class that wraps all system calls for git and p4 commands
  class Lib
    def initialize(base = nil)
      @work_dir = nil
      @git_repo = false
      @path = nil

      if base.is_a?(Specss::Base)
        @work_dir = base.dir.path if base.dir
        @git_repo = base.git?
      elsif base.is_a?(Hash)
        @work_dir = base[:working_directory]
        @git_repo = base[:git_repo]
      end
    end
  end
end
