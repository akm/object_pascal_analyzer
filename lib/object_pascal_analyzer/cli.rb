require "object_pascal_analyzer"

require 'csv'
require 'json'
require 'thor'

module ObjectPascalAnalyzer
  class Cli < Thor

    SORT_KEYS = {
      total: [:total_lines, :max_depth, :comment_lines, :path, :class, :name],
      depth: [:max_depth, :total_lines, :comment_lines, :path, :class, :name],
      comment: [:comment_lines, :total_lines, :max_depth, :path, :class, :name],
    }

    desc 'summary PATH_TO_DIR', 'Show summary'
    option :number, aliases: 'n', type: :numeric, default: 5
    def summary(path_to_dir)
      pascal_files = ObjectPascalAnalyzer.load(path_to_dir)
      functions = pascal_files.map(&:functions).flatten.map{|f| f.to_hash(full: true)}

      num = options[:number].to_i

      defs = [
        {type: :total, head: "Top #{num} of the longest procedures or functions"},
        {type: :depth, head: "Top #{num} of the deepest procedures or functions"},
        {type: :comment, head: "Top #{num} of the most commented procedures or functions"},
      ]

      result = defs.map do |d|
        [
          d[:head],
          build_table(functions.sort(&sort_proc_for(SORT_KEYS[d[:type]]))[0,num]),
        ].join("\n")
      end.join("\n\n")

      output result + "\n"
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

      class Col
        attr_reader :alignment, :title
        def initialize(alignment, title)
          @alignment, @title = alignment, title
        end
      end

      COLS = {
        path:           Col.new('-', 'Path'),
        class:          Col.new('-', 'Class'),
        name:           Col.new('-', 'Name'),
        total_lines:    Col.new('' , 'Total'),
        empty_lines:    Col.new('' , 'Empty'),
        comment_lines:  Col.new('' , 'Comment'),
        max_depth:      Col.new('' , 'Depth'),
      }

      def build_table(functions)
        max_lengths = CSV_HEADERS.each_with_object({}) do |col, d|
          d[col] = (functions.map{|f| f[col]}.map(&:to_s) + [COLS[col].title]).map(&:length).max
        end
        row_format = CSV_HEADERS.map{|col| "%#{COLS[col].alignment}#{max_lengths[col]}\{#{col.to_s}\}" }.join(' ')
        header_format = CSV_HEADERS.map{|col| "%-#{max_lengths[col]}\{#{col.to_s}\}" }.join(' ')

        titles = COLS.each_with_object({}){|(k,col), d| d[k] = col.title }
        result = [header_format % titles]
        functions.each do |f|
          result << (row_format % f)
        end
        result.join("\n")
      end

      def sort_proc_for(keys)
        lambda do |a, b|
          keys.each do |key|
            d = a[key] <=> b[key]
            return a[key].is_a?(Integer) ? -1 * d : d if d != 0
          end
          return 0
        end
      end

    end
  end
end
