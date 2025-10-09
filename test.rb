# frozen_string_literal: true

require "simplecov"

SimpleCov.command_name "Unit Tests"
SimpleCov.start

# Tests for Sashite::Snn (Style Name Notation)
#
# This test suite verifies the validation, parsing, and comparison logic
# of the Sashite::Snn::Name class in accordance with the SNN specification v1.0.0.
#
# SNN Format Requirements:
#   - All uppercase OR all lowercase alphabetic characters only
#   - No digits, no special characters, no mixed case
#   - Uppercase = first player, lowercase = second player

require_relative "lib/sashite-snn"

def run_test(name)
  print "  #{name}... "
  yield
  puts "✓ Success"
rescue StandardError => e
  warn "✗ Failure: #{e.message}"
  warn "    #{e.backtrace.first}"
  exit(1)
end

puts
puts "Tests for Sashite::Snn (Style Name Notation) v1.0.0"
puts

run_test("Valid uppercase SNN strings are accepted") do
  valid_uppercase = [
    "CHESS", "SHOGI", "XIANGQI", "MAKRUK",
    "CHATURANGA", "SHATRANJ", "SITTUYIN", "JANGGI",
    "CAPABLANCA", "COURIER", "RAUMSCHACH", "OMEGA",
    "A", "Z", "ABC", "VERYLONGSTYLENAME"
  ]

  valid_uppercase.each do |name|
    raise "#{name.inspect} should be valid" unless Sashite::Snn.valid?(name)
    parsed = Sashite::Snn.parse(name)
    raise "Parsed value mismatch for #{name.inspect}" unless parsed.to_s == name
    raise "Parsed value should be frozen for #{name.inspect}" unless parsed.frozen?
    raise "Internal value should be frozen for #{name.inspect}" unless parsed.value.frozen?
  end
end

run_test("Valid lowercase SNN strings are accepted") do
  valid_lowercase = [
    "chess", "shogi", "xiangqi", "makruk",
    "chaturanga", "shatranj", "sittuyin", "janggi",
    "capablanca", "courier", "raumschach", "omega",
    "a", "z", "abc", "verylongstylename"
  ]

  valid_lowercase.each do |name|
    raise "#{name.inspect} should be valid" unless Sashite::Snn.valid?(name)
    parsed = Sashite::Snn.parse(name)
    raise "Parsed value mismatch for #{name.inspect}" unless parsed.to_s == name
    raise "Parsed value should be frozen for #{name.inspect}" unless parsed.frozen?
    raise "Internal value should be frozen for #{name.inspect}" unless parsed.value.frozen?
  end
end

run_test("Invalid SNN strings with mixed case are rejected") do
  invalid_mixed_case = [
    "Chess", "Shogi", "Xiangqi", "Makruk",
    "CheSS", "SHOgi", "XIANGqi", "MaKrUk",
    "Chaturanga", "Shatranj", "Sittuyin",
    "Ab", "aB", "AbC", "aBc"
  ]

  invalid_mixed_case.each do |name|
    valid = Sashite::Snn.valid?(name)
    raise "#{name.inspect} should be invalid (mixed case)" if valid

    begin
      Sashite::Snn.parse(name)
      raise "Parsing should fail for #{name.inspect} (mixed case)"
    rescue ArgumentError => e
      raise "Wrong error message for #{name.inspect}" unless e.message.include?("Invalid SNN string")
    end
  end
end

run_test("Invalid SNN strings with digits are rejected") do
  invalid_with_digits = [
    "CHESS960", "Chess960", "chess960",
    "GO9X9", "Go9x9", "go9x9",
    "MINISHOGI5X5", "Minishogi", "minishogi5x5",
    "CAPABLANCA10X8", "Capablanca10x8", "capablanca10x8",
    "1CHESS", "1chess", "C1HESS", "c1hess",
    "123", "A1", "a1", "ABC123"
  ]

  invalid_with_digits.each do |name|
    valid = Sashite::Snn.valid?(name)
    raise "#{name.inspect} should be invalid (contains digits)" if valid

    begin
      Sashite::Snn.parse(name)
      raise "Parsing should fail for #{name.inspect} (contains digits)"
    rescue ArgumentError => e
      raise "Wrong error message for #{name.inspect}" unless e.message.include?("Invalid SNN string")
    end
  end
end

run_test("Invalid SNN strings with special characters are rejected") do
  invalid_special_chars = [
    "MINI_SHOGI", "mini_shogi", "Chess-960",
    "SHŌGI", "象棋", "♔Chess", "Chess♔",
    " CHESS", "CHESS ", " chess ", "CH ESS",
    "A_B", "a-b", "A.B", "a:b",
    "A B", "CHESS\n", "\tCHESS"
  ]

  invalid_special_chars.each do |name|
    valid = Sashite::Snn.valid?(name)
    raise "#{name.inspect} should be invalid (special characters/whitespace)" if valid

    begin
      Sashite::Snn.parse(name)
      raise "Parsing should fail for #{name.inspect} (special characters/whitespace)"
    rescue ArgumentError => e
      raise "Wrong error message for #{name.inspect}" unless e.message.include?("Invalid SNN string")
    end
  end
end

run_test("Empty and non-string inputs are rejected") do
  invalid_inputs = [
    "", nil, 123, [], {}
  ]

  invalid_inputs.each do |input|
    valid = Sashite::Snn.valid?(input)
    raise "#{input.inspect} should be invalid" if valid

    begin
      Sashite::Snn.parse(input)
      raise "Parsing should fail for #{input.inspect}"
    rescue ArgumentError
      # expected
    end
  end
end

run_test("Equality distinguishes between uppercase and lowercase") do
  upper_chess = Sashite::Snn.parse("CHESS")
  upper_chess2 = Sashite::Snn.parse("CHESS")
  lower_chess = Sashite::Snn.parse("chess")

  raise "Same uppercase names should be equal" unless upper_chess == upper_chess2
  raise "Uppercase and lowercase should NOT be equal (different players)" if upper_chess == lower_chess

  upper_shogi = Sashite::Snn.parse("SHOGI")
  raise "Different names should NOT be equal" if upper_chess == upper_shogi
end

run_test("Hash consistency for equality") do
  name1 = Sashite::Snn.parse("SHOGI")
  name2 = Sashite::Snn.parse("SHOGI")
  name3 = Sashite::Snn.parse("shogi")
  name4 = Sashite::Snn.parse("CHESS")

  raise "Equal names should have same hash" unless name1.hash == name2.hash
  raise "Different player assignments should have different hashes" if name1.hash == name3.hash
  raise "Different styles should have different hashes" if name1.hash == name4.hash
end

run_test("Set and hash key behavior") do
  name1 = Sashite::Snn.parse("SHOGI")
  name2 = Sashite::Snn.parse("SHOGI")
  name3 = Sashite::Snn.parse("shogi")
  name4 = Sashite::Snn.parse("CHESS")

  set = [name1, name2, name3, name4].uniq
  raise "Set should contain 3 unique names (SHOGI, shogi, CHESS)" unless set.size == 3

  hash = {}
  hash[name1] = "First player Shogi"
  hash[name2] = "Updated first player Shogi"
  hash[name3] = "Second player Shogi"
  hash[name4] = "First player Chess"

  raise "Hash should contain 3 keys" unless hash.size == 3
  raise "Hash value mismatch" unless hash[name1] == "Updated first player Shogi"
  raise "Hash value mismatch" unless hash[name3] == "Second player Shogi"
end

run_test("String and symbol inputs are supported") do
  name1 = Sashite::Snn.name("XIANGQI")
  name2 = Sashite::Snn.name(:XIANGQI)

  raise "String and symbol inputs should be equal" unless name1 == name2
  raise "Should stringify correctly" unless name1.to_s == "XIANGQI"
  raise "Value should match" unless name1.value == "XIANGQI"
end

run_test("Frozen objects are immutable") do
  name = Sashite::Snn.parse("MAKRUK")

  raise "Name should be frozen" unless name.frozen?
  raise "Internal value should be frozen" unless name.value.frozen?

  begin
    name.instance_variable_set(:@value, "MODIFIED")
    raise "Should not be able to modify frozen object"
  rescue FrozenError, RuntimeError
    # Expected behavior
  end
end

run_test("Parse and name methods produce equivalent results") do
  styles = ["CHESS", "shogi", "XIANGQI", "makruk"]

  styles.each do |style|
    parsed = Sashite::Snn.parse(style)
    created = Sashite::Snn.name(style)
    constructed = Sashite::Snn::Name.new(style)

    raise "All construction methods should produce equal objects for #{style.inspect}" unless parsed == created && created == constructed
    raise "All should have same string value for #{style.inspect}" unless parsed.to_s == created.to_s && created.to_s == constructed.to_s
  end
end

run_test("Single character names are valid") do
  # Uppercase single letters
  ("A".."Z").each do |letter|
    raise "#{letter.inspect} should be valid" unless Sashite::Snn.valid?(letter)
    parsed = Sashite::Snn.parse(letter)
    raise "Parsed value should match for #{letter.inspect}" unless parsed.to_s == letter
  end

  # Lowercase single letters
  ("a".."z").each do |letter|
    raise "#{letter.inspect} should be valid" unless Sashite::Snn.valid?(letter)
    parsed = Sashite::Snn.parse(letter)
    raise "Parsed value should match for #{letter.inspect}" unless parsed.to_s == letter
  end
end

run_test("Case encoding represents player assignment") do
  # Uppercase = first player
  first_player_styles = ["CHESS", "SHOGI", "XIANGQI", "MAKRUK"]
  first_player_styles.each do |style|
    name = Sashite::Snn.parse(style)
    raise "Uppercase should be all uppercase for #{style.inspect}" unless name.value == name.value.upcase
    raise "Uppercase should not equal lowercase for #{style.inspect}" unless name.value != name.value.downcase
  end

  # Lowercase = second player
  second_player_styles = ["chess", "shogi", "xiangqi", "makruk"]
  second_player_styles.each do |style|
    name = Sashite::Snn.parse(style)
    raise "Lowercase should be all lowercase for #{style.inspect}" unless name.value == name.value.downcase
    raise "Lowercase should not equal uppercase for #{style.inspect}" unless name.value != name.value.upcase
  end
end

puts
puts "All SNN tests passed!"
puts
