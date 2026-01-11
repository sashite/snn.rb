# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name    = "sashite-snn"
  spec.version = ::File.read("VERSION.semver").chomp
  spec.author  = "Cyril Kato"
  spec.email   = "contact@cyril.email"
  spec.summary = "SNN (Style Name Notation) - foundational naming system for abstract strategy game styles"

  spec.description = <<~DESC
    SNN (Style Name Notation) provides a foundational, rule-agnostic naming system for identifying
    game styles in abstract strategy board games. This gem implements the SNN Specification v1.0.0
    with a modern Ruby interface featuring immutable style name objects and functional programming
    principles.

    SNN uses case-consistent alphabetic names (e.g., "CHESS", "SHOGI", "XIANGQI" for first player;
    "chess", "shogi", "xiangqi" for second player) to unambiguously represent both style identity
    and player assignment. As a foundational primitive with no dependencies, SNN serves as a building
    block for formal style identification across the Sashité ecosystem.

    Format: All uppercase OR all lowercase alphabetic characters only (no digits, no special characters).
    Ideal for game engines, protocols, and tools requiring clear and extensible style identifiers.
  DESC

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
    "rubygems_mfa_required" => "true"
  }
end
