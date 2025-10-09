# frozen_string_literal: true

require_relative "snn/name"

module Sashite
  # SNN (Style Name Notation) implementation for Ruby
  #
  # Provides a foundational naming system for identifying styles in abstract strategy board games.
  # SNN uses canonical, human-readable alphabetic names with case encoding to represent both
  # style identity and player assignment.
  #
  # Format: All uppercase OR all lowercase alphabetic characters
  #
  # Examples:
  #   "CHESS"    - Chess style for first player
  #   "chess"    - Chess style for second player
  #   "SHOGI"    - Shōgi style for first player
  #   "shogi"    - Shōgi style for second player
  #   "XIANGQI"  - Xiangqi style for first player
  #   "xiangqi"  - Xiangqi style for second player
  #
  # Case Encoding:
  #   - UPPERCASE names represent the first player's style
  #   - lowercase names represent the second player's style
  #
  # Constraints:
  #   - Alphabetic characters only (A-Z, a-z)
  #   - Case consistency required (all uppercase OR all lowercase)
  #   - No digits, no special characters, no mixed case
  #
  # As a foundational primitive, SNN has no dependencies and serves as a building block
  # for formal style identification in the Sashité ecosystem.
  #
  # See: https://sashite.dev/specs/snn/1.0.0/
  module Snn
    # Check if a string is valid SNN notation
    #
    # Valid SNN strings must contain only alphabetic characters in consistent case
    # (either all uppercase or all lowercase).
    #
    # @param snn_string [String] the string to validate
    # @return [Boolean] true if valid SNN, false otherwise
    #
    # @example Validate SNN strings
    #   Sashite::Snn.valid?("CHESS")     # => true
    #   Sashite::Snn.valid?("shogi")     # => true
    #   Sashite::Snn.valid?("Chess")     # => false (mixed case)
    #   Sashite::Snn.valid?("CHESS960")  # => false (contains digits)
    #   Sashite::Snn.valid?("GO9X9")     # => false (contains digits)
    def self.valid?(snn_string)
      Name.valid?(snn_string)
    end

    # Parse an SNN string into a Name object
    #
    # Converts a valid SNN string into an immutable Name object. The name must follow
    # SNN format rules: all uppercase or all lowercase alphabetic characters only.
    #
    # @param snn_string [String] the name string
    # @return [Snn::Name] a parsed name object
    # @raise [ArgumentError] if the name is invalid
    #
    # @example Parse valid SNN names
    #   Sashite::Snn.parse("SHOGI")    # => #<Snn::Name value="SHOGI">
    #   Sashite::Snn.parse("chess")    # => #<Snn::Name value="chess">
    #
    # @example Invalid names raise errors
    #   Sashite::Snn.parse("Chess")    # => ArgumentError (mixed case)
    #   Sashite::Snn.parse("CHESS960") # => ArgumentError (contains digits)
    def self.parse(snn_string)
      Name.parse(snn_string)
    end

    # Create a new Name instance directly
    #
    # Constructs a Name object from a string or symbol. The value must follow
    # SNN format rules: all uppercase or all lowercase alphabetic characters only.
    #
    # @param value [String, Symbol] style name to construct
    # @return [Snn::Name] new name instance
    # @raise [ArgumentError] if name format is invalid
    #
    # @example Create names
    #   Sashite::Snn.name("XIANGQI") # => #<Snn::Name value="XIANGQI">
    #   Sashite::Snn.name(:makruk)   # => #<Snn::Name value="makruk">
    #
    # @example Invalid formats raise errors
    #   Sashite::Snn.name("Chess960") # => ArgumentError
    def self.name(value)
      Name.new(value)
    end
  end
end
