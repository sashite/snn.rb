# snn.rb

[![Version](https://img.shields.io/github/v/tag/sashite/snn.rb?label=Version&logo=github)](https://github.com/sashite/snn.rb/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/snn.rb/main)
[![CI](https://github.com/sashite/snn.rb/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/sashite/snn.rb/actions)
[![License](https://img.shields.io/github/license/sashite/snn.rb)](https://github.com/sashite/snn.rb/blob/main/LICENSE)

> **SNN** (Style Name Notation) implementation for Ruby.

## Overview

This library implements the [SNN Specification v1.0.0](https://sashite.dev/specs/snn/1.0.0/).

### Implementation Constraints

| Constraint | Value | Rationale |
|------------|-------|-----------|
| Max string length | 32 | Sufficient for realistic style names |

These constraints enable bounded memory usage and safe parsing.

## Installation

```ruby
# In your Gemfile
gem "sashite-snn"
```

Or install manually:

```sh
gem install sashite-snn
```

## Usage

### Parsing (String → StyleName)

Convert an SNN string into a `StyleName` object.

```ruby
require "sashite/snn"

# Standard parsing (raises on error)
snn = Sashite::Snn.parse("Chess")
snn.name  # => "Chess"

# With numeric suffix
snn = Sashite::Snn.parse("Chess960")
snn.name  # => "Chess960"

# Invalid input raises ArgumentError
Sashite::Snn.parse("chess")  # => raises ArgumentError, "invalid format"
Sashite::Snn.parse("")       # => raises ArgumentError, "empty input"
```

### Formatting (StyleName → String)

Convert a `StyleName` back to an SNN string.

```ruby
# From StyleName object
snn = Sashite::Snn::StyleName.new("Chess")
snn.to_s  # => "Chess"

# String interpolation
"Playing #{snn}"  # => "Playing Chess"
```

### Validation

```ruby
# Boolean check
Sashite::Snn.valid?("Chess")     # => true
Sashite::Snn.valid?("Chess960")  # => true
Sashite::Snn.valid?("chess")     # => false (lowercase start)
Sashite::Snn.valid?("")          # => false (empty)
```

### Accessing Data

```ruby
snn = Sashite::Snn.parse("Chess960")

# Get the name (attribute)
snn.name  # => "Chess960"
```

## API Reference

### Types

```ruby
# StyleName represents a validated SNN style name.
class Sashite::Snn::StyleName
  # Creates a StyleName from a valid name string.
  # Raises ArgumentError if the name is invalid.
  #
  # @param name [String] SNN style name
  # @return [StyleName]
  def initialize(name)

  # Returns the style name.
  #
  # @return [String]
  def name

  # Returns the SNN string representation.
  #
  # @return [String]
  def to_s
end
```

### Constants

```ruby
Sashite::Snn::StyleName::MAX_STRING_LENGTH  # => 32
```

### Parsing

```ruby
# Parses an SNN string into a StyleName.
# Raises ArgumentError if the string is not valid.
#
# @param string [String] SNN style name string
# @return [StyleName]
# @raise [ArgumentError] if invalid
def Sashite::Snn.parse(string)
```

### Validation

```ruby
# Reports whether string is a valid SNN style name.
#
# @param string [String] SNN style name string
# @return [Boolean]
def Sashite::Snn.valid?(string)
```

### Errors

All parsing and validation errors raise `ArgumentError` with descriptive messages:

| Message | Cause |
|---------|-------|
| `"empty input"` | String length is 0 |
| `"input too long"` | String exceeds 32 characters |
| `"invalid format"` | Does not match SNN format |

## Design Principles

- **Bounded values**: Maximum string length prevents resource exhaustion
- **Object-oriented**: `StyleName` class enables methods and encapsulation
- **Ruby idioms**: `valid?` predicate, `to_s` conversion, `ArgumentError` for invalid input
- **Immutable style names**: `freeze` after construction
- **No dependencies**: Pure Ruby standard library only

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [SNN Specification](https://sashite.dev/specs/snn/1.0.0/) — Official specification
- [SNN Examples](https://sashite.dev/specs/snn/1.0.0/examples/) — Usage examples

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
