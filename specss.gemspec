# frozen_string_literal: true

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

  s.add_runtime_dependency 'rubrowser', '~> 2.0.0'

  s.add_development_dependency 'pry', '~> 0.12.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 0.80'
end
