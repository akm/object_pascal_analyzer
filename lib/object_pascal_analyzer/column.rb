require "object_pascal_analyzer"

module ObjectPascalAnalyzer
  class Column
    attr_reader :key, :alignment, :title
    def initialize(key, alignment, title)
      @key, @alignment, @title = key, alignment, title
    end

    def row_format(max_length)
      "%#{alignment}#{max_length}\{#{key.to_s}\}"
    end

    def header_format(max_length)
      "%-#{max_length}\{#{key.to_s}\}"
    end
  end
end
