# coding: utf-8
require_relative 'lib/alki/support/version'

Gem::Specification.new do |spec|
  spec.name          = "alki-support"
  spec.version       = Alki::Support::VERSION
  spec.authors       = ["Matt Edlefsen"]
  spec.email         = ["matt.edlefsen@gmail.com"]
  spec.summary       = %q{Alki support methods}
  spec.description   = %q{Various helper methods for Alki}
  spec.homepage      = "https://github.com/medlefsen/alki-support"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.bindir        = 'exe'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
