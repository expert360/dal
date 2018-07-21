defmodule DALTest.Band do
  use Ecto.Schema

  schema "bands" do
    field :name, :string
    field :website, :string
    field :rating, :integer
    belongs_to :genre, DALTest.Genre
    has_many :albums, DALTest.Album
  end

  defimpl DAL.Repo.Discoverable do
    def repo(_), do: DALTest.Repo
  end
end
