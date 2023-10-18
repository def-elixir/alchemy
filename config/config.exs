import Config

config :alchemy,
  ecto_repos: [Alchemy.Repo]

config :alchemy, Alchemy.Repo,
  database: "alchemy",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  migration_timestamps: [type: :timestamptz],
  log: false
