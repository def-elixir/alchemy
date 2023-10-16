defmodule Alchemy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Alchemy.Repo,
    ]
    # Load env file
    unless Mix.env == :prod do
      Dotenv.load
      Mix.Task.run("loadconfig")
    end
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Alchemy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
