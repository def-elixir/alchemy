defmodule Alchemy.Script.File do
  @moduledoc """
  File Util.
  """

  @directory "/aaa/"

  def clean(directory \\ @directory) do
    directory
      |> Path.join("/*")
      |> Path.wildcard()
      |> Enum.filter(&is_file?/1)
      |> Enum.each(fn file ->
        File.rm!(file)
        IO.puts("#{file}を削除しました")
      end)
  end

  def is_file?(path) do
    case File.stat(path) do
      {:ok, %File.Stat{type: :regular}} -> true
      _ -> false
    end
  end

end
