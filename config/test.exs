use Mix.Config

config :dal, DALTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "dal_test",
  username: "daniel",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  loggers: []


