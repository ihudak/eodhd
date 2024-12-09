lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "eodhd/version"

Gem::Specification.new do |spec|
  spec.name          = "eodhd"
  spec.version       = Eodhd::VERSION
  spec.authors       = ["Ivan Gudak"]
  spec.email         = ["ihudak@gmail.com"]

  spec.summary       = %q{Ruby library for EODHD API}
  spec.description   = "Ruby library for the EODHD API, a provider of stock and ETF API"
  spec.homepage      = "https://github.com/ihudak/eodhd"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ihudak/eodhd"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty",                       "~> 0.22.0"

  spec.add_development_dependency "bundler",            "~> 2.5"
  spec.add_development_dependency "rake",               "~> 13.2.1"
  spec.add_development_dependency "minitest",           "~> 5.25.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.7.1"
  spec.add_development_dependency "guard-minitest",     "~> 2.4.6"
  spec.add_development_dependency "webmock",            "~> 3.24.0"
end