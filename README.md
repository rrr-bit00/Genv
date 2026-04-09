# genv

`genv` は、`env.example` をもとに `.env` 系ファイルを生成するCLIツールです。

clone してきたリポジトリに `env.example` はあるのに `.env` がなく、毎回手で作るのが面倒だったため作成しました。

## できること

- `env.example` から環境変数名を読み取る
- `.env` ファイルを `KEY=""` の形式で生成する
- 出力先ファイル名を指定できる
- 複数の出力先ファイルをまとめて指定できる
- 既存ファイルはデフォルトでスキップする
- `--force` を付けた場合のみ上書きする

## 想定している使い方

リポジトリを clone したあと、`env.example` をもとに `.env` や `.env.local` をすばやく作成したいときに使います。

## 動作仕様

### デフォルト

- 入力ファイル: `env.example`
- 出力ファイル: `.env`

### 生成ルール

- `env.example` にある変数名をもとに生成する
- 値はコピーせず、すべて `KEY=""` の形式で出力する
- 既存ファイルがある場合は、明示してスキップする
- `--force` 指定時のみ上書きする

## 使用例

```bash
genv init
genv init -o .env.local
genv init -o .env.local -o .env.prod
genv init --example path/to/env.example -o .env
genv init --force -o .env.local
```

## オプション

### `--example <path>`

読み込む `env.example` ファイルのパスを指定します。  
デフォルトは `env.example` です。

### `-o, --output <path>`

出力先ファイルを指定します。  
複数回指定できます。  
指定がない場合は `.env` を生成します。

### `--force`

既存ファイルがある場合でも上書きします。

## 実行結果の例

### 生成成功

```text
Created: .env
Done. created=1 skipped=0
```

### 既存ファイルがある場合

```text
Skipped: .env.local (already exists)
Created: .env.prod
Done. created=1 skipped=1
```

## 終了コード

- `0`: 正常終了
- `1`: エラー

## エラーとなる例

- `env.example` が存在しない
- `env.example` の読み込みに失敗した
- 出力先ファイルの書き込みに失敗した
- オプション指定が不正

## 今後の追加候補

- `check` コマンドの追加
- コメント行や空行の扱いの改善
- `dry-run` の追加

## このツールを作った理由

新しいリポジトリを clone した直後に、`.env` 作成を毎回手作業で行うのが面倒だったためです。  
また、`env.example` の値をそのまま使うのではなく、変数名だけをもとに空の値で安全に初期化したいと考えました。

## ライセンス

MIT
