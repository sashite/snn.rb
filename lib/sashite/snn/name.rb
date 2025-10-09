# frozen_string_literal: true

module Sashite
  module Snn
    # Represents a style name in SNN (Style Name Notation) format.
    #
    # SNN provides a foundational naming system for abstract strategy game styles.
    # Each name must consist of alphabetic characters only, all in the same case
    # (either all uppercase or all lowercase).
    #
    # Case encoding:
    #   - UPPERCASE names represent the first player's style
    #   - lowercase names represent the second player's style
    #
    # Constraints:
    #   - Alphabetic characters only (A-Z or a-z)
    #   - Case consistency required (all uppercase OR all lowercase)
    #   - No digits, no special characters, no mixed case
    #
    # All instances are immutable.
    #
    # @example Valid names
    #   Sashite::Snn::Name.new("CHESS")    # => #<Snn::Name value="CHESS">
    #   Sashite::Snn::Name.new("shogi")    # => #<Snn::Name value="shogi">
    #   Sashite::Snn::Name.new("XIANGQI")  # => #<Snn::Name value="XIANGQI">
    #
    # @example Invalid names
    #   Sashite::Snn::Name.new("Chess")    # => ArgumentError (mixed case)
    #   Sashite::Snn::Name.new("CHESS960") # => ArgumentError (contains digits)
    #   Sashite::Snn::Name.new("GO9X9")    # => ArgumentError (contains digits)
    class Name
      # SNN validation pattern matching the specification
      # Format: All uppercase OR all lowercase alphabetic characters
      SNN_PATTERN = /\A([A-Z]+|[a-z]+)\z/

      # Error message for invalid SNN strings
      ERROR_INVALID_NAME = "Invalid SNN string: %s"

      # @return [String] the canonical style name
      attr_reader :value

      # Create a new style name instance
      #
      # The name must follow SNN format rules: all uppercase or all lowercase
      # alphabetic characters only. No digits, special characters, or mixed case.
      #
      # @param name [String, Symbol] the style name (e.g., "SHOGI", :chess)
      # @raise [ArgumentError] if the name does not match SNN pattern
      #
      # @example Create valid names
      #   Sashite::Snn::Name.new("CHESS")    # First player Chess
      #   Sashite::Snn::Name.new("shogi")    # Second player Shōgi
      #   Sashite::Snn::Name.new(:XIANGQI)   # First player Xiangqi
      #
      # @example Invalid names raise errors
      #   Sashite::Snn::Name.new("Chess")    # Mixed case
      #   Sashite::Snn::Name.new("CHESS960") # Contains digits
      def initialize(name)
        string_value = name.to_s
        self.class.validate_format(string_value)

        @value = string_value.freeze
        freeze
      end

      # Parse an SNN string into a Name object
      #
      # This is an alias for the constructor, provided for consistency
      # with other Sashité specifications.
      #
      # @param string [String] the SNN-formatted style name
      # @return [Name] a new Name instance
      # @raise [ArgumentError] if the string is invalid
      #
      # @example Parse valid names
      #   Sashite::Snn::Name.parse("SHOGI") # => #<Snn::Name value="SHOGI">
      #   Sashite::Snn::Name.parse("chess") # => #<Snn::Name value="chess">
      def self.parse(string)
        new(string)
      end

      # Check whether the given string is a valid SNN name
      #
      # Valid SNN strings must:
      #   - Contain only alphabetic characters (A-Z or a-z)
      #   - Have consistent case (all uppercase OR all lowercase)
      #   - Contain at least one character
      #
      # @param string [String] input string to validate
      # @return [Boolean] true if valid, false otherwise
      #
      # @example Valid names
      #   Sashite::Snn::Name.valid?("CHESS")    # => true
      #   Sashite::Snn::Name.valid?("shogi")    # => true
      #   Sashite::Snn::Name.valid?("XIANGQI")  # => true
      #
      # @example Invalid names
      #   Sashite::Snn::Name.valid?("Chess")    # => false (mixed case)
      #   Sashite::Snn::Name.valid?("CHESS960") # => false (contains digits)
      #   Sashite::Snn::Name.valid?("GO9X9")    # => false (contains digits)
      #   Sashite::Snn::Name.valid?("")         # => false (empty)
      def self.valid?(string)
        string.is_a?(::String) && string.match?(SNN_PATTERN)
      end

      # Returns the string representation of the name
      #
      # @return [String] the canonical style name
      #
      # @example
      #   name = Sashite::Snn::Name.new("SHOGI")
      #   name.to_s # => "SHOGI"
      def to_s
        value
      end

      # Equality based on string value
      #
      # Two names are equal if they have the same string value. Case matters:
      # "CHESS" (first player) is not equal to "chess" (second player).
      #
      # @param other [Object] object to compare with
      # @return [Boolean] true if equal, false otherwise
      #
      # @example
      #   name1 = Sashite::Snn::Name.new("CHESS")
      #   name2 = Sashite::Snn::Name.new("CHESS")
      #   name3 = Sashite::Snn::Name.new("chess")
      #
      #   name1 == name2  # => true
      #   name1 == name3  # => false (different case = different player)
      def ==(other)
        other.is_a?(self.class) && value == other.value
      end

      # Required for correct Set/Hash behavior
      alias eql? ==

      # Hash based on class and value
      #
      # Enables Name objects to be used as hash keys and in sets.
      #
      # @return [Integer] hash code
      #
      # @example Use as hash key
      #   styles = {
      #     Sashite::Snn::Name.new("CHESS") => "Western Chess",
      #     Sashite::Snn::Name.new("SHOGI") => "Japanese Chess"
      #   }
      def hash
        [self.class, value].hash
      end

      # Validate that the string is in proper SNN format
      #
      # @param str [String] string to validate
      # @raise [ArgumentError] if the string does not match SNN pattern
      #
      # @example Valid format
      #   Sashite::Snn::Name.validate_format("CHESS")  # No error
      #   Sashite::Snn::Name.validate_format("shogi")  # No error
      #
      # @example Invalid format
      #   Sashite::Snn::Name.validate_format("Chess")  # Raises ArgumentError
      def self.validate_format(str)
        raise ::ArgumentError, format(ERROR_INVALID_NAME, str.inspect) unless str.match?(SNN_PATTERN)
      end
    end
  end
end
