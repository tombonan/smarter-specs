module Files
  require 'json'
  
  module Perforce
    ##
    # Returns all ruby files in changelist as an array of files without extension
    def self.get_changelist_files
      changed_files = []
      p4_status = %x|p4 status &|
      p4_array = p4_status.split("\n")

      # Add all ruby files ready to be submitted to changed file array
      p4_array.each do |p|
        next unless p.include?('.rb')
        file = p.split(' - ')[0]
        status = p.split(' - ')[1]
        changed_files.push(File.basename(file, ".*")) if status.include? 'submit'
      end
      changed_files
    end
  end

  module Dependencies
    ##
    # Takes in a file and returns all files that are dependents as an array of files without extension
    def self.get_dependencies(file)
      dependents = []
      # Get file name without extension and convert to camel case
      basename = File.basename(file, ".*")
      basename = basename.gsub(/(?:^|_)([a-z])/) do $1.upcase end

      # Get rubrowser output and parse for the relation data
      output = %x|rubrowser &|
      data = output.match(/var\s+data\s+=\s+(.*?);/m)[1].split('</script>')[0]
      data_hash = JSON.parse(data)
      relations = data_hash['relations']

      # Return dependents of input file
      dependents_data = relations.select { |i| i['resolved_namespace'] == basename }
      dependents_data.each do |d|
        filename = d['file']
        basename = File.basename(filename, ".*")
        next if basename.include? '_spec'
        dependents.push(basename) unless dependents.include? basename
      end
      dependents
    end
  end

  module Specs
    ##
    # Returns all specs to run as an array of file paths relative to root
    def self.get_specs(changed_files)
      specs_to_run = []
      specs = Dir.glob('spec/**/*').select{ |e| File.file? e }

      # Check if each spec is included in the list of changed files
      specs.each do |s|
        spec_name = File.basename(s, ".*")
        spec_name.slice! '_spec' if spec_name.include? '_spec'
        next if spec_name.include? 'shared_examples'
        specs_to_run.push(s) if changed_files.include? spec_name
      end
      specs_to_run
    end

    ##
    # Returns array of specs to run with the absolute path chopped off
    def self.chop_file_paths(specs)
      specs_to_run = []
      
      specs.each do |s|
        spec_name = File.basename(s)
        specs_to_run.push(spec_name)
      end
      specs_to_run
    end
  end
  
end

