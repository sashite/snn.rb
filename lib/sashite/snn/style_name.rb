# frozen_string_literal: true

require_relative "constants"
require_relative "errors"
require_relative "parser"

module Sashite
  module Snn
    # Represents a validated SNN (Style Name Notation) style name.
    #
    # A StyleName encodes a single attribute:
    # - name: the validated SNN string (PascalCase with optional numeric suffix)
    #
    # Instances are immutable (frozen after creation).
    #
    # @example Creating style names
    #   snn = StyleName.new("Chess")
    #   snn = StyleName.new("Chess960")
    #
    # @example String conversion
    #   StyleName.new("Chess").to_s     # => "Chess"
    #   StyleName.new("Chess960").to_s  # => "Chess960"
    #
    # @see https://sashite.dev/specs/snn/1.0.0/
    class StyleName
      # Maximum length of a valid SNN string.
      MAX_STRING_LENGTH = Constants::MAX_STRING_LENGTH

      # @return [String] The validated SNN style name
      attr_reader :name

      # Creates a new StyleName instance.
      #
      # @param name [String] The SNN style name
      # @return [StyleName] A new frozen StyleName instance
      # @raise [Errors::Argument] If the name is invalid
      #
      # @example
      #   StyleName.new("Chess")
      #   StyleName.new("Chess960")
      def initialize(name)
        @name = Parser.parse(name)

        freeze
      end

      # ========================================================================
      # String Conversion
      # ========================================================================

      # Returns the SNN string representation.
      #
      # @return [String] The style name
      #
      # @example
      #   StyleName.new("Chess").to_s  # => "Chess"
      def to_s
        name
      end

      # ========================================================================
      # Equality
      # ========================================================================

      # Checks equality with another StyleName.
      #
      # @param other [Object] The object to compare
      # @return [Boolean] true if equal
      #
      # @example
      #   snn1 = StyleName.new("Chess")
      #   snn2 = StyleName.new("Chess")
      #   snn1 == snn2  # => true
      def ==(other)
        return false unless self.class === other

        name == other.name
      end

      alias eql? ==

      # Returns a hash code for the StyleName.
      #
      # @return [Integer] Hash code
      def hash
        name.hash
      end

      # Returns an inspect string for the StyleName.
      #
      # @return [String] Inspect representation
      #
      # @example
      #   StyleName.new("Chess").inspect  # => "#<Sashite::Snn::StyleName Chess>"
      def inspect
        "#<#{self.class} #{self}>"
      end
    end
  end
end
