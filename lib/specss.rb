require 'specss/version'
require 'specss/base'
require 'specss/lib'
require 'specss/path'
require 'specss/working_directory'

module Specss
  ##
  # Open an new working directory
  #
  # By default, the working_dir will be the current directory
  # unless otherwise specified
  def self.open(working_dir = Dir.pwd, options = {})
    Base.open(working_dir, options)
  end
end
