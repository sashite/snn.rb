# frozen_string_literal: true

require_relative "constants"
require_relative "errors"

module Sashite
  module Snn
    # Secure parser for SNN (Style Name Notation) strings.
    #
    # Designed for untrusted input: validates bounds first, parses character
    # by character, and enforces strict constraints at every step.
    #
    # @example
    #   Parser.parse("Chess")     # => "Chess"
    #   Parser.parse("Chess960")  # => "Chess960"
    #   Parser.parse("chess")     # => raises Errors::Argument
    #
    # @see https://sashite.dev/specs/snn/1.0.0/
    module Parser
      # Byte ranges for validation
      UPPERCASE_MIN = 0x41  # A
      UPPERCASE_MAX = 0x5A  # Z
      LOWERCASE_MIN = 0x61  # a
      LOWERCASE_MAX = 0x7A  # z
      DIGIT_MIN     = 0x30  # 0
      DIGIT_MAX     = 0x39  # 9

      class << self
        # Parses an SNN string, validating its format.
        #
        # @param input [String] The SNN string to parse
        # @return [String] The validated SNN string
        # @raise [Errors::Argument] If the input is invalid
        #
        # @example
        #   Parser.parse("Chess")     # => "Chess"
        #   Parser.parse("Chess960")  # => "Chess960"
        #   Parser.parse("")          # => raises Errors::Argument
        def parse(input)
          validate_input_type!(input)
          validate_not_empty!(input)
          validate_length!(input)
          validate_format!(input)

          input
        end

        # Reports whether the input is a valid SNN string.
        #
        # @param input [Object] The input to validate
        # @return [Boolean] true if valid, false otherwise
        #
        # @example
        #   Parser.valid?("Chess")  # => true
        #   Parser.valid?("chess")  # => false
        #   Parser.valid?(nil)      # => false
        def valid?(input)
          parse(input)
          true
        rescue Errors::Argument
          false
        end

        private

        # Validates input is a String.
        def validate_input_type!(input)
          return if ::String === input

          raise Errors::Argument, Errors::Argument::Messages::INVALID_FORMAT
        end

        # Validates input is not empty.
        def validate_not_empty!(input)
          return unless input.empty?

          raise Errors::Argument, Errors::Argument::Messages::EMPTY_INPUT
        end

        # Validates input does not exceed maximum length.
        def validate_length!(input)
          return if input.bytesize <= Constants::MAX_STRING_LENGTH

          raise Errors::Argument, Errors::Argument::Messages::INPUT_TOO_LONG
        end

        # Validates the SNN format using byte-level parsing.
        #
        # Format: uppercase letter, then letters, then optional digits at end.
        def validate_format!(input)
          bytes = input.bytes
          index = 0

          # State 1: First byte must be uppercase letter
          raise_invalid_format! unless uppercase?(bytes[index])
          index += 1

          # State 2: Parse letters (transition to digits allowed)
          while index < bytes.length
            byte = bytes[index]

            if letter?(byte)
              index += 1
            elsif digit?(byte)
              # Transition to digit state
              index += 1
              break
            else
              raise_invalid_format!
            end
          end

          # State 3: Parse remaining digits only (no return to letters)
          while index < bytes.length
            byte = bytes[index]
            raise_invalid_format! unless digit?(byte)
            index += 1
          end
        end

        # Character class predicates

        def uppercase?(byte)
          byte >= UPPERCASE_MIN && byte <= UPPERCASE_MAX
        end

        def lowercase?(byte)
          byte >= LOWERCASE_MIN && byte <= LOWERCASE_MAX
        end

        def letter?(byte)
          uppercase?(byte) || lowercase?(byte)
        end

        def digit?(byte)
          byte >= DIGIT_MIN && byte <= DIGIT_MAX
        end

        def raise_invalid_format!
          raise Errors::Argument, Errors::Argument::Messages::INVALID_FORMAT
        end
      end
    end
  end
end
