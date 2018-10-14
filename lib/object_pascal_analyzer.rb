require "object_pascal_analyzer/version"

require 'pathname'

require "object_pascal_analyzer/pascal_file_loader"

module ObjectPascalAnalyzer
  class << self
    def load(base_dir)
      base = Pathname.new(base_dir)
      Dir.glob(File.join(base_dir, "**/*.pas")).each.with_object({}) do |path, r|
        name = Pathname.new(path).relative_path_from(base).to_s
        begin
          r[name] = PascalFileLoader.new(path, name).execute
        rescue Exception => e
          $stderr.puts("Failed to load %s because of [%s] %s" % [name, e.class.name, e.inspect])
          raise e
        end
      end
    end
  end
end
