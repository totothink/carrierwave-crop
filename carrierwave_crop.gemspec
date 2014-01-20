# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave_crop/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-crop"
  spec.version       = CarrierwaveCrop::VERSION
  spec.authors       = ["totothink"]
  spec.email         = ["yalong1976@gmail.com"]
  spec.description   = %q{add crop feature with carrierwave}
  spec.summary       = %q{add crop feature with carrierwave}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "carrierwave"
  spec.add_dependency "carrierwave-mda"
end
