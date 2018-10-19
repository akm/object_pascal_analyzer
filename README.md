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
Top 5 of the longest procedures or functions
Path                       Class  Name               Total Empty Comment Depth
CollectionDemo/Unit1.pas   TForm1 EnumerateNodes       115     0       1     2
ThreadDemo/MouseReader.pas TForm1 HidCtlDeviceChange    38     0       7     2
ReadWriteDemo/Unit1.pas    TForm1 DoRead                35     0       0     2
ReadWriteDemo/Unit1.pas    TForm1 DoWrite               35     1       0     2
ReadWriteDemo/Unit1.pas    TForm1 HidCtlDeviceChange    21     0       0     3

Top 5 of the deepest procedures or functions
Path                       Class  Name               Total Empty Comment Depth
ReadWriteDemo/Unit1.pas    TForm1 HidCtlDeviceChange    21     0       0     3
CollectionDemo/Unit1.pas   TForm1 EnumerateNodes       115     0       1     2
ThreadDemo/MouseReader.pas TForm1 HidCtlDeviceChange    38     0       7     2
ReadWriteDemo/Unit1.pas    TForm1 DoRead                35     0       0     2
ReadWriteDemo/Unit1.pas    TForm1 DoWrite               35     1       0     2

Top 5 of the most commented procedures or functions
Path                       Class        Name               Total Empty Comment Depth
ThreadDemo/MouseReader.pas TForm1       HidCtlDeviceChange    38     0       7     2
ThreadDemo/MouseReader.pas TMouseThread Execute               18     0       5     1
ThreadDemo/MouseReader.pas TMouseThread HandleMouseData        6     0       2     0
CollectionDemo/Unit1.pas   TForm1       EnumerateNodes       115     0       1     2
ReadWriteDemo/Unit1.pas    TForm1       DoRead                35     0       0     2
```


### CSV

```
$ object_pascal_analyzer csv summary PATH\_TO\_DIRECTORY > result.csv
```


path | class | name | total_lines | empty_lines | comment_lines | max_depth
-- | -- | -- | -- | -- | -- | --
BasicDemo/Unit1.pas | TForm1 | HidCtlDeviceChange | 2 | 0 | 0 | 0
BasicDemo/Unit1.pas | TForm1 | HidCtlEnumerate | 4 | 0 | 0 | 0
CollectionDemo/Unit1.pas | TForm1 | HidCtlDeviceChange | 3 | 0 | 0 | 0
CollectionDemo/Unit1.pas | TForm1 | EnumerateNodes | 115 | 0 | 1 | 2
CollectionDemo/Unit1.pas | TForm1 | HidCtlEnumerate | 7 | 0 | 0 | 0
ReadWriteDemo/Unit1.pas | TForm1 | HidCtlDeviceChange | 21 | 0 | 0 | 3
ReadWriteDemo/Unit1.pas | TForm1 | HidCtlEnumerate | 12 | 0 | 0 | 1
ReadWriteDemo/Unit1.pas | TForm1 | FormActivate | 18 | 0 | 0 | 1
ReadWriteDemo/Unit1.pas | TForm1 | FormDestroy | 6 | 0 | 0 | 1
ReadWriteDemo/Unit1.pas | TForm1 | InfoButtonClick | 7 | 0 | 0 | 1
ReadWriteDemo/Unit1.pas | TForm1 | DoRead | 35 | 0 | 0 | 2
ReadWriteDemo/Unit1.pas | TForm1 | DoWrite | 35 | 1 | 0 | 2
ReadWriteDemo/Unit1.pas | TForm1 | ReadButtonClick | 1 | 0 | 0 | 0
ReadWriteDemo/Unit1.pas | TForm1 | WriteButtonClick | 1 | 0 | 0 | 0
ReadWriteDemo/Unit1.pas | TForm1 | ListBox1Click | 12 | 0 | 0 | 1
ReadWriteDemo/Unit2.pas | TInfoForm | FormCreate | 17 | 0 | 0 | 0
ThreadDemo/MouseReader.pas | TForm1 | HidCtlDeviceChange | 38 | 0 | 7 | 2
ThreadDemo/MouseReader.pas | TMouseThread | HandleMouseData | 6 | 0 | 2 | 0
ThreadDemo/MouseReader.pas | TMouseThread | Execute | 18 | 0 | 5 | 1
ThreadDemo/MouseReader.pas | TMouseThread | Execute/Dummy | 0 | 0 | 0 | 0

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
      "path": "Unit1.pas",
      "classes": [
        {
          "name": "TForm1",
          "functions": [
            {
              "name": "HidCtlDeviceChange",
              "total_lines": 2,
              "empty_lines": 0,
              "comment_lines": 0,
              "max_depth": 0
            },
            {
              "name": "HidCtlEnumerate",
              "total_lines": 4,
              "empty_lines": 0,
              "comment_lines": 0,
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
