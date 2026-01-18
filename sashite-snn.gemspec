# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "sashite-snn"
  spec.version                = ::File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "SNN (Style Name Notation) implementation for Ruby with immutable style name objects"
  spec.description            = "SNN (Style Name Notation) implementation for Ruby. Provides a rule-agnostic format for identifying game styles in abstract strategy board games with immutable style name objects and functional programming principles."
  spec.homepage               = "https://github.com/sashite/snn.rb"
  spec.license                = "Apache-2.0"
  spec.files                  = ::Dir["LICENSE", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.2.0"

  spec.metadata = {
    "bug_tracker_uri"       => "https://github.com/sashite/snn.rb/issues",
    "documentation_uri"     => "https://rubydoc.info/github/sashite/snn.rb/main",
    "homepage_uri"          => "https://github.com/sashite/snn.rb",
    "source_code_uri"       => "https://github.com/sashite/snn.rb",
    "specification_uri"     => "https://sashite.dev/specs/snn/1.0.0/",
    "wiki_uri"              => "https://sashite.dev/specs/snn/1.0.0/examples/",
    "funding_uri"           => "https://github.com/sponsors/sashite",
    "rubygems_mfa_required" => "true"
  }
end
