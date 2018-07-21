defmodule DALTest.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string
      add :band_id, :integer
    end
  end
end
