require "object_pascal_analyzer/version"

require 'pathname'

require "object_pascal_analyzer/pascal_file_loader"

module ObjectPascalAnalyzer
  DEBUG = ENV['DEBUG'] =~ /true|yes|on|1/i

  class << self
    def load(base_dir)
      base = Pathname.new(base_dir)
      Dir.glob(File.join(base_dir, "**/*.pas")).map do |path|
        name = Pathname.new(path).relative_path_from(base).to_s
        begin
          PascalFileLoader.new(path, name).execute
        rescue Exception => e
          $stderr.puts("Failed to load %s because of [%s] %s" % [name, e.class.name, e.inspect])
          raise e
        end
      end
    end
  end
end
