require "object_pascal_analyzer"

require 'thor'

module ObjectPascalAnalyzer
  class Cli < Thor
    desc 'summary PATH_TO_DIR', 'Show summary'
    def summary(path_to_dir)
      $stdout.puts "Show summary of #{path_to_dir}"
    end

    desc 'csv PATH_TO_DIR', 'Show details in CSV'
    def summary(path_to_dir)
      $stdout.puts "Show details of #{path_to_dir} in CSV"
    end

    desc 'json PATH_TO_DIR', 'Show details in JSON'
    def json(path_to_dir)
      $stdout.puts "Show details of #{path_to_dir} in JSON"
    end

    desc 'version', 'Show version'
    def version
      $stdout.puts ObjectPascalAnalyzer::VERSION
    end
  end
end
