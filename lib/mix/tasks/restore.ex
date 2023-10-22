defmodule Mix.Tasks.Restore do
  @moduledoc "Restore backuped directory"
  @shortdoc "Restore backuped directory"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    {_, [path], _} = OptionParser.parse(args, strict: [path: :string])
    Alchemy.Storage.Restore.main(path)
  end
end
