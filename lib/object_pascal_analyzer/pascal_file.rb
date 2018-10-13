require "object_pascal_analyzer"

require "object_pascal_analyzer/pascal_class"

module ObjectPascalAnalyzer
  class PascalFile
    attr_reader :klass, :name, :classes
    def initialize(name)
      @name = name
      @classes = {}
    end

    def class_by(name)
      @classes[name] ||= PascalClass.new(self, name)
    end

    def to_hash
      {
        path: name,
        classes: classes.values.map(&:to_hash)
      }
    end
  end
end
