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

    # ブロックが渡される場合ブロックは、lineがEND_PATTERNにマッチしてfunctionの定義を終える場合に呼び出されます
    def process(line)
      $stderr.puts "#{name} #{@begins} #{line}" if DEBUG
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
        increment
      end
    end

    def empty_line
      $stderr.puts "#{name} #{@begins} (empty)" if DEBUG
      increment{ @empty_lines += 1 }
    end

    def comment_line
      $stderr.puts "#{name} #{@begins} (comment)" if DEBUG
      increment{ @comment_lines += 1 }
    end

    def increment
      return unless @begins > 0
      @total_lines += 1
      yield if block_given?
    end

    def to_hash(full: false)
      r = {
        name: name,
        total_lines: total_lines,
        empty_lines: empty_lines,
        comment_lines: comment_lines,
        max_depth: max_depth,
      }
      r.update(class: klass.name, path: klass.pascal_file.name) if full
      return r
    end
  end
end
