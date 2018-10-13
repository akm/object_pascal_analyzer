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


end
