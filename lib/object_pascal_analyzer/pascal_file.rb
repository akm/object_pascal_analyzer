require "object_pascal_analyzer"

module ObjectPascalAnalyzer
  class PascalFile
    attr_reader :name, :classes
    def initialize(name)
      @name = name
      @classes = {}
    end
  end
end
