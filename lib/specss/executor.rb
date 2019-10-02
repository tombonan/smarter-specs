require 'specss/files'

module Executor
  class << self

    ##
    # Takes in option from parse and executes main functions
    def main(opt)
      $changed_files = Files::Perforce.get_changelist_files

      # Pass in options from ARGV on whether to run lite or extended
      case opt
      when 'extended'
        specs_to_run = extended
      else
        specs_to_run = lite
      end

      if specs_to_run.empty?
        puts 'No specs need to be run'
      else
        spec_names = Files::Specs.chop_file_paths(specs_to_run)
        puts 'Running specs: ' + spec_names.join(" ")
        exec "bundle exec rspec " + specs_to_run.join(" ")
      end
    end

    ##
    # Returns all unique files in changelist and their dependents
    def get_all_affected_files
      all_files = $changed_files
      dependents = get_dependents

      dependents.each do |d|
        all_files.push(d) unless all_files.include? d
      end
      all_files
    end

    ##
    # Returns all dependents of files in changelist
    def get_dependents
      dependents = []
      $changed_files.each do |f|
        dependents_array = Files::Dependencies.get_dependencies(f)
        dependents_array.each do |d|
          dependents.push(d) unless dependents.include? d
        end
      end
      dependents
    end

    def extended
      all_files = get_all_affected_files
      Files::Specs.get_specs(all_files)
    end

    def lite
      Files::Specs.get_specs($changed_files)
    end
  end
  
end
