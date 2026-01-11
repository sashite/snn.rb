# Snn.rb

[![Version](https://img.shields.io/github/v/tag/sashite/snn.rb?label=Version&logo=github)](https://github.com/sashite/snn.rb/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/snn.rb/main)
![Ruby](https://github.com/sashite/snn.rb/actions/workflows/main.yml/badge.svg?branch=main)
[![License](https://img.shields.io/github/license/sashite/snn.rb?label=License&logo=github)](https://github.com/sashite/snn.rb/raw/main/LICENSE)

> **SNN** (Style Name Notation) implementation for the Ruby language.

## What is SNN?

SNN (Style Name Notation) is a **foundational**, human-readable naming system for identifying game styles in abstract strategy board games. SNN serves as a primitive building block using descriptive alphabetic names with case encoding to represent style identity and player assignment.

Each SNN name is a case-consistent alphabetic identifier where:
- **Uppercase names** (e.g., `CHESS`, `SHOGI`) represent the **first player's** style
- **Lowercase names** (e.g., `chess`, `shogi`) represent the **second player's** style

This gem implements the [SNN Specification v1.0.0](https://sashite.dev/specs/snn/1.0.0/) as a foundational primitive with no dependencies.

## Installation

```ruby
# In your Gemfile
gem "sashite-snn"
```

Or install manually:

```sh
gem install sashite-snn
```

## Quick Start

```ruby
require "sashite/snn"

# Parse SNN strings into style name objects
name = Sashite::Snn.parse("SHOGI")             # => #<Snn::Name value="SHOGI">
name.to_s                                      # => "SHOGI"
name.value                                     # => "SHOGI"

# Create from string or symbol
name = Sashite::Snn.name("CHESS")              # => #<Snn::Name value="CHESS">
name = Sashite::Snn::Name.new(:xiangqi)        # => #<Snn::Name value="xiangqi">

# Validate SNN strings
Sashite::Snn.valid?("MAKRUK")                  # => true
Sashite::Snn.valid?("shogi")                   # => true
Sashite::Snn.valid?("Chess")                   # => false (mixed case)
Sashite::Snn.valid?("Chess960")                # => false (contains digits)
```

## SNN Format

An SNN string consists of alphabetic characters only, all in the same case:

```
<alphabetic-name>
```

**Examples:**
- `CHESS` — Chess style for first player
- `chess` — Chess style for second player
- `SHOGI` — Shōgi style for first player
- `shogi` — Shōgi style for second player

## Format Specification

### Structure

```
<alphabetic-name>
```

Where the name directly represents the style identity and player assignment through case.

### Grammar (BNF)

```bnf
<snn> ::= <uppercase-name> | <lowercase-name>

<uppercase-name> ::= <uppercase-letter>+
<lowercase-name> ::= <lowercase-letter>+

<uppercase-letter> ::= "A" | "B" | "C" | ... | "Z"
<lowercase-letter> ::= "a" | "b" | "c" | ... | "z"
```

### Regular Expression

```ruby
/\A([A-Z]+|[a-z]+)\z/
```

### Constraints

1. **Case consistency**: All letters must be either uppercase OR lowercase
2. **Alphabetic only**: Only ASCII letters allowed (no digits, no special characters)
3. **Direct assignment**: Names represent styles through explicit association

## API Reference

### Module Methods

#### `Sashite::Snn.valid?(string)`

Returns `true` if the string is valid SNN notation.

- **Parameter**: `string` (String) - String to validate
- **Returns**: `Boolean` - `true` if valid, `false` otherwise

```ruby
Sashite::Snn.valid?("CHESS")      # => true
Sashite::Snn.valid?("shogi")      # => true
Sashite::Snn.valid?("Chess")      # => false (mixed case)
Sashite::Snn.valid?("CHESS960")   # => false (contains digits)
Sashite::Snn.valid?("3DChess")    # => false (starts with digit)
```

#### `Sashite::Snn.parse(string)`

Parses an SNN string into a `Name` object.

- **Parameter**: `string` (String) - SNN notation string
- **Returns**: `Name` - Immutable name object
- **Raises**: `ArgumentError` if the string is invalid

```ruby
name = Sashite::Snn.parse("SHOGI")    # => #<Snn::Name value="SHOGI">
name = Sashite::Snn.parse("chess")    # => #<Snn::Name value="chess">
```

#### `Sashite::Snn.name(value)`

Creates a new `Name` instance directly.

- **Parameter**: `value` (String, Symbol) - Style name to construct
- **Returns**: `Name` - New name instance
- **Raises**: `ArgumentError` if name format is invalid

```ruby
Sashite::Snn.name("XIANGQI")  # => #<Snn::Name value="XIANGQI">
Sashite::Snn.name(:makruk)    # => #<Snn::Name value="makruk">
```

### Name Object

The `Name` object is immutable and provides read-only access to the style name:

```ruby
name = Sashite::Snn.parse("SHOGI")

name.value    # => "SHOGI"
name.to_s     # => "SHOGI"
name.frozen?  # => true
```

**Equality and hashing:**
```ruby
name1 = Sashite::Snn.parse("CHESS")
name2 = Sashite::Snn.parse("CHESS")
name3 = Sashite::Snn.parse("chess")

name1 == name2 # => true
name1.hash == name2.hash # => true
name1 == name3 # => false (different case = different player)
```

## Examples

### Traditional Chess Family

```ruby
# First player styles (uppercase)
chess = Sashite::Snn.parse("CHESS")      # Western Chess
shogi = Sashite::Snn.parse("SHOGI")      # Japanese Chess
xiangqi = Sashite::Snn.parse("XIANGQI")  # Chinese Chess
makruk = Sashite::Snn.parse("MAKRUK")    # Thai Chess

# Second player styles (lowercase)
chess_p2 = Sashite::Snn.parse("chess")
shogi_p2 = Sashite::Snn.parse("shogi")
```

### Historical Games

```ruby
chaturanga = Sashite::Snn.parse("CHATURANGA")  # Ancient Indian Chess
shatranj = Sashite::Snn.parse("SHATRANJ")      # Medieval Islamic Chess
```

### Modern Variants

```ruby
raumschach = Sashite::Snn.parse("RAUMSCHACH")  # 3D Chess
omega = Sashite::Snn.parse("OMEGA")            # Omega Chess
```

### Case Consistency

```ruby
# Valid - all uppercase
Sashite::Snn.valid?("CHESS")      # => true
Sashite::Snn.valid?("XIANGQI")    # => true

# Valid - all lowercase
Sashite::Snn.valid?("shogi")      # => true
Sashite::Snn.valid?("makruk")     # => true

# Invalid - mixed case
Sashite::Snn.valid?("Chess")      # => false
Sashite::Snn.valid?("Shogi")      # => false
Sashite::Snn.valid?("XiangQi")    # => false

# Invalid - contains non-alphabetic characters
Sashite::Snn.valid?("CHESS960")   # => false
Sashite::Snn.valid?("GO9X9")      # => false
Sashite::Snn.valid?("MINI_SHOGI") # => false
```

### Working with Names

```ruby
# Create and compare
name1 = Sashite::Snn.parse("SHOGI")
name2 = Sashite::Snn.parse("SHOGI")
name1 == name2 # => true

# String and symbol inputs
name1 = Sashite::Snn.name("XIANGQI")
name2 = Sashite::Snn.name(:XIANGQI)
name1 == name2 # => true

# Immutability
name = Sashite::Snn.parse("CHESS")
name.frozen?        # => true
name.value.frozen?  # => true
```

### Collections

```ruby
# Create a set of styles
styles = %w[CHESS SHOGI XIANGQI MAKRUK].map { |n| Sashite::Snn.parse(n) }

# Filter by prefix
styles.select { |s| s.value.start_with?("X") }.map(&:to_s)
# => ["XIANGQI"]

# Use in hash
style_map = {
  Sashite::Snn.parse("CHESS") => "Western Chess",
  Sashite::Snn.parse("SHOGI") => "Japanese Chess"
}
```

## Relationship with SIN

**SNN and SIN are independent primitives** that serve complementary roles:

- **SNN**: Human-readable, descriptive names (`CHESS`, `SHOGI`)
- **SIN**: Compact, single-character identification (`C`, `S`)

### Optional Correspondence

While both specifications can be used independently, they may be related through:

- **Mapping tables**: External context defining SNN ↔ SIN relationships
- **Case consistency**: When mapped, case must be preserved (`CHESS` ↔ `C`, `chess` ↔ `c`)

```ruby
# Example mapping (defined externally, not part of SNN)
SNN_TO_SIN = {
  "CHESS" => "C",
  "chess" => "c",
  "SHOGI" => "S",
  "shogi" => "s"
}

# Multiple SNN names may map to the same SIN
SNN_TO_SIN["CAPABLANCA"] = "C"  # Also maps to "C"
SNN_TO_SIN["COURIER"] = "C"     # Also maps to "C"
```

### Important Notes

1. **No dependency**: SNN does not depend on SIN, nor SIN on SNN
2. **Bidirectional mapping requires context**: Converting between SNN and SIN requires external mapping information
3. **Independent usage**: Systems may use SNN alone, SIN alone, or both with defined mappings
4. **Multiple mappings**: One SNN name may correspond to multiple SIN characters in different contexts, and vice versa

## Error Handling

```ruby
begin
  name = Sashite::Snn.parse("Chess960")
rescue ArgumentError => e
  warn "Invalid SNN: #{e.message}"
  # => "Invalid SNN string: \"Chess960\""
end
```

### Common Errors

```ruby
# Mixed case
Sashite::Snn.parse("Chess")
# => ArgumentError: Invalid SNN string: "Chess"

# Contains digits
Sashite::Snn.parse("CHESS960")
# => ArgumentError: Invalid SNN string: "CHESS960"

# Contains special characters
Sashite::Snn.parse("MINI_SHOGI")
# => ArgumentError: Invalid SNN string: "MINI_SHOGI"

# Empty string
Sashite::Snn.parse("")
# => ArgumentError: Invalid SNN string: ""
```

## Design Principles

- **Human-readable**: Descriptive names for better usability
- **Case-consistent**: Visual distinction between players through case
- **Foundational primitive**: Serves as building block for formal style identification
- **Rule-agnostic**: Independent of specific game mechanics
- **Self-contained**: No external dependencies
- **Immutable**: All objects are frozen and thread-safe
- **Canonical**: Each style has one valid representation per context

## Properties

- **Purely functional**: Immutable data structures, no side effects
- **Specification compliant**: Strict adherence to [SNN v1.0.0](https://sashite.dev/specs/snn/1.0.0/)
- **Minimal API**: Simple validation, parsing, and comparison
- **Universal**: Supports any abstract strategy board game style
- **No dependencies**: Foundational primitive requiring no external gems

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [SNN Specification](https://sashite.dev/specs/snn/1.0.0/) — Official specification
- [SNN Examples](https://sashite.dev/specs/snn/1.0.0/examples/) — Usage examples

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
