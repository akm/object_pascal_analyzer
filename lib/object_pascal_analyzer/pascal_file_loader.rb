# coding: utf-8
require "object_pascal_analyzer"

require 'nkf'

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
      source_text = read_file(path)
      source_text.lines.each do |line|
        if found_implementation
          process(line)
        else
          if IMPLEMENTATION_PATTERN =~ line
            found_implementation = true
          end
        end
      end
      pascal_file
    end

    def read_file(path)
      # https://docs.ruby-lang.org/ja/2.3.0/class/NKF.html
      encode = NKF.guess(File.read(path))
      # https://docs.ruby-lang.org/ja/2.3.0/method/IO/s/read.html
      # https://docs.ruby-lang.org/ja/latest/method/Kernel/m/open.html
      File.read(path, mode: "r:utf-8:#{encode.to_s}")
    rescue EncodingError
      # 変換不可能な不正な文字コードを含んでいる場合、それらを空白文字に置換した文字列を返します
      File.read(path).encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "")
    end

    # Object pascal の識別子
    # http://docs.embarcadero.com/products/rad_studio/cbuilder6/JA/oplg.pdf
    # http://wiki.freepascal.org/Identifiers/ja
    FUNCTION_PATTERN = /\s*(?:function|procedure)\s+([\w\.]+)/i
    METHOD_PATTERN = /\A(\w+)\.(\w+)\z/i

    EMPTY_PATTERN = /\A\s*\n\z/
    COMMENT_PATTERN = /\A\s*\/\/.*\n\z/

    def process(line)
      if line =~ EMPTY_PATTERN
        @current.empty_line if @current
        return
      end
      if line =~ COMMENT_PATTERN
        @current.comment_line if @current
        return
      end
      func = line.scan(FUNCTION_PATTERN).flatten.first
      if func
        @function_stack.push(@current) if @current
        @current = new_function(func)
      elsif @current
        @current.process(line){ @current = @function_stack.pop } # functionの定義を終える際に呼び出されるブロックを指定
      end
    end

    def new_function(func)
      class_name, meth = func.scan(METHOD_PATTERN).flatten
      if class_name
        func_name = meth
      elsif @current
        class_name = @current.klass.name
        func_name = "%s/%s" % [@current.name, func]
      else
        class_name = 'unit' # class_name ならクラス用のメソッドではなくユニットの関数
        func_name = func
      end
      klass = pascal_file.class_by(class_name)
      return klass.function_by(func_name)
    end
  end
end
