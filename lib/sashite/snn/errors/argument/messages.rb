# frozen_string_literal: true

module Sashite
  module Snn
    module Errors
      class Argument < ::ArgumentError
        # Error messages for SNN parsing and validation.
        #
        # @example
        #   Messages::EMPTY_INPUT       # => "empty input"
        #   Messages::INPUT_TOO_LONG    # => "input too long"
        #   Messages::INVALID_FORMAT    # => "invalid format"
        module Messages
          # Parsing error messages.

          # Error message for empty input string.
          EMPTY_INPUT = "empty input"

          # Error message for input exceeding maximum length.
          INPUT_TOO_LONG = "input too long"

          # Error message for invalid SNN format.
          INVALID_FORMAT = "invalid format"
        end
      end
    end
  end
end
