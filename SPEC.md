# SPEC

## ツール名

genv

## 目的

`env.example` をもとに `.env` 系ファイルを自動生成するCLIツールを作る。

clone してきたリポジトリに `env.example` はあるのに `.env` がなく、毎回手で作るのが面倒な状況を減らすことを目的とする。

## 対象コマンド

```bash
genv init
```

将来的に `check` などを追加する余地はあるが、今回のMVPは `init` のみとする。

## 入力

### デフォルト

- 入力ファイル: `env.example`

### オプション

- `--example <path>`
  - 読み込む example ファイルのパスを指定する

## 出力

### デフォルト

- 出力ファイル: `.env`

### オプション

- `-o, --output <path>`
  - 出力先ファイルを指定する
  - 複数回指定可能
  - 指定がない場合は `.env` を生成する

## 基本仕様

- `env.example` に含まれる環境変数名を読み取る
- 値はコピーしない
- 出力先にはすべて `KEY=""` の形式で書き込む
- 変数の並び順は `env.example` の順番を維持する

例:

```env
DB_HOST=localhost
DB_USER=postgres
SECRET_KEY=sample
```

生成結果:

```env
DB_HOST=""
DB_USER=""
SECRET_KEY=""
```

## 対象とする行

MVPでは以下を対象とする。

- `KEY=value` 形式の行

MVPでは以下は深追いしない。

- コメント行の厳密な再現
- 空行の完全保持
- `export KEY=value` 形式への完全対応
- 複雑な引用符や特殊ケースの完全対応

## 既存ファイルがある場合の挙動

- 出力先ファイルが存在しない場合
  - 新規作成する
- 出力先ファイルが既に存在する場合
  - 明示してスキップする
- `--force` 指定時のみ
  - 既存ファイルを上書きする

## オプション一覧

### `--example <path>`

読み込む example ファイルのパスを指定する。

### `-o, --output <path>`

出力先ファイルを指定する。複数回指定可能。

### `--force`

既存ファイルがある場合でも上書きする。

### `--dry-run`

将来的な追加候補。MVPでは未対応でもよい。

## 実行例

```bash
genv init
genv init -o .env.local
genv init -o .env.local -o .env.prod
genv init --example path/to/env.example -o .env
genv init --force -o .env.local
```

## 想定される出力

### 新規作成

```text
Created: .env
Done. created=1 skipped=0
```

### 一部スキップあり

```text
Skipped: .env.local (already exists)
Created: .env.prod
Done. created=1 skipped=1
```

## 終了コード

- `0`
  - 正常終了
  - 一部スキップがあっても正常扱いとする

- `1`
  - エラー
  - example ファイル未検出
  - 読み込み失敗
  - 書き込み失敗
  - オプション指定不正 など

## エラー条件

- `env.example` が存在しない
- `env.example` の読み込みに失敗した
- 出力先ファイルの書き込みに失敗した
- オプション指定が不正

## 今回やらないこと

- `env.example` の値をそのままコピーすること
- `.env.local` と `.env.prod` で内容を変えて生成すること
- 高度なバリデーション
- `check` コマンド
- コメントや空行の完全再現
- 既存ツールとの差分調査を先にやること

## 今後の拡張候補

- `genv check` の追加
- `--dry-run` の追加
- コメント行や空行の扱い改善
- `export KEY=value` 形式の対応
- CIで使いやすい出力改善

## 完了条件

以下を満たしたら、MVPとして完成とみなす。

- `genv init` が動作する
- `env.example` を読んで `.env` を生成できる
- 生成形式が `KEY=""` になっている
- `-o` で出力先を指定できる
- `-o` を複数指定できる
- 既存ファイルを明示してスキップできる
- `--force` で上書きできる
- エラー時に終了コード `1` を返せる
- README がある
- 最低限のテストがある
