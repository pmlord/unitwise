module Unitwise
  # 
  class PreferredUnitSystem

    class << self

      def current
        @current ||= new
      end

      def named_systems
        @named_systems ||= {}
      end

      def add_system(name, preferred_units)
        named_systems.merge!({ name => new(preferred_units) })
      end

      def set_system(unit_system)
        @current = case unit_system.class
                   when Symbol
                     named_systems[unit_system]
                   when self.class
                     unit_system
                   else
                     new(unit_system)
                   end
      end

    end


    def initialize(preferred_units=[])
      @system = {}

      preferred_units.reduce(@system) do |s, unit_str|
        unit = Unitwise::Unit.new(unit_str)
        key = unit.composition_string
        s.merge!({ key => unit })
      end
    end

    def unit_for(measurement)
      @system[measurement.composition_string]
    end

  end
end
