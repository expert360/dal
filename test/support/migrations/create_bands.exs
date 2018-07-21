defmodule DALTest.Migrations.CreateBands do
  use Ecto.Migration

  def change do
    create table(:bands) do
      add :name, :string
      add :website, :string
      add :rating, :integer
      add :genre_id, :integer
    end
  end
end
