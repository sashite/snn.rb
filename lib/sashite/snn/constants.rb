# frozen_string_literal: true

module Sashite
  module Snn
    # Constants for the SNN (Style Name Notation) specification.
    #
    # Defines validation constraints for SNN tokens.
    #
    # @example
    #   Sashite::Snn::Constants::MAX_STRING_LENGTH  # => 32
    #
    # @see https://sashite.dev/specs/snn/1.0.0/
    module Constants
      # Maximum length of a valid SNN string.
      #
      # @return [Integer] 32
      MAX_STRING_LENGTH = 32

      # Empty string constant for internal use.
      #
      # @return [String] ""
      EMPTY_STRING = ""
    end
  end
end
