require "object_pascal_analyzer"

require 'csv'
require 'json'
require 'thor'

module ObjectPascalAnalyzer
  class Cli < Thor
    desc 'summary PATH_TO_DIR', 'Show summary'
    def summary(path_to_dir)
      pascal_files = ObjectPascalAnalyzer.load(path_to_dir)
      functions = pascal_files.map(&:functions).flatten.map{|f| f.to_hash(full: true)}

      result = [
        build_table(functions[0,5]),
      ]
      output result.join("\n")
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

      ALIGNMENTS = {
        path: '-',
        class: '-',
        name: '-',
        total_lines: '',
        empty_lines: '',
        comment_lines: '',
        max_depth: '',
      }

      FORMAT_TYPES = {
        path: 's',
        class: 's',
        name: 's',
        total_lines: 'd',
        empty_lines: 'd',
        comment_lines: 'd',
        max_depth: 'd',
      }

      TITLES = {
        path: 'Path',
        class: 'Class',
        name: 'Name',
        total_lines: 'Total',
        empty_lines: 'Empty',
        comment_lines: 'Comment',
        max_depth: 'Depth',
      }

      def build_table(functions)
        max_lengths = CSV_HEADERS.each_with_object({}) do |col, d|
          d[col] = (functions.map{|f| f[col]}.map(&:to_s) + [TITLES[col]]).map(&:length).max
        end
        row_format = CSV_HEADERS.map{|col| "%#{ALIGNMENTS[col]}#{max_lengths[col]}\{#{col.to_s}\}" }.join(' ')
        header_format = CSV_HEADERS.map{|col| "%-#{max_lengths[col]}\{#{col.to_s}\}" }.join(' ')

        puts "header_format"
        puts header_format.inspect
        puts "row_format"
        puts row_format.inspect
        result = [header_format % TITLES]

        functions.each do |f|
          p f
          result << (row_format % f)
        end
        result.join("\n")
      end
    end
  end
end
