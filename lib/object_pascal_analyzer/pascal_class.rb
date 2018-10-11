require "object_pascal_analyzer"

require "object_pascal_analyzer/pascal_function"

module ObjectPascalAnalyzer
  class PascalClass
    attr_reader :pascal_file, :name, :functions
    def initialize(pascal_file, name)
      @pascal_file, @name = pascal_file, name
      @functions = {}
    end

    def function_by(name)
      @functions[name] ||= PascalFunction.new(self, name)
    end
  end
end
