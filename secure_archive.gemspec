# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secure_archive/version'

Gem::Specification.new do |spec|
  spec.name          = "secure_archive"
  spec.version       = SecureArchive::VERSION
  spec.authors       = ["Romain Tartière"]
  spec.email         = ["romain@blogreen.org"]
  spec.summary       = %q{Create encrypted directory tree archive for backing-up sensitive data.}
  spec.homepage      = "https://github.com/sante-link/secure_archive"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "gpgme", "~> 2.0.8"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
