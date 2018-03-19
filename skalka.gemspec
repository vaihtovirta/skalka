lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "skalka/version"

Gem::Specification.new do |spec|
  spec.name          = "skalka"
  spec.version       = Skalka::VERSION
  spec.authors       = ["Emil Shakirov"]
  spec.email         = ["me@emil.sh"]

  spec.summary       = "The rolling pin for your json api responses."
  spec.description   = "Simple JSON API parser/flattener"
  spec.homepage      = "https://github.com/vaihtovirta/skalka.git"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "transproc"
end
