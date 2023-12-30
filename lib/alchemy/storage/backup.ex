defmodule Alchemy.Storage.Backup do
  alias Alchemy.Directory
  alias Alchemy.File, as: BackupFile
  alias Alchemy.Repo
  alias Alchemy.Utils.File, as: FileUtil

  @file_excluded [".DS_Store"]

  def upload(path, directory_id \\ nil) do
    with {:ok, file_info} <- FileUtil.stat(Path.expand(path)),
         {:ok, result} <- upload_individually(file_info.type, path, directory_id) do
          IO.inspect(result)
          if file_info.type == :directory do
            upload_subdirectory(path, result.id)
          end
    end
  end

  defp upload_subdirectory(parent_path, parent_id) do
    parent_path
    |> File.ls!()
    |> Enum.reject(fn f -> f in @file_excluded end)
    |> Enum.each(&upload(Path.join(parent_path, &1), parent_id))
  end

  def upload_individually(file_type, path, directory_id \\ nil)

  def upload_individually(:directory, path, directory_id) do
    directory = %{name: Path.basename(path), parent_id: directory_id}
    upload_directory(directory)
  end

  def upload_individually(:regular, path, directory_id) do
    with {:ok, contents} <- FileUtil.read(path) do
      file = %{name: Path.basename(path), contents: contents, directory_id: directory_id}
      upload_file(file)
    end
  end

  defp upload_directory(attrs) do
    case insert_directory(attrs) do
        {:ok, directory} -> {:ok, directory}
        {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset.errors}
    end
  end

  defp insert_directory(attrs) do
    %Directory{}
    |> Directory.changeset(attrs)
    |> Repo.insert()
  end

  defp upload_file(attrs) do
    case insert_file(attrs) do
      {:ok, file} -> {:ok, file}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset.errors}
    end
  end

  defp insert_file(attrs) do
    %BackupFile{}
    |> BackupFile.changeset(attrs)
    |> Repo.insert()
  end
end
