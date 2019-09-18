lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specss/version'

Gem::Specification.new do |s|
  s.name        = 'specss'
  s.version     = Specss::VERSION
  s.authors     = ['Tom Bonan']
  s.email       = ['tombonan@spectralogic.com']
  s.homepage    = 'https://github.com/tombonan/smarter-specs'
  s.summary     = 'A smarter Rspec Runner'
  s.description = 'A smarter Rspec Runner'
  s.license     = 'MIT'

  s.files       = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_runtime_dependency 'rubrowser-local2.7.1'
  
  s.post_install_message = "Welcome to the Spec Party"
end
