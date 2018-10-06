require "object_pascal_analyzer"

module ObjectPascalAnalyzer
  class PascalFunction
    attr_reader :name
    attr_reader :total_lines, :empty_lines, :comment_lines, :max_depth
    def initialize(name, total_lines, empty_lines, comment_lines, max_depth)
      @name = name
      @total_lines, @empty_lines, @comment_lines, @max_depth = total_lines, empty_lines, comment_lines, max_depth
    end
  end
end
