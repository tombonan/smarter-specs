require 'specss/files'

module Executor
  class << self

    ##
    # Takes in option from parse and executes main functions
    def main(opt)
      $changed_files = Files::Perforce.get_changelist_files

      return false unless $changed_files

      # Pass in options from ARGV on whether to run lite or extended
      case opt
      when 'extended'
        specs_to_run = extended
      when 'list'
        list_specs
      else
        specs_to_run = condensed
      end

      run_specs(specs_to_run) unless opt == 'list'
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

    def condensed
      Files::Specs.get_specs($changed_files)
    end

    ##
    # Prints a list of specs for files opened for edit
    def list_specs
      specs = condensed
      puts specs.join("\n")
    end

    def run_specs(specs_to_run)
      if specs_to_run.empty?
        puts 'No specs need to be run'
      else
        spec_names = Files::Specs.chop_file_paths(specs_to_run)
        puts 'Running specs: ' + spec_names.join(" ")
        exec "bundle exec rspec " + specs_to_run.join(" ")
      end
    end
  end
end
