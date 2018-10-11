require 'object_pascal_analyzer'

RSpec.describe ObjectPascalAnalyzer do
  # requires basic_demo_unit1
  shared_examples_for 'basic_demo_unit1' do
    let(:tform1){ basic_demo_unit1.classes['TForm1'] }
    let(:hidctldevicechange){ tform1.functions['HidCtlDeviceChange'] }
    let(:hidctlenumerate){ tform1.functions['HidCtlEnumerate'] }

    context "TForm1" do
      subject{ tform1 }
      it do
        expect(subject.name).to eq "TForm1"
        expect(subject.functions.length).to eq 2
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

  # requires thread_demo_mouse_reader
  shared_examples_for 'thread_demo_mouse_reader' do
    let(:tform1){ thread_demo_mouse_reader.classes['TForm1'] }
    let(:hidctldevicechange){ tform1.functions['HidCtlDeviceChange'] }

    let(:tmousethread){ thread_demo_mouse_reader.classes['TMouseThread'] }
    let(:handlemousedata){ tmousethread.functions['HandleMouseData'] }
    let(:execute        ){ tmousethread.functions['Execute'] }
    let(:execute_dummy  ){ tmousethread.functions['Execute/Dummy'] }

    context "TForm1" do
      subject{ tform1 }
      it do
        expect(subject.name).to eq "TForm1"
        expect(subject.functions.length).to eq 1
      end
    end

    context "HidCtlDeviceChange" do
      subject{ hidctldevicechange }
      it do
        expect(subject.klass).to eq tform1
        expect(subject.name).to eq "HidCtlDeviceChange"
        expect(subject.total_lines).to eq 38
        expect(subject.empty_lines).to eq 0
        expect(subject.comment_lines).to eq 7
        expect(subject.max_depth).to eq 2
      end
    end

    context "TMouseThread" do
      subject{ tmousethread }
      it do
        expect(subject.name).to eq "TMouseThread"
        expect(subject.functions.length).to eq 3
      end
    end

    context "HandleMouseData" do
      subject{ handlemousedata }
      it do
        expect(subject.klass).to eq tmousethread
        expect(subject.name).to eq "HandleMouseData"
        expect(subject.total_lines).to eq 6
        expect(subject.empty_lines).to eq 0
        expect(subject.comment_lines).to eq 2
        expect(subject.max_depth).to eq 0
      end
    end

    context "Execute" do
      subject{ execute }
      it do
        expect(subject.klass).to eq tmousethread
        expect(subject.name).to eq "Execute"
        expect(subject.total_lines).to eq 18
        expect(subject.empty_lines).to eq 0
        expect(subject.comment_lines).to eq 5
        expect(subject.max_depth).to eq 1
      end
    end

    context "Execute/Dummy" do
      subject{ execute_dummy }
      it do
        expect(subject.klass).to eq tmousethread
        expect(subject.name).to eq "Execute/Dummy"
        expect(subject.total_lines).to eq 0
        expect(subject.empty_lines).to eq 0
        expect(subject.comment_lines).to eq 0
        expect(subject.max_depth).to eq 0
      end
    end
  end

  File.expand_path("../../jedi-jvcl/tests/restructured/examples/HID/BasicDemo", __FILE__).tap do |path|
    context path do
      let(:result){ ObjectPascalAnalyzer.load(path) }
      let(:basic_demo_unit1){ result['Unit1.pas'] }

      context "result" do
        it { expect(result.length).to eq 1 }
      end

      context "unit1" do
        subject{ basic_demo_unit1 }
        it { expect(subject.name).to eq 'Unit1.pas' }
        it { expect(subject.classes.length).to eq 1 }
      end

      it_behaves_like 'basic_demo_unit1'
    end
  end

  File.expand_path("../../jedi-jvcl/tests/restructured/examples/HID", __FILE__).tap do |path|
    context path do
      let(:result){ ObjectPascalAnalyzer.load(path) }
      let(:basic_demo_unit1){ result['BasicDemo/Unit1.pas'] }
      let(:thread_demo_mouse_reader){ result['ThreadDemo/MouseReader.pas'] }

      context "result" do
        it { expect(result.length).to eq 5 }
      end

      context "unit1" do
        subject{ basic_demo_unit1 }
        it { expect(subject.name).to eq 'BasicDemo/Unit1.pas' }
        it { expect(subject.classes.length).to eq 1 }
      end

      it_behaves_like 'basic_demo_unit1'
      it_behaves_like 'thread_demo_mouse_reader'
    end
  end
end
