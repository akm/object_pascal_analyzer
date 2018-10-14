require "object_pascal_analyzer"

require 'csv'
require 'json'
require 'thor'

module ObjectPascalAnalyzer
  class Cli < Thor
    desc 'summary PATH_TO_DIR', 'Show summary'
    def summary(path_to_dir)
      $stdout.puts "Show summary of #{path_to_dir}"
    end

    CSV_HEADERS = [
      :path, :class, :name,
      :total_lines,
      :empty_lines,
      :comment_lines,
      :max_depth,
    ]

    desc 'csv PATH_TO_DIR', 'Show details in CSV'
    def csv(path_to_dir)
      pascal_files = ObjectPascalAnalyzer.load(path_to_dir)
      result = pascal_files.map do |f|
        f.functions.map{|f| f.to_hash(full: true)}
      end.flatten
      options = {
        write_headers: true,
        headers: CSV_HEADERS,
      }
      output = CSV.generate("", options) do |csv|
        result.each do |r|
          csv << CSV_HEADERS.map{|h| r[h]}
        end
      end
      $stdout.puts output
    end

    desc 'json PATH_TO_DIR', 'Show details in JSON'
    def json(path_to_dir)
      pascal_files = ObjectPascalAnalyzer.load(path_to_dir)
      hash = {files: pascal_files.map(&:to_hash)}
      $stdout.puts JSON.pretty_generate(hash)
    end

    desc 'version', 'Show version'
    def version
      $stdout.puts ObjectPascalAnalyzer::VERSION
    end
  end
end
