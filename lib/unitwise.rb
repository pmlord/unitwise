require 'liner'
require 'memoizable'
require 'parslet'
require 'signed_multiset'
require 'yaml'
require 'bigdecimal'

require 'unitwise/version'
require 'unitwise/base'
require 'unitwise/compatible'
require 'unitwise/expression'
require 'unitwise/scale'
require 'unitwise/functional'
require 'unitwise/measurement'
require 'unitwise/atom'
require 'unitwise/prefix'
require 'unitwise/term'
require 'unitwise/unit'
require 'unitwise/search'
require 'unitwise/errors'
require 'unitwise/preferred_unit_system'

# Unitwise is a library for performing mathematical operations and conversions
# on all units defined by the [Unified Code for Units of Measure(UCUM).
module Unitwise

  # Search for available compounds. This is just a helper method for
  # convenience
  # @param term [String, Regexp]
  # @return [Array]
  # @api public
  def self.search(term)
    Search.search(term)
  end

  # Determine if a given string is a valid unit expression
  # @param expression [String]
  # @return [true, false]
  # @api public
  def self.valid?(expression)
    begin
      !!Unitwise::Expression.decompose(expression)
    rescue ExpressionError
      false
    end
  end
  
  # The system path for the installed gem
  # @api private
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  # A helper to get the location of a yaml data file
  # @api private
  def self.data_file(key)
    File.join path, 'data', "#{key}.yaml"
  end

  def self.preferred_units=(input)
    Unitwise::PreferredUnitSystem.set_system(input)
  end

  def self.use_preferred_units(new_system)
    old_system = Unitwise::PreferredUnitSystem.current
    self.preferred_units = new_system
    yield
  ensure
    self.preferred_units = old_system
  end

  def self.add_preferred_units(name, preferred_units)
    Unitwise::PreferredUnitSystem.add_system(name, preferred_units)
  end
end

# Measurement initializer shorthand. Use this to instantiate new measurements.
# @param first [Numeric, String] Either a numeric value or a unit expression
# @param last [String, Nil] Either a unit expression, or nil
# @return [Unitwise::Measurement]
# @example
#   Unitwise(20, 'mile') # => #<Unitwise::Measurement 20 mile>
#   Unitwise('km') # => #<Unitwise::Measurement 1 km>
# @api public
def Unitwise(*args)
  Unitwise::Measurement.new(*args)
end
