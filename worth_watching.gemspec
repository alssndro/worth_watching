# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'worth_watching/version'

Gem::Specification.new do |spec|
  spec.name          = "worth_watching"
  spec.version       = WorthWatching::VERSION
  spec.authors       = ["Sandro"]
  spec.email         = ["sandro@?.com"]
  spec.description   = %q{Retrieve the ratings of a movie from IMDB, Rotten
                          Tomatoes and Metacritic}
  spec.summary       = %q{Retrieve the ratings of a movie from IMDB, Rotten
                          Tomatoes and Metacritic}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"

  spec.add_dependency "json"
  spec.add_dependency "nokogiri"
  spec.add_dependency "typhoeus"
end
