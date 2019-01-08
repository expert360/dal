use Mix.Config

config :dal, DALTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("POSTGRES_DB"),
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASS"),
  hostname: System.get_env("POSTGRES_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox,
  loggers: []


