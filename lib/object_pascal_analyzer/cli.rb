require "object_pascal_analyzer"

require 'csv'
require 'json'
require 'thor'

module ObjectPascalAnalyzer
  class Cli < Thor
    desc 'summary PATH_TO_DIR', 'Show summary'
    def summary(path_to_dir)
      output "Show summary of #{path_to_dir}"
    end

    CSV_HEADERS = [
      :path, :class, :name,
      :total_lines,
      :empty_lines,
      :comment_lines,
      :max_depth,
    ]

    CSV_OPTIONS = {
      write_headers: true,
      headers: CSV_HEADERS,
    }

    desc 'csv PATH_TO_DIR', 'Show details in CSV'
    def csv(path_to_dir)
      pascal_files = ObjectPascalAnalyzer.load(path_to_dir)
      result = pascal_files.map(&:functions).flatten.map{|f| f.to_hash(full: true)}
      text = CSV.generate("", CSV_OPTIONS) do |csv|
        result.each do |r|
          csv << CSV_HEADERS.map{|h| r[h]}
        end
      end
      output text
    end

    desc 'json PATH_TO_DIR', 'Show details in JSON'
    def json(path_to_dir)
      pascal_files = ObjectPascalAnalyzer.load(path_to_dir)
      hash = {files: pascal_files.map(&:to_hash)}
      output JSON.pretty_generate(hash)
    end

    desc 'version', 'Show version'
    def version
      output ObjectPascalAnalyzer::VERSION
    end

    no_commands do
      def output(value)
        $stdout.puts(value)
      end
    end
  end
end
