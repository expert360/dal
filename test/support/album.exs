defmodule DALTest.Album do
  use Ecto.Schema

  schema "albums" do
    field :name, :string

    belongs_to :band, DALTest.Band
  end

  defimpl DAL.Repo.Discoverable do
    def repo(_), do: DALTest.Repo
  end
end
