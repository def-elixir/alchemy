defmodule Alchemy.Storage.Backup do
  alias Alchemy.Directory
  alias Alchemy.File, as: BackupFile
  alias Alchemy.Repo

  @file_excluded [".DS_Store"]

  def main(path) do
    run(path)
  end

  def run(path, directory_id \\ nil) do
    with {:ok, file_info} <- classify_file_type(path),
         {:ok, result} <- backup(file_info.type, path, directory_id) do
          IO.inspect(result)
          if file_info.type == :directory do
            run_recursive(path, result.id)
          end
    else
      {:error, message} -> IO.inspect(message.errors, label: "error")
    end
  end

  def run_recursive(entry, directory_id \\ nil) do
    entry
      |> File.ls!()
      |> Enum.reject(fn f -> f in @file_excluded end)
      |> Enum.each(fn path -> Path.join(entry, path) |> run(directory_id) end)
  end

  def classify_file_type(path) do
    case File.stat(path) do
      {:ok, file_info} -> {:ok, file_info}
      {:error, :enoent} -> {:error, "file or directory not found"}
      {:error, message} -> {:error, message}
    end
  end

  def backup(type, path, directory_id \\ nil)

  def backup(:directory, path, directory_id) do
    case create_directory(%{ name: Path.basename(path), parent_id: directory_id }) do
      {:ok, directory} -> {:ok, directory}
      {:error, message} -> {:error, message}
    end
  end

  def backup(:regular, path, directory_id) do
    with {:ok, contents} <- File.read(path),
         {:ok, file} <- create_file(%{ name: Path.basename(path), contents: contents, directory_id: directory_id }) do
          {:ok, file}
    else
      {:error, message} -> {:error, message}
    end
  end

  def create_directory(attrs \\ %{}) do
    case directory_changeset(attrs) |> insert_directory() do
      {:ok, directory} -> {:ok, directory}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp directory_changeset(attrs) do
    %Directory{}
    |> Directory.changeset(attrs)
  end

  defp insert_directory(changeset) do
    case Repo.insert(changeset) do
      {:ok, directory} -> {:ok, directory}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_file(attrs \\ %{}) do
    case file_changeset(attrs) |> insert_file() do
      {:ok, file} -> {:ok, file}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp file_changeset(attrs) do
    %BackupFile{}
      |> BackupFile.changeset(attrs)
  end

  defp insert_file(changeset) do
    case Repo.insert(changeset) do
      {:ok, file} -> {:ok, file}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
