# coding: utf-8
require "object_pascal_analyzer"

module ObjectPascalAnalyzer
  class PascalFunction
    attr_reader :klass, :name
    attr_accessor :total_lines, :empty_lines, :comment_lines, :max_depth
    attr_accessor :begins # 作業用の一時的な属性
    def initialize(klass, name)
      @klass, @name = klass, name
      @total_lines, @empty_lines, @comment_lines, @max_depth = 0, 0, 0, 0
      @begins = 0
    end
  end
end
