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
puts "=== Parser Tests ==="
puts

# ============================================================================
# VALID INPUTS - STANDARD NAMES
# ============================================================================

puts "Valid inputs - standard names:"

run_test("parses 'Chess'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Chess") == "Chess"
end

run_test("parses 'Shogi'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Shogi") == "Shogi"
end

run_test("parses 'Xiangqi'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Xiangqi") == "Xiangqi"
end

run_test("parses 'Makruk'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Makruk") == "Makruk"
end

run_test("parses 'Go'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Go") == "Go"
end

# ============================================================================
# VALID INPUTS - SINGLE LETTER
# ============================================================================

puts
puts "Valid inputs - single letter:"

run_test("parses single uppercase letter 'A'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("A") == "A"
end

run_test("parses single uppercase letter 'Z'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Z") == "Z"
end

run_test("parses all single uppercase letters A-Z") do
  ("A".."Z").each do |letter|
    raise "wrong result for #{letter}" unless Sashite::Snn::Parser.parse(letter) == letter
  end
end

# ============================================================================
# VALID INPUTS - WITH NUMERIC SUFFIX
# ============================================================================

puts
puts "Valid inputs - with numeric suffix:"

run_test("parses 'Chess960'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Chess960") == "Chess960"
end

run_test("parses 'Shogi2'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Shogi2") == "Shogi2"
end

run_test("parses 'G5'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("G5") == "G5"
end

run_test("parses 'XY123'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("XY123") == "XY123"
end

run_test("parses 'A1'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("A1") == "A1"
end

run_test("parses name with leading zero in suffix") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("Chess01") == "Chess01"
end

# ============================================================================
# VALID INPUTS - ALL UPPERCASE
# ============================================================================

puts
puts "Valid inputs - all uppercase:"

run_test("parses 'CHESS'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("CHESS") == "CHESS"
end

run_test("parses 'ABC'") do
  raise "wrong result" unless Sashite::Snn::Parser.parse("ABC") == "ABC"
end

# ============================================================================
# VALID INPUTS - MAXIMUM LENGTH
# ============================================================================

puts
puts "Valid inputs - maximum length:"

run_test("parses string at exactly max length (32 chars)") do
  input = "Abcdefghijklmnopqrstuvwxyz123456"
  raise "wrong length" unless input.bytesize == 32
  raise "wrong result" unless Sashite::Snn::Parser.parse(input) == input
end

# ============================================================================
# valid?
# ============================================================================

puts
puts "valid? method:"

run_test("returns true for valid standard names") do
  raise "should be valid" unless Sashite::Snn::Parser.valid?("Chess")
  raise "should be valid" unless Sashite::Snn::Parser.valid?("Shogi")
  raise "should be valid" unless Sashite::Snn::Parser.valid?("Xiangqi")
end

run_test("returns true for single uppercase letters") do
  raise "should be valid" unless Sashite::Snn::Parser.valid?("A")
  raise "should be valid" unless Sashite::Snn::Parser.valid?("Z")
end

run_test("returns true for names with numeric suffix") do
  raise "should be valid" unless Sashite::Snn::Parser.valid?("Chess960")
  raise "should be valid" unless Sashite::Snn::Parser.valid?("G5")
end

run_test("returns false for empty string") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("")
end

run_test("returns false for lowercase start") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("chess")
end

run_test("returns false for digit start") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("1Chess")
end

run_test("returns false for nil") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?(nil)
end

# ============================================================================
# ERROR CASES - EMPTY INPUT
# ============================================================================

puts
puts "Error cases - empty input:"

run_test("raises on empty string") do
  Sashite::Snn::Parser.parse("")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "empty input"
end

# ============================================================================
# ERROR CASES - INPUT TOO LONG
# ============================================================================

puts
puts "Error cases - input too long:"

run_test("raises on 33 characters") do
  input = "Abcdefghijklmnopqrstuvwxyz1234567"
  raise "wrong length" unless input.bytesize == 33
  Sashite::Snn::Parser.parse(input)
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "input too long"
end

run_test("raises on very long input") do
  Sashite::Snn::Parser.parse("Chess" * 100)
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "input too long"
end

# ============================================================================
# ERROR CASES - INVALID FORMAT
# ============================================================================

puts
puts "Error cases - invalid format:"

run_test("raises on lowercase start") do
  Sashite::Snn::Parser.parse("chess")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on digit start") do
  Sashite::Snn::Parser.parse("1Chess")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on letters after digits") do
  Sashite::Snn::Parser.parse("Chess960A")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on hyphen") do
  Sashite::Snn::Parser.parse("Chess-960")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on underscore") do
  Sashite::Snn::Parser.parse("Chess_Variant")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on space") do
  Sashite::Snn::Parser.parse("Chess 960")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

run_test("raises on special characters") do
  Sashite::Snn::Parser.parse("Chess!")
  raise "should have raised"
rescue Sashite::Snn::Errors::Argument => e
  raise "wrong message" unless e.message == "invalid format"
end

# ============================================================================
# SECURITY - NULL BYTE INJECTION
# ============================================================================

puts
puts "Security - null byte injection:"

run_test("rejects null byte alone") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\x00")
end

run_test("rejects name with embedded null byte") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\x00960")
end

run_test("rejects name followed by null byte") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\x00")
end

run_test("rejects null byte followed by name") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\x00Chess")
end

# ============================================================================
# SECURITY - CONTROL CHARACTERS
# ============================================================================

puts
puts "Security - control characters:"

run_test("rejects newline") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\n")
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\nChess")
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\nShogi")
end

run_test("rejects carriage return") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\r")
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\rChess")
end

run_test("rejects tab") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\t")
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\tChess")
end

run_test("rejects other control characters") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\x01")  # SOH
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\x1B")  # ESC
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\x7F")  # DEL
end

# ============================================================================
# SECURITY - UNICODE LOOKALIKES
# ============================================================================

puts
puts "Security - Unicode lookalikes:"

run_test("rejects Cyrillic lookalikes") do
  # Cyrillic 'С' (U+0421) looks like Latin 'C'
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xD0\xA1hess")
end

run_test("rejects Greek lookalikes") do
  # Greek 'Α' (U+0391) looks like Latin 'A'
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xCE\x91")
end

run_test("rejects full-width characters") do
  # Full-width 'C' (U+FF23)
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xEF\xBC\xA3hess")
end

# ============================================================================
# SECURITY - COMBINING CHARACTERS
# ============================================================================

puts
puts "Security - combining characters:"

run_test("rejects combining acute accent") do
  # 'C' + combining acute accent (U+0301)
  raise "should be invalid" if Sashite::Snn::Parser.valid?("C\xCC\x81hess")
end

run_test("rejects combining diaeresis") do
  # 'C' + combining diaeresis (U+0308)
  raise "should be invalid" if Sashite::Snn::Parser.valid?("C\xCC\x88")
end

# ============================================================================
# SECURITY - ZERO-WIDTH CHARACTERS
# ============================================================================

puts
puts "Security - zero-width characters:"

run_test("rejects zero-width space") do
  # Zero-width space (U+200B)
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xE2\x80\x8B")
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Chess\xE2\x80\x8B")
end

run_test("rejects zero-width non-joiner") do
  # Zero-width non-joiner (U+200C)
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xE2\x80\x8C")
end

run_test("rejects BOM") do
  # Byte order mark (U+FEFF)
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xEF\xBB\xBF")
  raise "should be invalid" if Sashite::Snn::Parser.valid?("\xEF\xBB\xBFChess")
end

# ============================================================================
# SECURITY - NON-ASCII LETTERS
# ============================================================================

puts
puts "Security - non-ASCII letters:"

run_test("rejects accented characters") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Échecs")  # French for Chess
  raise "should be invalid" if Sashite::Snn::Parser.valid?("Schäch")
end

run_test("rejects non-Latin scripts") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?("将棋")  # Japanese for Shogi
  raise "should be invalid" if Sashite::Snn::Parser.valid?("象棋")  # Chinese for Xiangqi
end

# ============================================================================
# SECURITY - NON-STRING INPUT
# ============================================================================

puts
puts "Security - non-string input:"

run_test("rejects nil") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?(nil)
end

run_test("rejects integer") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?(123)
end

run_test("rejects array") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?(%w[C h e s s])
end

run_test("rejects symbol") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?(:Chess)
end

run_test("rejects hash") do
  raise "should be invalid" if Sashite::Snn::Parser.valid?({ name: "Chess" })
end

# ============================================================================
# ROUND-TRIP TESTS
# ============================================================================

puts
puts "Round-trip tests:"

run_test("valid names round-trip correctly") do
  names = %w[Chess Shogi Xiangqi Makruk Go Chess960 A Z XY123]
  names.each do |name|
    raise "wrong result for #{name}" unless Sashite::Snn::Parser.parse(name) == name
  end
end

puts
puts "All Parser tests passed!"
puts
