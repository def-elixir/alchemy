defmodule Mix.Tasks.Scraping do
  @moduledoc "Scraping web page"
  @shortdoc "Scraping web page"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")
    Alchemy.Script.Scraping.get_data()
  end
end
