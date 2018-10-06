# ObjectPascalAnalyzer

Analyze your Object Pascal source code statically with ObjectPascalAnalyzer.

ObjectPascalAnalyzerで静的にソースコードを解析しましょう。


## Prerequisite 前提条件

- [Ruby](https://www.ruby-lang.org/ja/downloads/)


## Installation インストール

```bash
$ gem install object_pascal_analyzer
```

## Usage 使い方

### English

1. Show summary by `object_pascal_analyzer summary PATH\_TO\_DIRECTORY`
1. Check the details by
    - `object_pascal_analyzer csv PATH\_TO\_DIRECTORY > result.csv`
    - `object_pascal_analyzer json PATH\_TO\_DIRECTORY > result.json`

### 日本語

1. サマリを表示します `object_pascal_analyzer summary PATH\_TO\_DIRECTORY`
1. 以下のコマンドで詳細をチェックします
    - `object_pascal_analyzer csv PATH\_TO\_DIRECTORY > result.csv`
    - `object_pascal_analyzer json PATH\_TO\_DIRECTORY > result.json`

Check the result repeatedly. (結果を繰り返しチェックしましょう)

### Summary

```
$ object_pascal_analyzer summary PATH\_TO\_DIRECTORY
```

```
Top 10 of the longest procedures or functions
  1. JvChart.pas   TJvChart.DrawVerticalBars   51
  2. JvChart.pas   TJvChart.PrimaryYAxisLabels 27
  ...

Top 10 of the deepest procedures or functions
  1. JvChart.pas   TJvChart.PrimaryYAxisLabels 3
  2. JvChart.pas   TJvChart.DrawVerticalBars   2
  ...

Top 10 of the most commented procedures or functions
  2. JvChart.pas   TJvChart.DrawVerticalBars   5
  1. JvChart.pas   TJvChart.PaintCursor        1
  ...
```


### CSV

```
$ object_pascal_analyzer csv summary PATH\_TO\_DIRECTORY > result.csv
```

| path          | class           | procedure/function | total\_lines | empty\_lines | comment\_lines | living\_lines  | max\_depth |
|---            |---              |---                 |---          :|---          :|---            :|---            :|---        :|
| JvChart.pas   | TJvChart        | PaintCursor        | 12           | 2            | 1              | 9              | 1          |
| JvChart.pas   | TJvChart        | PrimaryYAxisLabels | 27           | 0            | 0              | 27             | 3          |
| JvChart.pas   | TJvChart        | DrawVerticalBars   | 51           | 6            | 5              | 40             | 2          |
| JvChart.pas   | TJvChart        | DrawVerticalBars/CalcRawRect | 9  | 0            | 0              |  9             | 0          |


- `total lines` means the number of lines between `begin` and `end`. It doesn't contains `begin` and `end`.
- `comment_lines` means the number of lines which is totally commented out with `//`.
    - Now `(*...*)` and `{...}` aren't supported.
        - You can send us a pull request!


- `total lines` は `begin` と `end` の間の行数です. `begin` と `end` は含みません。
- `comment_lines` は `//` で全部がコメントになっている行です。
    - 現時点では `(*...*)` と `{...}` はサポートされていません。
        - Pull Requestを送るチャンスですよ！

### JSON format

```bash
$ object_pascal_analyzer json json PATH\_TO\_DIRECTORY  > result.json
```

```json
{
    "files": [
        {
            "path": "JvChart.pas",
            "classes": [
                {
                    "name": "TJvChart",
                    "functions": [
                        {
                            "name": "PaintCursor",
                            "total_lines": 12,
                            "empty_lines": 2,
                            "comment_lines": 1,
                            "living_lines": 9,
                            "max_depth": 1
                        },
                        {
                            "name": "PrimaryYAxisLabels",
                            "total_lines": 27,
                            "empty_lines": 0,
                            "comment_lines": 0,
                            "living_lines": 27,
                            "max_depth": 3
                        },
                        {
                            "name": "DrawVerticalBars",
                            "total_lines": 51,
                            "empty_lines": 6,
                            "comment_lines": 5,
                            "living_lines": 40,
                            "max_depth": 2
                        },
                        {
                            "name": "DrawVerticalBars/CalcRawRect",
                            "total_lines": 9,
                            "empty_lines": 0,
                            "comment_lines": 0,
                            "living_lines": 9,
                            "max_depth": 0
                        }
                    ]
                }
            ]
        }
    ]
}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/object_pascal_analyzer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ObjectPascalAnalyzer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/object_pascal_analyzer/blob/master/CODE_OF_CONDUCT.md).
