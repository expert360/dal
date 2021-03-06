use Mix.Config

config :dal, DALTest.Repo,
  database: System.get_env("POSTGRES_DB"),
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASS"),
  hostname: System.get_env("POSTGRES_HOST"),
  port: System.get_env("POSTGRES_PORT"),
  pool: Ecto.Adapters.SQL.Sandbox,
  log: :warn
