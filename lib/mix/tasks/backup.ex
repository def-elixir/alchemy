defmodule Mix.Tasks.Backup do
  @moduledoc "Backup directory"
  @shortdoc "Backup directory"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    {_, [path], _} = OptionParser.parse(args, strict: [path: :string])
    Alchemy.Storage.Backup.main(path)
  end
end
