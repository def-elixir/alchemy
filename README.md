# Alchemy

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `alchemy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alchemy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/alchemy>.

# Elixir環境構築

## asdfのインストール

公式
https://asdf-vm.com/

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
```

パスを通す

```bash
vi ~/.bashrc
```

<pre>
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
</pre>

```bash
source ~/.bashrc
```

```bash
which asdf
```

## asdf自体のアップデート

```bash
asdf update
```

## すべてのプラグインのアップデート

```bash
asdf plugin-update --all
```

## ElixirとErlangのインストール

```bash
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

## Elixirのインストール

バージョンを指定してインストール
```bash
asdf list-all elixir
asdf install elixir 1.15.7
```

## Erlangのインストール

バージョンを指定してインストール
```bash
asdf list-all erlang
asdf install erlang 26.0.2
```

※パッケージが必要

```bash
sudo apt install libssl-dev automake autoconf libncurses5-dev
```

## ディレクトリ個別でバージョン切り替えする場合

作業用ディレクトリで実行
```bash
asdf local erlang 26.0.2
asdf local elixir 1.15.7
```

バージョン確認
```bash
asdf current
iex -v
```

## グローバルに設定する場合

```bash
asdf global erlang 26.0.2
asdf global elixir 1.15.7
```

```bash
asdf current
iex -v
```

## アンインストール

インストール済みのバージョンを確認
```bash
asdf list
```

アンインストール
```bash
asdf uninstall プラグイン名 バージョン
```

## mix

* プロジェクトの作成

```bash
mix new my_app
```

* umbrellaプロジェクトの場合

```bash
mix new elixir_app --umbrella
cd elixir_app
cd apps
mix new my_app
```

* パッケージのインストール

mix.exsのあるディレクトリで実行

```bash
mix deps.get
mix install
```

* コンパイル

```bash
mix compile
```

* ヘルプ

```bash
mix help
```

* 実行

```bash
mix run -e 'ModuleName.function();
```

## iex

* iexの起動

プロジェクト内のモジュールをiexで使用

```bash
iex -S mix
```

* モジュールの読み込み

```bash
iex()> import ModuleName
```

* 再読み込み

```bash
iex()> recompile
```
