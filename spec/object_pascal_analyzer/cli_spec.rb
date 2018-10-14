require 'object_pascal_analyzer/cli'

RSpec.describe ObjectPascalAnalyzer::Cli do

  subject{ ObjectPascalAnalyzer::Cli.new }

  describe :csv do
    it do
      expect(subject).to receive(:output).with(File.read(File.expand_path('../cli_spec/HID.csv', __FILE__)))
      subject.csv(File.expand_path('../../jedi-jvcl/tests/restructured/examples/HID', __FILE__))
    end
  end

  describe :json do
    it do
      expected = File.read(File.expand_path('../cli_spec/HID-BasicDemo.json', __FILE__)).strip
      expect(subject).to receive(:output).with(expected)
      subject.json(File.expand_path('../../jedi-jvcl/tests/restructured/examples/HID/BasicDemo', __FILE__))
    end
  end

  describe :version do
    it do
      expect(subject).to receive(:output).with(ObjectPascalAnalyzer::VERSION)
      subject.version
    end
  end

end
