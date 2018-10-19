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

  describe :summary do
    it :default do
      subject.options = {number: 5}
      expect(subject).to receive(:output).with(File.read(File.expand_path('../cli_spec/HID_summary.txt', __FILE__)))
      subject.summary(File.expand_path('../../jedi-jvcl/tests/restructured/examples/HID', __FILE__))
    end

    it "only top 3" do
      subject.options = {number: 3}
      expect(subject).to receive(:output).with(File.read(File.expand_path('../cli_spec/HID_summary_top3.txt', __FILE__)))
      subject.summary(File.expand_path('../../jedi-jvcl/tests/restructured/examples/HID', __FILE__))
    end
  end

end
