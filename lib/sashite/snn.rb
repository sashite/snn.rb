# frozen_string_literal: true

require_relative "snn/constants"
require_relative "snn/errors"
require_relative "snn/parser"
require_relative "snn/style_name"

module Sashite
  # SNN (Style Name Notation) implementation for Ruby.
  #
  # SNN provides a human-readable naming system for game styles (Piece Styles)
  # in abstract strategy board games. It uses PascalCase names with optional
  # numeric suffixes to identify movement traditions or game variants.
  #
  # @example Parsing
  #   snn = Sashite::Snn.parse("Chess")
  #   snn.name  # => "Chess"
  #
  # @example Validation
  #   Sashite::Snn.valid?("Chess960")  # => true
  #   Sashite::Snn.valid?("chess")     # => false
  #
  # @see https://sashite.dev/specs/snn/1.0.0/
  module Snn
    # Parses an SNN string into a StyleName.
    #
    # @param input [String] The SNN string to parse
    # @return [StyleName] A new StyleName instance
    # @raise [Errors::Argument] If the input is invalid
    #
    # @example
    #   snn = Sashite::Snn.parse("Chess")
    #   snn.name  # => "Chess"
    #
    # @example With numeric suffix
    #   snn = Sashite::Snn.parse("Chess960")
    #   snn.name  # => "Chess960"
    def self.parse(input)
      StyleName.new(input)
    end

    # Reports whether the input is a valid SNN string.
    #
    # @param input [Object] The input to validate
    # @return [Boolean] true if valid, false otherwise
    #
    # @example
    #   Sashite::Snn.valid?("Chess")     # => true
    #   Sashite::Snn.valid?("Chess960")  # => true
    #   Sashite::Snn.valid?("chess")     # => false
    #   Sashite::Snn.valid?("")          # => false
    def self.valid?(input)
      Parser.valid?(input)
    end
  end
end
