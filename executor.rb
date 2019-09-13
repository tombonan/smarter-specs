module Executor
  require_relative 'files'
  def self.main
    $changed_files = Files::Perforce.get_changelist_files
    all_files = get_all_affected_files
    
    specs_to_run = Files::Specs.get_specs(all_files)

    if specs_to_run.empty?
      puts 'No specs need to be run'
    else
      puts 'Running specs: ' + specs_to_run.join(" ")
      exec "rspec " + specs_to_run.join(" ")
    end
  end

  #
  ## Returns all unique files in changelist and their dependents
  def self.get_all_affected_files
    all_files = $changed_files
    dependents = get_dependents

    dependents.each do |d|
      all_files.push(d) unless all_files.include? d
    end
    all_files
  end

  #
  ## Returns all dependents of files in changelist
  def self.get_dependents
    dependents = []
    $changed_files.each do |f|
      dependents_array = Files::Dependencies.get_dependencies(f)
      dependents_array.each do |d|
        dependents.push(d) unless dependents.include? d
      end
    end
    dependents
  end
  
end
