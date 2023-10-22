defmodule Alchemy.Storage.Restore do
  import Ecto.Query
  use Ecto.Schema
  alias Alchemy.Directory
  alias Alchemy.Repo

  @local_directory "~/data/repo/restore"

  def main(path) do
    # 対象ディレクトリの取得
    directory = get_root_directory_by_name(path)
    @local_directory
      |> Path.expand()
      |> Path.join(directory.name)
      |> restore_recursive(directory.id)
  end

  def restore_recursive(path, directory_id) do
    make_directory(path)
    directory = get_directory_by_id(directory_id)
    directory.files
      |> Enum.each(fn f -> Path.join(path, f.name) |> create_file(f.contents) end)
    directory.subdirectories
      |> Enum.each(fn sub ->
        path = Path.join(path, sub.name)
        restore_recursive(path, sub.id)
      end)
  end

  def create_file(path, contents) do
    case File.write(path, contents) do
      :ok -> IO.puts("ファイル書き込みに成功しました。: #{path}")
      {:error, message} -> IO.puts("ファイル書き込みに失敗しました。: #{message}")
    end
  end

  def make_directory(path) do
    case File.mkdir_p(path) do
      :ok -> IO.puts("ディレクトの作成に成功しました。: #{path}")
      {:error, message} -> IO.puts("ディレクトの作成に失敗しました。: #{message}")
    end
  end

  def get_directory_by_id(directory_id) do
    from(d in Directory,
      left_join: s in assoc(d, :subdirectories),
      left_join: f in assoc(d, :files),
      where: d.id == ^directory_id,
      preload: [subdirectories: s, files: f]
    ) |> Repo.one()
  end

  def get_root_directory_by_name(name) do
    from(d in Directory,
      left_join: s in assoc(d, :subdirectories),
      left_join: f in assoc(d, :files),
      where: d.name == ^name and is_nil(d.parent_id),
      preload: [subdirectories: s, files: f]
    ) |> Repo.one()
  end

end
