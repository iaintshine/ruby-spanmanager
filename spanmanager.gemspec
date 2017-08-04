# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spanmanager/version"

Gem::Specification.new do |spec|
  spec.name          = "spanmanager"
  spec.version       = SpanManager::VERSION
  spec.authors       = ["iaintshine"]
  spec.email         = ["bodziomista@gmail.com"]

  spec.summary       = %q{Current span managemt for OpenTracing}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/iaintshine/ruby-activespan"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'opentracing'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-console"
end
