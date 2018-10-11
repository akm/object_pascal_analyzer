require "object_pascal_analyzer"

module ObjectPascalAnalyzer
  class PascalFunction
    attr_reader :klass, :name
    attr_accessor :total_lines, :empty_lines, :comment_lines, :max_depth
    def initialize(klass, name)
      @klass, @name = klass, name
      @total_lines, @empty_lines, @comment_lines, @max_depth = 0, 0, 0, 0
    end
  end
end
