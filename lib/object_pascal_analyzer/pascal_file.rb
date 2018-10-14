require "object_pascal_analyzer"

require "object_pascal_analyzer/pascal_class"

module ObjectPascalAnalyzer
  class PascalFile
    attr_reader :klass, :name, :classes
    def initialize(name)
      @name = name
      @classes = []
    end

    def add_class(name)
      PascalClass.new(self, name).tap{|r| @classes << r}
    end

    def find_class(name)
      @classes.detect{|c| c.name == name}
    end

    def class_by(name)
      find_class(name) || add_class(name)
    end

    def to_hash
      {
        path: name,
        classes: classes.map(&:to_hash)
      }
    end

    def functions
      classes.map(&:functions).flatten
    end
  end
end
