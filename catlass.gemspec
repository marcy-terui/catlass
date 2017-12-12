# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "catlass/version"

Gem::Specification.new do |spec|
  spec.name          = "catlass"
  spec.version       = Catlass::VERSION
  spec.authors       = ["Masashi Terui"]
  spec.email         = ["terui@serverworks.co.jp"]

  spec.summary       = %q{Cloud Automation as Code}
  spec.description   = %q{Cloud Automation as Code with Cloud Automator (https://cloudautomator.com/en/)}
  spec.homepage      = "https://githb.com/marcy-terui/catlass"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_dependency "dslh"
  spec.add_dependency "thor"
  spec.add_dependency "coderay"
  spec.add_dependency "diffy"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "octorelease"
end
