defmodule DALTest.Repo do
  use Ecto.Repo, otp_app: :dal, adapter: Ecto.Adapters.Postgres
end
