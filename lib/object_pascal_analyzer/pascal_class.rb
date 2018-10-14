require "object_pascal_analyzer"

require "object_pascal_analyzer/pascal_function"

module ObjectPascalAnalyzer
  class PascalClass
    attr_reader :pascal_file, :name, :functions
    def initialize(pascal_file, name)
      @pascal_file, @name = pascal_file, name
      @functions = []
    end

    def add_function(name)
      PascalFunction.new(self, name).tap{|r| @functions << r}
    end

    def find_function(name)
      @functions.detect{|f| f.name == name}
    end

    def function_by(name)
      find_function(name) || add_function(name)
    end

    def to_hash
      {
        name: name,
        functions: functions.map(&:to_hash)
      }
    end

    def function_array
      functions
    end
  end
end
