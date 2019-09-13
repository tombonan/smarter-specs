#!/usr/bin/env ruby

specs = Dir.glob('spec/**/*').select{ |e| File.file? e }

p4_status = %x|p4 status &|
p4_array = p4_status.split("\n")

changed_files = []
specs_to_run = []

# Add all ruby files ready to be submitted to changed file array
p4_array.each do |p|
  next unless p.include?('.rb')
  file = p.split(' - ')[0]
  status = p.split(' - ')[1]
  changed_files.push(File.basename(file, ".*")) if status.include? 'submit'
end

# Check if each spec is included in the list of changed files
specs.each do |s|
  spec_name = File.basename(s, ".*")
  spec_name.slice! '_spec' if spec_name.include? '_spec'
  specs_to_run.push(s) if changed_files.include? spec_name
end

if specs_to_run.empty?
  puts 'No specs need to be run'
else
  puts 'Running specs: ' + specs_to_run.join(" ")
  exec "rspec " + specs_to_run.join(" ")
end

