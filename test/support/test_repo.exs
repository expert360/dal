defmodule DALTest.Repo do
  use Ecto.Repo, otp_app: :dal
end

DALTest.Repo.start_link()
