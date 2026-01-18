#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../../../lib/sashite/snn/errors"

# Helper function to run a test and report errors
def run_test(name)
  print "  #{name}... "
  yield
  puts "✔"
rescue StandardError => e
  warn "✗ Failure: #{e.message}"
  warn "    #{e.backtrace.first}"
  exit(1)
end

puts
puts "=== Errors Tests ==="
puts

# ============================================================================
# PARSING ERROR MESSAGES
# ============================================================================

puts "Parsing error messages:"

run_test("EMPTY_INPUT is defined") do
  raise "wrong value" unless Sashite::Snn::Errors::Argument::Messages::EMPTY_INPUT == "empty input"
end

run_test("INPUT_TOO_LONG is defined") do
  raise "wrong value" unless Sashite::Snn::Errors::Argument::Messages::INPUT_TOO_LONG == "input too long"
end

run_test("INVALID_FORMAT is defined") do
  raise "wrong value" unless Sashite::Snn::Errors::Argument::Messages::INVALID_FORMAT == "invalid format"
end

# ============================================================================
# ERROR CLASS
# ============================================================================

puts
puts "Error class:"

run_test("Argument inherits from ArgumentError") do
  raise "wrong inheritance" unless Sashite::Snn::Errors::Argument < ArgumentError
end

run_test("Argument can be raised with message") do
  raise Sashite::Snn::Errors::Argument, Sashite::Snn::Errors::Argument::Messages::EMPTY_INPUT
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "empty input"
end

run_test("Argument can be rescued as ArgumentError") do
  raise Sashite::Snn::Errors::Argument, "test"
rescue ArgumentError => e
  raise "should be rescuable as ArgumentError" unless e.message == "test"
end

# ============================================================================
# ERROR MESSAGES ARE FROZEN
# ============================================================================

puts
puts "Immutability:"

run_test("EMPTY_INPUT is frozen") do
  raise "should be frozen" unless Sashite::Snn::Errors::Argument::Messages::EMPTY_INPUT.frozen?
end

run_test("INPUT_TOO_LONG is frozen") do
  raise "should be frozen" unless Sashite::Snn::Errors::Argument::Messages::INPUT_TOO_LONG.frozen?
end

run_test("INVALID_FORMAT is frozen") do
  raise "should be frozen" unless Sashite::Snn::Errors::Argument::Messages::INVALID_FORMAT.frozen?
end

puts
puts "All Errors tests passed!"
puts
