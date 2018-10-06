require 'object_pascal_analyzer/loader'

RSpec.describe ObjectPascalAnalyzer::Loader do

  # requires basic_demo_unit1
  shared_examples_for 'basic_demo_unit1' do
    let(:tform1){ basic_demo_unit1.classes['TForm1'] }
    let(:hidctldevicechange){ tform1.methods['HidCtlDeviceChange'] }
    let(:hidctlenumerate){ tform1.methods['HidCtlEnumerate'] }

    context "TForm1" do
      subject{ tform1 }
      it do
        expect(subject.name).to eq "TForm1"
        expect(subject.methods.length).to eq 2
      end
    end

    context "HidCtlDeviceChange" do
      subject{ hidctldevicechange }
      it do
        expect(subject.klass).to eq tform1
        expect(subject.name).to eq "HidCtlDeviceChange"
        expect(subject.total_lines).to eq 2
        expect(subject.empty_lines).to eq 0
        expect(subject.comment_lines).to eq 0
        expect(subject.max_depth).to eq 0
      end
    end

    context "HidCtlEnumerate" do
      subject{ hidctlenumerate }
      it do
        expect(subject.klass).to eq tform1
        expect(subject.name).to eq "HidCtlEnumerate"
        expect(subject.total_lines).to eq 4
        expect(subject.empty_lines).to eq 0
        expect(subject.comment_lines).to eq 0
        expect(subject.max_depth).to eq 0
      end
    end
  end

  let(:loader){ ObjectPascalAnalyzer::Loader.new }

  File.expand_path("../../jedi-jvcl/tests/restructured/examples/HID/BasicDemo", __FILE__).tap do |path|
    context path do
      let(:result){ loader.load(path) }
      let(:basic_demo_unit1){ result['Unit1.pas'] }

      context "result" do
        it { expect(result.length).to eq 1 }
      end

      context "unit1" do
        subject{ basic_demo_unit1 }
        it { expect(subject.name).to eq 'Unit1.pas' }
        it { expect(subject.classes.length).to eq 1 }
      end

      it_behaves_like 'basic_demo_class'
    end
  end

end
