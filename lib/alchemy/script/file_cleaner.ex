defmodule Alchemy.Script.FileCleaner do
  @moduledoc """
  File Utilities for cleaning up.
  """

  @default_path "~/Desktop"
  @protection_path_list ["/", "~/"]

  def cleanup(path \\ @default_path) do
    with {:ok, absolute_path} <- to_absolute_path(path),
         :ok <- validate_path(absolute_path)
    do
      absolute_path
      |> Path.join("/*")
      |> Path.wildcard()
      |> Enum.filter(&File.regular?/1)
      |> Enum.each(fn file ->
        File.rm!(file)
        IO.puts("#{file}: deleted.")
      end)
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def cleanup_all(path) do
    with {:ok, absolute_path} <- to_absolute_path(path),
         :ok <- validate_path(absolute_path)
    do
      absolute_path
      |> Path.join("/*")
      |> Path.wildcard()
      |> Enum.each(fn path ->
        File.rm_rf!(path)
        IO.puts("#{path}: deleted.")
      end)
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp to_absolute_path(path) when path == "", do: {:error, "Path argument: \"\" not allowed."}
  defp to_absolute_path(path), do: {:ok, Path.expand(path)}

  defp validate_path(path) do
    with {:ok, _} <- path_exists(path),
         {:ok, _} <- protect_path(path)
    do
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp path_exists(path) do
    case File.exists?(path) do
      true  -> {:ok, path}
      false -> {:error, "#{path}: No such path."}
    end
  end

  defp protect_path(path) do
    protection_path_list = @protection_path_list |> Enum.map(&Path.expand/1)
    case Enum.member?(protection_path_list, path) do
      false -> {:ok, path}
      true  -> {:error, "#{path}: Protected."}
    end
  end

end
