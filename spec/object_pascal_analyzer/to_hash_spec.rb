require 'object_pascal_analyzer/pascal_file'

RSpec.describe ObjectPascalAnalyzer::PascalFile do
  subject do
    ObjectPascalAnalyzer::PascalFile.new("unit1.pas").tap do |pf|
      pf.class_by("TForm1").tap do |klass|
        klass.function_by("Button1Click").tap do |f|
          f.total_lines = 10
          f.empty_lines = 2
          f.comment_lines = 3
          f.max_depth = 1
        end
        klass.function_by("Input1Change").tap do |f|
          f.total_lines = 40
          f.empty_lines = 2
          f.comment_lines = 10
          f.max_depth = 3
        end
      end
      pf.class_by("THelper").tap do |klass|
        klass.function_by("run").tap do |f|
          f.total_lines = 20
          f.empty_lines = 3
          f.comment_lines = 0
          f.max_depth = 2
        end
      end
    end
  end

  describe :to_hash do
    it do
      expected = {
        path: "unit1.pas",
        classes: [
          {
            name: "TForm1",
            functions: [
              {
                name: "Button1Click",
                total_lines: 10,
                empty_lines: 2,
                comment_lines: 3,
                max_depth: 1,
              },
              {
                name: "Input1Change",
                total_lines: 40,
                empty_lines: 2,
                comment_lines: 10,
                max_depth: 3,
              },
            ],
          },
          {
            name: "THelper",
            functions: [
              {
                name: "run",
                total_lines: 20,
                empty_lines: 3,
                comment_lines: 0,
                max_depth: 2,
              },
            ],
          },
        ]
      }
      expect(subject.to_hash).to eq expected
    end
  end

  describe :functions do
    it do
      expect(subject.classes.length).to eq 2
      expect(subject.classes.values[0].functions.length).to eq 2
      expect(subject.classes.values[1].functions.length).to eq 1
      result = subject.functions
      result.each do |r|
        p r
      end
      expect(result.length).to eq 3
      result[0].tap do |r|
        expect(r.klass.pascal_file.name).to eq "unit1.pas"
        expect(r.klass.name).to eq "TForm1"
        expect(r.name).to eq "Button1Click"
        expect(r.total_lines).to eq 10
        expect(r.empty_lines).to eq 2
        expect(r.comment_lines).to eq 3
        expect(r.max_depth).to eq 1
      end
      result[1].tap do |r|
        expect(r.klass.pascal_file.name).to eq "unit1.pas"
        expect(r.klass.name).to eq "TForm1"
        expect(r.name).to eq "Input1Change"
        expect(r.total_lines).to eq 40
        expect(r.empty_lines).to eq 2
        expect(r.comment_lines).to eq 10
        expect(r.max_depth).to eq 3
      end
      result[2].tap do |r|
        expect(r.klass.pascal_file.name).to eq "unit1.pas"
        expect(r.klass.name).to eq "THelper"
        expect(r.name).to eq "run"
        expect(r.total_lines).to eq 20
        expect(r.empty_lines).to eq 3
        expect(r.comment_lines).to eq 0
        expect(r.max_depth).to eq 2
      end
    end
  end

end
