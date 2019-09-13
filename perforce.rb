module Perforce
  def self.execute
    changed_files = get_changelist_files
    specs_to_run = get_specs(changed_files)

    if specs_to_run.empty?
      puts 'No specs need to be run'
    else
      puts 'Running specs: ' + specs_to_run.join(" ")
      exec "rspec " + specs_to_run.join(" ")
    end
  end

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

  def self.get_specs(changed_files)
    specs_to_run = []
    specs = Dir.glob('spec/**/*').select{ |e| File.file? e }

    # Check if each spec is included in the list of changed files
    specs.each do |s|
      spec_name = File.basename(s, ".*")
      spec_name.slice! '_spec' if spec_name.include? '_spec'
      specs_to_run.push(s) if changed_files.include? spec_name
    end
    specs_to_run
  end

end

