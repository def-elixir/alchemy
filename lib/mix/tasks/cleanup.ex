defmodule Mix.Tasks.Cleanup do
  @moduledoc "Cleanup directory"
  @shortdoc "Cleanup directory"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Alchemy.Script.File.cleanup()
  end
end
