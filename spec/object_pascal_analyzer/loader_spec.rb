require 'object_pascal_analyzer/loader'

RSpec.describe ObjectPascalAnalyzer::Loader do
  subject{ ObjectPascalAnalyzer::Loader.new }
  it "loads directories" do
    r = subject.load(File.expand_path("../../jedi-jvcl/tests/restructured/examples/HID/BasicDemo"), __FILE__)
    expect(r).to be_an Array
    expect(r.length).to eq 1

    f0 = r.first
    expect(f0.name).to eq 'Unit1.pas'
    expect(f0.classes.length).to eq 1

    c0 = f0.classes.first
    expect(c0.path).to eq f0
    expect(c0.name).to eq "TForm1"
    expect(c0.methods.length).to eq 2

    m0 = c0.methods[0]
    expect(m0.klass).to eq c0
    expect(m0.name).to eq "HidCtlDeviceChange"
    expect(m0.total_lines).to eq 2
    expect(m0.empty_lines).to eq 0
    expect(m0.comment_lines).to eq 0
    expect(m0.max_depth).to eq 0

    m1 = c0.methods[1]
    expect(m1.klass).to eq c0
    expect(m1.name).to eq "HidCtlEnumerate"
    expect(m1.total_lines).to eq 4
    expect(m1.empty_lines).to eq 0
    expect(m1.comment_lines).to eq 0
    expect(m1.max_depth).to eq 0
  end
end
