defmodule Alchemy.MixProject do
  use Mix.Project

  def project do
    [
      app: :alchemy,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Alchemy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.4"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.17.4"},
      {:timex, "~> 3.7"},
      {:dotenv, "~> 3.0.0"},
      {:req, "~> 0.3"},
      {:httpoison, "~> 2.1.0"},
      {:floki, "~> 0.35.0"},
      {:csv, "~> 3.2"},
    ]
  end
end
