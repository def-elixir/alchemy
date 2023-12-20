defmodule Mix.Tasks.Cleanup do
  @moduledoc "Cleanup directory"
  @shortdoc "Cleanup directory"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Alchemy.Script.FileCleaner.cleanup()
  end
end
