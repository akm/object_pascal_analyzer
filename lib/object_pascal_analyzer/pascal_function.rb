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

    BEGIN_PATTERN = /\bbegin\s*(?:\#.+)?\z/i
    END_PATTERN = /\bend\s*\;\s*(?:\#.+)?\z/i

    EMPTY_PATTERN = /\A\s*\n\z/
    COMMENT_PATTERN = /\A\s*\/\/.*\n\z/

    # ブロックが渡される場合ブロックは、lineがEND_PATTERNにマッチしてfunctionの定義を終える場合に呼び出されます
    def process(line)
      case line
      when BEGIN_PATTERN
        @total_lines += 1 if @begins > 0
        @begins += 1
        @max_depth = @begins - 1 if @max_depth < @begins - 1
      when END_PATTERN
        @begins -= 1
        @total_lines += 1 if @begins > 0
        if @begins == 0
          yield if block_given?
        end
      else
      if @begins > 0
        @total_lines += 1
        if line =~ EMPTY_PATTERN
          @empty_lines += 1
        elsif line =~ COMMENT_PATTERN
          @comment_lines += 1
        end
      else
        # begin前は特にカウントしない
      end
      end
    end
  end
end
