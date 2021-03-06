require 'object_pascal_analyzer'

RSpec.describe ObjectPascalAnalyzer do
  # requires basic_demo_unit1
  shared_examples_for 'basic_demo_unit1' do
    let(:tform1){ basic_demo_unit1.find_class('TForm1') }
    let(:hidctldevicechange){ tform1.find_function('HidCtlDeviceChange') }
    let(:hidctlenumerate){ tform1.find_function('HidCtlEnumerate') }

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
    let(:tform1){ thread_demo_mouse_reader.find_class('TForm1') }
    let(:hidctldevicechange){ tform1.find_function('HidCtlDeviceChange') }

    let(:tmousethread){ thread_demo_mouse_reader.find_class('TMouseThread') }
    let(:handlemousedata){ tmousethread.find_function('HandleMouseData') }
    let(:execute        ){ tmousethread.find_function('Execute') }
    let(:execute_dummy  ){ tmousethread.find_function('Execute/Dummy') }

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
      let(:basic_demo_unit1){ result.detect{|f| f.name == 'Unit1.pas'} }

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
      let(:basic_demo_unit1){ result.detect{|f| f.name == 'BasicDemo/Unit1.pas'} }
      let(:thread_demo_mouse_reader){ result.detect{|f| f.name == 'ThreadDemo/MouseReader.pas'} }

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

  # JvSpecialProgress.pas includes some invalid character (byte sequences ).
  File.expand_path("../../jedi-jvcl/tests/restructured/examples/JvSpecialProgress", __FILE__).tap do |path|
    context path do
      it do
        expect {
          ObjectPascalAnalyzer.load(path)
        }.not_to raise_error
      end
    end
  end

  context "unit functions" do
    let(:path){ File.expand_path("../../examples/with_commented_functions.pas", __FILE__) }
    let(:loader){ ObjectPascalAnalyzer::PascalFileLoader.new(path, "with_commented_functions.pas") }
    it do
      pascal_file = loader.execute
      expect(pascal_file.classes.length).to eq 1
      unit = pascal_file.find_class("unit")
      expect(unit.functions.length).to eq 4
      unit.function_by("ADD_SPACE").tap do |f|
        expect(f.total_lines).to eq 8
        expect(f.empty_lines).to eq 2
        expect(f.comment_lines).to eq 0
      end
      unit.function_by("ADD_SPACE2").tap do |f|
        expect(f.total_lines).to eq 9
        expect(f.empty_lines).to eq 2
        expect(f.comment_lines).to eq 0
      end
      unit.function_by("DEL_ALL_SPACE").tap do |f|
        expect(f.total_lines).to eq 35
        expect(f.empty_lines).to eq 1
        expect(f.comment_lines).to eq 0
      end
      unit.function_by("SYO_CHAR").tap do |f|
        expect(f.total_lines).to eq 9
        expect(f.empty_lines).to eq 0
        expect(f.comment_lines).to eq 0
      end
    end
  end

  context "end else begin" do
    let(:path){ File.expand_path("../../examples/end_else_begin.pas", __FILE__) }
    let(:loader){ ObjectPascalAnalyzer::PascalFileLoader.new(path, "end_else_begin.pas") }
    it do
      pascal_file = loader.execute
      expect(pascal_file.classes.length).to eq 1
      unit = pascal_file.find_class("unit")
      expect(unit.functions.length).to eq 1
      unit.function_by("DEL_ALL_SPACE").tap do |f|
        expect(f.total_lines).to eq 33
        expect(f.empty_lines).to eq 1
        expect(f.comment_lines).to eq 0
      end
    end
  end

  context "too many depth" do
    let(:path){ File.expand_path("../../jedi-jvcl/jvcl/examples/JvParameterList/JvParameterListMainForm.pas", __FILE__) }
    let(:loader){ ObjectPascalAnalyzer::PascalFileLoader.new(path, "JvParameterListMainForm.pas") }
    it do
      pascal_file = loader.execute
      klass = pascal_file.find_class("TJvParameterListDemoMainFrm")
      klass.function_by("Button15Click").tap do |f|
        expect(f.total_lines).to eq 150
        expect(f.empty_lines).to eq 0
        expect(f.comment_lines).to eq 3
        expect(f.max_depth).to eq 1
      end
    end
  end

end
