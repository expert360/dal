defmodule DALTest.Genre do
  use Ecto.Schema

  schema "genres" do
    field :name, :string
  end

  defimpl DAL.Repo.Discoverable do
    def repo(_), do: DALTest.Repo
  end
end
