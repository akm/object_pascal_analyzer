require "object_pascal_analyzer"

require 'thor'

module ObjectPascalAnalyzer
  class Cli < Thor
    desc 'version', 'Show version'
    def version
      $stdout.puts ObjectPascalAnalyzer::VERSION
    end
  end
end
