defmodule Alchemy.Script.File do
  @moduledoc """
  File Util.
  """

  @default_directory "~/Desktop"

  def cleanup(directory \\ @default_directory) do
    directory
      |> Path.expand()
      |> Path.join("/*")
      |> Path.wildcard()
      |> Enum.filter(&is_file?/1)
      |> Enum.each(fn file ->
        File.rm!(file)
        IO.puts("#{file}を削除しました")
      end)
  end


  def cleanup_all(directory) do
    directory
      |> Path.expand()
      |> Path.join("/*")
      |> Path.wildcard()
      |> Enum.each(fn path ->
        File.rm_rf!(path)
        IO.puts("#{path}を削除しました")
      end)
  end

  defp is_file?(path) do
    case File.stat(path) do
      {:ok, %File.Stat{type: :regular}} -> true
      _ -> false
    end
  end

end
