require "object_pascal_analyzer"

module ObjectPascalAnalyzer
  class PascalClass
    attr_reader :name, :functions
    def initialize(name)
      @name = name
      @functions = {}
    end
  end
end
