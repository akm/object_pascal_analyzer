# coding: utf-8
require "object_pascal_analyzer"

require "object_pascal_analyzer/pascal_file"

module ObjectPascalAnalyzer
  class PascalFileLoader

    attr_reader :path
    attr_reader :pascal_file

    def initialize(path, name)
      @path = path
      @pascal_file = PascalFile.new(name)
      @function_stack = []
      @current = nil
    end

    IMPLEMENTATION_PATTERN = /\s*implementation/i

    def execute
      found_implementation = false
      open(path) do |source_file|
        source_file.each_line do |line|
          if found_implementation
            process(line)
          else
            if IMPLEMENTATION_PATTERN =~ line
              found_implementation = true
            end
          end
        end
      end
      pascal_file
    end

    # Object pascal の識別子
    # http://docs.embarcadero.com/products/rad_studio/cbuilder6/JA/oplg.pdf
    # http://wiki.freepascal.org/Identifiers/ja
    FUNCTION_PATTERN = /\s*(?:function|procedure)\s+([\w\.]+)/i
    METHOD_PATTERN = /\A(\w+)\.(\w+)\z/i

    BEGIN_PATTERN = /\bbegin\s*(?:\#.+)?\z/i
    END_PATTERN = /\bend\s*\;\s*(?:\#.+)?\z/i

    EMPTY_PATTERN = /\A\s*\n\z/
    COMMENT_PATTERN = /\A\s*\/\/.*\n\z/

    def process(line)
      func = line.scan(FUNCTION_PATTERN).flatten.first
      if func
        class_name, meth = func.scan(METHOD_PATTERN).flatten
        class_name ||= 'unit' # class_name ならクラス用のメソッドではなくユニットの関数
        klass = pascal_file.class_by(class_name)
        @function_stack.push(@current) if @current
        @current = klass.function_by(meth || func)
        @current_begins = 0
      elsif @current
        if line =~ BEGIN_PATTERN
          @current.total_lines += 1 if @current_begins > 0
          @current_begins += 1
          @current.max_depth = @current_begins -1 if @current.max_depth < @current_begins -1
        elsif line =~ END_PATTERN
          @current_begins -= 1
          @current.total_lines += 1 if @current_begins > 0
          if @current_begins == 0
            @current = @function_stack.pop
          end
        elsif @current_begins > 0
          @current.total_lines += 1
          if line =~ EMPTY_PATTERN
            @current.empty_lines += 1
          elsif line =~ COMMENT_PATTERN
            @current.comment_lines += 1
          end
        else
          # begin前は特にカウントしない
        end
      end

    end
  end
end
