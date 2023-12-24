defmodule Alchemy.Utils.File do

  def read(path) do
    case File.read(path) do
      {:ok, contents} -> {:ok, contents}
      {:error, _} -> {:error, :badfile}
    end
  end

  def open(path) do
    case File.open(path, [:write, :utf8]) do
      {:ok, file} -> {:ok, file}
      {:error, reason} -> {:error, reason}
    end
  end
end
