defmodule Alchemy.Storage.Restore do
  import Ecto.Query
  use Ecto.Schema
  alias Alchemy.Directory
  alias Alchemy.Repo

  @download_path "~/data/repo/restore"

  def download(path) do
    download_path = @download_path |> Path.expand()
    root_directory = get_root_directory_by_name(path)
    download_subdirectory(Path.join(download_path, root_directory.name), root_directory.id)
  end

  def download_subdirectory(path, directory_id) do
    make_directory(path)
    directory = get_directory_by_id(directory_id)
    directory.files |> Enum.each(&create_file(Path.join(path, &1.name), &1.contents))
    directory.subdirectories |> Enum.each(&download_subdirectory(Path.join(path, &1.name), &1.id))
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
