#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../../../lib/sashite/snn"

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
puts "=== StyleName Tests ==="
puts

# ============================================================================
# CONSTRUCTOR
# ============================================================================

puts "Constructor:"

run_test("creates style name with valid name") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "wrong name" unless snn.name == "Chess"
end

run_test("creates style name with numeric suffix") do
  snn = Sashite::Snn::StyleName.new("Chess960")
  raise "wrong name" unless snn.name == "Chess960"
end

run_test("creates style name with single letter") do
  snn = Sashite::Snn::StyleName.new("A")
  raise "wrong name" unless snn.name == "A"
end

run_test("creates style name with all uppercase") do
  snn = Sashite::Snn::StyleName.new("CHESS")
  raise "wrong name" unless snn.name == "CHESS"
end

run_test("raises on empty string") do
  Sashite::Snn::StyleName.new("")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "empty input"
end

run_test("raises on lowercase start") do
  Sashite::Snn::StyleName.new("chess")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on digit start") do
  Sashite::Snn::StyleName.new("1Chess")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on input too long") do
  Sashite::Snn::StyleName.new("A" * 33)
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "input too long"
end

run_test("raises on invalid characters") do
  Sashite::Snn::StyleName.new("Chess-960")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

# ============================================================================
# IMMUTABILITY
# ============================================================================

puts
puts "Immutability:"

run_test("style name is frozen") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "should be frozen" unless snn.frozen?
end

run_test("name attribute is frozen") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "should be frozen" unless snn.name.frozen?
end

# ============================================================================
# STRING CONVERSION
# ============================================================================

puts
puts "String conversion:"

run_test("to_s returns the name") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "wrong result" unless snn.to_s == "Chess"
end

run_test("to_s returns name with numeric suffix") do
  snn = Sashite::Snn::StyleName.new("Chess960")
  raise "wrong result" unless snn.to_s == "Chess960"
end

run_test("to_s returns single letter name") do
  snn = Sashite::Snn::StyleName.new("A")
  raise "wrong result" unless snn.to_s == "A"
end

run_test("string interpolation works") do
  snn = Sashite::Snn::StyleName.new("Shogi")
  raise "wrong result" unless "Playing #{snn}" == "Playing Shogi"
end

# ============================================================================
# CONSTANTS
# ============================================================================

puts
puts "Constants:"

run_test("MAX_STRING_LENGTH is 32") do
  raise "wrong value" unless Sashite::Snn::StyleName::MAX_STRING_LENGTH == 32
end

# ============================================================================
# EQUALITY
# ============================================================================

puts
puts "Equality:"

run_test("style names with same name are equal") do
  snn1 = Sashite::Snn::StyleName.new("Chess")
  snn2 = Sashite::Snn::StyleName.new("Chess")
  raise "should be equal" unless snn1 == snn2
end

run_test("style names with different names are not equal") do
  snn1 = Sashite::Snn::StyleName.new("Chess")
  snn2 = Sashite::Snn::StyleName.new("Shogi")
  raise "should not be equal" if snn1 == snn2
end

run_test("style name is not equal to string") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "should not be equal" if snn == "Chess"
end

run_test("style name is not equal to nil") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "should not be equal" if snn == nil
end

run_test("eql? is alias for ==") do
  snn1 = Sashite::Snn::StyleName.new("Chess")
  snn2 = Sashite::Snn::StyleName.new("Chess")
  raise "should be eql" unless snn1.eql?(snn2)
end

run_test("hash is equal for equal style names") do
  snn1 = Sashite::Snn::StyleName.new("Chess")
  snn2 = Sashite::Snn::StyleName.new("Chess")
  raise "hashes should be equal" unless snn1.hash == snn2.hash
end

run_test("hash is different for different style names") do
  snn1 = Sashite::Snn::StyleName.new("Chess")
  snn2 = Sashite::Snn::StyleName.new("Shogi")
  raise "hashes should be different" if snn1.hash == snn2.hash
end

run_test("can be used as hash key") do
  hash = {}
  snn1 = Sashite::Snn::StyleName.new("Chess")
  snn2 = Sashite::Snn::StyleName.new("Chess")
  hash[snn1] = "Western Chess"
  raise "should find value" unless hash[snn2] == "Western Chess"
end

# ============================================================================
# INSPECT
# ============================================================================

puts
puts "Inspect:"

run_test("inspect returns readable representation") do
  snn = Sashite::Snn::StyleName.new("Chess")
  raise "wrong format" unless snn.inspect == "#<Sashite::Snn::StyleName Chess>"
end

run_test("inspect with numeric suffix") do
  snn = Sashite::Snn::StyleName.new("Chess960")
  raise "wrong format" unless snn.inspect == "#<Sashite::Snn::StyleName Chess960>"
end

run_test("inspect with single letter") do
  snn = Sashite::Snn::StyleName.new("A")
  raise "wrong format" unless snn.inspect == "#<Sashite::Snn::StyleName A>"
end

# ============================================================================
# MODULE METHODS (Sashite::Snn)
# ============================================================================

puts
puts "Module methods (Sashite::Snn):"

run_test("Snn.parse returns StyleName") do
  snn = Sashite::Snn.parse("Chess")
  raise "wrong class" unless snn.is_a?(Sashite::Snn::StyleName)
  raise "wrong name" unless snn.name == "Chess"
end

run_test("Snn.parse raises on invalid") do
  Sashite::Snn.parse("chess")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("Snn.valid? returns true for valid") do
  raise "should be valid" unless Sashite::Snn.valid?("Chess")
  raise "should be valid" unless Sashite::Snn.valid?("Chess960")
end

run_test("Snn.valid? returns false for invalid") do
  raise "should be invalid" if Sashite::Snn.valid?("chess")
  raise "should be invalid" if Sashite::Snn.valid?("")
end

# ============================================================================
# INTEGRATION TESTS
# ============================================================================

puts
puts "Integration tests:"

run_test("parse then to_string") do
  snn = Sashite::Snn.parse("Chess960")
  raise "wrong result" unless snn.to_s == "Chess960"
end

run_test("round-trip parse and to_string") do
  names = %w[Chess Shogi Xiangqi Makruk Go Chess960 A Z XY123]
  names.each do |name|
    snn = Sashite::Snn.parse(name)
    raise "wrong result for #{name}" unless snn.to_s == name
  end
end

run_test("multiple style names can be collected") do
  names = %w[Chess Shogi Xiangqi]
  styles = names.map { |name| Sashite::Snn.parse(name) }
  raise "wrong result" unless styles.map(&:name) == names
end

run_test("style names can be sorted by name") do
  styles = %w[Xiangqi Chess Shogi].map { |name| Sashite::Snn.parse(name) }
  sorted = styles.sort_by(&:name)
  raise "wrong order" unless sorted.map(&:name) == %w[Chess Shogi Xiangqi]
end

puts
puts "All StyleName tests passed!"
puts
